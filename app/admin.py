from django.contrib import admin

from .models import Post,User,PostLike,UserFollow,PostComment

# Register your models here.
admin.site.register(User)
admin.site.register(Post)
admin.site.register(PostLike)
admin.site.register(UserFollow)
admin.site.register(PostComment)