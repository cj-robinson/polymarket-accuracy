# Set up
# -----
library(tidyverse)
library(clipr)
library(waffle)
library(lubridate)
library(ggtext) 

outcomes <- read_csv("../data/outcomes.csv")

outcomes %>%  
  filter(prediction_price < .95,  
         volume > 100000) %>% 
  group_by(correct_prediction) %>% 
  tally()
# viz 1 -- DJ vs other
# -----

outcomes %>%  
  filter(prediction_price < .95,  
         volume > 100000) %>% 
  filter(!is.na(correct_prediction)) %>%  
  mutate(trump_flag = ifelse(grepl("trump",tolower(question)), "Political events\nmentioning Trump", "Other\npolitical events")) %>%  
  group_by(trump_flag, correct_prediction) %>%  
  tally() 

trump_outcomes <- outcomes %>%  
  filter(prediction_price < .95,  
         volume > 100000) %>% 
  filter(!is.na(correct_prediction)) %>%  
  mutate(trump_flag = ifelse(grepl("trump",tolower(question)), "Political events\nmentioning Trump", "Other\npolitical events")) %>%  
  group_by(trump_flag, correct_prediction) %>%  
  tally() %>% 
  mutate(correct_prediction = ifelse(correct_prediction == "TRUE", "Correct prediction", "Incorrect prediction")) %>% 
  mutate(correct_prediction = factor(correct_prediction, 
                                     levels = c( "Incorrect prediction","Correct prediction"))) %>% 
  arrange(desc(correct_prediction))

trump_outcomes %>% 
  ggplot(aes(values = n, 
             fill = correct_prediction)) +  # Reverse TRUE/FALSE here
  geom_waffle(make_proportional = TRUE,  
              show.legend = TRUE, 
              size=1, 
              flip=TRUE,
              color="white",
              n_rows = 10) +  
  scale_fill_manual(values = c( "Incorrect prediction" = "grey", "Correct prediction" = "#95CB99")) +  # Swap colors accordingly
  ylab("Percentage of Political Betting Events") +  
  labs(title="Predictions on Trump are less accurate",
       subtitle="Proportion of political Polymarket events where market correctly predicted outcome") +  
  facet_wrap(~factor(trump_flag, levels = c("Political events\nmentioning Trump", "Other\npolitical events")),
             ncol=2,  
             strip.position = "bottom") +  
  theme_void() +  
  theme(
    plot.title = element_text(size = 18, face = "bold", margin = margin(b = 10, l = 15)),  # Title size, bold, bottom margin
    plot.subtitle = element_text(size = 14, margin = margin(b = 10, l = 15)),  # Subtitle size, bottom margin
    strip.text  = element_text(size = 14, hjust = 1, margin = margin(b=-5)) , # Legend text size,
    legend.position = "top",
    legend.justification = "center",
    strip.text.x = element_text(size = 12, hjust = 0.5, margin=margin(b=5)),  # Centered on bottom
    legend.title = element_blank(),
    legend.text = element_text(),
    plot.margin = margin(t = 20, r = 20, b = 20, l = 20)  # Extra space around the plot
  ) +
  guides(fill = guide_legend(reverse = TRUE))  # This swaps the legend order

ggsave("../img/waffle_trump_accuracy.png", 
       bg = "white",
       height = 8, 
       width = 8)

ggsave("../../personal-website/polymarket-accuracy/assets/waffle_trump_accuracy.png", 
       bg = "white",
       height = 8, 
       width = 8)
  
ggsave("../../personal-website/assets/waffle_trump_accuracy.png", 
       bg = "white",
       height = 4.5, 
       width = 8)

# viz 2 -- percentage/time
# -----

month_df <- outcomes %>% 
  mutate(date = floor_date(createdAt, "month")) %>%
  filter(createdAt < "2025-02-01") %>%
  filter(!is.na(correct_prediction)) %>% 
  mutate(trump_flag = ifelse(grepl("trump",tolower(question)), "Trump mentioned", "Trump not mentioned")) %>% 
  group_by(trump_flag, date) %>%
  summarize(vol = sum(volume)) %>%
  group_by(date) %>% 
  mutate(vol_perc = vol / sum(vol),
         date = lubridate::as_date(date))


month_df %>% 
  ggplot(aes(x = date, y = vol_perc, fill = trump_flag)) + 
  geom_bar(stat = "identity", position=position_stack(reverse =TRUE)) +
  scale_x_continuous(breaks = month_df$date,   
                   labels = format(month_df$date, "%B %Y"),
                   trans = c("date", "reverse")) +
  scale_fill_manual(values = c("#E81B23", "gray"))+
  geom_text(aes(label = ifelse(vol_perc > 0.03, scales::percent(vol_perc, accuracy = 1), "")),  
            size = 3,
            position =position_stack(reverse =TRUE, vjust = 1),
            color = 'white',
            hjust = 1.2
  ) +
  labs(title="In January 2025, <span style='color:#E81B23;'>Trump</span> dominated political prediction events",
       subtitle="Percentage of political Polymarket events mentioning Trump by creation month") + 
  theme_void() + 
  theme(
    plot.title = element_markdown(size = 18, face = "bold", margin = margin(t = 15, b =5, l = -60)),  
    plot.subtitle = element_text(size = 14, margin = margin(b = 10, l = -60)),  
    strip.text.x  = element_text(size = 10),
    axis.text.y = element_text(size = 10, hjust =1, margin = margin(r=-10, l = 10)),
    legend.title = element_blank(),
    legend.position = "top",
    legend.justification = "center",
    plot.margin = margin(t = 20, r = 20, b = 20, l = 20)  # Extra space around the plot
    
  ) + 
  coord_flip() 



ggsave("../img/trump_event_prop.png", 
       bg = "white",
       height = 8, 
       width = 10)

ggsave("../../personal-website/polymarket-accuracy/assets/trump_event_prop.png", 
       bg = "white",
       height = 8, 
       width = 10)
