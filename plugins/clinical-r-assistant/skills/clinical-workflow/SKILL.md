# Skill: clinical-workflow
Domain: Clinical Trial Statistical Programming
Description: Guides the full clinical R programming workflow from environment validation through planning, execution, and final reporting.

## Purpose
Create a disciplined workflow for clinical R programming that aligns with CDISC, GxP, auditability, and traceability expectations in regulated clinical environments.

## Core Directives
1. Validate the R environment before any task starts.
2. Check for required packages, versions, and dependencies using the active R library.
3. Confirm whether the requested work is a creation or modification task.
4. Validate the working context against study metadata, SAP, and CDISC implementation guidance.
5. Require user approval before execution begins.
6. Keep all outputs in the correct project directories and avoid writing raw source data elsewhere.
7. Prefer structured, reproducible code over ad hoc scripting.

## Required Workflow
- Step 1: Environment and dependency validation
  - Check whether packages such as admiral, cards, dplyr, ggplot2, tern, gtsummary, and related validation utilities are available.
  - Verify package versions match the expected study or project baseline.
- Step 2: Context and guardrail review
  - Confirm relevant metadata, SAP, and controlled terminology files.
  - Ensure data handling aligns with SDTM/ADaM standards.
- Step 3: Script status and intent classification
  - If a related script already exists under /programs, treat the task as a modification.
  - Otherwise treat it as a new creation.
- Step 4: Output format confirmation
  - Default to .html output unless the user specifies otherwise.
- Step 5: Summary and approval
  - Present the validated summary and ask for confirmation before proceeding.

## Safety and Compliance Rules
- Do not access or print raw sensitive data in console logs.
- Use USUBJID instead of subject names or direct identifiers.
- Never hardcode patient-level values when derived variables can be reproduced from source data.
- Use reproducible logic and maintain audit-ready documentation.
- Prefer modular code sections and clear validation checkpoints.

## Output Expectations
- Use R scripts placed under /programs.
- Store generated artifacts in /output only.
- When applicable, generate ARD objects before final TLF rendering.
- Ensure exports are traceable, reproducible, and compliant with study standards.