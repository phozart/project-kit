---
name: implementation-java
description: Java/Spring Boot implementation with clean architecture patterns
---

# Java Implementation Skill

Java/Spring Boot implementation skill with Controller→Service→Repository clean architecture.

## When to Use

- Java backend implementation tasks
- "Build the Spring Boot app"
- "Implement Java backend"
- Phase 7 implementation when Java is the chosen language

## Architecture

Strict layer separation:

```
src/main/java/com/example/
├── controller/       # REST controllers
├── service/          # Business logic
├── repository/       # Data access
├── model/            # Entity classes
├── dto/              # Data Transfer Objects (TYPE-CONTRACTS)
├── mapper/           # Entity ↔ DTO conversion
├── config/           # Configuration
└── exception/        # Custom exceptions
```

### Layer Responsibilities

**Controller Layer**
- HTTP request/response
- Input validation
- Delegate to services
- Return DTOs (never entities)

**Service Layer**
- Business logic
- Transaction management
- Orchestrate repositories
- Convert entities to DTOs

**Repository Layer**
- Database queries
- Extend JpaRepository
- Custom queries with @Query

## Spring Boot Project Structure

```
src/
├── main/
│   ├── java/com/example/app/
│   │   ├── controller/
│   │   │   └── UserController.java
│   │   ├── service/
│   │   │   ├── UserService.java
│   │   │   └── impl/
│   │   │       └── UserServiceImpl.java
│   │   ├── repository/
│   │   │   └── UserRepository.java
│   │   ├── model/
│   │   │   └── User.java
│   │   ├── dto/
│   │   │   ├── UserDTO.java
│   │   │   ├── CreateUserRequest.java
│   │   │   └── UpdateUserRequest.java
│   │   ├── mapper/
│   │   │   └── UserMapper.java
│   │   ├── exception/
│   │   │   ├── ResourceNotFoundException.java
│   │   │   └── GlobalExceptionHandler.java
│   │   ├── config/
│   │   │   ├── SecurityConfig.java
│   │   │   └── JpaConfig.java
│   │   └── Application.java
│   └── resources/
│       ├── application.yml
│       └── db/migration/
└── test/
    └── java/com/example/app/
```

## DTOs (TYPE-CONTRACTS)

Use records for immutable DTOs (Java 17+):

```java
// dto/UserDTO.java
package com.example.app.dto;

import java.time.Instant;

public record UserDTO(
    Long id,
    String email,
    String firstName,
    String lastName,
    Instant createdAt
) {}

// dto/CreateUserRequest.java
import jakarta.validation.constraints.*;

public record CreateUserRequest(
    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    String email,

    @NotBlank(message = "First name is required")
    @Size(min = 1, max = 100)
    String firstName,

    @NotBlank(message = "Last name is required")
    @Size(min = 1, max = 100)
    String lastName,

    @NotBlank(message = "Password is required")
    @Size(min = 8)
    String password
) {}

// dto/UpdateUserRequest.java
public record UpdateUserRequest(
    @Size(min = 1, max = 100)
    String firstName,

    @Size(min = 1, max = 100)
    String lastName
) {}
```

## Entity Models

```java
// model/User.java
package com.example.app.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.Instant;

@Entity
@Table(name = "users", indexes = {
    @Index(name = "idx_email", columnList = "email")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 255)
    private String email;

    @Column(name = "first_name", nullable = false, length = 100)
    private String firstName;

    @Column(name = "last_name", nullable = false, length = 100)
    private String lastName;

    @Column(name = "hashed_password", nullable = false)
    private String hashedPassword;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private Instant updatedAt;
}
```

## Repository Layer

```java
// repository/UserRepository.java
package com.example.app.repository;

import com.example.app.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByEmail(String email);

    boolean existsByEmail(String email);

    List<User> findByFirstNameContainingIgnoreCase(String firstName);

    @Query("SELECT u FROM User u WHERE u.createdAt > :date")
    List<User> findUsersCreatedAfter(Instant date);

    @Query(value = "SELECT * FROM users WHERE email LIKE %:domain", nativeQuery = true)
    List<User> findByEmailDomain(String domain);
}
```

## Mapper

```java
// mapper/UserMapper.java
package com.example.app.mapper;

import com.example.app.dto.*;
import com.example.app.model.User;
import org.springframework.stereotype.Component;

@Component
public class UserMapper {

    public UserDTO toDTO(User user) {
        return new UserDTO(
            user.getId(),
            user.getEmail(),
            user.getFirstName(),
            user.getLastName(),
            user.getCreatedAt()
        );
    }

    public User toEntity(CreateUserRequest request, String hashedPassword) {
        User user = new User();
        user.setEmail(request.email());
        user.setFirstName(request.firstName());
        user.setLastName(request.lastName());
        user.setHashedPassword(hashedPassword);
        return user;
    }

    public void updateEntity(User user, UpdateUserRequest request) {
        if (request.firstName() != null) {
            user.setFirstName(request.firstName());
        }
        if (request.lastName() != null) {
            user.setLastName(request.lastName());
        }
    }
}
```

## Service Layer

```java
// service/UserService.java
package com.example.app.service;

import com.example.app.dto.*;
import java.util.List;

public interface UserService {
    List<UserDTO> getAllUsers();
    UserDTO getUserById(Long id);
    UserDTO createUser(CreateUserRequest request);
    UserDTO updateUser(Long id, UpdateUserRequest request);
    void deleteUser(Long id);
}

// service/impl/UserServiceImpl.java
package com.example.app.service.impl;

import com.example.app.dto.*;
import com.example.app.exception.ResourceNotFoundException;
import com.example.app.mapper.UserMapper;
import com.example.app.model.User;
import com.example.app.repository.UserRepository;
import com.example.app.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional(readOnly = true)
    public List<UserDTO> getAllUsers() {
        return userRepository.findAll().stream()
            .map(userMapper::toDTO)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public UserDTO getUserById(Long id) {
        User user = userRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));
        return userMapper.toDTO(user);
    }

    @Override
    public UserDTO createUser(CreateUserRequest request) {
        if (userRepository.existsByEmail(request.email())) {
            throw new IllegalArgumentException("Email already exists: " + request.email());
        }

        String hashedPassword = passwordEncoder.encode(request.password());
        User user = userMapper.toEntity(request, hashedPassword);
        User savedUser = userRepository.save(user);

        return userMapper.toDTO(savedUser);
    }

    @Override
    public UserDTO updateUser(Long id, UpdateUserRequest request) {
        User user = userRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));

        userMapper.updateEntity(user, request);
        User updatedUser = userRepository.save(user);

        return userMapper.toDTO(updatedUser);
    }

    @Override
    public void deleteUser(Long id) {
        if (!userRepository.existsById(id)) {
            throw new ResourceNotFoundException("User not found with id: " + id);
        }
        userRepository.deleteById(id);
    }
}
```

## Controller Layer

```java
// controller/UserController.java
package com.example.app.controller;

import com.example.app.dto.*;
import com.example.app.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping
    public ResponseEntity<List<UserDTO>> getAllUsers() {
        List<UserDTO> users = userService.getAllUsers();
        return ResponseEntity.ok(users);
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserDTO> getUserById(@PathVariable Long id) {
        UserDTO user = userService.getUserById(id);
        return ResponseEntity.ok(user);
    }

    @PostMapping
    public ResponseEntity<UserDTO> createUser(@Valid @RequestBody CreateUserRequest request) {
        UserDTO user = userService.createUser(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(user);
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserDTO> updateUser(
        @PathVariable Long id,
        @Valid @RequestBody UpdateUserRequest request
    ) {
        UserDTO user = userService.updateUser(id, request);
        return ResponseEntity.ok(user);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }
}
```

## Exception Handling

```java
// exception/ResourceNotFoundException.java
package com.example.app.exception;

public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String message) {
        super(message);
    }
}

// exception/GlobalExceptionHandler.java
package com.example.app.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleResourceNotFound(ResourceNotFoundException ex) {
        ErrorResponse error = new ErrorResponse(
            HttpStatus.NOT_FOUND.value(),
            ex.getMessage(),
            Instant.now()
        );
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ErrorResponse> handleIllegalArgument(IllegalArgumentException ex) {
        ErrorResponse error = new ErrorResponse(
            HttpStatus.BAD_REQUEST.value(),
            ex.getMessage(),
            Instant.now()
        );
        return ResponseEntity.badRequest().body(error);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ValidationErrorResponse> handleValidationErrors(
        MethodArgumentNotValidException ex
    ) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach(error -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });

        ValidationErrorResponse response = new ValidationErrorResponse(
            HttpStatus.BAD_REQUEST.value(),
            "Validation failed",
            errors,
            Instant.now()
        );
        return ResponseEntity.badRequest().body(response);
    }
}

record ErrorResponse(int status, String message, Instant timestamp) {}
record ValidationErrorResponse(int status, String message, Map<String, String> errors, Instant timestamp) {}
```

## Quality Gates

Implementation must satisfy:
- Constructor injection (no @Autowired on fields)
- Records for DTOs
- Controllers return DTOs, never entities
- Services annotated with @Transactional
- Validation on all input DTOs
- Global exception handler
- Repository extends JpaRepository
- All TYPE-CONTRACTS imported from dto package

## References

- [Java Patterns](references/java-patterns.md) - Java 21+ features
- [Spring Boot Conventions](references/spring-boot-conventions.md) - Spring Boot 3 patterns

## Integration

Used by:
- **backend-developer agent**: Primary consumer during Phase 7
- **api-design skill**: Imports TYPE-CONTRACTS from dto package
