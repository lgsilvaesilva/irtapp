##-- Pacotes --##
library(shiny)
library(dplyr)
library(shinydashboard)
library(DT)
library(irtoys)
library(ltm)
library(plotly)
library(ggplot2)
library(ggthemes)
library(reshape2)
library(scales)
##-----##

##-- Load data --##
load(file = "data/par_item_est.rdata") ## parametros dos itens estimados
load(file = "data/par_item_sim.rdata") ## parametros simulados
load(file = "data/resp_sim.rdata")     ## respostas simuladas
load(file = "data/dados_tpm.rdata")    ## profix estimada
load(file = "data/prop_acerto_item.rdata") ## prop acerto
load(file = "data/theta.rdata") ## theta
##-----##

prop.acerto.item[, 2:4] <- round(prop.acerto.item[, 2:4], 2)
prop.acerto.item$Prop. <- prop.acerto.item$Prop./100

iccPlot <- function(a, b, c, lim = c(-3, 3)) {
  theta <- seq(lim[1], lim[2], len = 100)
  icc <- function(a,b,c) c + (1 - c)*1/(1 + exp(-1.7*a*(theta - b)))
  out <- mapply(FUN = icc, as.numeric(a), as.numeric(b), as.numeric(c))
  out <- as.data.frame(cbind(theta, out))
  out <- melt(out, id.vars = "theta")
  out$variable <- gsub(pattern = "V", "Item ", out$variable)
  return(out)
}


icc <- function(a, b, c) {
  theta <- seq(-5, 5, len = 300)
  prob  <-  c + (1 - c)*1/(1 + exp(-1.7*a*(theta - b)))
  df <- data.frame(theta, prob)
  return(df)
}