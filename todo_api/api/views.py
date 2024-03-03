from rest_framework import generics, status
from rest_framework.decorators import api_view
from rest_framework.response import Response

from .models import Todo
from .serializers import TodoSerializer


@api_view(['GET'])
def getRoutes(request):
    routes = [
        {
            'Endpoint': '/notes/',
            'method': 'GET',
            'body': None,
            'description': 'Returns an array of notes'
        },
        {
            'Endpoint': '/notes/id',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single notes object'
        },
        {
            'Endpoint': '/notes/create',
            'method': 'POST',
            'body': {
                'title': "",
                'desc': "",
                'isDone': False
            },
            'description': 'Creates new note with data sent in post request'
        },
        {
            'Endpoint': '/notes/id/update',
            'method': 'PUT',
            'body': {
                'title': "",
                'desc': "",
                'isDone': False
            },
            'description': 'Creates an existing note with data sent in post request'
        },
        {
            'Endpoint': '/notes/id/delete',
            'method': 'DELETE',
            'body': None,
            'description': 'Deletes and existing note'
        },
    ]
    return Response(routes)

@api_view(['GET'])
def getTasks(request):
    tasks = Todo.objects.all()
    serializer = TodoSerializer(tasks, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getTask(request, pk):
    task = Todo.objects.get(id=pk)
    serializer = TodoSerializer(task)
    return Response(serializer.data)

@api_view(['POST'])
def createTask(request):
    data = request.data
    serializer = TodoSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['PUT'])
def updateTask(request, pk):
    try:
        task = Todo.objects.get(id=pk)
    except Todo.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    serializer = TodoSerializer(task, data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
def deleteTask(request, pk):
    try:
        task = Todo.objects.get(id=pk)
    except Todo.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    task.delete()
    return Response(status=status.HTTP_204_NO_CONTENT)

# class TodoGetCreate(generics.ListCreateAPIView):
#     queryset = Todo.objects.all()
#     serializer_class = TodoSerializer

# class TodoUpdateDelete(generics.RetrieveUpdateDestroyAPIView):
#     queryset = Todo.objects.all()
#     serializer_class = TodoSerializer

