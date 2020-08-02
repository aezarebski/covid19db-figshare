library(ggplot2)
library(ggspatial)
library(GADMTools)
library(purrr)
library(magrittr)
library(dplyr)
library(cowplot)
library(reshape2)

my_breaks <- seq(from = 0,
                 to = 20000,
                 by = 5000)

my_cols <- hcl.colors(n = length(my_breaks) - 1,
                      palette = "reds 3",
                      alpha = NULL,
                      rev = TRUE,
                      fixup = TRUE)

map_country_line_colour <- "#252525"
map_inline_thickness <- 0.1
map_outline_thickness <- 0.5

map_plot_background <- element_rect(colour = "#252525",
                                    fill = "#FFFFFF")

italy_sf <- gadm_sf_loadCountries("ITA", level = 1)$sf
italy_outline_sf <- gadm_sf_loadCountries("ITA", level = 0)$sf

epi_df <- read.csv("data/epidemiology.csv",
                   header = TRUE,
                   stringsAsFactors = FALSE
                   ) %>%
    filter(country == "Italy", adm_area_2 == "") %>%
    select(date, adm_area_1, adm_area_2, dead)


trento_mask <- epi_df$adm_area_1 == "Trento"
epi_df[trento_mask, ]$adm_area_1 <- "Trentino-Alto Adige"
epi_df <- rename(epi_df, NAME_1 = adm_area_1)

date_index_1 <- "2020-04-01"
plot_sf_1 <- left_join(italy_sf,
                       filter(epi_df, date == date_index_1), 
                       by = "NAME_1")

g_1 <- ggplot() +
    geom_sf(data = plot_sf_1,
            mapping = aes(fill = dead), 
            colour = map_country_line_colour, 
            size = map_inline_thickness) +
    geom_sf(data = italy_outline_sf,
            fill = NA,
            colour = map_country_line_colour, 
            size = map_outline_thickness) +
    scale_fill_gradientn(breaks = my_breaks,
                         colors = my_cols,
                         limits = range(my_breaks)) +
    theme_nothing() +
    theme(plot.background = map_plot_background)

date_index_2 <- "2020-06-01"
plot_sf_2 <- left_join(italy_sf, 
                       filter(epi_df, date == date_index_2), 
                       by = "NAME_1")

g_2 <- ggplot() +
    geom_sf(data = plot_sf_2,
            mapping = aes(fill = dead), 
            colour = map_country_line_colour, 
            size = map_inline_thickness) +
    geom_sf(data = italy_outline_sf,
            fill = NA,
            colour = map_country_line_colour, 
            size = map_outline_thickness) +
    scale_fill_gradientn(breaks = my_breaks,
                         colors = my_cols,
                         limits = range(my_breaks)) +
    theme_nothing() +
    theme(plot.background = map_plot_background)

italy_legend <- get_legend(g_1 +
                           labs(fill = "Cumulative\ndeaths") +
                           theme(legend.position = "left",
                                 legend.box.margin = margin(0, 0, 0, 0),
                                 legend.key.height = unit(2, units = "cm")))

g_maps_without_legend <- plot_grid(g_1 + theme(legend.position = "none", plot.margin = margin(0, 0, 0, 0, "cm")),
                                   g_2 + theme(legend.position = "none", plot.margin = margin(0, 0, 0, 0, "cm")),
                                   ncol = 1)

g_maps <- plot_grid(g_maps_without_legend,
                    italy_legend,
                    ncol = 2,
                    rel_widths = c(1,0.3))

plot_epi_df <- epi_df %>%
    group_by(date) %>%
    summarise(total_dead = sum(dead)) %>%
    mutate(date = as.Date(date, format = "%Y-%m-%d"))

plot_mobility_df <- read.csv("data/mobility.csv",
                             header = TRUE,
                             stringsAsFactors = FALSE) %>%
    filter(country == "Italy", 
           adm_area_1 == "", 
           source == "GOOGLE_MOBILITY") %>%
    select(date, workplace) %>%
    mutate(date = as.Date(date, format = "%Y-%m-%d"))
plot_mobility_df <- plot_mobility_df[order(plot_mobility_df$date),]

plot_gov_df <- read.csv("data/government_response.csv",
                        stringsAsFactors = FALSE,
                        header = TRUE) %>%
    filter(country == "Italy") %>%
    select(date, stringency_indexfordisplay) %>%
    mutate(date = as.Date(date, format = "%Y-%m-%d"))

plot_ts_df <- left_join(plot_epi_df, plot_gov_df, by = "date") %>%
    left_join(plot_mobility_df, by = "date") %>%
    melt(id.vars = "date")

facet_labels <- c(workplace = "Relative workplace mobility",
                  stringency_indexfordisplay = "Governmental response\nstringency index",
                  total_dead = "Cumulative deaths")

g_ts <- ggplot(plot_ts_df, aes(x = date, y = value)) + 
    geom_line() +
    scale_y_continuous(position = "right") +
    facet_grid(variable~., 
               scales = "free_y", 
               labeller = labeller(variable= facet_labels), 
               switch = "both") +
    labs(x = "Date", y = NULL) +
    theme_bw() +
    theme(
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        plot.margin = unit(c(0,0,0,2),"cm"),
        axis.title.x = element_text(size = 18),
        axis.text.x = element_text(size = 13),
        axis.text.y = element_text(size = 13),
        strip.text.y = element_text(size = 13)
    )

g_final <- plot_grid(g_ts,
                     g_maps,
                     ncol = 2,
                     rel_widths = c(0.8,1.0),
                     labels = "AUTO",
                     label_x = 0)

ggsave("demo-combination-plot.pdf",
       g_final,
       width = 2 * 14.8,
       height = 2 * 10.5,
       units = "cm")





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
