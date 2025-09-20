rm(list=ls())
pacman::p_load(tidyverse, lubridate, cmdstanr)

dat <- read_csv("SimpleWeight.csv") |>
  mutate(date = lubridate::ymd_hms(`日時 [Asia/Tokyo]`)) |>
  mutate(weight = `体 重 [kg]`) |>
  select(date,weight) |>
  complete(date = seq(min(date, na.rm = TRUE), max(date, na.rm = TRUE), by = "day")) |> 
  write_csv(file = "SimpleWeight.csv")

dat |> 
  filter(date > "2024/01/01") |> 
  filter(date < "2024/06/01") |> 
  ggplot(aes(x=date,y=weight))+geom_point()

model <- cmdstanr::cmdstan_model("jp/change_point.stan")

dat <- dat |> 
  filter(date > "2024/01/01") |> 
  filter(date < "2024/06/01") |> na.omit(dat) |> 
  write_csv(file = "myWeights.csv")


dataSet <- list(
  L = nrow(dat),
  w = dat$weight
)

fit <- model$sample(
  data = dataSet,
  chains = 4,
  parallel_chains = 4,
  iter_warmup = 2000,
  iter_sampling = 2000
)

