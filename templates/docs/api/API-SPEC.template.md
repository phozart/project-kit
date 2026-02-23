# API Specification: [PROJECT_NAME]

**Date:** [DATE]
**Version:** [VERSION]
**Author:** [AUTHOR]

## Overview

[API_OVERVIEW]

## Base URL

```
[BASE_URL]
```

## Authentication

**Method:** [AUTH_METHOD]

**Details:** [AUTH_DETAILS]

**Example:**
```
Authorization: [AUTH_EXAMPLE]
```

## Endpoints

### [ENDPOINT_1]

**Method:** `[GET|POST|PUT|PATCH|DELETE]`
**Path:** `/[PATH]`
**Description:** [DESCRIPTION]

**Authentication Required:** [YES|NO]

**Request Parameters:**

| Parameter | Type | Location | Required | Description |
|-----------|------|----------|----------|-------------|
| [PARAM_1] | [TYPE] | [QUERY|PATH|BODY|HEADER] | [YES|NO] | [DESCRIPTION] |
| [PARAM_2] | [TYPE] | [QUERY|PATH|BODY|HEADER] | [YES|NO] | [DESCRIPTION] |

**Request Body:**
```json
{
  "[FIELD_1]": "[TYPE]",
  "[FIELD_2]": "[TYPE]"
}
```

**Response:**

**Success (200):**
```json
{
  "[FIELD_1]": "[VALUE]",
  "[FIELD_2]": "[VALUE]"
}
```

**Error (4xx/5xx):**
```json
{
  "error": {
    "code": "[ERROR_CODE]",
    "message": "[ERROR_MESSAGE]"
  }
}
```

**Example Request:**
```bash
curl -X [METHOD] '[BASE_URL]/[PATH]' \
  -H 'Authorization: [AUTH]' \
  -H 'Content-Type: application/json' \
  -d '[REQUEST_BODY]'
```

---

### [ENDPOINT_2]

**Method:** `[GET|POST|PUT|PATCH|DELETE]`
**Path:** `/[PATH]`
**Description:** [DESCRIPTION]

**Authentication Required:** [YES|NO]

**Request Parameters:**

| Parameter | Type | Location | Required | Description |
|-----------|------|----------|----------|-------------|
| [PARAM_1] | [TYPE] | [QUERY|PATH|BODY|HEADER] | [YES|NO] | [DESCRIPTION] |
| [PARAM_2] | [TYPE] | [QUERY|PATH|BODY|HEADER] | [YES|NO] | [DESCRIPTION] |

**Request Body:**
```json
{
  "[FIELD_1]": "[TYPE]",
  "[FIELD_2]": "[TYPE]"
}
```

**Response:**

**Success (200):**
```json
{
  "[FIELD_1]": "[VALUE]",
  "[FIELD_2]": "[VALUE]"
}
```

**Error (4xx/5xx):**
```json
{
  "error": {
    "code": "[ERROR_CODE]",
    "message": "[ERROR_MESSAGE]"
  }
}
```

**Example Request:**
```bash
curl -X [METHOD] '[BASE_URL]/[PATH]' \
  -H 'Authorization: [AUTH]' \
  -H 'Content-Type: application/json'
```

---

### [ENDPOINT_3]

**Method:** `[GET|POST|PUT|PATCH|DELETE]`
**Path:** `/[PATH]`
**Description:** [DESCRIPTION]

**Authentication Required:** [YES|NO]

**Request Parameters:**

| Parameter | Type | Location | Required | Description |
|-----------|------|----------|----------|-------------|
| [PARAM_1] | [TYPE] | [QUERY|PATH|BODY|HEADER] | [YES|NO] | [DESCRIPTION] |

**Response:**

**Success (200):**
```json
{
  "[FIELD_1]": "[VALUE]"
}
```

**Error (4xx/5xx):**
```json
{
  "error": {
    "code": "[ERROR_CODE]",
    "message": "[ERROR_MESSAGE]"
  }
}
```

## Data Models

### [MODEL_1]

```json
{
  "[FIELD_1]": "[TYPE]",
  "[FIELD_2]": "[TYPE]",
  "[FIELD_3]": {
    "[NESTED_FIELD]": "[TYPE]"
  }
}
```

### [MODEL_2]

```json
{
  "[FIELD_1]": "[TYPE]",
  "[FIELD_2]": "[TYPE]"
}
```

## Error Codes

| Code | Message | Description |
|------|---------|-------------|
| [CODE_1] | [MESSAGE] | [DESCRIPTION] |
| [CODE_2] | [MESSAGE] | [DESCRIPTION] |
| [CODE_3] | [MESSAGE] | [DESCRIPTION] |

## Rate Limiting

[RATE_LIMITING_DETAILS]

## Pagination

[PAGINATION_DETAILS]

## Versioning

[VERSIONING_STRATEGY]

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| [VERSION] | [DATE] | [CHANGES] |
