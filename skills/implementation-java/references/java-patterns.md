# Java Patterns

Java 21+ features including records, sealed classes, and pattern matching.

## Records (Java 14+)

Immutable data carriers:

```java
// Simple record
public record User(Long id, String email, String name) {}

// With validation
public record User(Long id, String email, String name) {
    public User {
        if (email == null || !email.contains("@")) {
            throw new IllegalArgumentException("Invalid email");
        }
    }
}

// With methods
public record User(String firstName, String lastName) {
    public String fullName() {
        return firstName + " " + lastName;
    }
}

// Usage
User user = new User(1L, "john@example.com", "John");
System.out.println(user.email());  // john@example.com
```

## Sealed Classes (Java 17+)

Restrict which classes can extend/implement:

```java
public sealed interface Shape
    permits Circle, Rectangle, Triangle {}

public final class Circle implements Shape {
    private final double radius;
    public Circle(double radius) { this.radius = radius; }
}

public final class Rectangle implements Shape {
    private final double width, height;
    public Rectangle(double width, double height) {
        this.width = width;
        this.height = height;
    }
}

public final class Triangle implements Shape {
    private final double base, height;
    public Triangle(double base, double height) {
        this.base = base;
        this.height = height;
    }
}
```

## Pattern Matching

### instanceof (Java 16+)

```java
// Old way
if (obj instanceof String) {
    String str = (String) obj;
    System.out.println(str.length());
}

// New way
if (obj instanceof String str) {
    System.out.println(str.length());
}
```

### Switch Expressions (Java 17+)

```java
// With sealed classes
public double area(Shape shape) {
    return switch (shape) {
        case Circle c -> Math.PI * c.radius() * c.radius();
        case Rectangle r -> r.width() * r.height();
        case Triangle t -> 0.5 * t.base() * t.height();
    };
}

// With null check
String result = switch (obj) {
    case null -> "null";
    case String s -> "String: " + s;
    case Integer i -> "Integer: " + i;
    default -> "Unknown";
};
```

## Text Blocks (Java 15+)

```java
String json = """
    {
        "name": "John",
        "email": "john@example.com",
        "age": 30
    }
    """;

String sql = """
    SELECT u.id, u.email, u.name
    FROM users u
    WHERE u.created_at > ?
    ORDER BY u.name
    """;
```

## Optionals

```java
import java.util.Optional;

// Create
Optional<User> user = userRepository.findById(id);

// Get or throw
User user = optional.orElseThrow(() ->
    new ResourceNotFoundException("User not found"));

// Get or default
User user = optional.orElse(new User());

// Map
Optional<String> email = userOptional.map(User::getEmail);

// Filter
Optional<User> activeUser = userOptional.filter(User::isActive);

// ifPresent
userOptional.ifPresent(user -> System.out.println(user.getName()));

// ifPresentOrElse
userOptional.ifPresentOrElse(
    user -> System.out.println(user.getName()),
    () -> System.out.println("No user found")
);
```

## Streams

```java
import java.util.stream.Collectors;
import java.util.List;
import java.util.Map;

List<User> users = userRepository.findAll();

// Filter and map
List<String> emails = users.stream()
    .filter(User::isActive)
    .map(User::getEmail)
    .collect(Collectors.toList());

// Find first
Optional<User> admin = users.stream()
    .filter(u -> u.getRole() == Role.ADMIN)
    .findFirst();

// Count
long count = users.stream()
    .filter(User::isActive)
    .count();

// Group by
Map<Role, List<User>> usersByRole = users.stream()
    .collect(Collectors.groupingBy(User::getRole));

// Partition
Map<Boolean, List<User>> activeUsers = users.stream()
    .collect(Collectors.partitioningBy(User::isActive));

// To map
Map<Long, User> userMap = users.stream()
    .collect(Collectors.toMap(User::getId, u -> u));
```

## Lombok

```java
import lombok.*;

// @Data = @Getter + @Setter + @ToString + @EqualsAndHashCode + @RequiredArgsConstructor
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    private Long id;
    private String email;
    private String name;
}

// @Builder
@Builder
public class User {
    private Long id;
    private String email;
    private String name;
}

// Usage
User user = User.builder()
    .id(1L)
    .email("john@example.com")
    .name("John")
    .build();

// Constructor injection
@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final UserMapper userMapper;
}
```

## Exception Handling

```java
// Try-with-resources
try (Connection conn = dataSource.getConnection();
     PreparedStatement stmt = conn.prepareStatement(sql)) {
    ResultSet rs = stmt.executeQuery();
    // Process results
} catch (SQLException e) {
    throw new DatabaseException("Database error", e);
}

// Multiple catch blocks
try {
    processData();
} catch (IOException e) {
    logger.error("IO error", e);
} catch (SQLException e) {
    logger.error("Database error", e);
} catch (Exception e) {
    logger.error("Unexpected error", e);
    throw new RuntimeException(e);
}
```

## Var (Type Inference)

```java
// Local variables only
var user = new User();
var users = userRepository.findAll();
var email = user.getEmail();

// Not allowed
// var = null;  // Cannot infer type
// public var email;  // Only for local variables
```

## Collections

```java
import java.util.*;

// List
List<String> names = new ArrayList<>();
List<String> names = List.of("Alice", "Bob", "Charlie");  // Immutable

// Set
Set<String> emails = new HashSet<>();
Set<String> emails = Set.of("a@ex.com", "b@ex.com");  // Immutable

// Map
Map<Long, User> userMap = new HashMap<>();
Map<String, Integer> scores = Map.of(
    "Alice", 100,
    "Bob", 95
);  // Immutable

// Copy
List<User> copy = new ArrayList<>(users);
Set<User> copy = new HashSet<>(users);
```

## CompletableFuture (Async)

```java
import java.util.concurrent.CompletableFuture;

// Async execution
CompletableFuture<User> future = CompletableFuture.supplyAsync(() ->
    userRepository.findById(id).orElse(null)
);

// Chain operations
CompletableFuture<String> result = future
    .thenApply(user -> user.getEmail())
    .thenApply(String::toUpperCase);

// Multiple futures
CompletableFuture<User> userFuture = getUserAsync(1L);
CompletableFuture<List<Order>> ordersFuture = getOrdersAsync(1L);

CompletableFuture.allOf(userFuture, ordersFuture).join();

User user = userFuture.get();
List<Order> orders = ordersFuture.get();

// Exception handling
future.exceptionally(ex -> {
    logger.error("Error", ex);
    return null;
});
```

## Best Practices

1. Use records for DTOs (immutable)
2. Use sealed classes for fixed hierarchies
3. Use pattern matching with switch
4. Use Optionals instead of null
5. Use Streams for collection operations
6. Use Lombok to reduce boilerplate
7. Use var for local variables
8. Use try-with-resources
9. Use CompletableFuture for async
10. Prefer immutable collections
