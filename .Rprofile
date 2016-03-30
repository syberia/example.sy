if (!nzchar(Sys.getenv("R_ROOT"))) {
  Sys.setenv("R_ROOT" = "TRUE") # Don't re-lockbox for process forks, like GBM

  # Set to TRUE to get all the juicy details
  options(lockbox.verbose = FALSE)

  # Set important common options
  options(stringsAsFactors = FALSE)
  library(methods); library(utils); library(stats)
  options(menu.graphics = FALSE) # Disable tcl/tk for installation from CRAN
  options(repos = structure(c(CRAN = "http://streaming.stat.iastate.edu/CRAN/")))

  # Install all the packages that can't be managed by lockbox or Ramd.
  # Make sure we install it in the correct library, for users with multiple libPaths...
  main_lib <- if (Sys.getenv("R_LIBS_USER") %in% .libPaths()) {
    normalizePath(Sys.getenv("R_LIBS_USER"))
  } else {
    .libPaths()[[1]]
  }
  is_installed <- function(package) {
    package %in% utils::installed.packages(main_lib)[,1]
  }
  install_if_not_installed <- function(package) {
    if (!is_installed(package)) {
        install.packages(package, main_lib, type = "source", quiet = !isTRUE(getOption("lockbox.verbose")))
    }
  }
  download <- function(path, url, ...) {
    request <- httr::GET(url, ...)
    httr::stop_for_status(request)
    writeBin(httr::content(request, "raw"), path)
    path
  }
  is_in_rprofile <- function(x) {
    any(grepl(x, scan("~/.Rprofile", what = "", quiet = TRUE)))
  }

  if (file.exists("~/.Rprofile") && (is_in_rprofile("require") ||
    is_in_rprofile("library")) && !is_in_rprofile("interactive")) {
      stop("Your ~/.Rprofile loads packages outside an `isTRUE(interactive)` block and cannot be loaded.")
  }

  # Because lockbox is installed manually, we install it's dependencies manually
  lapply(c("httr", "yaml", "digest", "crayon"), install_if_not_installed)
  # Now we install lockbox.
  if (!is_installed("lockbox") || utils::packageVersion("lockbox") != package_version("0.2.1")) {
    is_trivial_lockbox_change <- is_installed("lockbox") && as.character(utils::packageVersion("lockbox")) %in% c("0.2.0")
    if (!identical(Sys.getenv("JENKINS"),"1") && !is_trivial_lockbox_change &&
      (file.exists("~/.R/lockbox") || file.exists("~/.R/lockbox.experimental"))) {
        message("\033[31mWiping lockbox directory...\033[39m\n") # Manual crayon in manualbox!
        old_version <- tryCatch(utils::packageVersion("lockbox"), error = function(e) { "old" })
        system(paste0("rm -rf ~/.R/lockbox-", old_version))
        system(paste0("mv ~/.R/lockbox ~/.R/lockbox-", old_version))
      }
      for (path in .libPaths()) {
        try(utils::remove.packages("lockbox", lib = path), silent = TRUE)
      }
    lockbox_tar <- tempfile(fileext = ".tar.gz")
    lockbox_url <- "https://github.com/robertzk/lockbox/archive/0.2.1.tar.gz"
    download(lockbox_tar, lockbox_url)
    install.packages(lockbox_tar, repos = NULL, type = "source")
    unlink(lockbox_tar, TRUE, TRUE)
  }

  lockbox::lockbox("lockfile.yml")
  syberia_engine()

  # Run user-specific Rprofile
  # Calling syberia_project within ~/.Rprofile causes infinite loops, so we disable it temporarily.
  assign("syberia_project", local({ calls <- list(); function(...) { calls <<- list(calls, list(...)) } }), envir = globalenv())
  invisible(local({
    syberia_project_calls <- environment(get("syberia_project", envir = globalenv()))$calls
    rm("syberia_project", envir = globalenv())
    lapply(syberia_project_calls, function(call) { do.call(syberia_project, call) })
  }))
  config_files <- c("~/.Rprofile")
  lapply(config_files, function(x) { if (file.exists(x)) source(x) })
}
