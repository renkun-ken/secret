#' The secret package
#' @name secret-package
#' @docType package
#' @details
#' Hide the source code of functions in package via Rcpp.
#' @seealso \link{https://stackoverflow.com/a/1360175/2906900}
NULL

read_text <- function(file) {
  size <- file.info(file)$size
  readChar(file, size)
}

template <- read_text(system.file("template.cpp", package = .packageName))

#' Use secret functions
#' @param pkg package location
#' @export
use_secret <- function(pkg = ".") {
  message("Create secret/")
  dir.create(file.path(pkg, "secret"), showWarnings = FALSE)

  message("Create src/")
  dir.create(file.path(pkg, "src"), showWarnings = FALSE)

  message("Create src/HideString.h")
  file.copy(system.file("HideString.h", package = .packageName), file.path(pkg, "src", "HideString.h"))

  message("Ignore secret in .Rbuildignore")
  Rbuildignore <- file.path(pkg, ".Rbuildignore")
  if (!("^secret$" %in% readLines(Rbuildignore))) {
    con <- file(Rbuildignore, open = "at")
    writeLines("^secret$", con)
    close(con)
  }

  message("Please add BH to LinkingTo field in DESCRIPTION")
}

create_secret <- function(pkg, name) {
  cpp_file <- file.path(pkg, "src", sprintf("%s.cpp", name))
  script_file <- file.path(pkg, "secret", sprintf("%s.R", name))
  script_text <- read_text(script_file)
  secret_code <- strsplit(script_text, split = "")[[1]]
  secret_code <- gsub("'", "\\'", secret_code, fixed = TRUE)
  secret_code <- gsub("\n", "\\n", secret_code, fixed = TRUE)
  secret_code <- paste("('", secret_code, "')", sep = "", collapse = "")
  cpp_code <- gsub("(' ')", secret_code,
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
    create_secret(pkg, gsub("([^.]+)\\.[[:alnum:]]+$", "\\1", basename(file)))
  }
}
