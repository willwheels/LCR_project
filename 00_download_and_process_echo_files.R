library(tidyverse)

## create directory structure


if (!dir.exists(here::here("data", "raw"))) {
  dir.create(here::here("data", "raw"), recursive = TRUE)
}

if (!dir.exists(here::here("data", "R_data_files"))) {
  dir.create(here::here("data", "R_data_files"), recursive = TRUE)
}


## grab SDWA data downloads from ECHO

sdwa_zip <- here::here("data", "raw", "SDWA_latest_downloads.zip" )

if (!file.exists(sdwa_zip)) {
  download.file("https://echo.epa.gov/files/echodownloads/SDWA_latest_downloads.zip",
                destfile =  sdwa_zip)
}


if (!file.exists("SDWA_PUB_WATER_SYSTEMS.csv")) {
  unzip(sdwa_zip, files = "SDWA_PUB_WATER_SYSTEMS.csv", exdir = here::here("data", "raw"))
}

if (!file.exists("SDWA_LCR_Samples.csv")) {
  unzip(sdwa_zip, files = "SDWA_LCR_SAMPLES.csv", exdir = here::here("data", "raw"))
}

col_types_samples <- list(
  SUBMISSIONYEARQUARTER = col_character(),
  PWSID = col_character(),
  SAMPLE_ID = col_character(),
  SAMPLING_END_DATE = col_character(),
  SAMPLING_START_DATE = col_character(),
  RECONCILIATION_ID = col_character(),
  SAMPLE_FIRST_REPORTED_DATE = col_character(),
  SAMPLE_LAST_REPORTED_DATE = col_character(),
  SAR_ID = col_double(),
  CONTAMINANT_CODE = col_character(),
  RESULT_SIGN_CODE = col_character(),
  SAMPLE_MEASURE = col_double(),
  UNIT_OF_MEASURE = col_character(),
  SAR_FIRST_REPORTED_DATE = col_character(),
  SAR_LAST_REPORTED_DATE = col_character()
)

echo_lcr_samples <- read_csv(here::here("data", "raw", "SDWA_LCR_SAMPLES.csv"),
                             col_types = col_types_samples)

source("echo_systems.R")

echo_lcr_samples <- echo_lcr_samples %>%
  mutate(state = substr(PWSID, 1, 2)) %>%
  left_join(echo_systems)

save(echo_lcr_samples, file = here::here("data", "R_data_files", "echo_lcr_samples.Rda"))


## Go to https://ordspub.epa.gov/ords/sfdw/f?p=108:35:::::P35_REPORT2:LCR
## click on "Lead Samples," clear the sampling start and end dates
## then click on the "View Reports" button, then download the report as .csv
## exceot I'm getting server errors so maybe not

