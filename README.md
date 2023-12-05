# Changes-in-Life-Expectancy-by-Country-1952-2007-
An RShiny application showcasing changes in life expectancy by birth per country within the timeframe 1952-2007 using data from the `gapminder` package in R.

You can access the RShiny dashboard here: 

## I. Description
This RShiny dashboard (pictured below) allows the user to look at life expectancy rates at birth among different countries and how much they've changed from one year to another.  The data on life expectancy rates is plotted as an adjustable dumbbell plot where both ends of each dumbbell plotted represent data points for life expectancy rates at different years for a given country; this dumbbell plot is based off the dumbbell plot presented in Chapter 8.2 of the book [Modern Data Visualization with R](https://rkabacoff.github.io/datavis/index.html) by Robert Kamacoff, which is available online for free and (possibly) Amazon for purchase as a physical book. 

Using the Filter toolbar to the left of the dashboard, the user can select the two years in which life expectancy data is obtained, the continents to get a list of countries from, and which countries to display data for on this dumbbell plot (with a maximum of 15 countries that can be plotted at once).

For example, in this dashboard (see picture below), it's been adjusted to showcase changes in life expectancy for the selected and plotted countries `Bahrain`, `Chad`, `China`, `Egypt`, and `Indonesia` from the year 1962 (indicated by red-colored points) to the year 1987 (indicated on the graph as blue-colored points).  The red and blue points respectively show values for life expectancy at birth for those countries in 1962 and 1987 respectively with a grey line connecting the two together.

![](https://raw.githubusercontent.com/Ken-Vu/Changes-in-Life-Expectancy-by-Country-1952-2007-/main/snapshot_dashboard.jpg?token=GHSAT0AAAAAACLHLJ7PQLZQUF6ULBPSKGBEZLPRGBQ)

## II. Instructions
### a. Using the Dashboard

### b. Running the Dashboard Locally

## III. Data Set Used

## IV. Tools Used

## References
### a. Books
- **[Modern Data Visualization with R](https://rkabacoff.github.io/datavis/index.html)** by Robert Kamacoff: <br/> [Chapter 8.2](https://rkabacoff.github.io/datavis/Time.html#dummbbell-charts) goes into more detail on dumbbell plots and how to graph them (which while helpfully, isn't compatible with `plotly`.  However, it does give you a sense of how to make your own and use them along with providing best practices for creating a variety of compelling data visualizations of your own, such as in Chapters 3-6, 10, 11, and 14.
- **[Interactive Web-Based Data Visualization with R, plotly, and shiny](https://plotly-r.com/)** by Carson Sievert: <br/> [Chapter 25](https://plotly-r.com/controlling-tooltips) (especially in section 25.2) covers some techniques on how to modify and customize tooltips (i.e. the textbox that appears when you hover your mouse over a data point, graphed line, or any kind of object made with plotted data).  Chapters 5, 33, and 34 cover some ways to use the function `ggplotly()` to make your `ggplot2` graphs interactive along with the rest of the book showcasing what the `plotly` package in R can do in terms of making interactive graphs and geospacial maps.
