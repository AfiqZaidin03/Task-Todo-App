from django.db import models

# Create your models here.

class Todo(models.Model):
    title = models.CharField(max_length = 100)
    desc = models.CharField(max_length = 200)
    isDone = models.BooleanField(default = False)
    updated = models.DateTimeField(auto_now=True)
    created = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title[0:50]
    
    class Meta: 
        ordering = ['-updated']