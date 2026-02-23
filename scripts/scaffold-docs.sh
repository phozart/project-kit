#!/usr/bin/env bash
# scaffold-docs.sh — Create the docs directory structure for a new project
# Usage: bash scaffold-docs.sh [project-root]

PROJECT_ROOT="${1:-.}"

# Create all documentation directories
mkdir -p "$PROJECT_ROOT/docs/discovery"
mkdir -p "$PROJECT_ROOT/docs/product"
mkdir -p "$PROJECT_ROOT/docs/requirements"
mkdir -p "$PROJECT_ROOT/docs/architecture"
mkdir -p "$PROJECT_ROOT/docs/data"
mkdir -p "$PROJECT_ROOT/docs/api"
mkdir -p "$PROJECT_ROOT/docs/design"
mkdir -p "$PROJECT_ROOT/docs/qa"
mkdir -p "$PROJECT_ROOT/docs/security"
mkdir -p "$PROJECT_ROOT/docs/devops"
mkdir -p "$PROJECT_ROOT/docs/guides"
mkdir -p "$PROJECT_ROOT/docs/chronicles"
mkdir -p "$PROJECT_ROOT/docs/sprints"
mkdir -p "$PROJECT_ROOT/docs/changes"
mkdir -p "$PROJECT_ROOT/docs/innovation"

echo "Documentation structure created at $PROJECT_ROOT/docs/"
echo "Directories:"
find "$PROJECT_ROOT/docs" -type d | sort | sed 's/^/  /'
