# Generated by Django 4.1.7 on 2024-03-08 08:45

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('backendApplication', '0003_applicationuser_delete_buyer_delete_seller'),
    ]

    operations = [
        migrations.AddField(
            model_name='applicationuser',
            name='cnic_dob',
            field=models.CharField(default=0.0004997501249375312, max_length=50),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='applicationuser',
            name='cnic_father_name',
            field=models.CharField(default='as', max_length=150),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='applicationuser',
            name='cnic_file',
            field=models.CharField(default='as', max_length=255),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='applicationuser',
            name='cnic_name',
            field=models.CharField(default='as', max_length=150),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='applicationuser',
            name='cnic_number',
            field=models.CharField(default=123134235, max_length=50),
            preserve_default=False,
        ),
    ]
