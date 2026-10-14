load_adsl <- function(path = "data/ADSL.xpt") {
  required_cols <- c("USUBJID", "SITEID", "AGE", "AGEU", "SEX", "RACE", "ETHNIC", "ARM", "ARMCD", "SAFFL", "ITTFL", "PPROTFL")
  if (grepl("\\.xpt$", path, ignore.case = TRUE)) adsl <- haven::read_xpt(path)
  else if (grepl("\\.csv$", path, ignore.case = TRUE)) adsl <- read.csv(path)
  else stop("Unsupported file format. Use .xpt or .csv")
  missing <- setdiff(required_cols, names(adsl))
  if (length(missing) > 0) warning("Missing columns: ", paste(missing, collapse = ", "))
  adsl <- adsl %>%
    dplyr::mutate(
      SEX = factor(SEX, levels = c("M", "F"), labels = c("Male", "Female")),
      RACE = factor(RACE), ETHNIC = factor(ETHNIC),
      ARM = factor(ARM), ARMCD = factor(ARMCD),
      SAFFL = factor(SAFFL, levels = c("Y", "N")),
      ITTFL = factor(ITTFL, levels = c("Y", "N")),
      PPROTFL = factor(PPROTFL, levels = c("Y", "N")),
      AGEU = factor(AGEU, levels = c("YEARS", "MONTHS", "DAYS"))
    ) %>% dplyr::filter(SAFFL == "Y")
  return(adsl)
}

get_population_flags <- function(adsl) {
  flag_cols <- grep("FL$", names(adsl), value = TRUE)
  flag_cols[flag_cols != "RANDFL"]
}
