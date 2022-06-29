dashboardPage(
  dashboardHeader( title='Health Crisis: Obesity'),
  dashboardSidebar(
    sidebarUserPanel("Corey Kelly",
                     image = "./img/NYCDSA 1.png"),
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("National Demographics", tabName = "US", icon = icon("flag-usa")),
      menuItem("State Demographics", tabName = "state", icon = icon("chart-bar")),
      menuItem("National Trends", tabName = "trends", icon = icon("chart-line"))
    )
    ),
  dashboardBody(
    tabItems(
      tabItem(tabName = 'home',
              fluidPage(
                h2("Introduction"),
                p(strong("According to the CDC, \"Six in ten Americans live with at 
                         least one chronic disease, like heart disease and stroke, 
                         cancer, or diabetes. These and other chronic diseases are 
                         the leading causes of death and disability in America, and 
                         they are also a leading driver of healthcare costs.\"[1]  
                         One of the significant contributors to chronic disease in 
                         America is obesity.  Obesity makes every chronic disease worse 
                         and is primarily to blame for the dramatic increase in type 2 
                         diabetes over the past 20 years.  For example, the connection 
                         between obesity and type 2 diabetes is so closely related it is 
                         sometimes called \"diabesity\"[2]  With the far-reaching effect of 
                         obesity on chronic disease my aim was to look at obesity across different 
                         market segments of the United States to help potential governmental agencies, 
                         healthcare organizations, and pharmaceutical companies more effectively target 
                         resources and get an increased ROI.")),
                fluidRow(
                  column(12,
                         box(width = NULL, status = "primary", solidHeader = T, 
                             align="center",title = "Percent of U.S. Adults that are Obese 2011-2020",
                                plotOutput("by_year", width = "75%"))
                         )
                  )
                )
      ),

      
      tabItem(tabName ='US',
              fluidRow(
                column(width = 10,
                       box(width = NULL,solidHeader = T,status = "primary", 
                           align="center",title = "Percent of U.S. Adults that are Obese Across Demographics",
                           plotOutput("bar")),
                       box(width = NULL,solidHeader = T,status = "primary",
                           align="center",title = "Percent of U.S. Adults that are Obese by State and Market Segment",
                           girafeOutput("national"))
                       ),
                column(width = 2,
                       box(width = NULL, solidHeader = T,
                           selectizeInput(
                             inputId = "year",
                             label = h3("Year"),
                             choices = unique(sort(na.omit(df_map$Year))),
                             selected=unique(sort(na.omit(df_map$Year))[1]))
                           ),
                       box(width = NULL,solidHeader = T,selectizeInput(
                             inputId = "demo",
                             label = h3("Demographic"),
                             choices = unique(sort(na.omit(df_map$demographic))),
                             selected=unique(sort(na.omit(df_map$demographic))[1]))
                           ),
                       box(width = NULL,solidHeader = T, selectizeInput(
                         inputId = "inSelect",
                         label = h3("Market Segment"),
                         c()
                       )
                           )
                       )
                )
              ),
      
      
      tabItem(tabName = 'state',
              fluidPage(fluidRow(
                box(width = NULL,solidHeader = T,status = "primary",
                           align="center",title = "Percent of U.S. Adults that 
                         are Obese by State and Market Segment",
                    fluidRow(column(width = 6,plotOutput("age")),
                    column(width = 6,plotOutput("edu"))),
                    fluidRow(column(width = 6,plotOutput("inc")),
                        column(width = 6,plotOutput("race")))
                    ),
                
                column(width = 6,
                       box(width = NULL, solidHeader = T,
                           selectizeInput(
                             inputId = "yr",
                             label = h3("Year"),
                             choices = unique(sort(na.omit(df_map$Year))),
                             selected=unique(sort(na.omit(df_map$Year))[1]))
                           ),
                       box(width = NULL, solidHeader = T,
                           selectizeInput(
                             inputId = "state",
                             label = h3("State"),
                             choices = unique(sort(na.omit(df_map$NAME))),
                             selected=unique(sort(na.omit(df_map$NAME))[1]))
                           )),
                column(width = 6, box(width = NULL,solidHeader = T,status = "primary",
                           align="center",title = "Percent of U.S. Adults that 
                         are Obese by State and Market Segment",
                           girafeOutput("states")))
                
              ))
             
      ),
      tabItem(tabName = "trends",
              image = ".img/NYCDSA 1.png",
              fluidRow(box(width = NULL,solidHeader = T,status = "primary",
                           align="center",title = "Percent of U.S. Adults that 
                         are Obese vs Dietary Factors 2011-2020",
                           column(width = 6, imageOutput("fruit")),
                           column(width = 6, imageOutput("veg")))),
              fluidRow(box(width = NULL,solidHeader = T,status = "primary",
                           align="center",title = "Percent of U.S. Adults that 
                         are Obese vs Activity Factors 2011-2020",
                           column(width = 6,imageOutput("combo")),
                           column(width = 6,imageOutput("act")))
             
                
                   
                )
        
      )
                
             
    
    )
  )
)
