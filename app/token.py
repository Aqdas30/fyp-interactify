from rest_framework.authtoken.models import Token
from django.contrib.auth.models import User

token = Token.objects.get(key='0e1c568ba2d452a602d848ef0a33756e05434e89')
print(token.user)  # This should print the user associated with the token
