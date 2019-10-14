server <- function(input, output){
  
  # ----------------------------- DATA LOADER -------------------------------
  
  data <- eventReactive(input$go, {
    inFile <- input$file
    if (is.null(inFile)) return(NULL)
    read.csv(inFile$datapath,header = TRUE)
  })

  # ----------------------------- 1D -------------------------------
  
  output$colonnes <- renderPlot({
    barplot(effectifs(), main = input$unid, 
            ylab="Effectifs", las = 2,
            names.arg = substr(names(effectifs()), 1, 4))
  })
  
  output$effectifsCumDiag <- renderPlot({
    if(sapply(data(), class)[input$unid] != "factor"){
      plot(ecdf(as.numeric(as.character(data()[,input$unid]))), 
           col ="green4", xlab = input$unid, ylab ="Fréquences cumulées", 
           main = paste("Fréquences cumulés pour",input$unid))
    }
  })  
  
  output$boiteMoustaches <- renderPlot({
    if(sapply(data(), class)[input$unid] != "factor"){
      boxplot( data()[,input$unid], col = grey(0.8), 
               main = input$unid,
               ylab = input$unid, las = 1)
      # Affichage complémentaires en Y des différents âges
      rug(data()[,input$unid], side = 2)
    }
  })
  
  output$effectifsDiag <- renderPlot({ 
    plot(table(data()[,input$unid]),  xlab = input$unid, ylab ="Effectifs", 
         main = paste("Distribution des effectifs pour l'âge",input$unid))
  })

  effectifs <- reactive({table(data()[,input$unid])})
  
  output$secteurs <- renderPlot({
      pie(effectifs(), labels = substr(names(effectifs()), 1, 4), 
          main = input$unid, col=c())
  })
  
  tabStats <- reactive({
    # Calculer les effectifs et les effectifs cumulés
    table.tmp <- as.data.frame(table(data()[,input$unid]))
    table.tmp <- cbind(table.tmp, cumsum(table.tmp[[2]]))
    # Calculer les fréquences et les fréquences cumulés
    table.tmp <- cbind(table.tmp, 
                       table.tmp[[2]]/nrow(data())*100,
                       table.tmp[[3]]/nrow(data())*100)
    # Ajouter des noms de colonnes
    colnames(table.tmp) <- c(input$unid, "Effectifs", "Effectifs Cum.",
                             "Fréquences", "Fréquences Cum.")
    # Renvoyer le tableau statistique
    table.tmp
  })
  output$contents <- renderTable({ tabStats() })
  
  # -----------------------------  2D -------------------------------
  
  # output$nuagePoints <- renderPlot({
  #   validate(
  #     need((sapply(data(), class)[input$bid1] != "factor" && sapply(data(), class)[input$bid2] != "factor")
  #          , label = "Only Quantitative variables")
  #   )
  #   
  #   options(scipen=999)
  #   x.var = input$bid1; y.var = input$bid2;
  #   plot(x = data()[, x.var], y = data()[, y.var], col = "blue",
  #        las = 2, cex.axis = 0.7,
  #        main = paste(y.var, "en fonction de", x.var),
  #        xlab = x.var, ylab = y.var, cex.lab = 1.2
  #   )
  #   # Droite de régression linéaire (y~x) 
  #   abline(lm(data()[, y.var]~data()[, x.var]), col="red", lwd = 2)
  #   options(scipen=0)
  # })

  output$correlation <- renderText({
    if(sapply(data(), class)[input$bid1] != "factor" && sapply(data(), class)[input$bid2] != "factor"){
      coeff.tmp <- cov(data()[, input$bid1], data()[, input$bid2])/(sqrt(var(data()[, input$bid1])*var(data()[, input$bid2])))
      paste("Coefficient de corrélation linéaire =", round(coeff.tmp,digits = 2))
    }
  })
  
  # ----------------------------- 2D -------------------------------

  output$force <- renderTable({
    force.df <- as.data.frame(matrix(NA, nrow = 3, ncol = 1))
    rownames(force.df) = c("X2", "Phi2", "Cramer")
    # La table de contingence des profils observés
    tab = with(data(), table(Sex, Level))
    # print(table(Sex, Level))
    # La table de contigence s'il y a indépendence
    tab.indep = tab
    n = sum(tab)
    tab.rowSum = apply(tab, 2, sum)
    tab.colSum = apply(tab, 1, sum)
    
    for(i in c(1:length(tab.colSum))){
      for(j in c(1:length(tab.rowSum))){
        tab.indep[i,j] = tab.colSum[i]*tab.rowSum[j]/n
      }
    }
    
    # Calcul du X²
    force.df[1,1] = sum((tab-tab.indep)^2/tab.indep)
    # Calcul du Phi²
    force.df[2,1] = force.df[1,1]/n
    # Calcul du Cramer
    force.df[3,1] = sqrt(force.df[2,1]/(min(nrow(tab), ncol(tab))-1))
    
    force.df
    
  }, rownames=TRUE, colnames=FALSE)
  
  # ----------------------------- 2D -------------------------------
  
  output$nuagePointshist <- renderPlot({
    validate(
      need(sapply(data(), class)[input$bid1] != "factor" 
           && sapply(data(), class)[input$bid2] != "factor"
           , label = "Only Quantitative variables")
    )
    options(digits=1)
    
    psych::scatter.hist(data()[, input$bid1], data()[, input$bid2])
  })
  
  # ----------------------------- BOXPLOT -------------------------------
  
  output$boxplotGgplot <- renderPlot({
    a = TRUE
    if(is.null(input$multd))
      a = FALSE
    for(i in input$multd)
      if(sapply(data(), class)[i] == "factor")
        a = FALSE
    if(a){
      # Reshape data()
      data.stack <- reshape::melt(data(), measure.vars = input$multd )
      # Boxplot élaborée
      ggplot2::qplot(x = data.stack[,1], y = data.stack[,2], 
            xlab = "Modalités", ylab = "Mesures",
            geom=c("boxplot", "jitter"), fill=data.stack[,1]) +
        theme(legend.title=element_blank())
    }
  })
  
  # ----------------------------- +D -------------------------------
  
  output$barplotBi <- renderPlot({
    # Diagramme en barres entre les variables 'Level' et 'Sex'
    ggplot2::ggplot(data(), ggplot2::aes(x = data()[,input$bid1], fill = data()[,input$bid2])) + ggplot2::geom_bar()
  })

  output$barplotDodgeBi <- renderPlot({
    # Diagramme de profils entre les variables 'Level' et 'Sex'
    ggplot2::ggplot(data(), ggplot2::aes(x = data()[,input$bid1], fill = data()[,input$bid2])) + ggplot2::geom_bar(position = "dodge")
  })

  # Boîtes parallèles
  # ----
  output$boxplotBasic <- renderPlot({
    # need(sapply(data(), class)[input$multd] != "factor" 
    #      , label = "Only Quantitative variables")
    # need(!is.null(input$multd) 
    #      , label = "Please Select one or More Variables")
    a = TRUE
    if(is.null(input$multd))
      a = FALSE
    for(i in input$multd)
      if(sapply(data(), class)[i] == "factor")
        a = FALSE
    if(a){
      # Reshape data()
      data.stack <- reshape::melt(data(), measure.vars = input$multd )
      # Boxplot basique
      boxplot(data.stack$value ~ data.stack$variable , col="grey",
              xlab = "Modalités", ylab = "Mesures")
    }
  })
  
  output$caract <- renderTable({
    a = FALSE
    if(is.null(input$multd))
      a = FALSE
    for(i in input$multd)
      if(sapply(data(), class)[i] == "factor")
        a = FALSE
    
    if(a){
      var.names <- input$multd
      # Initialisation de la table
      caract.df <- data.frame()
      # Pour chaque colonne, calcul de min, max, mean et ecart-type
      for(strCol in var.names){
        caract.vect <- c(min(data()[, strCol]), max(data()[,strCol]), 
                         mean(data()[,strCol]), sqrt(var(data()[,strCol])))
        caract.df <- rbind.data.frame(caract.df, caract.vect)
      }
      # Définition des row/colnames
      rownames(caract.df) <- var.names
      colnames(caract.df) <- c("Minimum", "Maximum", "Moyenne", "Ecart-type")
      # Renvoyer la table
      caract.df
    }
  }, rownames = TRUE, digits = 0)
  
  
  # Calcul et affichage le rapport de corrélation
  # ---
  # output$correlation <- renderText({
  #   # Calcul de la variance expliquée
  #   tmp.mean.y = mean(as.vector(as.matrix(data())))
  #   tmp.mean.yr = apply(data(), MARGIN = 2, mean)
  #   tmp.nl = rep(nrow(data()), 4)
  #   sE2 = (1/sum(tmp.nl))*sum(tmp.nl*(tmp.mean.yr-tmp.mean.y)^2)
  #   # Calcul de la variance résiduelle
  #   tmp.var.yr = apply(data(), MARGIN = 2, var)
  #   sR2 = (1/sum(tmp.nl))*sum(tmp.nl*tmp.var.yr)
  #   # Calcul du rapport de corrélation
  #   rCor = sqrt(sE2/(sE2+sR2))
  #   paste("\n\nRapport de corrélation =", round(rCor, digits = 2))
  #   print(sE2)
  #   print(sR2)
  # })
  
  # ----------------------------- Render Table -------------------------------
  
  output$table <- DT::renderDT({data()},options = list(scrollX = TRUE))
 
  # ----------------------------- Load Checkboxes-------------------------------
  
  output$miss <- renderPlot({
    Amelia::missmap(data())
  })
  
  output$checkbox1 <- renderUI({
    choice <- colnames(data())
    radioButtons(inputId = "unid", label = "Select variable", choices = choice)
  })
  
  output$checkbox2 <- renderUI({
    choice <- colnames(data())
        list(
          selectInput(inputId = "bid1", label = "Select first variable", choices = choice),
          selectInput(inputId = "bid2", label = "Select second variable", choices = choice)
        )
  })
  
  output$checkbox3 <- renderUI({
    choice <- colnames(data())
    checkboxGroupInput("multd","Select variable(s)", choices = choice)
  })
  
  # output$checkbox <- renderUI({
  #   choice <- colnames(data())
  #   # a = sapply(data(), class)
  #   # for(i in 1:length(choice))
  #   #   choice[i] = paste(choice[i],paste(a[i],")",sep = ""),sep = " (")
  #   
  #   if(input$dimensionSize == 'Unidimentional')
  #     choices <- radioButtons(inputId = "unid", label = "Select variable", choices = choice)
  #   else 
  #     if(input$dimensionSize == 'Bidimentional'){
  #       choices <- list(
  #         selectInput(inputId = "bid1", label = "Select first variable", choices = choice),
  #         selectInput(inputId = "bid2", label = "Select second variable", choices = choice)
  #       )
  #     }
  #   else
  #     choices <- checkboxGroupInput("multd","Select variable(s)", choices = choice)
  #   list(hr(),choices)
  # })
}