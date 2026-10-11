# Skill: reporting-standards
Domain: Clinical Reporting and TLF Standards
Description: Establishes the standards for creating submission-ready tables, listings, and figures from ADaM data with reproducible outputs and ARD integration.

## Purpose
Support consistent, regulatory-friendly statistical reporting for clinical trial results using modern clinical R tooling and standard TLF output patterns.

## Core Directives
1. Prefer modern pharmaverse-style tools where appropriate.
2. Generate ARD before final reporting output.
3. Use transparent denominators based on the ADSL population.
4. Maintain consistent numbering and titles for TLF outputs.
5. Ensure plots and tables are readable, reproducible, and interpretable without manual reconstruction.
6. Preserve the source-to-output traceability chain.

## TLF Standards
### Tables
- Use `gtsummary`, `rtables`, or `tern` when appropriate.
- Include counts (N) in column headers.
- Apply dynamic formatting for decimals and percent labels.
- Prefer clean, traceable labeling for treatment groups and analysis populations.

### Listings
- Display subject-level data in a logical order.
- Group by USUBJID where applicable.
- Keep formatting readable and suitable for review.
- Avoid excessive data sprawl; split large listings when needed.

### Figures
- Include clear titles, labeled axes, and treatment group legends.
- Add footnotes indicating population and analysis basis.
- For survival analyses, include a risk table with number at risk.
- Ensure figures are self-explanatory and auditable.

## ARD Requirements
- Generate Analysis Results Data before final export functions.
- Save ARD outputs as `.rds` files in the project output folder.
- Keep machine-readable summaries aligned with the final displayed TLF.

## Output and Export Rules
- Default to HTML output unless the user specifies otherwise.
- Write outputs only to approved directories, such as /output.
- Keep file names consistent with TLF numbering and purpose.
- Do not expose sensitive subject identifiers in exported outputs.

## Final Reporting Checklist
- Data source is clear and traceable.
- Population denominator is explicit.
- Output includes required labels and title conventions.
- ARD exists before final rendering.
- File is exported to the correct location.