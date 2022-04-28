import json
import requests
r = requests.get('http://169.254.169.254/latest/meta-data/iam/info')
r.json()
print(r.json())
