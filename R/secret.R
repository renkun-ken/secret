read_text <- function(..., collapse = "\n") {
  paste0(readLines(...), collapse = collapse)
}

template <- read_text("inst/template.cpp")

#' Use secret functions
#' @param pkg package location
#' @export
use_secret <- function(pkg = ".") {
  dir.create(file.path(pkg, "secret"), showWarnings = FALSE)
  dir.create(file.path(pkg, "src"), showWarnings = FALSE)
  Rbuildignore <- file.path(pkg, ".Rbuildignore")
  if (!("^secret$" %in% readLines(Rbuildignore))) {
    con <- file(Rbuildignore, open = "at")
    writeLines("^secret$", con)
    close(con)
  }
}

create_secret <- function(pkg, name) {
  cpp_file <- file.path(pkg, "src", sprintf("%s.cpp", name))
  script_file <- file.path(pkg, "secret", sprintf("%s.R", name))
  script_text <- read_text(script_file, collapse = "\\n")
  cpp_code <- gsub("SECRET_CODE", script_text,
    gsub("SECRET_NAME", name, template, fixed = TRUE), fixed = TRUE)
  writeLines(cpp_code, cpp_file)
}

#' Build secret functions
#' @param pkg package location
#' @export
build_secret <- function(pkg = ".") {
  secret_dir <- file.path(pkg, "secret")
  secret_files <- list.files(secret_dir, "\\.R$")
  for (file in secret_files) {
    create_secret(pkg,
      sub("([^.]+)\\.[[:alnum:]]+$", "\\1", basename(file)))
  }
}
