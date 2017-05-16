list(
  import = list(R = "iris"),
  data   = list(
    "Create a dependent variable"   = list(renamer, c("Sepal.Length" = "dep_var")),
    "Create a primary key variable" = list(multi_column_transformation(seq_along), "dep_var", "id"),
    "Drop categorical features"     = list(drop_variables, is.factor)
  ),
  model  = list("lm", .id_var = "id"),
  export = list(R = "model")
)
