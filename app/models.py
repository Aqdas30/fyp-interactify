from django.db import models
from django.contrib.auth.models import AbstractUser


from django.db import models
from django.contrib.auth.models import AbstractUser
import random
import string

class User(AbstractUser):
    username = None
    email = models.EmailField(unique=True)
    username = models.CharField(unique=True, max_length=16)
    bio = models.CharField(max_length=164, null=True)

    is_verified = models.BooleanField(default=False)  # Add verification field
    verification_code = models.CharField(max_length=6, null=True, blank=True)  # Verification code
    reset_code = models.CharField(max_length=6, null=True, blank=True)  # Add reset code



    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = []

    def generate_verification_code(self):
        """Generate a random 6-digit code."""
        code = ''.join(random.choices(string.digits, k=6))
        self.verification_code = code
        self.save()
        return code
    def generate_reset_code(self):
        """Generate a random 6-digit code for password reset."""
        code = ''.join(random.choices(string.digits, k=6))
        self.reset_code = code
        self.save()
        return code
# models.py


from django.db import models
from django.contrib.auth.models import AbstractUser

class Post(models.Model):
    title = models.CharField(max_length=32)
    description = models.CharField(max_length=164)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    user = models.ForeignKey(User, null=True, on_delete=models.SET_NULL)
    post_type = models.CharField(max_length=10)  # e.g., 'text', 'image', 'video'
    media = models.FileField(upload_to='uploads/', null=True, blank=True)  # Media field for image/video

    @property
    def like_count(self):
        return self.postlike_set.count()

    @property
    def comment_count(self):
        return self.postcomment_set.count()

class PostLike(models.Model):
    post = models.ForeignKey(Post, null=False, on_delete=models.CASCADE)
    user = models.ForeignKey(User, null=False, on_delete=models.CASCADE)

    class Meta:
        unique_together = (("post", "user"), )

class PostComment(models.Model):
    comment_text = models.CharField(max_length=264)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    user = models.ForeignKey(User, null=False, on_delete=models.CASCADE)
    post = models.ForeignKey(Post, null=False, on_delete=models.CASCADE)

class UserFollow(models.Model):
    user = models.ForeignKey(User, null=False, on_delete=models.CASCADE, related_name="src_follow")
    follows = models.ForeignKey(User, null=False, on_delete=models.CASCADE, related_name="dest_follow")
