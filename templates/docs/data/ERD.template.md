# Entity Relationship Diagram: [PROJECT_NAME]

**Date:** [DATE]
**Version:** [VERSION]
**Author:** [AUTHOR]

## Overview

This document provides the entity relationship diagram and detailed relationship descriptions for [PROJECT_NAME].

## ERD Diagram

[DIAGRAM_PLACEHOLDER]

## Entity Summary

| Entity | Description | Primary Key | Foreign Keys |
|--------|-------------|-------------|--------------|
| [ENTITY_1] | [DESCRIPTION] | [PK] | [FKS] |
| [ENTITY_2] | [DESCRIPTION] | [PK] | [FKS] |
| [ENTITY_3] | [DESCRIPTION] | [PK] | [FKS] |
| [ENTITY_4] | [DESCRIPTION] | [PK] | [FKS] |

## Relationship Details

### [ENTITY_1] ←→ [ENTITY_2]

**Type:** [ONE_TO_ONE|ONE_TO_MANY|MANY_TO_MANY]
**Description:** [RELATIONSHIP_DESCRIPTION]

**Foreign Key:**
- **Column:** [FK_COLUMN]
- **References:** [REFERENCED_TABLE].[REFERENCED_COLUMN]
- **On Delete:** [CASCADE|SET_NULL|RESTRICT]
- **On Update:** [CASCADE|SET_NULL|RESTRICT]

**Business Rule:** [BUSINESS_RULE]

---

### [ENTITY_2] ←→ [ENTITY_3]

**Type:** [ONE_TO_ONE|ONE_TO_MANY|MANY_TO_MANY]
**Description:** [RELATIONSHIP_DESCRIPTION]

**Foreign Key:**
- **Column:** [FK_COLUMN]
- **References:** [REFERENCED_TABLE].[REFERENCED_COLUMN]
- **On Delete:** [CASCADE|SET_NULL|RESTRICT]
- **On Update:** [CASCADE|SET_NULL|RESTRICT]

**Business Rule:** [BUSINESS_RULE]

---

### [ENTITY_3] ←→ [ENTITY_4]

**Type:** [ONE_TO_ONE|ONE_TO_MANY|MANY_TO_MANY]
**Description:** [RELATIONSHIP_DESCRIPTION]

**Foreign Key:**
- **Column:** [FK_COLUMN]
- **References:** [REFERENCED_TABLE].[REFERENCED_COLUMN]
- **On Delete:** [CASCADE|SET_NULL|RESTRICT]
- **On Update:** [CASCADE|SET_NULL|RESTRICT]

**Business Rule:** [BUSINESS_RULE]

## Junction Tables

### [JUNCTION_TABLE_NAME]

**Purpose:** [PURPOSE]

**Structure:**
| Column | Type | Constraint | Description |
|--------|------|------------|-------------|
| [COLUMN_1] | [TYPE] | [PK, FK] | [DESCRIPTION] |
| [COLUMN_2] | [TYPE] | [PK, FK] | [DESCRIPTION] |
| [COLUMN_3] | [TYPE] | [CONSTRAINT] | [DESCRIPTION] |

**Relationships:**
- [ENTITY_1] (1:N)
- [ENTITY_2] (1:N)

## Cardinality Rules

### One-to-One Relationships
- [RELATIONSHIP_1]: [RULE]

### One-to-Many Relationships
- [RELATIONSHIP_2]: [RULE]
- [RELATIONSHIP_3]: [RULE]

### Many-to-Many Relationships
- [RELATIONSHIP_4]: [RULE]

## Normalization

**Normalization Level:** [1NF|2NF|3NF|BCNF]

**Justification:** [JUSTIFICATION]

**Denormalization Decisions:**
- [DENORMALIZATION_1]
- [DENORMALIZATION_2]

## Database Schema Script

```sql
-- [ENTITY_1] Table
CREATE TABLE [ENTITY_1] (
  [COLUMN_1] [TYPE] [CONSTRAINTS],
  [COLUMN_2] [TYPE] [CONSTRAINTS],
  PRIMARY KEY ([PK_COLUMN])
);

-- [ENTITY_2] Table
CREATE TABLE [ENTITY_2] (
  [COLUMN_1] [TYPE] [CONSTRAINTS],
  [COLUMN_2] [TYPE] [CONSTRAINTS],
  [FK_COLUMN] [TYPE],
  PRIMARY KEY ([PK_COLUMN]),
  FOREIGN KEY ([FK_COLUMN]) REFERENCES [ENTITY_1]([PK_COLUMN])
);

-- Indexes
CREATE INDEX [INDEX_NAME] ON [TABLE_NAME]([COLUMN_NAME]);
```

## Notes

[ADDITIONAL_NOTES]
