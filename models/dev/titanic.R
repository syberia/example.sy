titles <- c(
  mr = "Mr.", ms = "Mrs.", mrs = "Ms\\.|Miss\\.",
  master = "Master.", rev = "Rev.", dr = "Dr."
)
fixed_titles <- c("mr", "ms", "master", "rev", "dr")

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
   ,"Formal title" = list(regex_factor, "name", "title", cases = titles, fixed = fixed_titles)
   ,"title_fare variable" = list(new_variable, function(title, fare) { stats::ave(fare, title, FUN = mean) }, "title_fare")
   ,"class_fare"           = list(multi_column_transformation(function(klass, fare) { ave(fare, klass, FUN = mean) }), c("pclass", "fare"), "class_fare")
   ,"Some simple derivations" = list(atransform, alist(fare_diff = fare - title_fare, fare_pct = fare / title_fare, fare_diff_class = fare - class_fare, fare_pct_class = fare / class_fare))
  )
)

