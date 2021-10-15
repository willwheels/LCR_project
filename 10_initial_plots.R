library(tidyverse)


load( here::here("data", "R_data_files", "echo_lcr_samples.Rda"))



summary(echo_lcr_samples$SAMPLE_MEASURE)
unique(echo_lcr_samples$UNIT_OF_MEASURE)
unique(echo_lcr_samples$CONTAMINANT_CODE)
unique(echo_lcr_samples$RESULT_SIGN_CODE)

echo_lcr_samples <- echo_lcr_samples %>%
  filter(CONTAMINANT_CODE == "PB90")

## there are negative values and zeroes, need to track those down--I assume they are some sort
## of non-detect

ggplot(echo_lcr_samples %>% filter(SAMPLE_MEASURE > 0, SAMPLE_MEASURE <= .025),
       aes(x= SAMPLE_MEASURE)) +
  geom_histogram(binwidth = .001) +
  theme_minimal()

ggplot(echo_lcr_samples %>% filter(SAMPLE_MEASURE > .005, SAMPLE_MEASURE <= .025),
       aes(x= SAMPLE_MEASURE)) +
  geom_histogram(binwidth = .001) +
  theme_minimal()


echo_lcr_sample_counts <- echo_lcr_samples %>%
  group_by(PWSID, SAMPLING_END_DATE, SAMPLING_START_DATE) %>%
  count() %>% 
  ungroup() %>%
  group_by(n) %>%
  count(sort = TRUE)
  

load( here::here("data", "R_data_files", "scraped_lcr_summaries.Rda"))


unique(scraped_lcr_summaries$contaminant_name)

head(echo_lcr_sample_counts, 20)

print("Wes and I don't think there should be more than one")

scraped_lcr_summary_counts <- scraped_lcr_summaries %>%
  group_by(pwsid, sampling_end_date, sampling_start_date) %>%
  count() %>% 
  ungroup() %>%
  group_by(n) %>%
  count(sort = TRUE)


head(scraped_lcr_summary_counts, 20)


scraped_lcr_sample_counts_state <- scraped_lcr_summaries %>%
  group_by(pwsid, STATE_CODE, sampling_end_date, sampling_start_date) %>%
  count() %>% 
  ungroup() %>%
  group_by(STATE_CODE, n) %>%
  count() 

  
echo_lcr_sample_counts_state <- echo_lcr_samples %>%
  group_by(PWSID, STATE_CODE, SAMPLING_END_DATE, SAMPLING_START_DATE) %>%
  count() %>% 
  ungroup() %>%
  group_by(STATE_CODE, n) %>%
  count() 

echo_lcr_samples_scraped_states <- echo_lcr_samples %>% 
  filter(state %in% unique(scraped_lcr_summaries$state))

ggplot(echo_lcr_samples_scraped_states %>% filter(SAMPLE_MEASURE > .005, SAMPLE_MEASURE <= .025),
       aes(x = SAMPLE_MEASURE)) +
  geom_histogram(binwidth = .001) +
  labs(title = "LCR Sample Summaries, ECHO data") +
  theme_minimal()

echo_plot <- ggplot(echo_lcr_samples_scraped_states %>% filter(SAMPLE_MEASURE > .005, SAMPLE_MEASURE <= .025),
                    aes(x = SAMPLE_MEASURE)) +
  geom_histogram(binwidth = .001) +
  labs(title = "LCR Sample Summaries, ECHO data") +
  theme_minimal()

  
ggplot(scraped_lcr_summaries %>% filter(sample_result > .005, sample_result <= .025),
       aes(x = sample_result)) +
  geom_histogram(binwidth = .001) +
  labs(title = "LCR Sample Summaries, Scraped Data") +
  theme_minimal()

echo_data_to_combine <- echo_lcr_samples_scraped_states %>%
  select(SAMPLE_MEASURE) %>%
  rename(sample_result = SAMPLE_MEASURE) %>%
  mutate(data_source = "ECHO")

scraped_data_to_combine <- scraped_lcr_summaries %>%
  select(sample_result) %>%
  mutate(data_source = "Scraped")

combined_sample_data <- rbind(echo_data_to_combine, scraped_data_to_combine)

ggplot(combined_sample_data %>% filter(sample_result > .005, sample_result <= .025),
       aes(x = sample_result)) +
  geom_histogram(binwidth = .001) +
  labs(title = "LCR Sample Summaries", caption = "16 scraped states, sample years not aligned") +
  theme_minimal() +
  facet_wrap(~data_source)
