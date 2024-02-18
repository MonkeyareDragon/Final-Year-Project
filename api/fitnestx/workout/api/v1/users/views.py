from rest_framework import viewsets, status, permissions
from rest_framework.response import Response
from fitnestx.workout.models import Equipment, Exercise, ExerciseSteps, Workout
from .serializers import WorkoutSerializer

class WorkoutViewSet(viewsets.ModelViewSet):
    permission_classes = [permissions.AllowAny]
    queryset = Workout.objects.all()
    serializer_class = WorkoutSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)