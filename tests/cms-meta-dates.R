library(healthyR.data)

# Exercise the public function with deterministic CMS-shaped data, replacing
# only the HTTP retrieval assignment so package checks do not need a network.
temporal <- c("not a date", "2026-01-01/2026-06-30", "2026-01-01",
              "2026-01-01/", "/2026-06-30", NA_character_, "",
              "../..", "2026-02-30/2026-06-30", " 2026-01-01 / 2026-06-30 ")
modified <- c("invalid", rep("2026-07-01T12:00:00Z", 9))
fixture <- list(dataset = data.frame(
    title = rep("Market Saturation & Utilization State-County", 10),
    description = "Test metadata", landingPage = "https://example.com",
    modified = modified, keyword = "nation", describedBy = "https://example.com/schema",
    identifier = paste0("dataset-", seq_along(temporal)), temporal = temporal,
    references = "https://example.com/reference"
))
fixture$dataset$contactPoint <- data.frame(
    `@type` = rep("vcard:Contact", 10), fn = "CMS",
    hasEmail = "mailto:example@example.com", check.names = FALSE
)
fixture$dataset$distribution <- lapply(seq_along(temporal), function(i) {
    data.frame(`@type` = "dcat:Distribution", description = "latest",
               title = "Test CSV", modified = modified[i], temporal = temporal[i],
               format = "csv", mediaType = "text/csv", accessURL = NA_character_,
               downloadURL = "https://example.com/data.csv", check.names = FALSE)
})

fetch_fixture <- get_cms_meta_data
function_body <- body(fetch_fixture)
retrieval <- which(vapply(as.list(function_body), function(expr) {
    identical(expr, quote(data_sets <- get_json_data(url)))
}, logical(1)))
stopifnot(length(retrieval) == 1L)
function_body[[retrieval]] <- quote(data_sets <- fixture)
body(fetch_fixture) <- function_body
environment(fetch_fixture) <- environment()

result <- withCallingHandlers(
    fetch_fixture(.keyword = "nation",
                  .title = "Market Saturation & Utilization State-County"),
    warning = function(w) stop(conditionMessage(w))
)
expected_start <- as.Date(c(NA, rep("2026-01-01", 3), rep(NA, 5), "2026-01-01"))
expected_end <- as.Date(c(NA, "2026-06-30", NA, NA, "2026-06-30",
                         NA, NA, NA, "2026-06-30", "2026-06-30"))
stopifnot(nrow(result) == 10L,
          inherits(result, "cms_meta_data"),
          identical(result$start, expected_start),
          identical(result$end, expected_end),
          identical(result$distribution_start, expected_start),
          identical(result$distribution_end, expected_end),
          identical(result$modified, as.Date(c(NA, rep("2026-07-01", 9)))),
          identical(result$distribution_modified, result$modified),
          identical(attr(result, "parameters")$.keyword, "nation"),
          nrow(fetch_fixture(.modified_date = "2026-07-01")) == 9L,
          nrow(fetch_fixture(.identifier = "^dataset-2$", .media_type = "csv")) == 1L,
          nrow(fetch_fixture(.data_version = "archive")) == 0L,
          nrow(fetch_fixture(.data_version = "all")) == 10L)
