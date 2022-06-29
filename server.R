function(input, output, session) {

#Home Page Plot
#--------------------------------------------
  output$by_year <- renderPlot(
    df_npa%>%
      filter(
        LocationDesc == "National",
        QuestionID =="Q036",
        demographic ==	Total
      )%>%ggplot(.,aes(x = as.Date(paste(as.character(Year),"-01-01",sep="")), y=Data_Value))+
      geom_point(size=1.75)+
      geom_line(aes(color=Topic, linetype = Topic),size=1.25)+
      labs(x ="Years", y = "% of Population")+
      theme(plot.title = element_text(hjust = 0.5),
            legend.title = element_text(size = 10), 
            legend.text = element_text(size = 10), 
            legend.position = "bottom")+
      scale_color_manual(values = c("darkred"))
    
  )

  
#Observe the Demographic Input Selected  
#--------------------------------------------

observe({
    input_demo = input$demo
    
    updateSelectInput(
      session,
      "inSelect",
      choices =unique(sort(filter(df_npa, demographic==input_demo, QuestionID=="Q036",!is.na(demographic))$Stratification1)),
      selected=unique(sort(filter(df_npa, demographic==input_demo, QuestionID=="Q036",!is.na(demographic))$Stratification1))[1]
    )
  })
  
  
  
#A Bar Graph that responds to select inputs.
#--------------------------------------------
  output$bar = renderPlot(
    df_npa%>%
      filter(Class =="Obesity / Weight Status",
             QuestionID =="Q036",
             Year==input$year,
             demographic == input$demo,
             LocationDesc == "National",
             !is.na(demographic))%>%
      mutate(label_bar=paste(as.character(Data_Value),"%", sep = ""))%>%
      select(demographic,Data_Value,label_bar,Question,Stratification1)%>%
      ggplot(aes(y = Data_Value, x = Stratification1))+
      geom_col(aes(fill=Stratification1))+
      geom_text(aes(label = label_bar), vjust = -0.5)+
      labs(y = "% Percent of Obesity", x=input$demo)+
      theme(plot.title = element_text(hjust = 0.5),legend.position="none")
  )
  
  
  

#An interactive map of the U.S. that responds to select inputs. 
#--------------------------------------------
  output$national <- renderGirafe({
    gg = df_map%>%
      filter(Year==input$year,
        demographic==input$demo,
        Stratification1==input$inSelect,
        QuestionID=="Q036"
      )%>% 
      ggplot(aes(fill = Data_Value))+
      geom_sf_interactive(aes(tooltip = tooltip, data_id = NAME),size = 0.1)+ 
      scale_fill_continuous(
        high = "#A60027", low = "white", na.value = "grey50", name = "Obesity",
        label=percent_format(scale = 1))+
      theme_void()+ theme(legend.position = "right") +
      theme(plot.title = element_text(hjust = 0.5,size = 10))
    
    
    x<- girafe(ggobj = gg, height_svg = 4.25, width_svg = 5.5)%>%
      girafe_options(opts_hover(css = "fill:cyan"),opts_sizing(rescale =T, width =1 ))
    x
  })
  

  
  
  
output$table <- renderDataTable({
  df_npa%>%
    filter(
      Year==input$yr,
      demographic==input$d,
      Stratification1==input$ui2,
      QuestionID=="Q036",
      #LocationDesc==input$state,
      !is.na(demographic)
      )%>%
    select(Year,LocationDesc,Data_Value,demographic,Stratification1)%>%
    rename(States=LocationDesc)
  })


#A map of the each state that responds to select inputs. 
#--------------------------------------------
output$states <- renderGirafe({
  gg = df_map%>%
    filter(
      Year==input$yr,
      demographic==input$demo,
      Stratification1==input$inSelect,
      QuestionID=="Q036",
      NAME == input$state
    )%>% 
    ggplot()+
    geom_sf()+ 
    geom_sf_label(aes(label = paste(tooltip," Obesity", sep = "")),label.size = 0.25)+
    theme_void()+ theme(legend.position = "none")
  
  x<- girafe(ggobj = gg, height_svg = 3, width_svg = 4)%>%
    girafe_options(opts_sizing(rescale =T, width =1 ))
  x
})


#A Bar Graph that responds to select inputs.
#--------------------------------------------
demog = reactive({
  df_npa%>%
    filter(Class =="Obesity / Weight Status",
           QuestionID =="Q036",
           Year==input$yr,
           LocationDesc == input$state,
           !is.na(demographic))%>%
    mutate(label_bar=paste(as.character(Data_Value),"%", sep = ""))%>%
    select(demographic,Data_Value,label_bar,Question,Stratification1)
})



output$age = renderPlot(
  demog()%>%filter(demographic == "Age")%>%
    ggplot(aes(y = Data_Value, x = Stratification1))+
    geom_col(aes(fill=Stratification1))+
    geom_text(aes(label = label_bar), vjust = -0.5)+
    labs(y = "% Percent of Obesity", x="Age")+
    theme(plot.title = element_text(hjust = 0.5),legend.position="none")
)

output$edu = renderPlot(
  demog()%>%filter(demographic == "Education")%>%
    ggplot(aes(y = Data_Value, x = Stratification1))+
    geom_col(aes(fill=Stratification1))+
    geom_text(aes(label = label_bar), vjust = -0.5)+
    labs(y = "% Percent of Obesity", x="Education")+
    theme(plot.title = element_text(hjust = 0.5),legend.position="none")
)
output$inc = renderPlot(
  demog()%>%filter(demographic == "Income")%>%
    ggplot(aes(y = Data_Value, x = Stratification1))+
    geom_col(aes(fill=Stratification1))+
    geom_text(aes(label = label_bar), vjust = -0.5)+
    labs(y = "% Percent of Obesity", x="Income")+
    theme(plot.title = element_text(hjust = 0.5),legend.position="none")
)
output$race = renderPlot(
  demog()%>%filter(demographic == "Race/Ethnicity")%>%
    ggplot(aes(y = Data_Value, x = Stratification1))+
    geom_col(aes(fill=Stratification1))+
    geom_text(aes(label = label_bar), vjust = -0.5)+
    labs(y = "% Percent of Obesity", x="Race/Ethnicity")+
    theme(plot.title = element_text(hjust = 0.5),legend.position="none")
)

output$fruit = renderImage(
    list(src = "www/img/obesityvsfruit.png",
    contentType = "image/png",
    width = 600,
    height = 400,
    alt = "fruit"),
    deleteFile = F
)

output$combo = renderImage(
  list(src = "www/img/obesity_vs_combo.png",
       contentType = "image/png",
       width = 600,
       height = 400,
       alt = "combo"),
  deleteFile = F
)
output$act = renderImage(
  list(src = "www/img/obesity_vs_activity.png",
       contentType = "image/png",
       width = 600,
       height = 400,
       alt = "act"),
  deleteFile = F
)
  
 
output$veg = renderImage(
  
  list(src = "www/img/obesity vs veggies.png",
       contentType = "image/png",
       width = 600,
       height = 400,
       alt = "veg"),
  deleteFile = F
)
   
}



  

