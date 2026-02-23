# RBAC Patterns

Role-based access control, permissions, and authorization middleware.

## Role Hierarchy

```
ADMIN
  ├─ USER
  │   └─ GUEST
  └─ MODERATOR
```

## Database Schema

```sql
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE permissions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE role_permissions (
    role_id INTEGER REFERENCES roles(id),
    permission_id INTEGER REFERENCES permissions(id),
    PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    role_id INTEGER REFERENCES roles(id)
);

-- Insert roles
INSERT INTO roles (name) VALUES ('ADMIN'), ('USER'), ('GUEST');

-- Insert permissions
INSERT INTO permissions (name) VALUES
    ('user.read'),
    ('user.create'),
    ('user.update'),
    ('user.delete'),
    ('order.read'),
    ('order.create');

-- Assign permissions to roles
-- ADMIN has all permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT 1, id FROM permissions;

-- USER has limited permissions
INSERT INTO role_permissions (role_id, permission_id)
VALUES (2, 1), (2, 5), (2, 6);  -- read users, read/create orders
```

## Python Implementation

### Models

```python
from enum import Enum
from sqlalchemy import Table, Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship

class Role(str, Enum):
    ADMIN = "admin"
    USER = "user"
    GUEST = "guest"

# Association table
user_roles = Table(
    'user_roles',
    Base.metadata,
    Column('user_id', Integer, ForeignKey('users.id')),
    Column('role_id', Integer, ForeignKey('roles.id'))
)

role_permissions = Table(
    'role_permissions',
    Base.metadata,
    Column('role_id', Integer, ForeignKey('roles.id')),
    Column('permission_id', Integer, ForeignKey('permissions.id'))
)

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True)
    email = Column(String, unique=True, nullable=False)
    roles = relationship("RoleModel", secondary=user_roles, back_populates="users")

class RoleModel(Base):
    __tablename__ = "roles"

    id = Column(Integer, primary_key=True)
    name = Column(String(50), unique=True, nullable=False)
    users = relationship("User", secondary=user_roles, back_populates="roles")
    permissions = relationship("Permission", secondary=role_permissions, back_populates="roles")

class Permission(Base):
    __tablename__ = "permissions"

    id = Column(Integer, primary_key=True)
    name = Column(String(100), unique=True, nullable=False)
    roles = relationship("RoleModel", secondary=role_permissions, back_populates="permissions")
```

### Role Checker

```python
from fastapi import Depends, HTTPException, status
from typing import List

def require_role(allowed_roles: List[Role]):
    def role_checker(current_user: User = Depends(get_current_user)):
        user_role_names = [role.name for role in current_user.roles]

        if not any(role.value in user_role_names for role in allowed_roles):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Requires one of: {[r.value for r in allowed_roles]}"
            )

        return current_user

    return role_checker

# Usage
@router.delete("/users/{user_id}")
def delete_user(
    user_id: int,
    current_user: User = Depends(require_role([Role.ADMIN]))
):
    # Only admins can access
    pass

@router.get("/users")
def get_users(
    current_user: User = Depends(require_role([Role.ADMIN, Role.USER]))
):
    # Admins and users can access
    pass
```

### Permission Checker

```python
def require_permission(permission: str):
    def permission_checker(current_user: User = Depends(get_current_user)):
        user_permissions = []
        for role in current_user.roles:
            user_permissions.extend([p.name for p in role.permissions])

        if permission not in user_permissions:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Missing permission: {permission}"
            )

        return current_user

    return permission_checker

# Usage
@router.post("/users")
def create_user(
    user_data: CreateUserRequest,
    current_user: User = Depends(require_permission("user.create"))
):
    pass
```

## Java/Spring Boot Implementation

### Models

```java
@Entity
@Table(name = "roles")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    private RoleName name;

    @ManyToMany(mappedBy = "roles")
    private Set<User> users = new HashSet<>();

    @ManyToMany
    @JoinTable(
        name = "role_permissions",
        joinColumns = @JoinColumn(name = "role_id"),
        inverseJoinColumns = @JoinColumn(name = "permission_id")
    )
    private Set<Permission> permissions = new HashSet<>();
}

@Entity
@Table(name = "users")
public class User {
    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "user_roles",
        joinColumns = @JoinColumn(name = "user_id"),
        inverseJoinColumns = @JoinColumn(name = "role_id")
    )
    private Set<Role> roles = new HashSet<>();
}

public enum RoleName {
    ADMIN, USER, GUEST
}
```

### Security Configuration

```java
@Configuration
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/v1/admin/**").hasRole("ADMIN")
                .requestMatchers("/api/v1/users/**").hasAnyRole("ADMIN", "USER")
                .anyRequest().authenticated()
            );
        return http.build();
    }
}
```

### Method Security

```java
@RestController
@RequestMapping("/api/v1/users")
public class UserController {

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }

    @PreAuthorize("hasAuthority('user.create')")
    @PostMapping
    public ResponseEntity<UserDTO> createUser(@RequestBody CreateUserRequest request) {
        UserDTO user = userService.createUser(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(user);
    }

    @PreAuthorize("hasRole('ADMIN') or #id == authentication.principal.id")
    @PutMapping("/{id}")
    public ResponseEntity<UserDTO> updateUser(
        @PathVariable Long id,
        @RequestBody UpdateUserRequest request
    ) {
        // Admin can update anyone, users can update themselves
        UserDTO user = userService.updateUser(id, request);
        return ResponseEntity.ok(user);
    }
}
```

## Resource-Based Authorization

Check ownership before allowing action:

```python
def require_owner_or_admin(resource_user_id: int):
    def ownership_checker(
        current_user: User = Depends(get_current_user)
    ):
        # Check if admin
        if any(role.name == "admin" for role in current_user.roles):
            return current_user

        # Check if owner
        if current_user.id != resource_user_id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to access this resource"
            )

        return current_user

    return ownership_checker

@router.put("/users/{user_id}")
def update_user(
    user_id: int,
    data: UpdateUserRequest,
    current_user: User = Depends(require_owner_or_admin(user_id))
):
    # User can update their own profile, or admin can update anyone
    pass
```

## Attribute-Based Access Control (ABAC)

More granular than RBAC:

```python
from typing import Callable

def check_access(
    resource: str,
    action: str,
    condition: Callable[[User], bool] = None
):
    def access_checker(current_user: User = Depends(get_current_user)):
        # Check permissions
        permission_name = f"{resource}.{action}"
        user_permissions = get_user_permissions(current_user)

        if permission_name not in user_permissions:
            raise HTTPException(status_code=403, detail="Access denied")

        # Check additional conditions
        if condition and not condition(current_user):
            raise HTTPException(status_code=403, detail="Condition not met")

        return current_user

    return access_checker

# Usage with condition
@router.get("/orders/{order_id}")
def get_order(
    order_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(
        check_access(
            "order",
            "read",
            lambda user: user.department == "sales"  # Only sales can view
        )
    )
):
    pass
```

## Row-Level Security

Filter queries based on user:

```python
def get_visible_orders(db: Session, current_user: User) -> List[Order]:
    query = db.query(Order)

    # Admins see all
    if current_user.role == Role.ADMIN:
        return query.all()

    # Users see only their orders
    return query.filter(Order.user_id == current_user.id).all()
```

## Frontend Integration

```typescript
// React hook for permissions
import { useAuth } from '@/hooks/useAuth';

export function usePermissions() {
  const { user } = useAuth();

  const hasRole = (role: string): boolean => {
    return user?.roles?.includes(role) ?? false;
  };

  const hasPermission = (permission: string): boolean => {
    return user?.permissions?.includes(permission) ?? false;
  };

  const canAccess = (resource: string, action: string): boolean => {
    return hasPermission(`${resource}.${action}`);
  };

  return { hasRole, hasPermission, canAccess };
}

// Component
function DeleteUserButton({ userId }: { userId: string }) {
  const { canAccess } = usePermissions();

  if (!canAccess('user', 'delete')) {
    return null;  // Hide button if no permission
  }

  return <button onClick={() => deleteUser(userId)}>Delete</button>;
}

// Route guard
function AdminRoute({ children }: { children: React.ReactNode }) {
  const { hasRole } = usePermissions();

  if (!hasRole('ADMIN')) {
    return <Navigate to="/forbidden" />;
  }

  return <>{children}</>;
}
```

## Best Practices

1. Use roles for broad categories (Admin, User)
2. Use permissions for specific actions
3. Check permissions on backend (never trust frontend)
4. Implement row-level security for multi-tenant apps
5. Cache permissions to reduce database queries
6. Log authorization failures for security auditing
7. Use resource-based checks for ownership
8. Provide clear error messages
9. Test authorization rules thoroughly
10. Review and update permissions regularly
