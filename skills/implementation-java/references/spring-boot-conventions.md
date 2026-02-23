# Spring Boot Conventions

Spring Boot 3 patterns including security, JPA, and validation.

## Application Configuration

```yaml
# application.yml
spring:
  application:
    name: my-app

  datasource:
    url: jdbc:postgresql://localhost:5432/mydb
    username: ${DB_USER}
    password: ${DB_PASSWORD}
    driver-class-name: org.postgresql.Driver

  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: false
    properties:
      hibernate:
        format_sql: true
        dialect: org.hibernate.dialect.PostgreSQLDialect

  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: https://auth.example.com

server:
  port: 8080
  error:
    include-message: always
    include-stacktrace: never

logging:
  level:
    com.example: DEBUG
    org.springframework: INFO
```

## Security Configuration

```java
// config/SecurityConfig.java
package com.example.app.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/v1/auth/**", "/api/v1/health").permitAll()
                .requestMatchers("/api/v1/admin/**").hasRole("ADMIN")
                .anyRequest().authenticated()
            )
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )
            .oauth2ResourceServer(oauth2 -> oauth2
                .jwt(jwt -> {})
            );

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
```

## JPA Configuration

### Entity Relationships

```java
// One-to-Many
@Entity
public class User {
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Order> orders = new ArrayList<>();

    public void addOrder(Order order) {
        orders.add(order);
        order.setUser(this);
    }
}

@Entity
public class Order {
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
}

// Many-to-Many
@Entity
public class Student {
    @ManyToMany
    @JoinTable(
        name = "student_course",
        joinColumns = @JoinColumn(name = "student_id"),
        inverseJoinColumns = @JoinColumn(name = "course_id")
    )
    private Set<Course> courses = new HashSet<>();
}

@Entity
public class Course {
    @ManyToMany(mappedBy = "courses")
    private Set<Student> students = new HashSet<>();
}
```

### Custom Queries

```java
@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // Derived query
    List<User> findByEmailContaining(String email);
    Optional<User> findByEmailAndActiveTrue(String email);

    // JPQL
    @Query("SELECT u FROM User u WHERE u.createdAt > :date")
    List<User> findRecentUsers(@Param("date") Instant date);

    // Native SQL
    @Query(value = "SELECT * FROM users WHERE role = :role", nativeQuery = true)
    List<User> findByRole(@Param("role") String role);

    // Modifying query
    @Modifying
    @Query("UPDATE User u SET u.active = false WHERE u.id = :id")
    void deactivateUser(@Param("id") Long id);

    // Pagination
    Page<User> findByActive(boolean active, Pageable pageable);

    // Projection
    @Query("SELECT new com.example.app.dto.UserSummary(u.id, u.email) FROM User u")
    List<UserSummary> findAllSummaries();
}
```

### Specifications (Dynamic Queries)

```java
// specification/UserSpecification.java
import org.springframework.data.jpa.domain.Specification;

public class UserSpecification {

    public static Specification<User> hasEmail(String email) {
        return (root, query, cb) ->
            email == null ? null : cb.equal(root.get("email"), email);
    }

    public static Specification<User> isActive(Boolean active) {
        return (root, query, cb) ->
            active == null ? null : cb.equal(root.get("active"), active);
    }

    public static Specification<User> createdAfter(Instant date) {
        return (root, query, cb) ->
            date == null ? null : cb.greaterThan(root.get("createdAt"), date);
    }
}

// Usage
Specification<User> spec = Specification.where(UserSpecification.hasEmail(email))
    .and(UserSpecification.isActive(true))
    .and(UserSpecification.createdAfter(date));

List<User> users = userRepository.findAll(spec);
```

## Validation

```java
import jakarta.validation.constraints.*;

public record CreateUserRequest(
    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    String email,

    @NotBlank(message = "Name is required")
    @Size(min = 2, max = 100, message = "Name must be between 2 and 100 characters")
    String name,

    @NotNull(message = "Age is required")
    @Min(value = 18, message = "Must be at least 18")
    @Max(value = 120, message = "Must be at most 120")
    Integer age,

    @Pattern(regexp = "^\\+?[1-9]\\d{1,14}$", message = "Invalid phone number")
    String phone,

    @Past(message = "Birth date must be in the past")
    LocalDate birthDate
) {}

// Custom validator
import jakarta.validation.Constraint;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

@Constraint(validatedBy = UniqueEmailValidator.class)
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface UniqueEmail {
    String message() default "Email already exists";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}

public class UniqueEmailValidator implements ConstraintValidator<UniqueEmail, String> {
    @Autowired
    private UserRepository userRepository;

    @Override
    public boolean isValid(String email, ConstraintValidatorContext context) {
        return email != null && !userRepository.existsByEmail(email);
    }
}
```

## Transaction Management

```java
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;
    private final InventoryService inventoryService;

    @Transactional
    public Order createOrder(CreateOrderRequest request) {
        // Check inventory
        inventoryService.reserveItems(request.items());

        // Create order
        Order order = new Order();
        // ... populate order
        return orderRepository.save(order);
    }

    @Transactional(readOnly = true)
    public List<Order> getOrders() {
        return orderRepository.findAll();
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void logAction(String action) {
        // Runs in new transaction
    }

    @Transactional(isolation = Isolation.SERIALIZABLE)
    public void criticalOperation() {
        // Highest isolation level
    }
}
```

## Pagination and Sorting

```java
// Controller
@GetMapping
public ResponseEntity<Page<UserDTO>> getUsers(
    @RequestParam(defaultValue = "0") int page,
    @RequestParam(defaultValue = "20") int size,
    @RequestParam(defaultValue = "id,asc") String[] sort
) {
    Sort.Direction direction = sort[1].equalsIgnoreCase("desc") ? Sort.Direction.DESC : Sort.Direction.ASC;
    Pageable pageable = PageRequest.of(page, size, Sort.by(direction, sort[0]));

    Page<UserDTO> users = userService.getUsers(pageable);
    return ResponseEntity.ok(users);
}

// Service
@Transactional(readOnly = true)
public Page<UserDTO> getUsers(Pageable pageable) {
    Page<User> users = userRepository.findAll(pageable);
    return users.map(userMapper::toDTO);
}
```

## Caching

```java
import org.springframework.cache.annotation.*;

@Service
@RequiredArgsConstructor
@CacheConfig(cacheNames = "users")
public class UserService {

    @Cacheable(key = "#id")
    public UserDTO getUserById(Long id) {
        // Cached by id
        return userMapper.toDTO(userRepository.findById(id).orElseThrow());
    }

    @CachePut(key = "#result.id")
    public UserDTO updateUser(Long id, UpdateUserRequest request) {
        // Updates cache
        User user = userRepository.findById(id).orElseThrow();
        userMapper.updateEntity(user, request);
        return userMapper.toDTO(userRepository.save(user));
    }

    @CacheEvict(key = "#id")
    public void deleteUser(Long id) {
        // Removes from cache
        userRepository.deleteById(id);
    }

    @CacheEvict(allEntries = true)
    public void clearCache() {
        // Clears entire cache
    }
}

// Configuration
@Configuration
@EnableCaching
public class CacheConfig {
    @Bean
    public CacheManager cacheManager() {
        return new ConcurrentMapCacheManager("users", "orders");
    }
}
```

## Testing

```java
// Unit test
@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private UserMapper userMapper;

    @InjectMocks
    private UserServiceImpl userService;

    @Test
    void getUserById_ShouldReturnUser() {
        // Arrange
        User user = new User();
        user.setId(1L);
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(userMapper.toDTO(user)).thenReturn(new UserDTO(1L, "test@ex.com", "Test", "User", Instant.now()));

        // Act
        UserDTO result = userService.getUserById(1L);

        // Assert
        assertNotNull(result);
        assertEquals(1L, result.id());
        verify(userRepository).findById(1L);
    }
}

// Integration test
@SpringBootTest
@AutoConfigureMockMvc
class UserControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void createUser_ShouldReturnCreated() throws Exception {
        CreateUserRequest request = new CreateUserRequest("test@ex.com", "Test", "User", "password");

        mockMvc.perform(post("/api/v1/users")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.email").value("test@ex.com"));
    }
}
```

## Best Practices

1. Use constructor injection with @RequiredArgsConstructor
2. Use records for DTOs
3. Add @Transactional on service methods
4. Use @Valid for input validation
5. Implement global exception handling
6. Use Page<T> for pagination
7. Use Specifications for dynamic queries
8. Cache frequently accessed data
9. Write integration tests
10. Use application.yml for configuration
