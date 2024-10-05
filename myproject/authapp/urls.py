# authapp/urls.py

from django.urls import path
from .views import RegisterView, MyTokenObtainPairView, VerifyEmailView, ResendVerificationEmailView
from rest_framework_simplejwt.views import TokenRefreshView

urlpatterns = [
    path('register/', RegisterView.as_view(), name='auth_register'),
    path('login/', MyTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('verify-email/', VerifyEmailView.as_view(), name='email_verify'),  # Added verification endpoint
    path('resend-verification/', ResendVerificationEmailView.as_view(), name='resend_verification'),
]
