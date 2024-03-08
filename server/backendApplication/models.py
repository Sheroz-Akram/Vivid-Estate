from django.db import models

# Create your models here.
class ApplicationUser(models.Model):
    full_name = models.CharField(max_length=150)
    email_address = models.EmailField(unique=True)
    user_name = models.CharField(unique=True, max_length=100)
    password = models.CharField(max_length=150)
    otp_code = models.CharField(max_length=4)
    verification_status = models.CharField(max_length=10)
    user_type = models.CharField(max_length=10)

    def __str__(self):
        return "User: " + self.full_name + "    Email: " +self.email_address

