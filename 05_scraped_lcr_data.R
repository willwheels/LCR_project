library(tidyverse)


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
    mutate(sample_result = as.numeric(sample_result), num_samples = as.integer(num_samples))
  
}

all_summaries <- map_dfr(lcr_summary_files, read_summaries)

source("echo_systems.R")


scraped_lcr_summaries <- all_summaries %>%
  left_join(echo_systems, by = c("pwsid" = "PWSID")) %>%
  filter(contaminant_name == "Lead", !is.na(sample_result)) %>%
  mutate(remainder = num_samples %% 5, remainder0 = remainder == 0,
         state = substr(pwsid, 1, 2),
         sample_year = lubridate::year(lubridate::mdy(sampling_end_date)))
  
save(scraped_lcr_summaries, file = here::here("data", "R_data_files", "scraped_lcr_summaries.Rda"))


ggplot(all_summaries %>% filter(sample_result > 0, sample_result <= .025, num_samples >= 5),
       aes(x = sample_result)) +
  geom_histogram(binwidth = .001) +
  theme_minimal()

ggplot(all_summaries %>% filter(sample_result > .005, sample_result <= .025, num_samples >= 5),
       aes(x = sample_result)) +
  geom_histogram(binwidth = .001) +
  theme_minimal() +
  facet_wrap(~remainder0)

ggplot(all_summaries %>% filter(sample_result > .005, sample_result <= .025, num_samples >= 5),
       aes(x = sample_result)) +
  geom_histogram(binwidth = .001) +
  theme_minimal() +
  facet_wrap(~state)


ggplot(all_summaries %>% filter(sample_result > .005, sample_result <= .025,
                                num_samples >= 5, state %in% c("IL", "IN", "OH", "VT")),
       aes(x = sample_result)) +
  geom_histogram(binwidth = .001) +
  theme_minimal() +
  facet_wrap(~state)

ggsave("four_state_lcr_scraped.png")

ohio_summaries <- all_summaries %>%
  filter(state == "OH")


ggplot(ohio_summaries %>% filter(sample_result > 0, sample_result <= .025, num_samples >= 5),
       aes(x = sample_result)) +
  geom_histogram(binwidth = .001) +
  theme_minimal()





ggplot(ohio_summaries %>% filter(sample_result > 0, sample_result <= .025, num_samples >= 5),
       aes(x = sample_result)) +
  geom_histogram(binwidth = .001) +
  theme_minimal() +
  facet_wrap(~remainder0)



