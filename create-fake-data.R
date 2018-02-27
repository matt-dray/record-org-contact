# create dummy data

library(dplyr)
library(charlatan)
library(stringr)
library(lubridate)


# Create dataframe --------------------------------------------------------


# generate fake research refernces IDs to loop through

research_ref <- charlatan::ch_doi(50)

# generate vectors of fakes to sample from

fake_urns <- as.character(ch_integer(n = 100, min = 100000, max = 400000))
fake_leads <- paste0(tolower(gsub(" ", "", ch_name(5))), "@fake.com")
fake_tag <- c("Accountability", "Curriculum", "Qualifications")
fake_mode <- c("Telephone", "Email", "Text", "In-person")
fake_start <- sample(seq(as.Date("2017/01/01"), as.Date("2017/05/31"), by = "day"), 10)
fake_end <- sample(seq(as.Date("2017/06/01"), as.Date("2017/12/31"), by = "day"), 10)

# create empty list to fill

project_list <- list()

# loop through each project

for (i in seq_along(research_ref)) {
  
  # generate sample
  
  project_sample <- dplyr::tibble(
    urn = sample(fake_urns, 50),
    research_ref = research_ref[i],
    lead_email = sample(fake_leads, 1),
    reason_tag = sample(fake_tag, 1),
    reason_sentence = paste("To gather evidence on", tolower(reason_tag)),
    mode = sample(fake_mode, 1),
    start = lubridate::ymd(sample(fake_start, 1)),
    end = lubridate::ymd(sample(fake_end, 1))
  )
  
  # assign name
  
  project_list[[i]] <- project_sample # add it to your list
  
}

# bind the list elements together into a datframe

fake_dataset <- do.call(rbind, project_list)

fake_dataset <- fake_dataset %>% 
  mutate_if(is.character, as.factor) %>% 
  mutate(reason_sentence = as.character(reason_sentence))


# create fake schools list to be joined by urn to fake dataset

fake_schools <- tibble(
  urn = unique(fake_dataset$urn),
  school_name = paste(
    stringr::str_to_title(charlatan::ch_taxonomic_genus(length(unique(fake_dataset$urn)))),
    "School"
  )
) %>% 
  mutate(school_name = as.factor(school_name))

# check fake school names

unique(fake_schools$school_name)

# join fake school names to fake urns

fake_dataset <- fake_dataset %>% left_join(
  y = fake_schools,
  by = "urn"
) %>% 
  select(
    # school info
    `Name` = school_name,
    `URN` = urn,
    # contact info
    `Reason tag` = reason_tag,
    `Reason text` = reason_sentence,
    Mode = mode,
    `Contact start` = start,
    `Contact end` = end,
    # research info
    `Research ref` = research_ref,
    `Lead` = lead_email
  )

# save the fake data

saveRDS(fake_dataset, "global/fake_dataset.RDS")
