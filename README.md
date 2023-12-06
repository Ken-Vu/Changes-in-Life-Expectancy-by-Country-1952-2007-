# Changes-in-Life-Expectancy-by-Country-1952-2007-
An RShiny application showcasing changes in life expectancy by birth per country within the timeframe 1952-2007 using data from the `gapminder` package in R.

You can access the RShiny dashboard here: 

## I. Description
This RShiny dashboard (pictured below) allows the user to look at life expectancy rates at birth among different countries and how much they've changed from one year to another.  The data on life expectancy rates is plotted as an adjustable dumbbell plot where both ends of each dumbbell plotted represent data points for life expectancy rates at different years for a given country; this dumbbell plot is based off the dumbbell plot presented in Chapter 8.2 of the book [Modern Data Visualization with R](https://rkabacoff.github.io/datavis/index.html) by Robert Kamacoff, which is available online for free and (possibly) Amazon for purchase as a physical book. 

Using the Filter toolbar to the left of the dashboard, the user can select the two years in which life expectancy data is obtained, the continents to get a list of countries from, and which countries to display data for on this dumbbell plot (with a maximum of 15 countries that can be plotted at once).

For example, in this snapshot of the dashboard (see picture below), it's been adjusted to showcase changes in life expectancy for the selected and plotted countries `Bahrain`, `Chad`, `China`, `Egypt`, and `Indonesia` from the year 1962 (indicated by red-colored points) to the year 1987 (indicated on the graph as blue-colored points).  The red and blue points respectively show values for life expectancy at birth for those countries in 1962 and 1987 respectively with a grey line connecting the two together.

![](https://raw.githubusercontent.com/Ken-Vu/Changes-in-Life-Expectancy-by-Country-1952-2007-/main/snapshot_dashboard.jpg?token=GHSAT0AAAAAACLHLJ7PQLZQUF6ULBPSKGBEZLPRGBQ)

## II. Instructions
### a. Using the Dashboard
Primarily through the *Filter* toolbar to the left of the dumbbell plot, you can customize and start displaying data on the dashboard through modifying the following aspects of it:

------
#### 1. The Years Plotted
Through the slider labeled under **Year(s)**, you can control which two years in which you want to plot and compare life expectancy values for each country.  

To use this slider, left-click and hold on the circle at either end of the slider and move it to the desired year you want.  Then, release the left-click on your mouse to finalize your selection.  You can do the same for the other end of the slider if you want to adjust it as well.

Moving the slider will cause the dashboard to automatically update.

#### 2. The Continent(s) Chosen
Through the checkbox list labeled under **Continent(s)**, you can control which continent(s) you want to get data from, which will affect the list of countries you can select from for the input box labeled under **Countries**.

You can select as many continents as you like in the checkbox list there, ranging from `Asia` to `Europe`.  Note that deselecting continents will cause any countries you plotted that belong to them to disappear from the dashboard.  For example, if you selected `Asia` and `Europe`, plotted data from the countries `China` and `Germany`, and then deselected the country `Europe`, the country `Germany` will not show up on the dashboard since `Germany` is a country in `Europe`.  

In addition, to be able to plot countries outside the selected continents you chose, you have to select the continents those countries belong to in order for you to select them in the input box labeled under **Countries**.

#### 3. The Countries Plotted
Through the input box labeled under **Countries**, you can control which countries are plotted on the dashboard as long as the countries you want to plot are in the continents you selected in the checkbox list labeled under **Continent(s)** (as mentioned in the previous section).  Thus, to plot any countries, you should make sure you have at least one continent selected prior to plotting any countries.

To select countries to plot, click on the input box labeled under **Countries**, which will display a scrollable dropdown menu listing all the countries you can plot.  Click on as many countries as you want to plot in the dropdown menu with a maxmum of 15 countries you can plot and display all at once.  When you are done with your selections, you can click outside the input box and the dropdwon menu will close.  

In case you want to deslelect any country you chose to plot, you can click on the country you want to remove from the dashboard and press the backspace button on your keyboard to remove it.

#### 4. Additional dashbaord adjustments
Right above the dumbbell plot are a row of clickable grey icons that provide you additional ways to adjust and manipulate the way the dashbaord is displayed.  Such options including zooming in and out of the graph, downloading a snapshow of it, and autoscaling it to show the full dashboard. 

------
Now that you know how to use the *Filter* toolbar and the adjustment bar above the dumbbell plot, you should have the means to display life expectancy data on your dumbbell plot.  A quick note is that if you hover your mouse cursor over the points on each dumbbell, the data point you hover over will display a text box listing the name of the country, the value of life expectancy at that point, and the year that data point was recorded - all of which correspond to the data point you hover your mouse cursor over. 

### b. Running the Dashboard Locally
To run the dashboard locally after downloading the Rcode for it, you need to first have installed the following packages (or at the very least, have the latest versions of them): 
[`pacman`](https://www.rdocumentation.org/packages/pacman/), [`dplyr`](https://www.rdocumentation.org/packages/dplyr/), [`ggplot2`](https://www.rdocumentation.org/packages/ggplot2/), [`gapminder`](https://www.rdocumentation.org/packages/gapminder/), [`plotly`](https://www.rdocumentation.org/packages/plotly/), [`shiny`](https://www.rdocumentation.org/packages/shiny/).
<br /> <br /> <br />
You click on any of the names of the packages above to access the official R documentation for them in case you want to learn more about these packages and what features they have.

Anyway, to install them, run the following command below in your R console or script:
```{r}
install.packages(c("pacman", "dplyr", "ggplot2", "gapminder", "plotly", "shiny"))
```

After installing the packages listed above, you can run this Shiny app by entering the directory in which he files for it are stored and run the following command below:
```{r}
shiny::runApp()
```

## III. Data Set Used
The data set is from the [`gapminder`](https://www.rdocumentation.org/packages/gapminder/) package, which in turn uses data from the website of the educational non-profit organization Gapminder.  You can click [here](https://www.gapminder.org/data/) to access the data section of the website for further details on the data set itself.

## IV. Tools Used
The code was written in using RStudio 2023.09.0 Build 463 and the R programming language (version 4.3.1).

The following libraries were used to develop this Shiny application: 
- [`pacman`](https://www.rdocumentation.org/packages/pacman/) (ver. 0.5.1): a convenient package for loading and auto-updating packages all at once.
- [`dplyr`](https://www.rdocumentation.org/packages/dplyr/) (ver. 1.1.3): a package that is part of the `tidyverse` set of packages (along with `ggplot2`) that provides advanced methods for wrangling with your data 
- [`ggplot2`](https://www.rdocumentation.org/packages/ggplot2/) (ver. 3.4.3): the data visualization package designed by Hadley Wickham that will be used to construct the dumbbell plot
- [`gapminder`](https://www.rdocumentation.org/packages/gapminder/) (ver. 1.0.0) the package containing the *Gapminder* data set.
- [`plotly`](https://www.rdocumentation.org/packages/plotly/) (ver. 4.10.3): a package for creating unique and interactive plots.
- [`shiny`](https://www.rdocumentation.org/packages/shiny/) (ver. 1.7.5): the package for creating and deploying Shiny applications.

You can click on any of them to get the official R documentation on them in case you want to learn more about them and their features.

## References
### a. Books
- **[Modern Data Visualization with R](https://rkabacoff.github.io/datavis/index.html)** by Robert Kamacoff: <br/> [Chapter 8.2](https://rkabacoff.github.io/datavis/Time.html#dummbbell-charts) goes into more detail on dumbbell plots and how to graph them (which while helpfully, is not compatible with `plotly`.  However, it does give you a sense of how to make your own and use them along with providing best practices for creating a variety of compelling data visualizations of your own, such as in Chapters 3-6, 10, 11, and 14.
- **[Interactive Web-Based Data Visualization with R, plotly, and shiny](https://plotly-r.com/)** by Carson Sievert: <br/> [Chapter 25](https://plotly-r.com/controlling-tooltips) (especially in section 25.2) covers some techniques on how to modify and customize tooltips (i.e. the textbox that appears when you hover your mouse over a data point, graphed line, or any kind of object made with plotted data).  Chapters 5, 33, and 34 cover some ways to use the function `ggplotly()` to make your `ggplot2` graphs interactive along with the rest of the book showcasing what the `plotly` package in R can do in terms of making interactive graphs and geospacial maps.
