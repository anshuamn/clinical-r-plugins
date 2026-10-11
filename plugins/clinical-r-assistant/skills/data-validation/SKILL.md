# Skill: data-validation
Domain: Clinical Data Quality and Standards Validation
Description: Validates input datasets, transformation logic, and output structure for clinical R programming workflows.

## Purpose
Ensure that data imports, derivations, and exports remain consistent with study requirements, CDISC standards, PII rules, and reproducible clinical programming practices.

## Core Directives
1. Validate raw EDC and SDTM/ADaM datasets before use.
2. Explicitly select only required columns rather than using broad imports.
3. Remove or mask sensitive columns before any subject-level display.
4. Use USUBJID-based anonymized keying where subject identity is needed.
5. Confirm variable availability and naming conventions before proceeding with derivations.
6. Check for required variables in ADaM and SDTM datasets before export.

## Validation Checklist
- Data frame structure:
  - Verify expected columns exist.
  - Confirm variable names use standardized naming conventions.
- PII and PHI screening:
  - Review for patient names, initials, DOB, SSN, MRN, phone numbers, email, and address fields.
  - Remove direct identifiers from display or logging.
- SDTM/ADaM readiness:
  - Confirm domain-specific variable naming.
  - Check date fields are properly standardized.
  - Confirm no untraceable hardcoded values.
- TLF preparation:
  - Validate denominator calculations.
  - Check population flags and treatment group assignments.

## Required Data Handling Practices
- Use `select()` with explicitly named columns.
- Avoid printing raw rows or using `head()` on sensitive data.
- Use `str()`, `colnames()`, and summary-level validation checks instead of row-level inspection.
- If PII columns are present, sanitize them before execution.
- Do not write intermediate or raw subject-level files outside approved folders.

## Validation Failure Behavior
If validation fails:
- halt the workflow,
- identify the missing or noncompliant fields,
- fix the issue in the data handling logic,
- re-run validation,
- and only continue after the issue is resolved.

## Output Requirements
- Keep logs metadata-based and avoid value-level data dumps.
- Preserve traceability from source data to final TLF deliverables.
- Ensure final outputs remain reproducible and audit-friendly.