# authapp/serializers.py

from rest_framework import serializers
from django.contrib.auth.models import User  # Use CustomUser if you have one
from django.contrib.auth.password_validation import validate_password
from django.conf import settings
from django.urls import reverse
from django.core.mail import send_mail
from django.utils.http import urlsafe_base64_encode
from django.utils.encoding import force_bytes
from django.contrib.auth.tokens import default_token_generator

from .models import UserProfile
class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(
        write_only=True,
        required=True,
        validators=[validate_password],
        style={'input_type': 'password'}
    )
    password2 = serializers.CharField(
        write_only=True,
        required=True,
        style={'input_type': 'password'}
    )
    face_image = serializers.ImageField(required=True)  # Ensure face image is uploaded during registration


    class Meta:
        model = User  # Replace with CustomUser if applicable
        fields = ('username', 'password', 'password2', 'email', 'first_name', 'last_name','face_image')
        extra_kwargs = {
            'first_name': {'required': True},
            'last_name': {'required': True},
            'email': {'required': True},
        }

    def validate(self, attrs):
        if attrs['password'] != attrs['password2']:
            raise serializers.ValidationError({"password": "Password fields didn't match."})

        return attrs

    def create(self, validated_data):
        face_image = validated_data.pop('face_image')  # Extract face image data
        user = User.objects.create(
            username=validated_data['username'],
            email=validated_data['email'],
            first_name=validated_data.get('first_name', ''),
            last_name=validated_data.get('last_name', ''),
            is_active=False  # Inactive until email verification
        )
        user.set_password(validated_data['password'])
        user.save()

        # Save UserProfile and attach face image
        UserProfile.objects.create(user=user, face_image=face_image)

        # Send verification email
        self.send_verification_email(user)

        return user

    def send_verification_email(self, user):
        token = default_token_generator.make_token(user)
        uid = urlsafe_base64_encode(force_bytes(user.pk))
        #verification_link = f"{settings.SITE_URL}{reverse('email_verify')}?uid={uid}&token={token}"
        # verification_link = f"authapp:/email-verify?uid={uid}&token={token}"
        verification_link = f"{settings.SITE_URL}{('/verify-email')}?uid={uid}&token={token}"
        #verification_link = f"{settings.SITE_URL}/verify-email/?uid={uid}&token={token}"




        subject = 'Verify Your Email Address'

        # Construct the email content directly
        message = f"""
        Hello {user.first_name},

        Thank you for registering. Please click the link below to verify your email address:

        {verification_link}

        If you did not sign up for this account, please ignore this email.

        Thank you!
        """

        # Optionally, send HTML version
        html_message = f"""
        <p>Hello {user.first_name},</p>
        <p>Thank you for registering. Please click the link below to verify your email address:</p>
        <p><a href="{verification_link}">Verify Email</a></p>
        <p>If you did not sign up for this account, please ignore this email.</p>
        <p>Thank you!</p>
        """

        send_mail(
            subject,
            message,  # Plain text message
            settings.EMAIL_HOST_USER,  # From email
            [user.email],
            fail_silently=False,
            html_message=html_message  # Optional: HTML version
        )

# authapp/serializers.py
# authapp/serializers.py

# authapp/serializers.py

class ResendVerificationEmailSerializer(serializers.Serializer):
    email = serializers.EmailField()

    def validate_email(self, value):
        try:
            user = User.objects.get(email=value)
            if user.is_active:
                raise serializers.ValidationError('Account is already active.')
            return value
        except User.DoesNotExist:
            raise serializers.ValidationError('No account found with this email.')

    def save(self):
        email = self.validated_data['email']
        user = User.objects.get(email=email)
        user.is_active = False  # Ensure user is inactive
        user.save()
        self.send_verification_email(user)

    def send_verification_email(self, user):
        RegisterSerializer().send_verification_email(user)
