if (!nzchar(Sys.getenv("R_ROOT"))) {
  Sys.setenv("R_ROOT" = "TRUE")
  library(stats)
  library(utils)
  library(methods)
  installed_packages <- utils::installed.packages()[, 1]

  quick_install <- function(install_expr, name) {
    local({
      tryCatch({
        message("\033[32mInstalling ", sQuote(name), "...\033[39m")
        on.exit(sink())
        sink(tempfile())
        install_expr
      }, error = function(e) {
        stop("\033[31mError installing ", sQuote(name), ": \033[39m",
             as.character(e))
      })
    })
  }

  if (!is.element("devtools", installed_packages)) {
    quick_install(utils::install.packages("devtools"), "devtools")
  }

  if (!is.element("purrr", installed_packages)) {
    quick_install(utils::install.packages("purrr"), "purrr")
  }

  if (!is.element("R6", installed_packages)) {
    quick_install(utils::install.packages("R6"), "R6")
  }

  library(R6)

  if (!is.element("testthatsomemore", installed_packages) ||
      packageVersion("testthatsomemore") < package_version("0.2.4")) {
    quick_install(devtools::install_github("robertzk/testthatsomemore"),
                  "testthatsomemore")
  }

  if (!is.element("lockbox", installed_packages)) {
    quick_install(devtools::install_github("robertzk/lockbox"), "lockbox")
  }

  lockbox::lockbox("lockfile.yml")
  syberia_engine()
}

