from django.core.exceptions import ObjectDoesNotExist
from rest_framework import generics
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from app.models import Post, PostComment, PostLike, User, UserFollow
from app.serializer import CommentSerializer, PostLikeSerializer, PostSerializer, UserFollowSerializer

from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from rest_framework.views import APIView
from app.models import Post
from app.serializer import PostSerializer

# class CreatePost(APIView):
#     authentication_classes = [TokenAuthentication]
#     permission_classes = [IsAuthenticated]
#     parser_classes = [MultiPartParser, FormParser]  # To handle file uploads

#     def post(self, request):
#         serializer = PostSerializer(data=request.data, context={'request': request})

#         if serializer.is_valid():
#             post = serializer.save(user=request.user)
#             return Response({
#                 "success": True,
#                 "message": "Post created successfully",
#                 "post": PostSerializer(post).data
#             }, status=201)
#         else:
#             return Response({
#                 "success": False,
#                 "message": "Failed to create post",
#                 "errors": serializer.errors
#             }, status=400)


class CreatePost(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]  # To handle file uploads

    def post(self, request):
        print("Received data:", request.data)  # Debugging: check received data

        serializer = PostSerializer(data=request.data, context={'request': request})

        if serializer.is_valid():
            post = serializer.save(user=request.user)
            print("Media uploaded:", post.media)  # Debugging: check if media is saved
            return Response({
                "success": True,
                "message": "Post created successfully",
                "post": PostSerializer(post).data
            }, status=201)
        else:
            print("Serializer errors:", serializer.errors)  # Debugging: print any errors
            return Response({
                "success": False,
                "message": "Failed to create post",
                "errors": serializer.errors
            }, status=400)

class RetrievePost(generics.RetrieveAPIView):
    queryset = Post.objects.all()
    serializer_class = PostSerializer

class UpdatePost(generics.UpdateAPIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    queryset = Post.objects.all()
    serializer_class = PostSerializer

    def put(self, request, pk):
        post = Post.objects.get(id=pk)
        serializer = PostSerializer(post, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save(user=request.user)
            return Response({ "success": True, "message": "updated post" })
        else:
            print(serializer.errors)
            return Response({ "success": False, "message": "error updating post" })

class DestroyPost(generics.DestroyAPIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    queryset = Post.objects.all()
    serializer_class = PostSerializer

    
    def destroy(self, request, *args, **kwargs):
        try:
            pk = kwargs.get("pk")
            post = Post.objects.get(id=pk)
            if post.user.id == request.user.id:
                self.perform_destroy(post)
                return Response({ "success": True, "message": "post deleted" })
            else:
                return Response({ "success": False, "message": "not enough permissions" })
        except ObjectDoesNotExist:
            return Response({ "success": False, "message": "post does not exist" })


# class RetrieveUserPosts(generics.ListAPIView):
#     queryset = Post.objects.all()
#     serializer_class = PostSerializer
#     authentication_classes = [TokenAuthentication]
#     permission_classes = [IsAuthenticated]

#     def list(self, request, *args, **kwargs):
#         # If a user ID is passed, filter posts by that user
#         user_id = self.request.query_params.get('user_id', None)
#         if user_id:
#             user_posts = Post.objects.filter(user_id=user_id)
#         else:
#             # If no user ID is passed, filter by the logged-in user
#             user_posts = Post.objects.filter(user=request.user.id)
#         serializer = self.serializer_class(user_posts, many=True, context={'request': request})
#         return Response({"success": True, "posts": serializer.data})

from rest_framework import generics
from app.models import Post
from app.serializer import PostSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response

class RetrieveUserPosts(generics.ListAPIView):
    queryset = Post.objects.all()
    serializer_class = PostSerializer
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def list(self, request, *args, **kwargs):
        # Ensure you're filtering posts by the user's ID (for the profile page)
        user_id = self.request.query_params.get('user_id', None)
        
        if user_id:
            # Retrieve posts by the specified user (e.g., profile posts)
            user_posts = Post.objects.filter(user_id=user_id).order_by('-created_at')
        else:
            # If no user ID is passed, retrieve the posts of the logged-in user
            user_posts = Post.objects.filter(user=request.user).order_by('-created_at')
        
        # Pass the request context so the serializer can generate the full media URL
        serializer = self.serializer_class(user_posts, many=True, context={'request': request})
        return Response({"success": True, "posts": serializer.data})

class LikePost(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request, pk):
        try:
            post = Post.objects.get(id=pk)
            new_post_like, created = PostLike.objects.get_or_create(user=request.user, post=post)

            if not created:
                # If the like already exists, we delete it (unlike)
                new_post_like.delete()
                message = "Post unliked"
            else:
                message = "Post liked"

            # Get the updated likes count after the action
            likes_count = PostLike.objects.filter(post=post).count()

            return Response({
                "success": True, 
                "message": message,
                "likes_count": likes_count  # Return updated likes count
            })

        except ObjectDoesNotExist:
            return Response({"success": False, "message": "Post does not exist"})


from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from app.models import Post, PostComment
from app.serializer import CommentSerializer
from rest_framework.permissions import IsAuthenticated
from django.shortcuts import get_object_or_404

from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated


class CommentPost(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request, pk):
        post = get_object_or_404(Post, pk=pk)
        comment_text = request.data.get('comment')

        if not comment_text:
            return Response({'error': 'Comment text is required'}, status=status.HTTP_400_BAD_REQUEST)

        # Create the comment
        PostComment.objects.create(post=post, user=request.user, comment_text=comment_text)

        # Get the updated comments count
        comments_count = PostComment.objects.filter(post=post).count()

        return Response({
            'message': 'Comment posted successfully', 
            'comments_count': comments_count  # Send updated comments count
        }, status=status.HTTP_200_OK)

class FollowUser(APIView):
    queryset = UserFollow.objects.all()
    serializer_class = UserFollowSerializer
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, pk):
        following = UserFollow.objects.filter(user=request.user)
        followers = UserFollow.objects.filter(follows=request.user)

        following_serializer = UserFollowSerializer(following, many=True)
        followers_serializer = UserFollowSerializer(followers, many=True)
        return Response({ "success": True, "following": following_serializer.data, "followers": followers_serializer.data })


    def post(self, request, pk):
        try:
            following_user = User.objects.get(id=pk)
            follow_user = UserFollow.objects.get_or_create(user=request.user, follows=following_user)
            if not follow_user[1]:
                follow_user[0].delete()
                return Response({ "success": True, "message": "unfollowed user" })
            else:
                return Response({ "success": True, "message": "followed user" })


        except ObjectDoesNotExist:
            return Response({ "success": False, "message": "following user does not exist" })


from rest_framework import generics
from app.models import Post, UserFollow
from app.serializer import PostSerializer
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.response import Response
from rest_framework.generics import ListAPIView
from app.models import Post
from app.serializer import PostSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication

class RetrieveFollowedUserPosts(ListAPIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    serializer_class = PostSerializer

    def list(self, request, *args, **kwargs):
        followed_users = UserFollow.objects.filter(user=request.user).values_list('follows', flat=True)
        posts = Post.objects.filter(user_id__in=followed_users).order_by('-created_at')
        serializer = self.serializer_class(posts, many=True, context={'request': request})  # Pass request in context
        return Response({"success": True, "posts": serializer.data})
