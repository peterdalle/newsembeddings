library(text2vec)
library(tsne)
library(tidyverse)
library(lubridate)
library(glue)

get_query <- function(sql, database="mechanicalnews", UTF8 = TRUE) {
  library(RMySQL)
  drv <- DBI::dbDriver("MySQL")
  con <- DBI::dbConnect(drv, host="localhost", user="root", pass="root", dbname=database, encoding="UTF-8")
  if (UTF8) {
    DBI::dbSendQuery(con, statement="set character set 'utf8';")
  }
  df <- DBI::dbGetQuery(con, statement=sql)
  tmp <- DBI::dbDisconnect(con)
  return(data.table::as.data.table(df))
}

get_articles <- function(sql, UTF8=TRUE) {
  df <- get_query(sql=sql, UTF8=UTF8)
  cat(glue("Loaded {NROW(df)} articles\n"))
  return(df)
}

train_word2vec <- function(x, window=10, n_iter=2500, convergence_tol=0.00001) {
  start_time <- Sys.time()
  cat("itoken", "\n")
  it <- itoken(x, preprocessor = tolower, tokenizer = word_tokenizer)
  cat("create_vocabulary", "\n")
  vocab <- create_vocabulary(it)
  cat("prune_vocabulary", "\n")
  vocab = prune_vocabulary(vocab, term_count_min = 10)

  cat("vocab_vectorizer", "\n")
  vectorizer = vocab_vectorizer(vocab)

  cat("create_tcm", "\n")
  tcm = create_tcm(it, vectorizer, skip_grams_window = window)

  cat("glove$new", "\n")
  glove = GlobalVectors$new(rank = 50, x_max = 10)

  cat("glove$fit_transform", "\n")
  main = glove$fit_transform(tcm, n_iter=n_iter, convergence_tol=convergence_tol)
  context = glove$components

  end_time <- Sys.time()
  cat(end_time - start_time)

  main + t(context)
}


articles <- get_articles(sql="SELECT CONCAT(title, ' ', `lead`, ' ', body) AS body, added 
                              FROM articles WHERE parent_id = 0", UTF8=FALSE)

wordvectors <- articles$body %>%
    train_word2vec(window=15, n_iter=1000, convergence_tol=0.00001)

saveRDS(wordvectors, "trained-wordvectors.rds")
