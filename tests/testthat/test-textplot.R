context('test plots.R')

test_that("test plot.kwic scale argument default", {

    sda <- kwic(texts(data_corpus_inaugural)[[1]], 'american')
    sdp <- kwic(texts(data_corpus_inaugural)[[1]], 'people')
    mda <- kwic(data_corpus_inaugural, 'american')
    mdp <- kwic(data_corpus_inaugural, 'people')

    # Single document, should be absolute
    p <- textplot_xray(sda)
    expect_equal(p$labels$x, 'Token index')

    # Single document, multiple keywords, should be absolute
    p <- textplot_xray(sda, sdp)
    expect_equal(p$labels$x, 'Token index')

    # Multiple documents, should be relative
    p <- textplot_xray(mda)
    expect_equal(p$labels$x, 'Relative token index')

    # Multiple documents, multiple keywords, should be relative
    p <- textplot_xray(mda, mdp)
    expect_equal(p$labels$x, 'Relative token index')

    # Explicit overrides
    p <- textplot_xray(sda, scale='absolute')
    expect_equal(p$labels$x, 'Token index')
    p <- textplot_xray(sda, sdp, scale='absolute')
    expect_equal(p$labels$x, 'Token index')
    p <- textplot_xray(mda, scale='absolute')
    expect_equal(p$labels$x, 'Token index')
    p <- textplot_xray(mda, mdp, scale='absolute')
    expect_equal(p$labels$x, 'Token index')

    p <- textplot_xray(sda, scale='relative')
    expect_equal(p$labels$x, 'Relative token index')
    p <- textplot_xray(sda, sdp, scale='relative')
    expect_equal(p$labels$x, 'Relative token index')
    p <- textplot_xray(mda, scale='relative')
    expect_equal(p$labels$x, 'Relative token index')
    p <- textplot_xray(mda, mdp, scale='relative')
    expect_equal(p$labels$x, 'Relative token index')


})


test_that("test plot.kwic facet order parameter", {

    p <- textplot_xray(kwic(data_corpus_inaugural, 'american'), sort=TRUE)
    plot_docnames <- as.character(unique(ggplot2::ggplot_build(p)$layout$panel_layout$docname))
    expect_true(
        all(
            plot_docnames[order(plot_docnames)] == plot_docnames
        )
    )

    p <- textplot_xray(kwic(data_corpus_inaugural, 'american'), kwic(data_corpus_inaugural, 'people'), sort=TRUE)
    plot_docnames <- as.character(unique(ggplot2::ggplot_build(p)$layout$panel_layout$docname))
    expect_true(
        all(
            plot_docnames[order(plot_docnames)] == plot_docnames
        )
    )

    # Default should be false
    p <- textplot_xray(kwic(data_corpus_inaugural[c(53:54, 1:2)], 'american'), 
                       kwic(data_corpus_inaugural[c(53:54, 1:2)], 'people'))
    plot_docnames <- as.character(unique(ggplot2::ggplot_build(p)$layout$panel_layout$docname))
    expect_false(
        all(
            plot_docnames[order(plot_docnames)] == plot_docnames
        )
    )
    
})

test_that("test plot.kwic keeps order of keywords passed", {
    p <- textplot_xray(kwic(data_corpus_inaugural, 'people'), kwic(data_corpus_inaugural, 'american'), sort=TRUE)
    expect_equal(
        as.character(unique(ggplot2::ggplot_build(p)$layout$panel_layout$keyword)),
        c('people', 'american')
    )
})

test_that("test textplot_wordcloud works for dfm objects", {
    expect_silent(textplot_wordcloud(dfm(data_corpus_inaugural[1:5]), min.freq = 10))
})

test_that("test textplot_wordcloud works for tokens objects", {
    expect_silent(textplot_wordcloud(tokens(data_corpus_inaugural[1:5]), min.freq = 10))
})

test_that("test textplot_scale1d wordfish in the most basic way", {
    wfm <- textmodel_wordfish(dfm(data_corpus_irishbudget2010), dir = c(6,5))
    expect_false(identical(textplot_scale1d(wfm, sort = TRUE), 
                           textplot_scale1d(wfm, sort = FALSE)))
    expect_silent(textplot_scale1d(wfm, sort = TRUE, groups = docvars(data_corpus_irishbudget2010, "party")))
    expect_silent(textplot_scale1d(wfm, sort = FALSE, groups = docvars(data_corpus_irishbudget2010, "party")))
    
    expect_silent(textplot_scale1d(wfm, doclabels = apply(docvars(data_corpus_irishbudget2010, c("name", "party")), 
                                                          1, paste, collapse = " ")))
    
    p1 <- textplot_scale1d(wfm, margin = "features", sort = TRUE)
    p2 <- textplot_scale1d(wfm, margin = "features", sort = FALSE)
    p1$plot_env <- NULL
    p2$plot_env <- NULL
    expect_equivalent(p1, p2)
})

test_that("test textplot_scale1d wordscores in the most basic way", {
    ws <- textmodel_wordscores(dfm(data_corpus_irishbudget2010), c(rep(NA, 4), -1, 1, rep(NA, 8)))
    pr <- predict(ws)
    expect_false(identical(textplot_scale1d(pr, sort = TRUE), 
                           textplot_scale1d(pr, sort = FALSE)))
    expect_silent(textplot_scale1d(pr, sort = TRUE, groups = docvars(data_corpus_irishbudget2010, "party")))
    expect_silent(textplot_scale1d(pr, sort = FALSE, groups = docvars(data_corpus_irishbudget2010, "party")))
    
    expect_silent(textplot_scale1d(pr, doclabels = apply(docvars(data_corpus_irishbudget2010, c("name", "party")), 
                                                         1, paste, collapse = " ")))
    
    p1 <- textplot_scale1d(pr, margin = "features", sort = TRUE)
    p2 <- textplot_scale1d(pr, margin = "features", sort = FALSE)
    p1$plot_env <- NULL
    p2$plot_env <- NULL
    expect_equivalent(p1, p2)
})

test_that("test textplot_keyness ", {
    prescorpus <- corpus_subset(data_corpus_inaugural, President %in% c("Obama", "Trump"))
    presdfm <- dfm(prescorpus, groups = "President", remove = stopwords("english"),
                   remove_punct = TRUE)
    result <- textstat_keyness(presdfm, target = "Trump", measure = "chi2")
    
    # shows the correct statistic measure 
    p3 <- textplot_keyness(result, show_reference = TRUE)
    expect_equal(p3$labels$y, colnames(result)[1])
})

test_that("test textplot_keyness: show_reference works correctly ", {
    prescorpus <- corpus_subset(data_corpus_inaugural, President %in% c("Obama", "Trump"))
    presdfm <- dfm(prescorpus, groups = "President", remove = stopwords("english"),
                   remove_punct = TRUE)
    result <- textstat_keyness(presdfm, target = "Trump")
    
    k = 10
    p1 <- textplot_keyness(result, show_reference = FALSE, n = k)
    p2 <- textplot_keyness(result, show_reference = TRUE, n = k)
    
    # Plot with two different fills when show_reference = TRUE
    expect_equal(dim(table(ggplot2::ggplot_build(p1)$data[[1]]$fill)), 1)
    expect_equal(dim(table(ggplot2::ggplot_build(p2)$data[[1]]$fill)), 2)

    # number of words plotted doubled when show_reference = TRUE
    expect_equal(nrow(ggplot2::ggplot_build(p1)$data[[1]]), k)
    expect_equal(nrow(ggplot2::ggplot_build(p2)$data[[1]]), 2*k)
    

})

test_that("test textplot_network", {
    txt <- "A D A C E A D F E B A C E D"
    testfcm <- fcm(txt, context = "window", window = 3, tri = FALSE)
    testdfm <- dfm(txt)
    expect_silent(textplot_network(testfcm, vertex_color = 'red', offset = 0.1))
    expect_silent(textplot_network(testdfm, offset = 0.1))
    expect_error(textplot_network(testfcm, min_freq = 100), 
                 'There is no co-occurence higher than the threshold')
})

test_that("textplot_network error when fcm is too large", {
    testdfm <- dfm(data_corpus_irishbudget2010)
    expect_error(textplot_network(testdfm, min_freq = 1, offset = 0, omit_isolated = FALSE),
                   'fcm is too large for a network plot')
})

