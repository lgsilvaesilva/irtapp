##-- Pacotes --##
# library(irtoys)
##-----##

set.seed(10)

##-- Itens --##
n.item <- 20
par.a <- runif(n.item, 0.2, 3)       #parametro de discriminacao
par.b <- seq(-2, 2, length = n.item) #parametro de dificuldade
par.c <- runif(n.item, 0.10, 0.25)  #parametro de acerto ao acaso
par.item <- cbind(par.a, par.b, par.c)
save(par.item, file = "data/par_item_sim.rdata")
##-----##

##-- Respostas Simuladas --##
n.aluno <- 5000
prof <- rnorm(n.aluno, mean = 0, sd = 1)
resp.sim <- irtoys::sim(ip = par.item, x = prof)
save(resp.sim, file = "data/resp_sim.rdata")
##-----##

##-- Estimando Parametros --##
dados.tpm <- ltm::tpm(resp.sim)
save(dados.tpm, file = "data/dados_tpm.rdata")

par.est   <- coef(dados.tpm)
colnames(par.est) <- c("c", "b", "a")
save(par.est, file = "data/par_item_est.rdata")
theta <- ltm::factor.scores(dados.tpm, method = "EAP", prior = TRUE)
save(theta, file = "data/theta.rdata")

plot(dados.tpm)
hist(theta$score.dat$z1)
plot(theta,include.items=T)
##-----##

##-- Proporcao de acerto do item --##
prop.acerto.item <- round(colMeans(resp.sim)*100, 1)
prop.acerto.item <- data.frame(Item = rownames(par.est), Prop. = prop.acerto.item)
prop.acerto.item <- cbind(prop.acerto.item, par.est)
rownames(prop.acerto.item) <- NULL
prop.acerto.item <- prop.acerto.item[, c("Item", "a", "b", "c", "Prop.")]
save(prop.acerto.item, file = "data/prop_acerto_item.rdata")
plot(prop.acerto.item, par.b)
##-----##

pessoas <- matrix(rep(1, nrow(par.est)), nr = 1)
theta.p <- factor.scores(dados.tpm, method = "EAP", resp.patterns = pessoas)

# th.eap <- eap(resp=Scored[1, , drop = F], ip=Scored2pl, qu=normal.qu())





