# Generated by Django 4.1.7 on 2024-02-21 13:42

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('backendApplication', '0002_seller'),
    ]

    operations = [
        migrations.CreateModel(
            name='ApplicationUser',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('full_name', models.CharField(max_length=150)),
                ('email_address', models.EmailField(max_length=254, unique=True)),
                ('user_name', models.CharField(max_length=100, unique=True)),
                ('password', models.CharField(max_length=150)),
                ('otp_code', models.CharField(max_length=4)),
                ('verification_status', models.CharField(max_length=10)),
                ('user_type', models.CharField(max_length=10)),
            ],
        ),
        migrations.DeleteModel(
            name='Buyer',
        ),
        migrations.DeleteModel(
            name='Seller',
        ),
    ]
