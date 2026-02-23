# User Story Guide

Guide for writing effective user stories as part of requirements documentation.

## User Story Format

**Standard Template**:
```
As a [persona/role]
I want [capability/feature]
So that [benefit/value]
```

## User Story Structure

### Title
Short, descriptive title (50 characters or less)

### Story
```
As a [persona]
I want [capability]
So that [benefit]
```

### Acceptance Criteria
```
Given [initial context/precondition]
When [action or event]
Then [expected outcome]

And [additional outcome if needed]
```

### Additional Elements
- **Story ID**: US-XXX (links to REQ-F-XXX)
- **Priority**: Must Have / Should Have / Could Have / Won't Have
- **Story Points**: Estimate of effort (Fibonacci: 1, 2, 3, 5, 8, 13)
- **Dependencies**: Other stories that must be completed first
- **Notes**: Additional context, constraints, open questions

## Complete User Story Example

```markdown
### US-001: User Registration

**Story**:
As a new visitor
I want to create an account with my email and password
So that I can access the platform and save my work

**Acceptance Criteria**:

Given I am on the registration page
When I enter a valid email address and password
And I click the "Sign Up" button
Then my account is created
And I receive a verification email
And I am redirected to the email verification pending page

Given I enter an email that is already registered
When I click the "Sign Up" button
Then I see an error message "This email is already registered"
And I am offered a "Log in instead" link

Given I enter a password that is too weak
When I click the "Sign Up" button
Then I see an error message listing password requirements
And the password field is cleared
And I remain on the registration page

Given I leave required fields empty
When I click the "Sign Up" button
Then I see inline validation errors
And the form is not submitted

**Priority**: Must Have
**Story Points**: 5
**Dependencies**: None
**Related Requirements**: REQ-F-001, REQ-S-001, REQ-F-030

**Notes**:
- Password must be at least 8 characters with 1 uppercase, 1 lowercase, 1 number
- Email verification link expires after 24 hours
- Consider social auth in future story
```

## Writing Effective User Stories

### Good Story Characteristics (INVEST)

**Independent**: Story can be developed and delivered independently
- Bad: "As a user, I want pagination (part 1 of 3)"
- Good: "As a user, I want to browse all projects using pagination"

**Negotiable**: Details can be discussed and refined
- Bad: "The button must be #FF0000 red, 44px height, rounded 8px"
- Good: "As a user, I want clear call-to-action buttons so I know what actions are available"

**Valuable**: Provides clear value to users or business
- Bad: "As a developer, I want to refactor the database layer"
- Good: "As a user, I want faster page loads so I can work more efficiently"

**Estimable**: Team can estimate the effort
- Bad: "As a user, I want AI-powered features"
- Good: "As a user, I want AI to suggest project names based on description"

**Small**: Can be completed in one sprint/iteration
- Bad: "As a user, I want a complete project management system"
- Good: "As a user, I want to create a project with a name and description"

**Testable**: Has clear acceptance criteria
- Bad: "As a user, I want a beautiful UI"
- Good: "As a user, I want keyboard shortcuts for common actions so I can work faster"

### Common Patterns

**CRUD Operations**:
```
As a [user]
I want to [create/read/update/delete] [entity]
So that I can [manage/track/organize] [my work/data/content]
```

**Search/Filter**:
```
As a [user]
I want to search/filter [entities] by [criteria]
So that I can quickly find [what I need]
```

**Notifications**:
```
As a [user]
I want to be notified when [event]
So that I can [take action/stay informed]
```

**Permissions**:
```
As a [role]
I want to control [access/permissions] to [resource]
So that I can [protect/share] [data/content]
```

### Acceptance Criteria Guidelines

**Use Given/When/Then Format**:
- **Given**: Sets up the context and preconditions
- **When**: Describes the action or event
- **Then**: Specifies the expected outcome

**Be Specific**:
- Bad: "Then the user sees a success message"
- Good: "Then the user sees 'Project created successfully' message in green at top of page"

**Cover Edge Cases**:
- Happy path (normal flow)
- Error cases (validation failures)
- Boundary conditions (empty states, max limits)
- Permissions (unauthorized access)

**Example with Multiple Scenarios**:
```
Scenario: Successful project creation
Given I am logged in as a project owner
When I enter "My New Project" as the project name
And I click "Create Project"
Then a new project is created with name "My New Project"
And I am redirected to the project dashboard
And I see a success message "Project created successfully"

Scenario: Project name already exists
Given I am logged in as a project owner
And I already have a project named "Existing Project"
When I try to create another project named "Existing Project"
Then I see an error "A project with this name already exists"
And the project is not created
And I remain on the creation form

Scenario: Project name too short
Given I am logged in as a project owner
When I enter "AB" as the project name (less than 3 characters)
And I click "Create Project"
Then I see an error "Project name must be at least 3 characters"
And the project is not created
```

## User Stories vs Requirements

**User Stories**:
- User-centric perspective
- Conversational tone
- Focus on value and benefit
- Used for agile planning and development
- "As a... I want... So that..."

**Requirements**:
- System-centric perspective
- Formal tone
- Focus on behavior and constraints
- Used for specification and testing
- "The system shall..."

**Relationship**:
- One user story may map to multiple requirements
- Requirements provide formal detail for user stories
- Both should be traceable in RTM

## Tips

1. **Focus on the user, not the system** - What does the user want to accomplish?
2. **Include the "so that" clause** - It explains the value and can spark better solutions
3. **Use real persona names** - "As Sarah (Startup Founder)" is more concrete than "As a user"
4. **Write from user perspective** - Even for admin/system features
5. **Keep stories small** - If a story is too big, split it into multiple stories
6. **Collaborate** - User stories are conversation starters, not complete specifications
