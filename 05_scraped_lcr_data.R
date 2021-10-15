library(tidyverse)


## for this to work, you need to sync the LCR summaries directory to your OneDrive

username <- Sys.getenv("USERNAME")
lcr_summaries_path <- paste0("C:/Users/", username, 
                             "/OneDrive - Environmental Protection Agency (EPA)/DWDB/Data/LCR Summaries")

lcr_summary_files <- list.files(lcr_summaries_path, full.names = TRUE)


read_summaries <- function(filename){
  
  # read in as all character and change later--read_csv guesses differently for different files
  df <- read_csv(filename, col_names = FALSE, col_types = cols(.default = "c"))
  
  colnames(df) <- c("rownum", "county", "pwsid", "system_name", "sampling_start_date",
                                "sampling_end_date", "num_samples", "sample_result", "contaminant_name")
  
  df <- df %>%
    select(-rownum) %>%
    mutate(sample_result = as.numeric(sample_result), num_samples = as.integer(num_samples),
           state = substr(pwsid, 1, 2))
  
}

all_summaries <- map_dfr(lcr_summary_files, read_summaries)
warnings()

source("echo_systems.R")


scraped_lcr_summaries <- all_summaries %>%
  left_join(echo_systems, by = c("pwsid" = "PWSID")) %>%
  filter(contaminant_name == "Lead", !is.na(sample_result)) %>%
  mutate(remainder = num_samples %% 5, remainder0 = remainder == 0,
         sample_year = lubridate::year(lubridate::mdy(sampling_end_date)))
  
save(scraped_lcr_summaries, file = here::here("data", "R_data_files", "scraped_lcr_summaries.Rda"))



