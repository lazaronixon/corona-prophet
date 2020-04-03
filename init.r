if (!"prophet" %in% installed.packages()) {
  install.packages("devtools", repos="http://cloud.r-project.org")
  install.packages("prophet", repos="http://cloud.r-project.org")
}
