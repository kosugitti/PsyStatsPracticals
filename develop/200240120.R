pacman::p_load(tidyverse)
dat <- read_csv("Baseball.csv") %>%
  filter(Year == "2022年度") %>%
  dplyr::select(Year, Name, team, salary, position, Games, AtBats, Hit) %>%
  mutate_at(vars(Games, AtBats, Hit), ~ ifelse(is.na(.), 999, .)) %>%
  write_csv(file = "Baseball2022.csv")
