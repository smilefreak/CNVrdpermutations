context("Permutation c module")

load(system.file("extdata", "testSegments.RData", package="CNVrdpermutations"))
test_that("Length of data file", {
    expect_equal(length(permute_list),10)
})


test_that("Permutation CPP module", {
    expect_equal(length(permute_list), permute_segmentation_results(permute_list,1000,0,51304000,nperm=5))

})


