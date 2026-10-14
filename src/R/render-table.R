render_html <- function(tbl, title = "Demographics Table") {
  html <- rtables::to_html(tbl)
  sprintf('<!DOCTYPE html><html><head><meta charset="UTF-8"><style>body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif;padding:2rem;font-size:12px;}table{border-collapse:collapse;width:100%%;}th,td{border:1px solid #e2e8f0;padding:6px 10px;text-align:left;}th{background:#f8fafc;font-weight:600;color:#334155;position:sticky;top:0;}tr:nth-child(even)td{background:#fafafa;}.title{font-size:16px;font-weight:700;margin-bottom:4px;color:#1e293b;}.subtitle{font-size:12px;color:#64748b;margin-bottom:12px;}.footer{font-size:10px;color:#94a3b8;margin-top:12px;line-height:1.5;}.row-label{font-weight:500;}.row-total{font-weight:600;background:#f1f5f9;}.indent-1{padding-left:20px;}.indent-2{padding-left:40px;}</style></head><body>%s</body></html>', html)
}

render_rtf <- function(tbl, title = "Demographics Table", protocol = "PROTOCOL-001", population = "SAFFL") {
  df <- rtables::matrix_form(tbl, expand_newlines = TRUE) %>% as.data.frame(stringsAsFactors = FALSE)
  names(df) <- gsub("\\.", " ", names(df))
  rtf <- r2rtf::rtf_page(r2rtf::rtf_body(df, colheader = names(df), title = title, subtitle = paste("Protocol:", protocol, "| Population:", population), footnote = c("N = number of subjects in population; n = number of subjects in category", "Percentages based on N", "Source: ADaM ADSL", paste("Generated:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))), col_rel_width = c(2.5, rep(1.2, ncol(df) - 1)), font_size = 9, font_family = "Courier New"), orientation = "landscape", margins = c(1, 1, 1, 1))
  tmp <- tempfile(fileext = ".rtf"); r2rtf::rtf_encode(rtf, tmp); tmp
}

render_both <- function(tbl, ...) list(html = render_html(tbl, ...), rtf_path = render_rtf(tbl, ...))
