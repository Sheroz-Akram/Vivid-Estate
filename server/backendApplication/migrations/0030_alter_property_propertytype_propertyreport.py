# Generated by Django 4.1.7 on 2024-05-16 14:19

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('backendApplication', '0029_rename_seller_favourite_user_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='property',
            name='propertyType',
            field=models.CharField(choices=[('N/A', 'N/A'), ('Appartment', 'Appartment'), ('Room', 'Room'), ('Hostel', 'Hostel'), ('House', 'Hosue')], default='N/A', max_length=20),
        ),
        migrations.CreateModel(
            name='PropertyReport',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('issueType', models.CharField(max_length=50)),
                ('reportDetails', models.TextField()),
                ('propertyID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backendApplication.property')),
                ('reportingUser', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backendApplication.applicationuser')),
            ],
        ),
    ]