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

if (!is.element("lockbox", utils::installed.packages()[, 1])) {
  quick_install(devtools::install_github("robertzk/lockbox"), "lockbox")
}

lockbox::lockbox("lockfile.yml")
syberia_engine()

