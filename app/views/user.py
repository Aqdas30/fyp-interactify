from django.core.exceptions import ObjectDoesNotExist
from rest_framework import generics
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from app.serializer import UserLoginSerializer, UserSerializer
from app.models import User

from rest_framework.authtoken.models import Token
from django.views.decorators.csrf import csrf_exempt
from rest_framework import generics
from app.models import User
from app.serializer import UserSerializer

class CreateUser(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer

# views.py - LoginUserView

class LoginUserView(APIView):
    def post(self, request):
        serializer = UserLoginSerializer(data=request.data)

        if serializer.is_valid():
            try:
                user = User.objects.get(email=serializer.validated_data["email"])
                if not user.is_verified:
                    return Response({"success": False, "message": "Please verify your email address before logging in."})
                if user.check_password(serializer.validated_data["password"]):
                    token, _ = Token.objects.get_or_create(user=user)
                    return Response({
                        "success": True,
                        "token": token.key,
                        "user_id": user.id
                    })
                else:
                    return Response({"success": False, "message": "incorrect password"})
            except ObjectDoesNotExist:
                return Response({"success": False, "message": "user does not exist"})

        return Response({"success": False, "message": "invalid data"})

from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from app.models import User
from app.serializer import UserSerializer

class RetrieveUser(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, pk):
        try:
            user = User.objects.get(pk=pk)
            serializer = UserSerializer(user)
            return Response(serializer.data)
        except User.DoesNotExist:
            return Response({"error": "User not found"}, status=404)


class UpdateUser(APIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def put(self, request):
        serializer = self.serializer_class(request.user, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response({ "success": True, "message": "user updated" })
        else:
            print(serializer.errors)
            return Response({ "success": False, "message": "error updating user" })

class DestroyUser(generics.DestroyAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def destroy(self, request, pk):
        try:
            user = User.objects.get(id=pk)
            if pk == request.user.id:
                self.perform_destroy(request.user)
                return Response({ "success": True, "message": "user deleted" })
            else:
                return Response({ "success": False, "message": "not enough permissions" })
        except ObjectDoesNotExist:
            return Response({ "success": False, "message": "user does not exist" })


from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from app.models import User
from app.serializer import UserSerializer
from django.db.models import Q

from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from rest_framework.response import Response
from app.models import User
from app.serializer import UserSerializer
from django.db.models import Q

class SearchUserView(APIView):
    authentication_classes = [TokenAuthentication]  # Add TokenAuthentication
    permission_classes = [IsAuthenticated]  # Ensure the user is authenticated

    def get(self, request):
        search_query = request.query_params.get('q', None)
        if search_query:
            matched_users = User.objects.filter(
                Q(username__icontains=search_query) | Q(email__icontains=search_query)
            )
            serializer = UserSerializer(matched_users, many=True)
            return Response({"success": True, "users": serializer.data})
        return Response({"success": False, "message": "No search query provided."})



# views.py

from rest_framework.views import APIView
from rest_framework.response import Response
from app.models import User
from django.core.exceptions import ObjectDoesNotExist

class VerifyEmail(APIView):
    def post(self, request):
        email = request.data.get('email')
        code = request.data.get('verification_code')

        try:
            user = User.objects.get(email=email, verification_code=code)
            if user:
                user.is_verified = True
                user.verification_code = None  # Clear the verification code
                user.save()
                return Response({'success': True, 'message': 'Email verified successfully'})
            else:
                return Response({'success': False, 'message': 'Invalid code'})
        except ObjectDoesNotExist:
            return Response({'success': False, 'message': 'User does not exist'})
# views.py

from rest_framework.views import APIView
from rest_framework.response import Response
from app.models import User
from django.core.mail import send_mail
from django.conf import settings
from django.core.exceptions import ObjectDoesNotExist

class ForgotPasswordRequest(APIView):
    def post(self, request):
        email = request.data.get('email')

        try:
            user = User.objects.get(email=email)
            reset_code = user.generate_reset_code()

            # Send reset code via email
            send_mail(
                subject='Password Reset Request',
                message=f'Your password reset code is: {reset_code}',
                from_email=settings.DEFAULT_FROM_EMAIL,
                recipient_list=[user.email],
            )
            return Response({'success': True, 'message': 'Reset code sent to your email.'})

        except ObjectDoesNotExist:
            return Response({'success': False, 'message': 'User with this email does not exist.'})



# views.py

class ResetPassword(APIView):
    def post(self, request):
        email = request.data.get('email')
        reset_code = request.data.get('reset_code')
        new_password = request.data.get('new_password')

        try:
            user = User.objects.get(email=email, reset_code=reset_code)
            user.set_password(new_password)
            user.reset_code = None  # Clear the reset code after successful reset
            user.save()

            return Response({'success': True, 'message': 'Password has been reset successfully.'})

        except ObjectDoesNotExist:
            return Response({'success': False, 'message': 'Invalid reset code or user not found.'})



