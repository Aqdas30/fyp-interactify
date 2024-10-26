from rest_framework import serializers
from app.models import Post, PostComment, PostLike, User, UserFollow


from rest_framework import serializers
from app.models import User
from django.core.mail import send_mail
from django.conf import settings

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'email', 'first_name', 'last_name', 'username', 'password', 'bio']

    password = serializers.CharField(write_only=True)

    def create(self, validated_data):
        user = User(
            email=validated_data['email'],
            first_name=validated_data['first_name'],
            last_name=validated_data['last_name'],
            username=validated_data['username'],
        )
        user.set_password(validated_data['password'])
        user.save()

        # Generate verification code
        code = user.generate_verification_code()

        # Send verification email
        send_mail(
            subject='Verify your email',
            message=f'Your verification code is: {code}',
            from_email=settings.DEFAULT_FROM_EMAIL,
            recipient_list=[user.email],
        )

        return user
# serializer.py


class UserLoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField()



from rest_framework import serializers
from app.models import Post


from rest_framework import serializers
from app.models import Post

class PostSerializer(serializers.ModelSerializer):
    like_count = serializers.SerializerMethodField()  # Custom field for like count
    comment_count = serializers.SerializerMethodField()  # Custom field for comment count
    media_url = serializers.SerializerMethodField()  # Custom field for media URL (image or video)

    class Meta:
        model = Post
        fields = ['id', 'title', 'description', 'like_count', 'comment_count', 'post_type', 'media_url']

    def get_like_count(self, obj):
        return obj.like_count  # This will call the property defined in the model

    def get_comment_count(self, obj):
        return obj.comment_count  # This will call the property defined in the model

    def get_media_url(self, obj):
        request = self.context.get('request')
        if obj.media and request:
            return request.build_absolute_uri(obj.media.url)
        return None


from rest_framework import serializers
from .models import PostComment

# serializers.py
class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = PostComment
        fields = ['id', 'post', 'user', 'comment_text', 'created_at']

class PostLikeSerializer(serializers.ModelSerializer):
    class Meta:
        model = PostLike
        fields = "__all__"

    user = serializers.PrimaryKeyRelatedField(read_only=True)
    post = serializers.PrimaryKeyRelatedField(read_only=True)

class UserFollowSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserFollow
        fields = "__all__"

    user = serializers.PrimaryKeyRelatedField(read_only=True)
    follows_id = serializers.PrimaryKeyRelatedField(read_only=True)
