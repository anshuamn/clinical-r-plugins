library(shiny); library(rtables); library(htmltools)
source("R/data-loader.R", local = TRUE)
source("R/ard-demographics.R", local = TRUE)
source("R/render-table.R", local = TRUE)
source("R/metadata.R", local = TRUE)

rv <- reactiveValues(adsl = NULL, table_obj = NULL, html_output = NULL, rtf_path = NULL, metadata = NULL, status = "ready", error = NULL)
observe({ tryCatch({ rv$adsl <- load_adsl("data/ADSL.xpt"); rv$status <- "ready" }, error = function(e) { rv$status <- "error"; rv$error <- paste("Failed to load default data:", e$message) }) })

ui <- function(request) {
  fluidPage(
    tags$head(tags$link(rel = "stylesheet", href = "styles.css"), tags$script(HTML("Shiny.addCustomMessageHandler('download-file', function(msg) { const link = document.createElement('a'); link.href = msg.url; link.download = msg.filename; document.body.appendChild(link); link.click(); document.body.removeChild(link); });"))),
    div(class = "app-container",
      div(class = "header", h1("webR TLF Demo — Table 1: Demographics"), span(id = "status-badge", class = "status-badge ready", "Ready")),
      div(class = "card", h2("Data & Population"), div(class = "controls",
        div(class = "control-group", label("Population Flag"), selectInput("pop_flag", NULL, choices = NULL, selected = "SAFFL")),
        div(class = "control-group", label("Data Source"), fileInput("data_file", NULL, accept = c(".xpt", ".csv"), width = "250px")),
        actionButton("generate_btn", "Generate Table", class = "primary"),
        actionButton("download_html_btn", "Download HTML", class = "secondary"),
        actionButton("download_rtf_btn", "Download RTF", class = "secondary")
      )),
      div(class = "card", h2("Output"), div(id = "output-area", class = "output-area", uiOutput("table_html")),
        div(class = "download-btns", downloadButton("download_html", "Download HTML", class = "secondary"), downloadButton("download_rtf", "Download RTF", class = "secondary")),
        div(id = "metadata-footer", class = "metadata-footer", verbatimTextOutput("metadata_text"))
      )
    )
  )
}

server <- function(input, output, session) {
  observeEvent(rv$adsl, { if (!is.null(rv$adsl)) { flags <- get_population_flags(rv$adsl); updateSelectInput(session, "pop_flag", choices = flags, selected = "SAFFL") } })
  
  observeEvent(input$data_file, {
    req(input$data_file); rv$status <- "busy"; session$sendCustomMessage("update-badge", list(status = "busy", text = "Loading data..."))
    tryCatch({ ext <- tools::file_ext(input$data_file$name); rv$adsl <- load_adsl(input$data_file$datapath); rv$status <- "ready"; session$sendCustomMessage("update-badge", list(status = "ready", text = "Ready")); showNotification("Data loaded", type = "message") }, error = function(e) { rv$status <- "error"; rv$error <- e$message; session$sendCustomMessage("update-badge", list(status = "error", text = "Error")); showNotification(paste("Error:", e$message), type = "error") })
  })
  
  observeEvent(input$generate_btn, {
    req(rv$adsl, input$pop_flag); rv$status <- "busy"; session$sendCustomMessage("update-badge", list(status = "busy", text = "Generating..."))
    tryCatch({ tbl <- build_ard_demographics(rv$adsl, input$pop_flag); rv$table_obj <- tbl; rendered <- render_both(tbl, title = "Demographic Characteristics", protocol = "PROTOCOL-001", population = input$pop_flag); rv$html_output <- rendered$html; rv$rtf_path <- rendered$rtf_path; data_hash <- hash_data(rv$adsl); rv$metadata <- generate_metadata(data_hash); rv$status <- "ready"; session$sendCustomMessage("update-badge", list(status = "ready", text = "Ready")); showNotification("Table generated", type = "message") }, error = function(e) { rv$status <- "error"; rv$error <- e$message; session$sendCustomMessage("update-badge", list(status = "error", text = "Error")); showNotification(paste("Error:", e$message), type = "error") })
  })
  
  output$table_html <- renderUI({ req(rv$html_output); HTML(rv$html_output) })
  output$metadata_text <- renderText({ req(rv$metadata); jsonlite::toJSON(rv$metadata, pretty = TRUE, auto_unbox = TRUE) })
  
  output$download_html <- downloadHandler(filename = function() paste0("Table1_Demographics_", format(Sys.time(), "\%Y\%m\%d_\%H\%M\%S"), ".html"), content = function(file) writeLines(rv$html_output, file))
  output$download_rtf <- downloadHandler(filename = function() paste0("Table1_Demographics_", format(Sys.time(), "\%Y\%m\%d_\%H\%M\%S"), ".rtf"), content = function(file) file.copy(rv$rtf_path, file))
}

shinyApp(ui = ui, server = server, options = list(launch.browser = FALSE, port = 3838))
