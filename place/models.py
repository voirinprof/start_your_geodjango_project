from django.contrib.gis.db import models

class Place(models.Model):
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    location = models.PointField(geography=True, srid=4326)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name