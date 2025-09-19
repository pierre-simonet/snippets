# XXX Project - Claude Configuration

## Project Structure

## Build Commands
```bash
# Build all modules
./gradlew build

# Run tests
./gradlew test

# Clean build
./gradlew clean build
```

## Development Guidelines
- Use Java coding conventions
- Follow existing patterns in the codebase
- Run tests after each modification to ensure nothing is broken
- Run tests before committing changes
- Update this file when adding new build commands or project structure changes
- Do not add unnecessary comments - only add comments for complex algorithms or non-obvious business logic
- Follow YAGNI (You Aren't Gonna Need It): Only implement what is currently needed, avoid over-engineering
- Follow SOLID principles for object-oriented design:
  - Single Responsibility: Each class should have one reason to change
  - Open/Closed: Open for extension, closed for modification
  - Liskov Substitution: Subtypes must be substitutable for their base types
  - Interface Segregation: Clients should not depend on interfaces they don't use
  - Dependency Inversion: Depend on abstractions, not concretions

### Java Best Practices
- Use meaningful and descriptive names for classes, methods, and variables
- Prefer composition over inheritance
- Use immutable objects when possible (final fields, no setters)
- Handle exceptions properly - catch specific exceptions, not generic Exception
- Use try-with-resources for resource management
- Prefer interfaces over concrete classes for method parameters and return types
- Use Optional instead of returning null
- Follow Java naming conventions (camelCase for methods/variables, PascalCase for classes)
- Use enums instead of constants for fixed sets of values
- Implement equals(), hashCode(), and toString() consistently
- Use StringBuilder for string concatenation in loops
- Validate method parameters early (fail-fast principle)
- Use Collections framework effectively (List, Set, Map interfaces)
- Prefer streams for data processing when it improves readability
- Use generics to ensure type safety
- Keep methods small and focused (single responsibility)
- Use static imports sparingly and only for frequently used utilities

### Domain-Driven Design (DDD) Principles
- Model the business domain accurately in code
- Use ubiquitous language - same terminology between business and development teams
- Organize code around bounded contexts to separate different business domains
- Implement aggregates to maintain consistency boundaries
- Use domain entities with clear identity and lifecycle
- Create value objects for concepts without identity
- Implement domain services for operations that don't belong to entities or value objects
- Use repositories for aggregate persistence abstraction
- Apply factory patterns for complex object creation
- Keep domain logic separate from infrastructure concerns
- Use domain events to communicate between bounded contexts
- Implement anti-corruption layers when integrating with external systems

## Security Guidelines

### General Secure Coding Practices
- Validate and sanitize all user inputs to prevent injection attacks.
- Use error handling without revealing sensitive information.
- Avoid exposing sensitive data in API responses.
- Do not hardcode any secrets (credentials, API keys, etc) in the source code or configuration files.

### HTTP Security headers and Cookies
- Use a Content Security Policy (CSP) to protect against XSS and clickjacking attacks.
- Set cookies with `HttpOnly`, `Secure`, and `SameSite` attributes.
- Enforce strict CORS policies for cookies.

#### CSRF Protection
Apply the following rules only if authentication relies on cookies instead of tokens.
- Use anti-CSRF tokens for state-changing operations.
- Validate `Origin` and `Referer` headers for non-GET requests.
- Require re-authentication before performing sensitive actions.

### Output Rendering
- Ensure output is encoded correctly for the corresponding context.
- Escape special characters in output to prevent injection attacks.

### Database
- Use parameterized queries or ORM to prevent injections.
- Implement proper authentication and authorization.
- Handle sensitive data properly.
- Monitor security issues.
- Apply the principle of least privilege to database users.

### API Security
- Apply authentication and integrity checks on all API requests.
- Configure CORS policies to restrict cross-origin access to trusted domains only.
- Apply rate limiting to manage traffic.
- Enforce security headers.
- Handle errors securely without revealing sensitive details to end users.
- Log access and actions for monitoring, auditing, and detecting abnormal activity.

### External Requests
- Restrict outbound requests to only necessary external services and internal endpoints.
- Use allowlists to define permitted destinations instead of blocking known bad domains.
- Disable unnecessary URL fetching capabilities in your application.
- Validate and sanitize all user-supplied URLs before making requests.
- Implement request timeouts and rate limits to prevent abuse.