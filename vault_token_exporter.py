import requests
from prometheus_client import start_http_server, Gauge
import time

# Address and token Vault itself
VAULT_ADDR = 'https://vault.addr.com'
VAULT_TOKEN = '$TOKEN'

# Vault token TTL function
def get_token_ttl():
    headers = {'X-Vault-Token': VAULT_TOKEN}
    response = requests.get(f'{VAULT_ADDR}/v1/auth/token/lookup-self', headers=headers)
    response.raise_for_status()
    data = response.json()
    return data['data']['ttl']

if __name__ == '__main__':
    # Create metrics
    token_ttl_seconds = Gauge('vault_token_ttl_seconds', 'Time to live for Vault token in seconds')
    token_ttl_days = Gauge('vault_token_ttl_days', 'Time to live for Vault token in days')

    # Запускаем HTTP-сервер на порту 8010
    start_http_server(8010)

    while True:
        try:
            # Receive token TTL
            ttl_seconds = get_token_ttl()
            # Обновляем значение метрик
            token_ttl_seconds.set(ttl_seconds)
            token_ttl_days.set(ttl_seconds / 86400)  # seconds to days
        except Exception as e:
            # Print error if appears
            print(f'Error: {e}')

        # Wait 60 sec
        time.sleep(60)
