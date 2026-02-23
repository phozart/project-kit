# Django Conventions

Django project structure, views, serializers, and ORM patterns.

## Project Structure

```
project/
├── apps/
│   ├── users/
│   │   ├── __init__.py
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── serializers.py
│   │   ├── services.py
│   │   ├── repositories.py
│   │   ├── urls.py
│   │   ├── admin.py
│   │   └── tests.py
│   └── orders/
├── core/
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── manage.py
└── requirements.txt
```

## Models

```python
# apps/users/models.py
from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    email = models.EmailField(unique=True)
    bio = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'users'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['email']),
        ]

    def __str__(self):
        return self.email

class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    phone = models.CharField(max_length=20, blank=True)
    address = models.TextField(blank=True)

    def __str__(self):
        return f"{self.user.email}'s profile"
```

## Serializers (Django REST Framework)

```python
# apps/users/serializers.py
from rest_framework import serializers
from .models import User, Profile

class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ['phone', 'address']

class UserSerializer(serializers.ModelSerializer):
    profile = ProfileSerializer(read_only=True)
    full_name = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['id', 'email', 'first_name', 'last_name', 'full_name', 'profile', 'created_at']
        read_only_fields = ['id', 'created_at']

    def get_full_name(self, obj):
        return f"{obj.first_name} {obj.last_name}"

class CreateUserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)

    class Meta:
        model = User
        fields = ['email', 'first_name', 'last_name', 'password']

    def validate_password(self, value):
        if not any(char.isdigit() for char in value):
            raise serializers.ValidationError("Password must contain at least one digit")
        return value

    def create(self, validated_data):
        return User.objects.create_user(**validated_data)

class UpdateUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['first_name', 'last_name', 'bio']
```

## Views

### ViewSets

```python
# apps/users/views.py
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .models import User
from .serializers import UserSerializer, CreateUserSerializer, UpdateUserSerializer

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]

    def get_serializer_class(self):
        if self.action == 'create':
            return CreateUserSerializer
        elif self.action in ['update', 'partial_update']:
            return UpdateUserSerializer
        return UserSerializer

    def get_queryset(self):
        queryset = super().get_queryset()
        # Filter by query params
        status = self.request.query_params.get('status')
        if status:
            queryset = queryset.filter(is_active=(status == 'active'))
        return queryset

    @action(detail=False, methods=['get'])
    def me(self, request):
        serializer = self.get_serializer(request.user)
        return Response(serializer.data)

    @action(detail=True, methods=['post'])
    def deactivate(self, request, pk=None):
        user = self.get_object()
        user.is_active = False
        user.save()
        return Response({'status': 'user deactivated'})
```

### Generic Views

```python
from rest_framework import generics

class UserListView(generics.ListAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer

class UserDetailView(generics.RetrieveAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer

class UserCreateView(generics.CreateAPIView):
    serializer_class = CreateUserSerializer
```

## URL Routing

```python
# apps/users/urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import UserViewSet

router = DefaultRouter()
router.register(r'users', UserViewSet)

urlpatterns = [
    path('', include(router.urls)),
]

# core/urls.py
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/v1/', include('apps.users.urls')),
]
```

## ORM Patterns

### Querying

```python
# Get single object
user = User.objects.get(id=1)

# Filter
active_users = User.objects.filter(is_active=True)

# Exclude
non_admin_users = User.objects.exclude(is_staff=True)

# Chaining
users = User.objects.filter(is_active=True).exclude(is_staff=True).order_by('-created_at')

# Select related (reduce N+1 queries)
users = User.objects.select_related('profile').all()

# Prefetch related (for many-to-many)
users = User.objects.prefetch_related('groups').all()

# Aggregate
from django.db.models import Count, Avg
stats = User.objects.aggregate(
    total=Count('id'),
    avg_age=Avg('age')
)

# Annotate
from django.db.models import Count
users = User.objects.annotate(
    num_orders=Count('orders')
).filter(num_orders__gt=0)
```

### Creating/Updating

```python
# Create
user = User.objects.create(
    email='user@example.com',
    first_name='John',
    last_name='Doe'
)

# Get or create
user, created = User.objects.get_or_create(
    email='user@example.com',
    defaults={'first_name': 'John', 'last_name': 'Doe'}
)

# Update
User.objects.filter(id=1).update(first_name='Jane')

# Update or create
user, created = User.objects.update_or_create(
    email='user@example.com',
    defaults={'first_name': 'John', 'last_name': 'Doe'}
)

# Bulk create
users = [
    User(email='user1@example.com', first_name='User1'),
    User(email='user2@example.com', first_name='User2'),
]
User.objects.bulk_create(users)

# Delete
User.objects.filter(id=1).delete()
```

## Permissions

```python
# permissions.py
from rest_framework import permissions

class IsOwnerOrReadOnly(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        if request.method in permissions.SAFE_METHODS:
            return True
        return obj.user == request.user

# views.py
class UserViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated, IsOwnerOrReadOnly]
```

## Pagination

```python
# settings.py
REST_FRAMEWORK = {
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 20
}

# Custom pagination
from rest_framework.pagination import PageNumberPagination

class CustomPagination(PageNumberPagination):
    page_size = 10
    page_size_query_param = 'page_size'
    max_page_size = 100

# views.py
class UserViewSet(viewsets.ModelViewSet):
    pagination_class = CustomPagination
```

## Filters

```python
# Install django-filter
# pip install django-filter

# settings.py
INSTALLED_APPS = [
    'django_filters',
]

REST_FRAMEWORK = {
    'DEFAULT_FILTER_BACKENDS': [
        'django_filters.rest_framework.DjangoFilterBackend',
        'rest_framework.filters.SearchFilter',
        'rest_framework.filters.OrderingFilter',
    ]
}

# filters.py
from django_filters import rest_framework as filters
from .models import User

class UserFilter(filters.FilterSet):
    email = filters.CharFilter(lookup_expr='icontains')
    created_after = filters.DateTimeFilter(field_name='created_at', lookup_expr='gte')

    class Meta:
        model = User
        fields = ['email', 'is_active', 'created_after']

# views.py
class UserViewSet(viewsets.ModelViewSet):
    filterset_class = UserFilter
    search_fields = ['email', 'first_name', 'last_name']
    ordering_fields = ['created_at', 'email']
```

## Signals

```python
# signals.py
from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import User, Profile

@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        Profile.objects.create(user=instance)

# apps.py
from django.apps import AppConfig

class UsersConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'apps.users'

    def ready(self):
        import apps.users.signals
```

## Testing

```python
# tests.py
from django.test import TestCase
from rest_framework.test import APITestCase
from rest_framework import status
from .models import User

class UserModelTest(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            email='test@example.com',
            password='testpass123'
        )

    def test_user_creation(self):
        self.assertEqual(self.user.email, 'test@example.com')
        self.assertTrue(self.user.check_password('testpass123'))

class UserAPITest(APITestCase):
    def test_create_user(self):
        data = {
            'email': 'test@example.com',
            'first_name': 'Test',
            'last_name': 'User',
            'password': 'testpass123'
        }
        response = self.client.post('/api/v1/users/', data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(User.objects.count(), 1)
```

## Best Practices

1. Use `select_related` and `prefetch_related` to avoid N+1 queries
2. Use ViewSets for REST APIs
3. Implement proper serializer validation
4. Use permissions for access control
5. Use filters for querying
6. Implement pagination for list endpoints
7. Use signals sparingly (can be hard to debug)
8. Write tests for models and views
9. Use transactions for data integrity
10. Follow Django naming conventions
