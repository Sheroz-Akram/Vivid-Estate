# Generated by Django 4.1.7 on 2024-05-16 17:34

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('backendApplication', '0031_alter_property_propertytype'),
    ]

    operations = [
        migrations.AddField(
            model_name='chatmessage',
            name='Type',
            field=models.CharField(default='text', max_length=255),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='property',
            name='propertyType',
            field=models.CharField(choices=[('Appartment', 'Appartment'), ('Hostel', 'Hostel'), ('House', 'Hosue'), ('Room', 'Room'), ('N/A', 'N/A')], default='N/A', max_length=20),
        ),
    ]
