#' access built-in stopwords
#' 
#' This function retrieves stopwords from the type specified in the \code{kind} 
#' argument and returns the stopword list as a character vector.  The default is 
#' English.
#' 
#' The stopword list is an internal data object named 
#' \code{\link{data_char_stopwords}}, which consists of English stopwords from 
#' the SMART information retrieval system (obtained from Lewis et. al. (2004) 
#' and a set of stopword lists from the Snowball stemmer project in different 
#' languages (see \url{http://snowballstem.org/projects.html}).  See
#' \link{data_char_stopwords} for details.
#' @rdname stopwords
#' @section A note of caution: Stop words are an arbitrary choice imposed by the
#'   user, and accessing a pre-defined list of words to ignore does not mean 
#'   that it will perfectly fit your needs. You are strongly encouraged to 
#'   inspect the list and to make sure it fits your particular requirements.
#' @param kind The pre-set kind of stopwords (as a character string).  Allowed
#'   values are \code{english}, \code{SMART}, \code{chinese}, \code{danish},
#'   \code{french}, \code{greek}, \code{hungarian}, \code{norwegian},
#'   \code{russian}, \code{swedish}, \code{catalan}, \code{dutch},
#'   \code{finnish}, \code{german}, \code{italian}, \code{portuguese},
#'   \code{spanish}, \code{arabic}.
#' @return a character vector of stopwords
#' @source The English stopwords are taken from the SMART information retrieval 
#'   system (obtained from Lewis, David D., et al. 
#'   "\href{http://www.jmlr.org/papers/volume5/lewis04a/lewis04a.pdf}{Rcv1: A 
#'   new benchmark collection for text categorization research.}" \emph{Journal 
#'   of machine learning research} (2004, 5 April): 361-397.
#'   
#'   Additional stopword lists are taken from the Snowball stemmer project in 
#'   different languages (see \url{http://snowballstem.org/projects.html}).
#'   
#'   The Greek stopwords were supplied by Carsten Schwemmer (see 
#'   \href{https://github.com/kbenoit/quanteda/issues/282}{GitHub issue #282}).
#'   
#'   The Chinese stopwords are taken from the
#'   \href{http://www.baiduguide.com/baidu-stopwords/}{Baidu stopword list}.
#' @name stopwords
#' @export
#' @examples
#' head(stopwords("english"))
#' head(stopwords("italian"))
#' head(stopwords("arabic"))
#' head(stopwords("chinese"))
#' head(stopwords("SMART"))
#' 
#' # adding to the built-in stopword list
#' toks <- tokens("The judge will sentence Mr. Adams to nine years in prison", remove_punct = TRUE)
#' tokens_remove(toks, c(stopwords("english"), "will", "mr", "nine"))
stopwords <- function(kind = quanteda_options("language_stopwords")) {
    if (!(kind %in% names(quanteda::data_char_stopwords)))
        stop(paste0("\"", kind, "\" is not a recognized stopword list name."))
    quanteda::data_char_stopwords[[kind]]
}

#' @rdname data-internal
#' @details \code{data_char_stopwords} provides stopword lists in multiple 
#'   languages; it is a named list of characters with the lowercase language 
#'   name (in English) as the name of each list element.  
#'   Supported languages are Arabic, Danish, Dutch, English, Finnish, French, 
#'   German, Greek, Hungarian, Italian, Norwegian, Portuguese, Russian, Spanish,
#'   and Swedish.
#' @source The English stopwords are taken from the SMART information retrieval 
#'   system (obtained from Lewis, David D., et al. 
#'   "\href{http://www.jmlr.org/papers/volume5/lewis04a/lewis04a.pdf}{Rcv1: A 
#'   new benchmark collection for text categorization research.}" \emph{Journal 
#'   of machine learning research} (2004, 5 April): 361-397.
#'   
#'   Additional stopword lists are taken from the Snowball stemmer project in 
#'   different languages (see \url{http://snowballstem.org/projects.html}).
#'   
#'   The Greek stopwords were supplied by Carsten Schwemmer (see 
#'   \href{https://github.com/kbenoit/quanteda/issues/282}{GitHub issue #282}).
#' @seealso \code{\link{stopwords}}
"data_char_stopwords"
