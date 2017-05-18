titles <- c(
  mister = "Mr.", missus = "Mrs.", miss = "Ms\\.|Miss\\.",
  master = "Master.", rev = "Rev.", dr = "Dr."
)
fixed_titles <- c("mister", "missus", "master", "rev", "dr")

list(
  import = list(
    url = list(
      "https://raw.githubusercontent.com/haven-jeon/introduction_to_most_usable_pkgs_in_project/master/bicdata/data/titanic.csv",
      stringsAsFactors = FALSE
    )
  ),

  data = list(
    "has paren in name" = list(multi_column_transformation(function(name) grepl("(", fixed = TRUE, name)), "name", "has_paren")
   ,"Name length variable" = list(new_variable, function(name) nchar(name), "name_length")
   ,"Formal title" = list(regex_factor, "name", "formal_title", cases = titles, fixed = fixed_titles)
  )
)

