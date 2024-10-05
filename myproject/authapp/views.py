# authapp/views.py
from rest_framework import generics, status
from rest_framework.response import Response
from .serializers import RegisterSerializer, ResendVerificationEmailSerializer
from rest_framework.permissions import AllowAny
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from django.contrib.auth.models import User  # Or CustomUser if you have one
from django.contrib.auth.tokens import default_token_generator
from django.utils.http import urlsafe_base64_decode
from django.utils.encoding import force_str
from django.shortcuts import redirect
from django.urls import reverse
from django.conf import settings
from django.http import HttpResponse
from django.views import View

from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework import serializers

# views.py

from rest_framework import status
from rest_framework.response import Response
from rest_framework import generics
from .serializers import RegisterSerializer
from .models import UserProfile
from django.core.files.base import ContentFile
from .utils import process_face_image
# views.py

from rest_framework import status
from rest_framework.response import Response
from rest_framework import generics
from .serializers import RegisterSerializer
from .models import UserProfile
from .utils import is_face_duplicate

# views.py
from rest_framework import status
from rest_framework.response import Response
from rest_framework import generics
from .serializers import RegisterSerializer
from .utils import is_face_duplicate

class RegisterView(generics.CreateAPIView):
    serializer_class = RegisterSerializer

    def post(self, request, *args, **kwargs):
        face_image = request.FILES.get('face_image')

        if face_image:
            # Check if the face already exists in the database
            if is_face_duplicate(face_image):
                return Response({'error': 'An account with this face already exists. You cannot register again.'},
                                status=status.HTTP_400_BAD_REQUEST)

        # If no duplicate, proceed with the regular registration process
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({'message': 'Registration successful!'}, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# class RegisterView(generics.CreateAPIView):
#     queryset = User.objects.all()  # Or CustomUser.objects.all()
#     permission_classes = (AllowAny,)
#     serializer_class = RegisterSerializer

#     def post(self, request, *args, **kwargs):
#         serializer = self.get_serializer(data=request.data)
#         if serializer.is_valid():
#             face_image = request.FILES.get('face_image')

#             if face_image:
#                 processed_image = process_face_image(face_image)  # Call your face processing utility here

#                 if processed_image is None:
#                     return Response({'error': 'No valid face found in the image'}, status=status.HTTP_400_BAD_REQUEST)
                
#                 # Replace the original face image with the processed one
#                 request.FILES['face_image'] = processed_image

#             serializer.save()
#             return Response({'message': 'Registration successful!'}, status=status.HTTP_201_CREATED)
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# authapp/views.py


class MyTokenObtainPairSerializer(TokenObtainPairSerializer):
    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)

        # Add custom claims if needed
        token['username'] = user.username
        return token

    def validate(self, attrs):
        data = super().validate(attrs)

        if not self.user.is_active:
            raise serializers.ValidationError({'error': 'Email not verified. Please verify your email before logging in.'})

        return data
class MyTokenObtainPairView(TokenObtainPairView):
    serializer_class = MyTokenObtainPairSerializer

# Email Verification View
# class VerifyEmailView(View):
#     def get(self, request):
#         uidb64 = request.GET.get('uid')
#         token = request.GET.get('token')
        
#         try:
#             uid = force_str(urlsafe_base64_decode(uidb64))
#             user = User.objects.get(pk=uid)
#         except (TypeError, ValueError, OverflowError, User.DoesNotExist):
#             user = None
        
#         if user is not None and default_token_generator.check_token(user, token):
#             user.is_active = True
#             user.save()
#             # Redirect to login page after successful verification
#             return redirect(f"{settings.FRONTEND_URL}/api/auth/login")  # Update FRONTEND_URL in settings
#         else:
#             return HttpResponse('Activation link is invalid!', status=400)

class VerifyEmailView(View):
    def get(self, request):
        uidb64 = request.GET.get('uid')
        token = request.GET.get('token')
        
        try:
            uid = force_str(urlsafe_base64_decode(uidb64))
            user = User.objects.get(pk=uid)
        except (TypeError, ValueError, OverflowError, User.DoesNotExist):
            user = None
        
        if user is not None and default_token_generator.check_token(user, token):
            user.is_active = True
            user.save()
            return HttpResponse(status=200)  # Success
        else:
            return HttpResponse('Activation link is invalid!', status=400)  # Error

# authapp/views.py

class ResendVerificationEmailView(generics.GenericAPIView):
    serializer_class = ResendVerificationEmailSerializer
    permission_classes = (AllowAny,)

    
def post(self, request):
    serializer = self.get_serializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response({'message': 'Verification email sent.'}, status=status.HTTP_200_OK)

    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
