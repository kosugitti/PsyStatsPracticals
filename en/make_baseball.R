# ==============================================================================
# Build the baseball sample data used in this textbook
#   Source : Lahman Baseball Database (CC BY-SA 3.0), via the R package Lahman
#   Output : Baseball.csv     (2011-2016 seasons, one row per player-season)
#            Baseball2016.csv (2016 season only, missing values coded as 999)
#   Usage  : place this file in your project folder and run
#            source("make_baseball.R")
# ==============================================================================

pacman::p_load(Lahman, dplyr, readr, stringr)

# ------------------------------------------------------------------------------
# Seasons (Lahman's salary table ends in 2016)
# ------------------------------------------------------------------------------
yrs <- 2011:2016

# ------------------------------------------------------------------------------
# Team nicknames (the 2016 name is used for each franchise)
# ------------------------------------------------------------------------------
nick <- Lahman::Teams |>
  dplyr::filter(yearID == 2016) |>
  dplyr::mutate(team = stringr::str_extract(name, "(Red Sox|White Sox|Blue Jays|\\S+)$"),
                team = dplyr::if_else(franchID == "ANA", "Angels", team)) |>
  dplyr::select(franchID, team)
tm <- Lahman::Teams |>
  dplyr::filter(yearID %in% yrs) |>
  dplyr::select(yearID, teamID, franchID) |>
  dplyr::left_join(nick, by = "franchID")

# ------------------------------------------------------------------------------
# Main position (the position with the most fielding games in the season)
# ------------------------------------------------------------------------------
pos <- Lahman::Fielding |>
  dplyr::filter(yearID %in% yrs) |>
  dplyr::group_by(playerID, yearID, POS) |>
  dplyr::summarise(G = sum(G), .groups = "drop") |>
  dplyr::group_by(playerID, yearID) |>
  dplyr::slice_max(G, n = 1, with_ties = FALSE) |>
  dplyr::ungroup() |>
  dplyr::mutate(position = dplyr::case_when(
    POS == "P" ~ "Pitcher",
    POS == "C" ~ "Catcher",
    POS == "OF" ~ "Outfielder",
    TRUE ~ "Infielder"
  )) |>
  dplyr::select(playerID, yearID, position)

# ------------------------------------------------------------------------------
# Salary (thousands of US dollars) and team
# ------------------------------------------------------------------------------
sal <- Lahman::Salaries |>
  dplyr::filter(yearID %in% yrs) |>
  dplyr::group_by(playerID, yearID) |>
  dplyr::summarise(salary = sum(salary) / 1000,
                   teamID = dplyr::first(teamID),
                   league = as.character(dplyr::first(lgID)), .groups = "drop")

# ------------------------------------------------------------------------------
# Batting and pitching records (mid-season trades are summed)
# ------------------------------------------------------------------------------
bat <- Lahman::Batting |>
  dplyr::filter(yearID %in% yrs) |>
  dplyr::group_by(playerID, yearID) |>
  dplyr::summarise(Games = sum(G), AtBats = sum(AB), Hit = sum(H), HR = sum(HR),
                   .groups = "drop")
pit <- Lahman::Pitching |>
  dplyr::filter(yearID %in% yrs) |>
  dplyr::group_by(playerID, yearID) |>
  dplyr::summarise(Win = sum(W), Lose = sum(L), Save = sum(SV), .groups = "drop")

# ------------------------------------------------------------------------------
# Join and tidy
# ------------------------------------------------------------------------------
dat <- sal |>
  dplyr::inner_join(pos, by = c("playerID", "yearID")) |>
  dplyr::left_join(bat, by = c("playerID", "yearID")) |>
  dplyr::left_join(pit, by = c("playerID", "yearID")) |>
  dplyr::left_join(tm, by = c("yearID", "teamID")) |>
  dplyr::left_join(
    Lahman::People |>
      dplyr::select(playerID, nameFirst, nameLast, height, weight, bats, throws),
    by = "playerID"
  ) |>
  dplyr::mutate(
    Name = paste(nameFirst, nameLast),
    height = round(height * 2.54),   # inches -> cm
    weight = round(weight * 0.4536)  # pounds -> kg
  ) |>
  dplyr::select(Year = yearID, Name, team, league, salary, bats, throws, height, weight,
                position, Games, AtBats, Hit, HR, Win, Lose, Save) |>
  dplyr::arrange(Year, league, team, Name)

readr::write_csv(dat, "Baseball.csv")

# ------------------------------------------------------------------------------
# Exercise file: 2016 only, missing values coded as 999
# ------------------------------------------------------------------------------
dat |>
  dplyr::filter(Year == 2016) |>
  dplyr::select(Year, Name, team, league, salary, position, Games, AtBats, Hit, Win, Lose) |>
  dplyr::mutate(dplyr::across(c(Win, Lose), ~ dplyr::coalesce(.x, 999))) |>
  readr::write_csv("Baseball2016.csv")
