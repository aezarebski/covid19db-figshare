library(ggplot2)
library(magrittr)
library(dplyr)
library(reshape2)

weather_plot_df <- read.csv("italy.csv",
                            header = TRUE,
                            stringsAsFactors = FALSE) %>%
    filter(country == "Italy", adm_area_2 == "NaN") %>%
    rename(humidity = humidity_mean_avg) %>%
    mutate(date = as.Date(date, format = "%Y-%m-%d"),
           temperature = temperature_mean_avg - 273.15) %>%
    select(date, adm_area_1, humidity, temperature) %>%
    melt(id.vars = c("date", "adm_area_1"))

facet_labels <- c(temperature = "Temperature (Celsius)",
                  humidity = "Humidity (XXX)")

weather_fig <- ggplot(weather_plot_df,
                      aes(x = date, y = value, group = adm_area_1)) +
    geom_line() +
    facet_wrap(~variable,
               scales = "free_y",
               labeller = labeller(variable = facet_labels)) +
    labs(x = "Date", y = NULL) +
    theme_bw()

ggsave("demo-weather-plot.pdf",
       weather_fig,
       width = 2 * 14.8,
       height = 2 * 10.5,
       units = "cm")
