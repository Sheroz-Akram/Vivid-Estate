from django.db import models

# Create your models here.
class ApplicationUser(models.Model):
    private_key = models.CharField(max_length=60)
    full_name = models.CharField(max_length=150)
    email_address = models.EmailField(unique=True)
    user_name = models.CharField(unique=True, max_length=100)
    password = models.CharField(max_length=150)
    otp_code = models.CharField(max_length=4)
    verification_status = models.CharField(max_length=10)
    user_type = models.CharField(max_length=10)
    cnic_file = models.CharField(max_length=255)
    cnic_name = models.CharField(max_length=150)
    cnic_number = models.CharField(max_length=50)
    cnic_father_name = models.CharField(max_length=150)
    cnic_dob = models.CharField(max_length=50)

    def __str__(self):
        return "User: " + self.full_name + "    Email: " +self.email_address

