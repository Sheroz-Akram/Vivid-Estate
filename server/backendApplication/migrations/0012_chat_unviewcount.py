# Generated by Django 4.1.7 on 2024-03-17 19:24

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('backendApplication', '0011_chatmessage_status'),
    ]

    operations = [
        migrations.AddField(
            model_name='chat',
            name='unviewCount',
            field=models.IntegerField(default=0),
            preserve_default=False,
        ),
    ]
