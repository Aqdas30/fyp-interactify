# from django.contrib.auth.models import BaseUserManager
# from django.utils.translation import gettext_lazy as _

# class UserManager(BaseUserManager):
#     def create_user(self, email, password=None, **extra_fields):
#         """Create and save a regular user with the given email and password."""
#         if not email:
#             raise ValueError(_('The Email field must be set'))
#         email = self.normalize_email(email)
#         # Create a new user instance using self.model
#         user = self.model(email=email, **extra_fields)
#         user.set_password(password)  # Set the user's password
#         user.save(using=self._db)  # Save the user to the database
#         return user

#     def create_superuser(self, email, password=None, **extra_fields):
#         """Create and save a superuser with the given email and password."""
#         extra_fields.setdefault('is_staff', True)
#         extra_fields.setdefault('is_superuser', True)

#         if extra_fields.get('is_staff') is not True:
#             raise ValueError(_('Superuser must have is_staff=True.'))
#         if extra_fields.get('is_superuser') is not True:
#             raise ValueError(_('Superuser must have is_superuser=True.'))

#         return self.create_user(email, password, **extra_fields)
