# Generated by Django 4.1.7 on 2024-04-06 15:01

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('backendApplication', '0018_applicationuser_feedback'),
    ]

    operations = [
        migrations.CreateModel(
            name='Property',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('description', models.TextField()),
                ('propertyType', models.CharField(max_length=50)),
                ('views', models.IntegerField()),
                ('likes', models.IntegerField()),
                ('price', models.IntegerField()),
            ],
        ),
        migrations.RenameField(
            model_name='applicationuser',
            old_name='Feedback',
            new_name='feedback',
        ),
        migrations.CreateModel(
            name='PropertyImages',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('imageLocation', models.CharField(max_length=255)),
                ('propertyID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backendApplication.property')),
            ],
        ),
    ]