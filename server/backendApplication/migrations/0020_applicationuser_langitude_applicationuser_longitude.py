# Generated by Django 4.1.7 on 2024-04-07 10:45

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('backendApplication', '0019_property_rename_feedback_applicationuser_feedback_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='applicationuser',
            name='langitude',
            field=models.FloatField(default=0.0),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='applicationuser',
            name='longitude',
            field=models.FloatField(default=0.0),
            preserve_default=False,
        ),
    ]
