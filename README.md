# Polymarket Accuracy

Find the story here: [https://cj-robinson.github.io/polymarket-accuracy](https://cj-robinson.github.io/polymarket-accuracy/)

### Overview/Findings

This project compared political betting market events from Polymarket in 2024 and 2025 with a focus on events that mention Trump. I find that Trump-related events are 12 percentage points less accurate (68% accurate) than other political events on the platform (80%). 

### Goals

I originally set out to examine prediction markets more broadly after they were largely praised after the 2024 election. I was skeptical of the ability for these markets to make accurate predictions, mostly due to bias. 

This was an assignment for our Data Studio class at Columbia Journalism School's Data Journalism program, intended to think about how to create end-to-end data stories about topics of our choosing on deadline.


### Data Collection and Analysis

All code for the API pull can be found in **analysis/poly_api_pull.ipynb**

I utilized multiple endpoints from [Polymarket API](https://docs.polymarket.com/#clob-api). First, I pulled all possible tags to get the encoding for political events. Then, I pulled all political events from 2024 onward that had a binary outcome (yes/no, desantis/haley) and were closed at the time of the pull. From there, I created a dictionary and started adding additional infromation like actual outcome, the price and volume. 

Two important methodological choices I made

1) Many markets close out with one choice having >99% odds since there's some lag from when the outcome happens and when the market closes. To account for this, I chose to pull the price **two days before market close** as I found that had greater variation without sacraficing recency. 

2) In the analysis itself, I limited markets to those **greater than $100,000 in volume** and **less than 95% probability of the correct outcome occuring**. This was to make sure the markets had sufficient activity to warrant a comparison and to ensure any markets that had all-but-certain events that closed late were filtered out. Find more at **analysis/polymarket_viz.R**

I then did exploratory data analysis using a combination Python/R notebook and transferring final designs/tweaking visualizations in R and Adobe Illustrator.

### Learnings

This project's data pull was a lot more time consuming than expected -- the Polymarket API is not super well documented and often had multiple endpoints with overlapping information. There were also a couple of retries for pulls when I realized I needed information from an endpoint after already running the loop, so would probably benefit me to run API calls with a smaller sample and do some basic analysis before launching into 5K cases that take a second each. 

I had fun making the dollar waffle chart -- I think this was a case where I could have used a stacked bar, but did so in the other part of the story and wanted to try and make the visualization a bit more engaging without losing understanding/context. 

I'll be making these charts reactive to smaller screen sizes very soon (ai2html here we come!), but I want to learn how to make more consistent-looking ggplot visualizations. Maybe that means making my own theme or outputting ggsave in all the same resolutions, but I'm not sure as of now. 
