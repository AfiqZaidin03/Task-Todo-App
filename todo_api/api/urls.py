from django.urls import path

from . import views

urlpatterns = [
    path('routes/', views.getRoutes, name='get_routes'),
    path('tasks/', views.getTasks, name='get_tasks'),
    path('task/<int:pk>/', views.getTask, name='get_task'),
    path('task/create/', views.createTask, name='create_task'),
    path('task/<int:pk>/update/', views.updateTask, name='update_task'),
    path('task/<int:pk>/delete/', views.deleteTask, name='delete_task'),
    
]