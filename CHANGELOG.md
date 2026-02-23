# Changelog

All notable changes to the project-kit plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-22

### Added
- Complete multi-agent project orchestration plugin for Claude Code
- 24 specialized agents covering all development lifecycle phases
- 22 skills with progressive disclosure via references/ directories
- 8 user-invocable commands (/project-init, /orchestrate, /gate-check, /techstack, /status, /chronicle, /sprint, /design-system)
- 30+ document templates for all project artifacts
- Guided techstack selection (technology decisions never made by agents)
- Configurable quality gates (manual/auto/skip per gate)
- 11-phase workflow: Setup, Innovation (opt), Product Design, Marketing (opt), Business Analysis, Architecture, UX/UI Design, Implementation, QA/Security, Release, Documentation
- Technology-specific developer agents: React, Next.js, Python, Java, API, Auth, Database
- Sprint coordination with parallel execution support
- Contract-driven development (TYPE-CONTRACTS + API-CONTRACTS)
- Unique-per-project design system creation (no defaults)
- Three documentation packages: Style Guide (HTML), Developer Guide, User Guide with screenshot placeholders
- Project chronicle for decision logging
- scaffold-docs.sh for directory structure creation
- project.config.yaml for persistent workflow state across sessions
