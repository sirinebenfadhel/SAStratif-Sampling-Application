library(shiny)
library(shinydashboard)
library(DT)
library(ggplot2)
library(dplyr)
library(tidyr)
library(forcats)
library(plotly)
library(bslib)
library(shinyjs)
library(readxl)
library(shinythemes)
library(shinyWidgets)
library(fresh)
library(leaflet)
library(writexl)
library(purrr)
# Création d'un thème personnalisé avec palette de bleus
my_theme <- create_theme(
  adminlte_color(
    light_blue = "#5dade2",   # Bleu clair rafraîchissant
    blue       = "#2874a6",   # Bleu profond
    aqua       = "#48c9b0",   # Turquoise doux
    navy       = "#1b2631"    # Bleu nuit
  ),
  adminlte_sidebar(
    width          = "300px",
    dark_bg        = "#1c2833",     # Fond sombre chic
    dark_hover_bg  = "#34495e",     # Hover plus clair pour contraste
    dark_color     = "#ecf0f1"      # Texte clair
  ),
  adminlte_global(
    content_bg     = "#f8f9f9",     # Fond général clair
    box_bg         = "#ffffff",    
    info_box_bg    = "#f0f3f4"      # InfoBox avec léger contraste
  )
)



# UI - Interface Utilisateur avec Sidebar
ui <- dashboardPage(
  skin = "blue",
  
  dashboardHeader(
    title = tags$div(
      style = "width: 100%; display: flex; justify-content: center; align-items: center;",
      tags$span(
        icon("layer-group", style = "color: #5D9CEC; margin-right: 12px; font-size: 24px;"),
        tags$span("SAStratif", style = "font-size: 28px; font-weight: bold;")
      )
    ),
    titleWidth = "100%"
  )
  ,
  
  dashboardSidebar(
    sidebarMenu(
      id = "sidebar",
      
      menuItem("Page d'accueil", tabName = "home", icon = icon("home")),
      tags$br(),
      
      menuItem("Importer les données", tabName = "import", icon = icon("upload")),
      tags$br(),
      
      menuItem("Analyse exploratoire", tabName = "explor", icon = icon("chart-bar")),
      tags$br(),
      
      menuItem("Tirage", icon = icon("random"),
               menuSubItem("Tirage aléatoire simple (SAS)", tabName = "sas", icon = icon("dice-one")),
               menuSubItem("Stratification proportionnelle", tabName = "strat", icon = icon("layer-group"))
      )
    )
  )
  ,
  
  # Corps principal
  dashboardBody(
    # Appliquer le thème personnalisé
    use_theme(my_theme),
    
    # Utilisation de shinyjs pour des fonctionnalités dynamiques
    useShinyjs(),
    
    tags$head(
      tags$style(HTML("
       /* HEADER avec dégradé bleu intense */
.skin-blue .main-header .logo,
.skin-blue .main-header .navbar {
  background: linear-gradient(90deg, #003366, #1a237e, #0052D4) !important; /* Dégradé bleu intense */
  color: white !important; /* Texte en blanc */
}

.skin-blue .main-header .logo:hover {
  background: linear-gradient(90deg, #003c9e, #3251e0) !important; /* Dégradé plus profond au survol */
}

/* SIDEBAR avec dégradé bleu intense */
.skin-blue .main-sidebar {
  background: linear-gradient(to bottom, #003366, #1a237e, #0052D4) !important; /* Dégradé bleu nuit */
}

/* Liens et texte dans le Sidebar */
.skin-blue .sidebar a {
  color: white !important; /* Texte blanc dans le sidebar */
  font-weight: bold; /* Texte en gras */
}

/* État actif dans le menu du Sidebar */
.skin-blue .sidebar-menu > li.active > a {
  background-color: rgba(255, 255, 255, 0.15) !important; /* Fond clair au survol */
  border-left: 4px solid white; /* Bordure blanche sur l'élément actif */
}

/* Survol des éléments du menu dans le Sidebar */
.skin-blue .sidebar-menu > li:hover > a {
  background-color: rgba(255, 255, 255, 0.10) !important; /* Survol avec un fond clair */
}

/* Transitions douces pour tous les éléments */
.main-header, .main-sidebar, .sidebar-menu a {
  transition: all 0.3s ease-in-out; /* Transition douce pour les changements */
}

/* Ajustement du texte dans le Header avec dégradé */
.main-header .navbar-brand {
  font-weight: bold;
  background: linear-gradient(to right, #003366, #1a237e); /* Dégradé bleu nuit pour la marque */
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent; /* Texte en dégradé */
}

/* Amélioration du survol dans le Sidebar */
.main-sidebar .sidebar a:hover {
  background-color: rgba(255, 255, 255, 0.1) !important; /* Fond légèrement transparent */
  color: #ffffff; /* Maintenir le texte blanc */
}

/* Footer avec un fond uniforme bleu nuit */
.sidebar-footer {
  background-color: #003366; /* Bleu nuit uniforme pour le footer */
}

/* Styles supplémentaires pour les bordures et éléments interactifs */
.box, .btn, .nav-tabs-custom {
  transition: all 0.3s ease;
}

/* Optimisation pour la responsivité */
@media (max-width: 768px) {
  .box { margin-bottom: 10px; }
}

      "))
    )
    ,
    
    # Contenu des onglets
    tabItems(
      # Page d'accueil
      tabItem(
        tabName = "home",
        tags$style(HTML("
   /* Home box background with glassmorphism */
.home-box {
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border-radius: 24px;
  border: 1px solid rgba(255, 255, 255, 0.18);
  box-shadow: 0 8px 32px rgba(15, 23, 42, 0.2);
  margin: 24px auto;
  max-width: 1200px;
  padding: 40px;
  transition: all 0.3s ease;
}

/* Home header with better typography */
.home-header {
  display: flex;
  align-items: center;
  gap: 24px;
  margin-bottom: 40px;
}

.home-header .icon {
  background: linear-gradient(135deg, #4361ee, #3a0ca3);
  color: white;
  padding: 20px;
  border-radius: 16px;
  font-size: 32px;
  box-shadow: 0 4px 20px rgba(67, 97, 238, 0.3);
}

.home-header-text h2 {
  font-size: 2.5rem;  /* Increased size for better readability */
  font-weight: 800;
  background: linear-gradient(135deg, #4361ee, #3a0ca3);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  margin: 0 0 8px 0;
  letter-spacing: -0.5px;
}

.home-header-text p {
  font-size: 1.2rem;  /* Slightly larger font */
  color: #64748b;
  margin: 0;
  font-weight: 400;
}

/* Feature cards */
.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 24px;
  margin-bottom: 40px;
}

/* Feature card with better padding and spacing */
.feature-card {
  background: white;
  padding: 30px; /* Increased padding for more room */
  border-radius: 16px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);  /* Slightly lighter shadow for better contrast */
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  border: none;
  position: relative;
  overflow: hidden;
}

.feature-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: linear-gradient(to bottom, #4361ee, #3a0ca3);
}

.feature-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(67, 97, 238, 0.1);
}

.feature-card h4 {
  margin: 0 0 12px;
  color: #1e293b;
  font-weight: 600;
  font-size: 1.2rem;  /* Slightly larger for better visibility */
}

.feature-card p {
  font-size: 1rem;  /* Slightly larger text for readability */
  color: #64748b;
  margin: 0;
  line-height: 1.6;
}

/* Button with better visibility */
.start-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto;
  padding: 16px 40px;
  font-size: 1.2rem;  /* Larger font for visibility */
  font-weight: 500;
  border-radius: 12px;
  background: linear-gradient(135deg, #4361ee, #3a0ca3);
  color: white;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(67, 97, 238, 0.3);
  text-decoration: none;
  gap: 8px;
}

.start-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(67, 97, 238, 0.4);
  color: white;
}

.start-btn:active {
  transform: translateY(0);
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .home-box {
    padding: 28px 20px;
    margin: 16px;
    border-radius: 20px;
  }

  .home-header {
    flex-direction: column;
    text-align: center;
    gap: 16px;
  }

  .home-header .icon {
    padding: 16px;
    font-size: 28px;
  }

  .features-grid {
    grid-template-columns: 1fr;
  }
}

 
  ")),
        
        div(
          class = "home-box",
          
          # Header
          div(
            class = "home-header",
            div(icon("layer-group", class = "icon")),
            div(
              class = "home-header-text",
              h2("SAStratif"),
              p("Analysez, échantillonnez, décidez avec une interface moderne")
            )
          ),
          
          # Feature cards
          div(
            class = "features-grid",
            
            div(
              class = "feature-card",
              h4(icon("chart-line"), "Analyse exploratoire"),
              p("Explorez vos données avec des visualisations interactives et des statistiques détaillées pour chaque variable.")
            ),
            
            div(
              class = "feature-card",
              h4(icon("random"), "Tirage SAS"),
              p("Effectuez des tirages aléatoires simples sans remise avec des paramètres entièrement configurables.")
            ),
            
            div(
              class = "feature-card",
              h4(icon("project-diagram"), "Stratification proportionnelle"),
              p("Générez des échantillons stratifiés en conservant parfaitement les proportions de votre population.")
            )
          ),
          
          # Start Button
          div(
            class = "text-center",
            actionButton("go_to_import", "Commencer l'analyse",
                         icon = icon("arrow-right"),
                         class = "start-btn")
          )
        )
      )
      
      ,
      
      # Importation des données
      tabItem(
        tabName = "import",
        fluidRow(
          box(
            title = "Importer les données",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            fluidRow(
              column(
                width = 4,
                box(
                  title = "Télécharger un fichier",
                  status = "info",
                  solidHeader = FALSE,
                  width = NULL,
                  fileInput("file", "Sélectionner un fichier",
                            accept = c(".csv", ".xlsx")),
                  hr(),
                  uiOutput("data_info")
                )
              ),
              column(
                width = 8,
                box(
                  title = "Aperçu des données",
                  status = "info",
                  solidHeader = FALSE,
                  width = NULL,
                  DTOutput("data_preview"),
                  footer = tags$div(
                    actionButton("go_to_explor", "Passer à l'analyse exploratoire",
                                 icon = icon("chart-bar"), class = "btn-primary"),
                    style = "text-align: right;"
                  )
                )
              )
            )
          )
        )
      ),
      
      tabItem(
        tabName = "explor",
        fluidRow(
          box(
            title = "Analyse exploratoire",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            fluidRow(
              column(
                width = 3,
                box(
                  title = "Paramètres",
                  status = "info",
                  solidHeader = FALSE,
                  width = NULL,
                  uiOutput("var_select_uni"),
                  actionButton("show_desc", "variables",
                               icon = icon("tag"), class = "btn-info", width = "100%"),
                  actionButton("show_stats", "Statistiques descriptives",
                               icon = icon("calculator"), class = "btn-info", width = "100%",
                               style = "margin-top: 10px;")
                )
              ),
              column(
                width = 9,
                tabBox(
                  title = "Résultats",
                  width = NULL,
                  id = "univar_tabs",  
                  tabPanel(
                    "Description",
                    uiOutput("description"),  # Pour du HTML
                    verbatimTextOutput("stats")  # Pour du texte brut
                  ),
                  tabPanel(
                    "Visualisation",
                    conditionalPanel(
                      condition = "input.var_select_uni_input != 'GOVERNORATE'",
                      plotlyOutput("uni_plot", height = "500px")
                    ),
                    conditionalPanel(
                      condition = "input.var_select_uni_input == 'GOVERNORATE'",
                      leafletOutput("gov_map", height = "500px")
                    ),
                    textOutput("plot_description")
                  ),
                  tabPanel(
                    "Tableau",
                    DTOutput("uni_table")
                  )
                )
              )
            ),
            footer = tags$div(
              actionButton("go_to_sas", "Passer au tirage aléatoire",
                           icon = icon("project-diagram"), class = "btn-primary"),
              style = "text-align: right;"
            )
          )
        )
      ),
      
      # Tirage aléatoire simple
      tabItem(
        tabName = "sas",
        fluidRow(
          box(
            title = "Tirage aléatoire simple sans remise (SAS)",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            fluidRow(
              column(
                width = 3,
                box(
                  title = "Paramètres",
                  status = "info",
                  solidHeader = FALSE,
                  width = NULL,
                  numericInput("n_sas", "Taille de l'échantillon:", min = 1, value = 10),
                  selectInput("var_comp", "Variable comparative:", choices = c("Region", "GOVERNORATE", "Area", "DELEGATION", "Lodging"),
                              selected = "Region"),
                  actionButton("run_sas", "Lancer le tirage",
                               icon = icon("play"), class = "btn-info", width = "100%"),
                  hr(),
                  radioButtons("download_type_sas", "Données à télécharger:",
                               choices = c("Échantillon" = "sample",
                                           "Statistiques descriptives" = "stats",
                                           "Comparaison des proportions" = "comparaison",
                                           "Graphique comparatif (PNG)" = "plot"),
                               selected = "sample"),
                  downloadButton("download_sas", "Télécharger", class = "btn-primary", width = "100%")
                )
              ),
              column(
                width = 9,
                tabBox(
                  title = "Résultats",
                  width = NULL,
                  tabPanel(
                    "Échantillon",
                    DTOutput("sas_sample")
                  ),
                  tabPanel(
                    "Comparaison",
                    fluidRow(
                      column(
                        width = 12,
                        box(
                          title = "Comparaison des proportions",
                          width = NULL,
                          DTOutput("prop_table"),
                          uiOutput("note_modalites"),
                          plotlyOutput("prop_plot", height = "400px")  
                        )
                      )
                    )
                  ),
                  tabPanel(
                    "Statistiques",
                    verbatimTextOutput("sas_stats")
                  )
                )
              )
            ),
            footer = tags$div(
              actionButton("go_to_strat", "Passer à la stratification",
                           icon = icon("layer-group"), class = "btn-primary"),
              style = "text-align: right;"
            )
          )
        )
      )
      ,
      
      # Stratification proportionnelle
      # Stratification proportionnelle
      tabItem(
        tabName = "strat",
        fluidRow(
          box(
            title = "Stratification à allocation proportionnelle",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            fluidRow(
              column(
                width = 3,
                box(
                  title = "Paramètres",
                  status = "info",
                  solidHeader = FALSE,
                  width = NULL,
                  numericInput("n_strat", "Taille de l'échantillon :", min = 1, value = 10),
                  selectInput("strat_var", "Variable de stratification :",
                              choices = c("Region", "GOVERNORATE", "DELEGATION"),
                              selected = "Region"),
                  selectInput("aux_var", "Variable auxiliaire (optionnelle) :",
                              choices = c("Aucune", "Area"),
                              selected = "Aucune"),
                  actionButton("run_strat", "Lancer le tirage",
                               icon = icon("play"), class = "btn-info", width = "100%"),
                  hr(),
                  radioButtons(
                    inputId = "download_type_strat",
                    label = "Données à télécharger:",
                    choices = c("Échantillon" = "sample",
                                "Allocations" = "alloc",
                                "Statistiques" = "stats"),
                    selected = "sample"
                  ),
                  downloadButton("download_strat", "Télécharger", class = "btn-primary", width = "100%")
                )
              ),
              column(
                width = 9,
                tabBox(
                  title = "Résultats",
                  width = NULL,
                  tabPanel("Allocation", DTOutput("strat_alloc")),
                  tabPanel("Échantillon", DTOutput("strat_sample")),
                  tabPanel("Statistiques", DTOutput("strat_stats"))
                )
              )
            )
          )
        )
      )
      
    )
  )
)

server <- function(input, output, session) {
  
  # Stockage réactif des données
  data_loaded <- reactiveVal(NULL)
  
  # Navigation entre les onglets
  observeEvent(input$go_to_import, {
    updateTabItems(session, "sidebar", "import")
  })
  
  observeEvent(input$go_to_explor, {
    updateTabItems(session, "sidebar", "explor")
  })
  
  
  observeEvent(input$go_to_sas, {
    updateTabItems(session, "sidebar", "sas")
  })
  
  observeEvent(input$go_to_strat, {
    updateTabItems(session, "sidebar", "strat")
  })
  
  # Données réactives
  data <- reactive({
    req(data_loaded())
    data_loaded()
  })
  data <- reactiveVal()
  
  observeEvent(input$file, {
    req(input$file)
    ext <- tools::file_ext(input$file$datapath)
    data <- switch(ext,
                   xlsx = readxl::read_excel(input$file$datapath),
                   xls = readxl::read_excel(input$file$datapath),
                   csv = readr::read_csv(input$file$datapath),
                   txt = readr::read_delim(input$file$datapath, delim = "\t"),
                   validate("Type de fichier non supporté"))
    
    data(data)
  })
  # Aperçu des données
  output$data_preview <- renderDT({
    req(data())
    datatable(
      data(),
      options = list(
        pageLength = 10,
        scrollX = TRUE,
        autoWidth = TRUE,
        dom = 'Bfrtip',
        buttons = c('copy', 'csv', 'excel'),
        lengthMenu = list(c(10, 25, 50, -1), c('10', '25', '50', 'Tous'))
      ),
      class = "display compact",
      rownames = FALSE,
      filter = 'top'
    )
  })
  
  # Informations sur les données
  output$data_info <- renderUI({
    req(data())
    
    # Variables catégorielles et numériques
    cat_vars <- names(data())[sapply(data(), function(x) is.character(x) | is.factor(x))]
    num_vars <- names(data())[sapply(data(), function(x) is.numeric(x))]
    
    tagList(
      tags$div(
        class = "alert alert-success",
        icon("check-circle"),
        tags$strong("Données chargées avec succès!")
      ),
      tags$p(
        tags$strong("Dimensions:"),
        paste(nrow(data()), "lignes ×", ncol(data()), "colonnes")
      ),
      tags$div(
        class = "data-summary",
        tags$p(tags$strong("Variables catégorielles:"), length(cat_vars)),
        tags$p(tags$strong("Variables numériques:"), length(num_vars)),
        style = "margin-bottom: 10px;"
      ),
      tags$div(
        class = "alert alert-info",
        icon("info-circle"),
        "Utilisez l'aperçu ci-contre pour explorer vos données."
      )
    )
  })
  
  # Variables catégorielles et numériques (sans les variables CODE)
  cat_vars <- reactive({
    req(data())
    names(data())[sapply(data(), function(x) is.character(x) | is.factor(x))]
  })
  
  num_vars <- reactive({
    req(data())
    names(data())[sapply(data(), function(x) is.numeric(x))]
  })
  
  # Variables pour visualisation (sans les variables CODE)
  viz_vars <- reactive({
    req(data())
    names(data())[!grepl("CODE", names(data()), ignore.case = TRUE)]
  })
  
  # Mise à jour des sélecteurs de variables
  observe({
    req(data())
    
    # Variables pour l'analyse univariée (sans CODE)
    updateSelectInput(session, "var_select_uni_input",
                      choices = viz_vars())
    
    # Variables pour l'analyse bivariée (sans CODE)
    updateSelectInput(session, "var_select_bi_x_input",
                      choices = viz_vars())
    updateSelectInput(session, "var_select_bi_y_input",
                      choices = viz_vars())
    
    # Variables pour le tirage SAS
    updateSelectInput(session, "var_comp", choices = cat_vars())
    
    # Variables pour la stratification
    strat_vars <- cat_vars()[cat_vars() %in% c("Region", "Gouvernorat", "Delegation")]
    if(length(strat_vars) == 0) strat_vars <- cat_vars()
    
    updateSelectInput(session, "strat_var", choices = strat_vars)
    
    # Variables auxiliaires pour la stratification
    aux_vars <- c()
    if("Milieu" %in% names(data())) aux_vars <- c(aux_vars, "Milieu")
    if("Area" %in% names(data())) aux_vars <- c(aux_vars, "Area")
    if("Population" %in% names(data())) aux_vars <- c(aux_vars, "Population")
    if("Menages" %in% names(data())) aux_vars <- c(aux_vars, "Menages")
    
    if(length(aux_vars) == 0) aux_vars <- names(data())
    
    updateSelectInput(session, "aux_var", choices = aux_vars)
  })
  
  # UI pour la sélection de variable univariée
  output$var_select_uni <- renderUI({
    req(data())
    selectInput("var_select_uni_input", "Sélectionner une variable:",
                choices = viz_vars())
  })
  
  
  output$var_select_bi_y <- renderUI({
    req(data())
    selectInput("var_select_bi_y_input", "Variable Y (axe vertical):",
                choices = viz_vars())
  })
  # Description des données
  output$description <- renderUI({
    req(data(), input$show_desc)
    
    # Créer un data.frame avec le nom de la variable, son type et le nombre de valeurs uniques
    var_info <- data.frame(
      Variable = names(data()),
      Type = sapply(data(), function(x) class(x)[1]),
      Valeurs_uniques = sapply(data(), function(x) length(unique(x))),
      stringsAsFactors = FALSE
    )
    
    # Affichage sous forme de tableau
    tagList(
      tags$h4("Description des variables"),
      tags$table(
        class = "table table-striped",
        tags$thead(
          tags$tr(
            tags$th("Variable"),
            tags$th("Type"),
            tags$th("Valeurs uniques")
          )
        ),
        tags$tbody(
          lapply(1:nrow(var_info), function(i) {
            tags$tr(
              tags$td(var_info$Variable[i]),
              tags$td(var_info$Type[i]),
              tags$td(var_info$Valeurs_uniques[i])
            )
          })
        )
      )
    )
  })
  
  
  # Statistiques descriptives
  output$stats <- renderPrint({
    req(data(), input$show_stats)  # Vérifier que les données et l'input sont disponibles
    
    # Exclure les variables dont le nom commence par "CODE"
    data_filtered <- data() %>%
      select(-starts_with("CODE"))  # Sélectionner uniquement les variables sans "CODE"
    
    # Calcul des statistiques descriptives classiques sur les variables restantes
    stats_summary <- summary(data_filtered)
    
    # Afficher les statistiques descriptives classiques
    print(stats_summary)
  })
  
  # Tableau univarié
  output$uni_table <- renderDT({
    req(data(), input$var_select_uni_input)
    var_name <- input$var_select_uni_input
    
    # S'assurer que la variable existe
    if(!var_name %in% names(data())) {
      return(NULL)
    }
    
    var <- data()[[var_name]]
    
    if (is.numeric(var)) {
      # Pour les variables numériques
      stats_df <- data.frame(
        Statistique = c("Minimum", "1er Quartile", "Médiane", "Moyenne", "3ème Quartile",
                        "Maximum", "Écart-type", "Variance", "Coefficient de variation"),
        Valeur = c(
          min(var, na.rm = TRUE),
          quantile(var, 0.25, na.rm = TRUE),
          median(var, na.rm = TRUE),
          mean(var, na.rm = TRUE),
          quantile(var, 0.75, na.rm = TRUE),
          max(var, na.rm = TRUE),
          sd(var, na.rm = TRUE),
          var(var, na.rm = TRUE),
          sd(var, na.rm = TRUE) / mean(var, na.rm = TRUE) * 100
        )
      )
      
      datatable(
        stats_df,
        options = list(dom = 't', pageLength = 20),
        rownames = FALSE
      ) %>%
        formatRound('Valeur', 2)
      
    } else {
      # Pour les variables catégorielles
      freq_table <- as.data.frame(table(var, useNA = "ifany"))
      names(freq_table) <- c("Modalité", "Fréquence")
      freq_table$Pourcentage <- freq_table$Fréquence / sum(freq_table$Fréquence) * 100
      
      datatable(
        freq_table,
        options = list(dom = 't', pageLength = 20),
        rownames = FALSE
      ) %>%
        formatRound('Pourcentage', 2)
    }
  })
  output$uni_plot <- renderPlotly({
    req(data(), input$var_select_uni_input)
    var_name <- input$var_select_uni_input
    
    if (!var_name %in% names(data())) {
      return(NULL)
    }
    
    var <- data()[[var_name]]
    
    if (all(is.na(var))) {
      return(NULL)
    }
    
    # Cas particulier pour GOVERNORATE
    if (var_name == "GOVERNORATE") {
      return(NULL)
    }
    
    if (is.numeric(var)) {
      # Histogramme pour variables numériques
      p <- ggplot(data(), aes(x = !!sym(var_name))) +
        geom_histogram(fill = "#3c8dbc", bins = 30, color = "white") +
        labs(title = paste("Distribution de", var_name),
             x = var_name,
             y = "Fréquence") +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
      
    } else {
      # Diagramme en barres pour variables catégorielles
      freq_table <- as.data.frame(table(var, useNA = "ifany"))
      names(freq_table) <- c("Modalité", "Fréquence")
      freq_table$Pourcentage <- freq_table$Fréquence / sum(freq_table$Fréquence) * 100
      
      # Limiter à 7 modalités les plus fréquentes si trop de catégories
      if (nrow(freq_table) > 7) {
        freq_table <- freq_table %>%
          arrange(desc(Fréquence)) %>%
          slice_head(n = 7)
      }
      
      p <- ggplot(freq_table, aes(x = reorder(Modalité, -Fréquence), y = Fréquence)) +
        geom_bar(stat = "identity", fill = "#3c8dbc") +
        geom_text(aes(label = paste0(round(Pourcentage, 1), "%")),
                  vjust = -0.5, size = 3) +
        labs(title = paste("Distribution de", var_name),
             x = var_name,
             y = "Fréquence") +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
      
    }
    
    # Personnalisation supplémentaire du plotly
    ggplotly(p) %>%
      config(displayModeBar = TRUE) %>%
      layout(
        hoverlabel = list(bgcolor = "white"),
        xaxis = list(fixedrange = TRUE),
        yaxis = list(fixedrange = TRUE)
      )
  })
  
  # Ajoutez ce code séparément dans votre serveur pour la carte
  output$gov_map <- renderLeaflet({
    req(data(), input$var_select_uni_input == "GOVERNORATE")
    
    gov_table <- table(data()[["GOVERNORATE"]])
    
    if (length(gov_table) == 24) {
      gov_coords <- data.frame(
        Governorate = names(gov_table),
        Count = as.integer(gov_table),
        Lat = c(36.82, 35.83, 33.89, 37.2, 34.75, 36.6, 35.75, 36.15, 34.99, 35.77, 36.92, 35.5, 36.4, 33.94, 34.84, 35.67, 36.72, 34.8, 36.1, 35.2, 36.5, 35.95, 36.3, 37.1),
        Long = c(10.17, 10.09, 9.5, 9.6, 9.3, 10.1, 9.7, 9.5, 10.2, 9.6, 10.3, 9.8, 10.05, 9.85, 9.4, 9.15, 9.75, 9.6, 9.4, 9.65, 9.3, 9.5, 9.75, 9.55)
      )
      
      leaflet(gov_coords) %>%
        addTiles() %>%
        addCircleMarkers(
          lng = ~Long, lat = ~Lat,
          radius = ~sqrt(Count) * 3,
          color = "#3c8dbc",
          fillColor = "#3c8dbc",
          stroke = TRUE,
          weight = 1,
          fillOpacity = 0.7,
          popup = ~paste("<b>", Governorate, "</b>: ", Count, " occurrences")
        ) %>%
        setView(lng = 9.5, lat = 35.0, zoom = 6)
    } else {
      leaflet() %>%
        addTiles() %>%
        setView(lng = 9.5, lat = 35.0, zoom = 6) %>%
        addPopups(lng = 9.5, lat = 35.0,
                  popup = "Erreur: Données de gouvernorat incomplètes")
    }
  })
  output$gov_map <- renderLeaflet({
    req(data(), input$var_select_uni_input == "GOVERNORATE")
    
    # Code pour générer la carte des gouvernorats
    gov_table <- table(data()[["GOVERNORATE"]])
    
    if (length(gov_table) == 24) {
      gov_coords <- data.frame(
        Governorate = names(gov_table),
        Count = as.integer(gov_table),
        Lat = c(36.82, 35.83, 33.89, 37.2, 34.75, 36.6, 35.75, 36.15, 34.99, 35.77, 36.92, 35.5, 36.4, 33.94, 34.84, 35.67, 36.72, 34.8, 36.1, 35.2, 36.5, 35.95, 36.3, 37.1),
        Long = c(10.17, 10.09, 9.5, 9.6, 9.3, 10.1, 9.7, 9.5, 10.2, 9.6, 10.3, 9.8, 10.05, 9.85, 9.4, 9.15, 9.75, 9.6, 9.4, 9.65, 9.3, 9.5, 9.75, 9.55)
      )
      
      leaflet(gov_coords) %>%
        addTiles() %>%
        addCircleMarkers(
          lng = ~Long, lat = ~Lat,
          radius = ~sqrt(Count) * 3,
          color = "#3c8dbc",
          fillColor = "#3c8dbc",
          stroke = TRUE,
          weight = 1,
          fillOpacity = 0.7,
          popup = ~paste("<b>", Governorate, "</b>: ", Count, " occurrences")
        ) %>%
        setView(lng = 9.5, lat = 35.0, zoom = 6)
    } else {
      leaflet() %>%
        addTiles() %>%
        setView(lng = 9.5, lat = 35.0, zoom = 6) %>%
        addPopups(lng = 9.5, lat = 35.0,
                  popup = "Erreur: Données de gouvernorat incomplètes")
    }
  })
  sas_result <- eventReactive(input$run_sas, {
    req(data(), input$n_sas, input$var_comp)
    
    # Notification de chargement
    id <- showNotification("Exécution du tirage aléatoire simple...", duration = NULL)
    on.exit(removeNotification(id), add = TRUE)
    
    withProgress(message = 'Tirage aléatoire simple en cours...', value = 0, {
      incProgress(0.3, detail = "Préparation des modalités")
      
      var_comp <- input$var_comp
      
      # Identifier les 15 modalités les plus fréquentes
      modalite_freq <- data() %>%
        count(!!sym(var_comp), sort = TRUE) %>%
        slice_head(n = 15) %>%
        pull(!!sym(var_comp))
      
      # Regrouper les autres modalités en "Autres"
      data_filtered <- data() %>%
        mutate(!!var_comp := if_else(
          !!sym(var_comp) %in% modalite_freq,
          !!sym(var_comp),
          "Autres"
        ))
      
      note <- "Les 15 modalités les plus fréquentes ont été conservées. Les autres ont été regroupées sous 'Autres'."
      
      # 1. Échantillonnage aléatoire simple
      incProgress(0.3, detail = "Sélection de l'échantillon")
      n <- min(input$n_sas, nrow(data_filtered))
      samp <- data_filtered %>% sample_n(size = n)
      
      # 2. Statistiques descriptives
      incProgress(0.2, detail = "Calcul des statistiques")
      stats <- samp %>%
        select(where(is.numeric)) %>%
        pivot_longer(everything()) %>%
        group_by(name) %>%
        summarise(
          Moyenne = mean(value, na.rm = TRUE),
          Médiane = median(value, na.rm = TRUE),
          `Écart-type` = sd(value, na.rm = TRUE),
          Minimum = min(value, na.rm = TRUE),
          Maximum = max(value, na.rm = TRUE),
          .groups = "drop"
        )
      
      # 3. Comparaison des proportions
      incProgress(0.2, detail = "Comparaison des proportions")
      
      # Population
      pop_prop <- data_filtered %>%
        count(!!sym(var_comp)) %>%
        mutate(Source = "Population", Proportion = n / sum(n)) %>%
        rename(Modalité = !!sym(var_comp)) %>%
        select(Modalité, Source, Proportion)
      
      # Échantillon
      samp_prop <- samp %>%
        count(!!sym(var_comp)) %>%
        mutate(Source = "Échantillon", Proportion = n / sum(n)) %>%
        rename(Modalité = !!sym(var_comp)) %>%
        select(Modalité, Source, Proportion)
      
      # Jointure
      comp_table <- bind_rows(pop_prop, samp_prop) %>%
        pivot_wider(names_from = Source, values_from = Proportion, values_fill = 0) %>%
        mutate(
          Différence = `Échantillon` - Population,
          `Différence (%)` = scales::percent(Différence, accuracy = 0.1)
        )
    })
    
    list(
      sample = samp,
      stats = stats,
      comp_table = comp_table,
      note = note
    )
  })
  
  # OUTPUTS ----
  
  # Échantillon
  output$sas_sample <- renderDT({
    req(sas_result())
    datatable(sas_result()$sample, options = list(pageLength = 10, scrollX = TRUE), rownames = FALSE)
  })
  
  output$sas_stats <- renderPrint({
    req(sas_result())
    data_sample <- sas_result()$sample
    data_sample_filtered <- data_sample %>% select(-starts_with("CODE"))
    stats_summary <- summary(data_sample_filtered)
    print(stats_summary)
  })
  
  output$prop_table <- renderDT({
    req(sas_result())
    datatable(sas_result()$comp_table, options = list(dom = 't', pageLength = 10), rownames = FALSE) %>%
      formatPercentage(c("Population", "Échantillon", "Différence"), 2)
  })
  
  output$prop_plot <- renderPlotly({
    req(sas_result())
    comp_data <- sas_result()$comp_table %>%
      select(Modalité, Population, `Échantillon`) %>%
      pivot_longer(-Modalité, names_to = "Source", values_to = "Proportion")
    
    p <- ggplot(comp_data, aes(x = Modalité, y = Proportion, fill = Source)) +
      geom_col(position = "dodge") +
      scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
      scale_fill_manual(values = c("Population" = "#2c3e50", "Échantillon" = "#3c8dbc")) +
      labs(
        title = paste("Comparaison des proportions :", sas_result()$var_comp),
        x = sas_result()$var_comp,
        y = "Proportion",
        fill = "Source"
      ) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    ggplotly(p) %>% layout(margin = list(b = 100))
  })
  
  output$note_modalites <- renderUI({
    req(sas_result()$note)
    HTML(paste0("<p style='font-size: 13px; color: gray; font-style: italic;'>",
                sas_result()$note, "</p>"))
  })
  
  # Téléchargement (échantillon, stats ou tableau comparatif, image comparative)
  output$download_sas <- downloadHandler(
    filename = function() {
      type <- input$download_type_sas
      if (type == "sample") {
        paste0("echantillon_SAS_", Sys.Date(), ".xlsx")
      } else if (type == "stats") {
        paste0("statistiques_SAS_", Sys.Date(), ".txt")
      } else if (type == "comparaison") {
        paste0("comparaison_SAS_", Sys.Date(), ".xlsx")
      } else if (type == "plot") {
        paste0("graphique_SAS_", Sys.Date(), ".png")
      }
    },
    content = function(file) {
      type <- input$download_type_sas
      if (type == "sample") {
        writexl::write_xlsx(sas_result()$sample, path = file)
      } else if (type == "stats") {
        stats <- capture.output(summary(sas_result()$sample %>% select(-starts_with("CODE"))))
        writeLines(stats, con = file)
      } else if (type == "comparaison") {
        writexl::write_xlsx(sas_result()$comp_table, path = file)
      } else if (type == "plot") {
        comp_data <- sas_result()$comp_table %>%
          select(Modalité, Population, `Échantillon`) %>%
          pivot_longer(-Modalité, names_to = "Source", values_to = "Proportion")
        
        p <- ggplot(comp_data, aes(x = Modalité, y = Proportion, fill = Source)) +
          geom_col(position = "dodge") +
          scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
          scale_fill_manual(values = c("Population" = "#2c3e50", "Échantillon" = "#3c8dbc")) +
          labs(
            title = paste("Comparaison des proportions :", sas_result()$var_comp),
            x = sas_result()$var_comp,
            y = "Proportion",
            fill = "Source"
          ) +
          theme_minimal() +
          theme(axis.text.x = element_text(angle = 45, hjust = 1))
        
        ggsave(file, plot = p, width = 10, height = 6, dpi = 300)
      }
    }
  )
  
  # Mise à jour des sélecteurs basée sur les données chargées
  # Mise à jour des sélecteurs basée sur les données chargées
  observe({
    req(data())
    updateSelectInput(session, "strat_var",
                      choices = c("Region", "GOVERNORATE", "DELEGATION"),
                      selected = "Region")
    updateSelectInput(session, "aux_var",
                      choices = c("Aucune", "Area"),
                      selected = "Aucune")
  })
  
  # Fonction principale pour l'échantillonnage stratifié
  strat_result <- eventReactive(input$run_strat, {
    req(data(), input$n_strat, input$strat_var)
    
    id <- showNotification("Calcul de l'échantillon stratifié en cours...",
                           duration = NULL, type = "message")
    on.exit(removeNotification(id), add = TRUE)
    
    withProgress(message = 'Traitement en cours', value = 0, {
      # 1. Calcul des allocations
      incProgress(0.2, detail = "Calcul des allocations par strate")
      
      strata_sizes <- data() %>%
        group_by(!!sym(input$strat_var)) %>%
        summarise(Taille = n(), .groups = "drop") %>%
        mutate(
          Proportion = Taille / sum(Taille),
          Allocation = floor(Proportion * input$n_strat),  # Utilisation de floor
          Reste = Proportion * input$n_strat - Allocation
        ) %>%
        arrange(desc(Reste)) %>%  # Tri pour la méthode de Hamilton
        mutate(
          # Ajout des unités restantes
          Allocation = Allocation + c(rep(1, input$n_strat - sum(Allocation)),
                                      rep(0, n() - (input$n_strat - sum(Allocation))))
        )
      
      # 2. Échantillonnage stratifié
      incProgress(0.5, detail = "Tirage aléatoire par strate")
      
      samp <- strata_sizes %>%
        split(.[[input$strat_var]]) %>%
        map_df(~ {
          data_strate <- data() %>% filter(!!sym(input$strat_var) == .x[[input$strat_var]][1])
          sample_n(data_strate, size = min(.x$Allocation, nrow(data_strate)))
        })
      
      # 3. Calcul des statistiques (uniquement si une variable auxiliaire est sélectionnée)
      incProgress(0.3, detail = "Génération des statistiques")
      
      stats <- if (input$aux_var != "Aucune" && is.numeric(data()[[input$aux_var]])) {
        samp %>%
          group_by(!!sym(input$strat_var)) %>%
          summarise(
            N = n(),
            Moyenne = mean(!!sym(input$aux_var), na.rm = TRUE),
            Médiane = median(!!sym(input$aux_var), na.rm = TRUE),
            SD = sd(!!sym(input$aux_var), na.rm = TRUE),
            .groups = "drop"
          )
      } else if (input$aux_var != "Aucune") {
        samp %>%
          group_by(!!sym(input$strat_var), !!sym(input$aux_var)) %>%
          summarise(N = n(), .groups = "drop") %>%
          group_by(!!sym(input$strat_var)) %>%
          mutate(Proportion = N / sum(N)) %>%
          ungroup()
      } else {
        NULL
      }
      
      list(
        allocations = strata_sizes %>% select(-Reste),
        sample = samp,
        stats = stats,
        strat_var = input$strat_var,
        aux_var = input$aux_var,
        note = if(sum(strata_sizes$Allocation) != input$n_strat) {
          paste("Note: Allocation ajustée à", sum(strata_sizes$Allocation),
                "unités au lieu de", input$n_strat)
        } else NULL
      )
    })
  })
  
  # Affichage des allocations
  output$strat_alloc <- renderDT({
    req(strat_result())
    
    datatable(
      strat_result()$allocations %>% 
        rename(
          "Strate" = input$strat_var,
          "Nh (Population)" = "Taille",
          "nh (Échantillon)" = "Allocation"
        ),
      options = list(
        pageLength = nrow(strat_result()$allocations),
        scrollX = TRUE,
        paging = FALSE
      ),
      rownames = FALSE,
      caption = "Allocation par strate (Nh = population totale, nh = échantillon)"
    ) %>%
      formatPercentage("Proportion", 2) %>%
      formatRound("nh (Échantillon)", 0)
  })
  
  output$strat_sample <- renderDT({
    req(strat_result())
    datatable(
      strat_result()$sample,
      options = list(
        pageLength = 10,
        scrollX = TRUE
      ),
      rownames = FALSE,
      caption = "Échantillon stratifié"
    )
  })
  
  # Affichage des statistiques
  output$strat_stats <- renderDT({
    req(strat_result())
    
    allocations <- strat_result()$allocations
    samp <- strat_result()$sample
    
    stats_data <- if (input$aux_var != "Aucune") {
      # Avec variable auxiliaire
      if (is.numeric(data()[[input$aux_var]])) {
        samp %>%
          group_by(!!sym(strat_result()$strat_var)) %>%
          summarise(
            Nh = first(allocations$Taille[match(!!sym(strat_result()$strat_var), 
                                                allocations[[strat_result()$strat_var]])]),
            nh = n(),
            Moyenne = mean(!!sym(input$aux_var), na.rm = TRUE),
            SD = sd(!!sym(input$aux_var), na.rm = TRUE),
            .groups = "drop"
          )
      } else {
        # Variable catégorielle
        samp %>%
          group_by(!!sym(strat_result()$strat_var), !!sym(input$aux_var)) %>%
          summarise(nh_cat = n(), .groups = "drop") %>%
          group_by(!!sym(strat_result()$strat_var)) %>%
          mutate(
            Nh = first(allocations$Taille[match(!!sym(strat_result()$strat_var), 
                                                allocations[[strat_result()$strat_var]])]),
            Proportion = nh_cat/sum(nh_cat)
          )
      }
    } else {
      # Sans variable auxiliaire
      samp %>%
        group_by(!!sym(strat_result()$strat_var)) %>%
        summarise(
          Nh = first(allocations$Taille[match(!!sym(strat_result()$strat_var), 
                                              allocations[[strat_result()$strat_var]])]),
          nh = n(),
          .groups = "drop"
        ) %>%
        mutate(Proportion = nh/sum(nh))
    }
    
    datatable(
      stats_data,
      options = list(
        dom = 't',
        pageLength = 10,
        scrollX = TRUE
      ),
      rownames = FALSE,
      caption = if (input$aux_var == "Aucune") {
        "Répartition de l'échantillon par strate"
      } else {
        paste("Statistiques pour", input$aux_var, "par strate")
      }
    ) %>%
      {if ("Proportion" %in% colnames(stats_data)) 
        formatPercentage(., "Proportion", 2) else .} %>%
      {if (all(c("Moyenne", "SD") %in% colnames(stats_data))) 
        formatRound(., c("Moyenne", "SD"), 2) else .}
  })
  
  output$download_strat <- downloadHandler(
    filename = function() {
      suffix <- switch(input$download_type_strat,
                       "alloc" = "allocations",
                       "stats" = "statistiques",
                       "sample" = "echantillon")
      paste0(suffix, "_strat_", Sys.Date(), ".xlsx")
    },
    content = function(file) {
      data_to_export <- switch(input$download_type_strat,
                               "alloc" = strat_result()$allocations,
                               "stats" = strat_result()$stats,
                               "sample" = strat_result()$sample
      )
      writexl::write_xlsx(data_to_export, path = file)
    }
  )
  
  
  
}
shinyApp(ui, server)

