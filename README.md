# SAStratif-Statistical-Sampling-Application

A modern R Shiny application for statistical sampling and survey analysis.

**Project Overview**
This application implements two fundamental sampling methods from survey theory:

**1. Simple Random Sampling (SRS) Without Replacement**
* Random selection of sampling units

* Comparative analysis between sample and population

* Proportion comparison across modalities

**2. Proportional Allocation Stratified Sampling**
* Stratification by geographic units (Region, Governorate, Delegation)

* Proportional allocation based on population sizes

* Auxiliary variable integration


**Sampling Framework**
* The application uses Tunisia's sampling framework based on:

-Geographic division into homogeneous blocks

-Source: National Institute of Statistics (INS) census data

-Block characteristics: Small, relatively homogeneous geographic units

- Average size: ~120 households per block

- Coverage: National territory

**Features**
**Exploratory Analysis**
* Interactive visualizations with Plotly

* Tunisian governorate mapping with Leaflet

* Descriptive statistics for all variables

* Dynamic data tables with filtering capabilities

**Simple Random Sampling (SRS)**
* Input:

-Sample size

-Comparative variable (Region, GOVERNORATE, Area, DELEGATION, Lodging)

* Output:

-Random sample

-Descriptive statistics

-Population-sample proportion comparison

-Comparative visualization

**Proportional Stratification**
* Input:

-Sample size

-Stratification variable (Region, GOVERNORATE, DELEGATION)

-Auxiliary variable (Area, optional)

* Output:

-Allocation table (nh values per stratum)

-Stratified sample

-Descriptive statistics by stratum

**Export Capabilities**
* Supported formats: Excel, CSV

* Export options: Samples, statistics, allocations, comparative plots

* Flexible download based on user selection

**Technical Implementation**
* Architecture
-Frontend: Shiny + Shinydashboard

-Visualization: Plotly, Leaflet, ggplot2

-Data Handling: dplyr, readxl, writexl

-UI Components: Custom CSS theme with blue gradient design

* Key Algorithms
-SRS: Base R sample() function without replacement

-Stratification: Proportional allocation with Hamilton method for rounding

-Modality grouping: Top 15 most frequent categories, others grouped as "Autres" .

 **How to Run the Application?**

* You can run the Shiny app locally using R:

* #Install dependencies
install.packages(c("shiny", "shinydashboard", "dplyr", "ggplot2"))

* #Launch the app
shiny::runApp("SAStratif")

**Installation & Usage**
* Prerequisites
R (version 4.0 or higher)

RStudio (recommended)

 **License**
This project is shared for academic purposes. Usage, modification, and redistribution require authorization.
See License .
