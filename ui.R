dashboardPage(title = "Teoria de Resposta ao Item",
              dashboardHeader(title = "Teoria de Resposta ao Item", titleWidth = "300px"),
              dashboardSidebar(
                width = "300px",
                sidebarMenu(style = "position: fixed; overflow: visible;",
                            sliderInput("mediaEscala", label = "Média", min = 0,
                                        max = 450, value = 100),
                            
                            sliderInput("dpEscala", label = "Desvio-padrão", min = 1,
                                        max = 100, value = 50),
                            
                            sliderInput("discriminacao", label = "Discriminação (a)", min = -5,
                                        max = 5, value = 1, step = 0.1),
                            
                            sliderInput("dificuldade", label = "Dificuldade (b)", min = -5,
                                        max = 5, value = 0, step = 0.1),
                            
                            sliderInput("chute", label = "Acerto ao acaso (c)", min = 0,
                                        max = 1, value = 0.2, step = 0.1),
                            
                            menuItem("Dashboard", 
                                     tabName = "dashboard",
                                     icon = icon("gear")
                            )
                )
              ),
              dashboardBody(
                tabItems(
                  tabItem(tabName = "dashboard",
                          fluidRow(
                            valueBoxOutput("theta"),
                            valueBoxOutput("proficiencia"),
                            valueBoxOutput("prop.acerto")
                          ),
                          fluidRow(
                            box(
                              width = 6, status = "primary", solidHeader = TRUE,
                              title = "Parâmetros dos Itens",
                              DT::dataTableOutput("parTable")            
                            ),
                            box(
                              width = 6, status = "primary", solidHeader = TRUE,
                              title = "Prop. Acerto x Dificuldade do Item",
                              plotOutput("hist")         
                            )
                          ),
                          fluidRow(
                            box(
                              width = 6, status = "primary", solidHeader = TRUE,
                              title = "Prop. Acerto x Dificuldade do Item",
                              plotlyOutput("propXdifi")         
                            ),
                            box(
                              width = 6, status = "primary", solidHeader = TRUE,
                              title = "Curva Característica do Item",
                              plotOutput("icc")         
                            )
                          ),
                          fluidRow(
                            box(
                              width = 12, status = "primary", solidHeader = TRUE,
                              title = "CCI - Dinâmica",
                              plotOutput("icc_dynamic")
                            )
                          )
                  )
                )
              )
)