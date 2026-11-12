library(dplyr)
library(tidyverse)

project1 <- read.csv("project1_2025_merged.csv")

oecd <- readRDS("oecd.rds")
opec <- readRDS("opec.rds")

project12 <- project1 |>
  mutate(isoecd = if_else(name %in% oecd, 1, 0)) |>
  mutate(isopec = if_else(name %in% opec, 1, 0))

population <- read_csv("pop.csv") |>
  select(geo, name, population = `2025`)

bmimen <- read_csv("body_mass_index_bmi_men_kgperm2.csv") |>
  select(geo, name, body_mass_index_bmi_men = `2016`)

bmiwomen <- read_csv("body_mass_index_bmi_women_kgperm2.csv") |>
  select(geo, name, body_mass_index_bmi_women = `2016`)

poverty <- read_csv("number_of_people_in_poverty.csv") |>
  select(geo, name, number_of_people_in_poverty = `2024`)

project3_2025 <- project12 |>
  left_join(bmimen, by = c("geo", "name")) |>
  left_join(bmiwomen, by = c("geo", "name")) |>
  left_join(poverty, by = c("geo", "name")) |>
  left_join(population, by = c("geo", "name"))

project3_2025 <- project3_2025 |>
  mutate(poverty = (number_of_people_in_poverty / population) * 100000)



project3_2025 <- project3_2025 |>
  select(-number_of_people_in_poverty, -population)
getwd()
write_csv(project3_2025, "data/project3_2025.csv")