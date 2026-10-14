build_ard_demographics <- function(adsl, population_flag = "SAFFL") {
  adsl_pop <- adsl %>% dplyr::filter(.data[[population_flag]] == "Y")
  trt_var <- "ARM"
  
  lyt <- rtables::basic_table(
    title = "Demographic Characteristics",
    subtitles = paste0("Population: ", population_flag, " (Safety)"),
    main_footer = c("N = number of subjects in population; n = number of subjects in category", "Percentages based on N", "Source: ADaM ADSL"),
    prov_footer = paste0("Generated: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))
  ) %>%
    rtables::split_cols_by(trt_var) %>%
    rtables::split_cols_by_multivar(c("n", "mean_sd", "median_range", "count_pct")) %>%
    rtables::analyze("AGE", afun = function(x, .N_col, .var, .spl_context) {
      list(n = rtables::rcell(length(x), format = "xx"),
           mean_sd = rtables::rcell(c(mean(x, na.rm = TRUE), sd(x, na.rm = TRUE)), format = "xx.x (xx.xx)"),
           median_range = rtables::rcell(c(median(x, na.rm = TRUE), min(x, na.rm = TRUE), max(x, na.rm = TRUE)), format = "xx.x [xx - xx]"),
           count_pct = rtables::rcell(c(length(x), 100), format = "xx (xx.x%)"))
    }, var_labels = "Age (years)", show_labels = "visible", na_str = "NE") %>%
    rtables::analyze("SEX", afun = function(x, .N_col, .var, .spl_context) {
      tab <- table(x, useNA = "no"); pct <- round(100 * tab / .N_col, 1)
      rcell_list <- lapply(names(tab), function(lvl) rtables::rcell(c(tab[lvl], pct[lvl]), format = "xx (xx.x%)"))
      names(rcell_list) <- names(tab); rcell_list
    }, var_labels = "Sex", show_labels = "visible", nested = TRUE) %>%
    rtables::analyze("RACE", afun = function(x, .N_col, .var, .spl_context) {
      tab <- table(x, useNA = "no"); pct <- round(100 * tab / .N_col, 1)
      rcell_list <- lapply(names(tab), function(lvl) rtables::rcell(c(tab[lvl], pct[lvl]), format = "xx (xx.x%)"))
      names(rcell_list) <- names(tab); rcell_list
    }, var_labels = "Race", show_labels = "visible", nested = TRUE) %>%
    rtables::analyze("ETHNIC", afun = function(x, .N_col, .var, .spl_context) {
      tab <- table(x, useNA = "no"); pct <- round(100 * tab / .N_col, 1)
      rcell_list <- lapply(names(tab), function(lvl) rtables::rcell(c(tab[lvl], pct[lvl]), format = "xx (xx.x%)"))
      names(rcell_list) <- names(tab); rcell_list
    }, var_labels = "Ethnicity", show_labels = "visible", nested = TRUE)
  
  rtables::build_table(lyt, adsl_pop)
}
