# 英語版の野球データ(Baseball.csv・Baseball2016.csv)を Lahman から作る
# 出典: Lahman Baseball Database (CC BY-SA 3.0)，R パッケージ Lahman 14.0.0
# 実行: en/ をカレントにして Rscript data-raw/make_baseball.R

pacman::p_load(Lahman, dplyr, readr, stringr)

# 対象年度 ---------------------------------------------------------------
# Lahman の年俸表は 2016 年までなので 2011-2016 年にする
yrs <- 2011:2016

# 球団の愛称(2016 年の名称を球団の系譜 franchID ごとに使う) ---------------
nick <- Lahman::Teams |>
  dplyr::filter(yearID == 2016) |>
  dplyr::mutate(team = stringr::str_extract(name, "(Red Sox|White Sox|Blue Jays|\\S+)$"),
                team = dplyr::if_else(franchID == "ANA", "Angels", team)) |>
  dplyr::select(franchID, team)
tm <- Lahman::Teams |>
  dplyr::filter(yearID %in% yrs) |>
  dplyr::select(yearID, teamID, franchID) |>
  dplyr::left_join(nick, by = "franchID")

# 主ポジション(その年の守備試合数が最多のもの) ----------------------------
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

# 年俸(千ドル)と所属 -------------------------------------------------------
sal <- Lahman::Salaries |>
  dplyr::filter(yearID %in% yrs) |>
  dplyr::group_by(playerID, yearID) |>
  dplyr::summarise(salary = sum(salary) / 1000,
                   teamID = dplyr::first(teamID),
                   league = as.character(dplyr::first(lgID)), .groups = "drop")

# 打撃と投手の成績(シーズン途中の移籍は合算) --------------------------------
bat <- Lahman::Batting |>
  dplyr::filter(yearID %in% yrs) |>
  dplyr::group_by(playerID, yearID) |>
  dplyr::summarise(Games = sum(G), AtBats = sum(AB), Hit = sum(H), HR = sum(HR),
                   .groups = "drop")
pit <- Lahman::Pitching |>
  dplyr::filter(yearID %in% yrs) |>
  dplyr::group_by(playerID, yearID) |>
  dplyr::summarise(Win = sum(W), Lose = sum(L), Save = sum(SV), .groups = "drop")

# 結合して整形 ---------------------------------------------------------------
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
    height = round(height * 2.54),   # インチ → cm
    weight = round(weight * 0.4536)  # ポンド → kg
  ) |>
  dplyr::select(Year = yearID, Name, team, league, salary, bats, throws, height, weight,
                position, Games, AtBats, Hit, HR, Win, Lose, Save) |>
  dplyr::arrange(Year, league, team, Name)

readr::write_csv(dat, "Baseball.csv")

# 演習用: 2016 年だけ・欠測を 999 で表したもの -------------------------------
dat |>
  dplyr::filter(Year == 2016) |>
  dplyr::select(Year, Name, team, league, salary, position, Games, AtBats, Hit, Win, Lose) |>
  dplyr::mutate(dplyr::across(c(Win, Lose), ~ dplyr::coalesce(.x, 999))) |>
  readr::write_csv("Baseball2016.csv")
