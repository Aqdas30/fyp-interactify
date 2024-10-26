from django.contrib import admin
from django.urls import include, path

from app.views.user import CreateUser, DestroyUser, ForgotPasswordRequest, LoginUserView, ResetPassword, RetrieveUser, SearchUserView, UpdateUser, VerifyEmail
from app.views.post import CommentPost, CreatePost, DestroyPost, FollowUser, RetrieveFollowedUserPosts, RetrievePost, RetrieveUserPosts, UpdatePost, LikePost

urlpatterns = [
    path('user/create/', CreateUser.as_view()),  
    path('user/login/', LoginUserView.as_view()),
    path('user/<int:pk>/', RetrieveUser.as_view()),
    path('user/update/', UpdateUser.as_view()),
    path('user/delete/<int:pk>', DestroyUser.as_view()),

    path('posts/', RetrieveUserPosts.as_view()),
    path('post/create/', CreatePost.as_view()),
    path('post/<int:pk>/', RetrievePost.as_view()),
    path('post/update/<int:pk>/', UpdatePost.as_view()),
    path('post/delete/<int:pk>/', DestroyPost.as_view()),

    path('post/like/<int:pk>/', LikePost.as_view()),


    path('post/comment/<int:pk>/', CommentPost.as_view()),
    path('post/comments/<int:pk>/', CommentPost.as_view()),
    path('user/search/', SearchUserView.as_view(), name='search_user'),  # Add the search endpoint
    path('feed/', RetrieveFollowedUserPosts.as_view()),  # New endpoint for the feed


    path('user/follow/<int:pk>/', FollowUser.as_view()),
    path('user/verify_email/', VerifyEmail.as_view()),  # Add this route
     
    path('user/forgot_password/', ForgotPasswordRequest.as_view()),  # Password reset request
    path('user/reset_password/', ResetPassword.as_view()),  # Reset password
    path('auth/', include('rest_framework_social_oauth2.urls')),  # Add this line


]

