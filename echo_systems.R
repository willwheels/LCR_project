
col_types_systems <- list(
  SUBMISSIONYEARQUARTER = col_character(),
  PWSID = col_character(),
  PWS_NAME = col_character(),
  PRIMACY_AGENCY_CODE = col_character(),
  EPA_REGION = col_character(),
  SEASON_BEGIN_DATE = col_character(),
  SEASON_END_DATE = col_character(),
  PWS_ACTIVITY_CODE = col_character(),
  PWS_DEACTIVATION_DATE = col_character(),
  PWS_TYPE_CODE = col_character(),
  DBPR_SCHEDULE_CAT_CODE = col_double(),
  CDS_ID = col_character(),
  GW_SW_CODE = col_character(),
  LT2_SCHEDULE_CAT_CODE = col_double(),
  OWNER_TYPE_CODE = col_character(),
  POPULATION_SERVED_COUNT = col_double(),
  POP_CAT_2_CODE = col_double(),
  POP_CAT_3_CODE = col_double(),
  POP_CAT_4_CODE = col_double(),
  POP_CAT_5_CODE = col_double(),
  POP_CAT_11_CODE = col_double(),
  PRIMACY_TYPE = col_character(),
  PRIMARY_SOURCE_CODE = col_character(),
  IS_GRANT_ELIGIBLE_IND = col_character(),
  IS_WHOLESALER_IND = col_character(),
  IS_SCHOOL_OR_DAYCARE_IND = col_character(),
  SERVICE_CONNECTIONS_COUNT = col_double(),
  SUBMISSION_STATUS_CODE = col_character(),
  ORG_NAME = col_character(),
  ADMIN_NAME = col_character(),
  EMAIL_ADDR = col_character(),
  PHONE_NUMBER = col_character(),
  PHONE_EXT_NUMBER = col_character(),
  FAX_NUMBER = col_character(),
  ALT_PHONE_NUMBER = col_character(),
  ADDRESS_LINE1 = col_character(),
  ADDRESS_LINE2 = col_character(),
  CITY_NAME = col_character(),
  ZIP_CODE = col_character(),
  COUNTRY_CODE = col_character(),
  FIRST_REPORTED_DATE = col_character(),
  LAST_REPORTED_DATE = col_character(),
  STATE_CODE = col_character(),
  SOURCE_WATER_PROTECTION_CODE = col_character(),
  SOURCE_PROTECTION_BEGIN_DATE = col_character(),
  OUTSTANDING_PERFORMER = col_character(),
  OUTSTANDING_PERFORM_BEGIN_DATE = col_character(),
  REDUCED_RTCR_MONITORING = col_character(),
  REDUCED_MONITORING_BEGIN_DATE = col_character(),
  REDUCED_MONITORING_END_DATE = col_character(),
  SEASONAL_STARTUP_SYSTEM = col_character()
)

echo_systems <- read_csv(here::here("data", "raw", "SDWA_PUB_WATER_SYSTEMS.csv"),
                         col_types = col_types_systems)

echo_systems <- echo_systems %>%
  select(PWSID, PWS_NAME, PRIMACY_AGENCY_CODE, EPA_REGION, STATE_CODE, PWS_TYPE_CODE, GW_SW_CODE, 
         POPULATION_SERVED_COUNT, POP_CAT_5_CODE)


rm(col_types_systems)
