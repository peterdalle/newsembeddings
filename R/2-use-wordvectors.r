library(text2vec)
library(tsne)
library(tidyverse)
library(glue)

related_words <- function(wordvectors, word, n=15) {
  if (!word %in% dimnames(wordvectors)[[1]]) {
    stop(glue("'{word}' not found in word vector"), call. = FALSE)
  }
  y_word <- wordvectors[word, , drop = FALSE]
  cos_sim = text2vec::sim2(x=wordvectors, y=y_word, method="cosine", norm="l2")
  sort(cos_sim[,1], decreasing = TRUE) %>%
    head(n) %>%
    as.data.frame() %>%
    rownames_to_column() %>%
    set_names("word", "prob")
}

wordvectors <- readRDS("wordvectors.rds")

wordvectors %>%
  related_words(word="regeringen", n=20)
