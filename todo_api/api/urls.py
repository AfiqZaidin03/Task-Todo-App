from django.urls import path

from . import views

urlpatterns = [
    path('', views.getRoutes),
    path('notes/', views.getTasks),
    path('notes/create/', views.createTask),
    path('notes/<str:pk>/update/', views.updateTask),
    path('notes/<str:pk>/delete/', views.deleteTask),
    path('notes/<str:pk>/', views.getTask)
]