generate_metadata <- function(data_hash, spec_hash = NULL, script = "app.R") {
  pkgs <- c("rtables", "tern", "gtsummary", "r2rtf", "haven", "dplyr")
  versions <- sapply(pkgs, function(p) if (requireNamespace(p, quietly = TRUE)) as.character(utils::packageVersion(p)) else "NOT_INSTALLED")
  list(generated_at = format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z"), script = script, r_version = paste(R.version$major, R.version$minor, sep = "."), platform = R.version$platform, packages = versions, data_hash = data_hash, spec_hash = spec_hash, webr = TRUE)
}

hash_data <- function(df) {
  if (requireNamespace("digest", quietly = TRUE)) return(digest::digest(df, algo = "sha256"))
  txt <- paste(capture.output(str(df)), capture.output(head(df)), capture.output(tail(df)), collapse = "")
  openssl::sha256(txt)
}
