# Generated by Django 4.1.7 on 2024-03-17 12:29

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('backendApplication', '0007_applicationuser_profile_pic'),
    ]

    operations = [
        migrations.AddField(
            model_name='chat',
            name='modified',
            field=models.DateTimeField(auto_now=True),
        ),
    ]
