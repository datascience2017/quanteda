library(quanteda)

context("test case change functions")

txt <- c("According to NATO", "There is G7 meeting")

test_that("toLower works.", {
    expect_equal(char_tolower(txt), c("according to nato", "there is g7 meeting"))
})

test_that("char_tolower/char_toUpper works.", {
    expect_equal((char_tolower(txt[1])), "according to nato")
    expect_equal((char_toupper(txt[1])), "ACCORDING TO NATO")
})

test_that("char_tolower keeps acronyms.", {
    expect_equal((char_tolower(txt, keep_acronyms = TRUE)), 
                 c("according to NATO", "there is G7 meeting"))
})

test_that("tokens_tolower/tokens_toupper works", {
    toks <- tokens(txt)
    expect_equal(as.list(tokens_tolower(toks)),
                  list(text1 = c("according", "to", "nato"),
                       text2 = c("there", "is", "g7", "meeting")))
    expect_equal(as.list(tokens_tolower(toks, keep_acronyms = TRUE)),
                 list(text1 = c("according", "to", "NATO"),
                      text2 = c("there", "is", "G7", "meeting")))
    expect_equal(as.list(tokens_toupper(toks)),
                 list(text1 = c("ACCORDING", "TO", "NATO"),
                      text2 = c("THERE", "IS", "G7", "MEETING")))
})

