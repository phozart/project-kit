# Java Stack Configurations

Common patterns and configurations for Java-based stacks.

## Spring Boot Stack

**Typical Dependencies** (Maven):
```xml
<dependencies>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
  </dependency>
</dependencies>
```

**Commands**:
```yaml
build: mvn clean package
test: mvn test
lint: mvn checkstyle:check
dev: mvn spring-boot:run
```

**Project Structure**:
```
src/
  main/
    java/
      com/company/project/
        Application.java
        controller/
        service/
        repository/
        model/
        dto/
        config/
    resources/
      application.yml
  test/
    java/
pom.xml
```

## Spring Boot with Gradle

**Commands**:
```yaml
build: ./gradlew build
test: ./gradlew test
lint: ./gradlew checkstyleMain
dev: ./gradlew bootRun
```

## Quarkus Stack

**Typical Dependencies**:
- quarkus-resteasy-reactive
- quarkus-hibernate-orm-panache
- quarkus-jdbc-postgresql
- quarkus-junit5

**Commands**:
```yaml
build: mvn package
test: mvn test
lint: mvn checkstyle:check
dev: mvn quarkus:dev
```

**Project Structure**:
```
src/
  main/
    java/
      com/company/project/
        resource/
        service/
        entity/
        dto/
    resources/
      application.properties
  test/
pom.xml
```

## Common Java Tooling

**Build Tools**:
- Maven (traditional, XML-based)
- Gradle (modern, Groovy/Kotlin DSL)

**Linting & Code Quality**:
- Checkstyle
- PMD
- SpotBugs
- SonarQube

**Testing**:
- JUnit 5 (primary framework)
- Mockito (mocking)
- AssertJ (fluent assertions)
- RestAssured (API testing)
- Testcontainers (integration testing)

**Common application.yml structure** (Spring Boot):
```yaml
spring:
  application:
    name: project-name
  datasource:
    url: jdbc:postgresql://localhost:5432/dbname
    username: ${DB_USER}
    password: ${DB_PASSWORD}
  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: false

server:
  port: 8080

logging:
  level:
    root: INFO
    com.company.project: DEBUG
```

**Maven pom.xml typical plugins**:
```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-maven-plugin</artifactId>
    </plugin>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-checkstyle-plugin</artifactId>
    </plugin>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-surefire-plugin</artifactId>
    </plugin>
  </plugins>
</build>
```
