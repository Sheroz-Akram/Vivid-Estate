# Generated by Django 4.1.7 on 2024-04-21 10:49

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('backendApplication', '0023_rename_propertyimages_propertyimage'),
    ]

    operations = [
        migrations.RenameField(
            model_name='property',
            old_name='propertyType',
            new_name='listingType',
        ),
        migrations.AddField(
            model_name='property',
            name='beds',
            field=models.IntegerField(default=0),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='property',
            name='floors',
            field=models.IntegerField(default=0),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='property',
            name='latitude',
            field=models.FloatField(default=0.0),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='property',
            name='longitude',
            field=models.FloatField(default=0.0),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='property',
            name='propertType',
            field=models.CharField(choices=[('N/A', 'N/A'), ('Appartment', 'Appartment'), ('Hostel', 'Hostel'), ('Room', 'Room'), ('House', 'Hosue')], default='N/A', max_length=20),
        ),
        migrations.AddField(
            model_name='property',
            name='size',
            field=models.IntegerField(default=0),
            preserve_default=False,
        ),
    ]
