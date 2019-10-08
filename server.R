function(input, output, session) {
  
  thetaReactive <- reactive({
    itemSel <- input$parTable_rows_selected
    resp.aluno <- matrix(rep(0, nrow(par.est)), nr = 1)
    theta.aluno <- factor.scores(dados.tpm, method = "EAP", resp.patterns = resp.aluno)
    
    if (length(itemSel)) {
      resp.aluno[, itemSel] <- 1
      theta.aluno <- factor.scores(dados.tpm, method = "EAP", resp.patterns = resp.aluno)
    }
    
    return(theta.aluno)
  })
  
  ##-- Tabela de Parametros
  output$parTable <- DT::renderDataTable({
    datatable(prop.acerto.item, options = list(pageLength = 10, autoWidth = TRUE, dom = 'pt')) %>% 
      formatPercentage('Prop.', 2) %>%
      formatStyle(
        'Prop.',
        background = styleColorBar(prop.acerto.item$Prop., 'steelblue'),
        backgroundSize = '100% 80%',
        backgroundRepeat = 'no-repeat',
        backgroundPosition = 'center'
      )
    }, server = TRUE)
  ##-----##
  
  ##-- Score Bruto
  output$theta <- renderValueBox({
    valueBox(
      round(thetaReactive()$score.dat$z1, 2),
      "Score Bruto",
      icon = icon("users")
    )
  })
  
  
  ##-- Proficiencia
  output$proficiencia <- renderValueBox({
    profix <- round(thetaReactive()$score.dat$z1*input$dpEscala + input$mediaEscala, 2)
    valueBox(
      value = profix,
      "Proficiência",
      color = if(profix < input$mediaEscala) "red" else "green",
      icon = if(profix < input$mediaEscala) icon("thumbs-down", lib = "glyphicon") else icon("thumbs-up", lib = "glyphicon")
    )
  })
  ##-----##
  
  ##-- Prop. Acerto
  output$prop.acerto <- renderValueBox({
    prop <- scales::percent(rowMeans(thetaReactive()$score.dat[, 1:20]))
    valueBox(
      value = prop,
      "Proporção de Acerto",
      color = "olive",
      icon = icon("ok-circle", lib = "glyphicon")
    )
  })
  ##-----##
  
  ##-- Scatter: prop x dific
  output$propXdifi <- renderPlotly({
    plot_ly(prop.acerto.item, y = ~Prop., x = ~b, color = ~b,
            size = ~Prop., text = ~paste("Dificuldade: ", b), type = "scatter", mode = "markers")
  })
  ##-----##
  
  ##-- Histograma
  output$hist <- renderPlot({
    theta$score.dat$profix <- theta$score.dat$z1*input$dpEscala + input$mediaEscala
    profix_aluno <- round(thetaReactive()$score.dat$z1, 2)*input$dpEscala + input$mediaEscala
    difi <- data.frame(b = theta$coef[, 2]*input$dpEscala + input$mediaEscala)
    
    ggplot(data = theta$score.dat, aes(x = profix, y = ..density.., fill=..count..)) +
      geom_histogram(bins = 30) +
      # geom_rug(alpha = 1/2, position = "jitter", aes(x = b), data = difi) +
      geom_vline(xintercept = profix_aluno, color = "indianred", size = 1.5) +
      labs(x = "Proficiência", y = "Densidade", fill = "Contagem") +
      theme_hc()
  })
  ##-----##
  
  ##-- ICC
  output$icc <- renderPlot({
  out <- iccPlot(a = par.est[, "a"], b = par.est[, "b"], c = par.est[, "c"])
  ggplot(data = out, aes(x = theta, y = value, group = variable, colour = variable)) +
    geom_line(size = 1) +
    scale_colour_tableau() +
    scale_y_continuous(labels = percent, limits = c(0, 1)) +
    guides(colour = "none") +
    labs(x = "Habilidade", y = "Probabilidade") +
    theme_hc()
  })
  
  ##-- ICC
  output$icc_dynamic <- renderPlot({
    prob_df <- icc(a = input$discriminacao, b = input$dificuldade, c = input$chute)
    
    ggplot(data = prob_df, aes(x = theta, y = prob)) +
      geom_line(color = "#2CA02C", size = 2) +
      scale_y_continuous(label = percent, limits = c(0, 1)) +
      labs(x = "Habilidade", y = "Probabilidade") +
      theme_hc()
  })
  
  
}


