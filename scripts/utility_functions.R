panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor=3, ...)
{
    usr <- par("usr"); on.exit(par(usr))
    par(usr = c(0, 1, 0, 1))
    r <- abs(cor(x, y))
    txt <- format(c(r, 0.123456789), digits = digits)[1]
    txt <- paste0(prefix, txt)
    if(missing(cex.cor)) 
        cex.cor <- 0.8/strwidth(txt)
    text(0.5, 0.5, txt, cex = cex.cor)
}

"cleanplot.pca" <- function(res.pca, ax1=1, ax2=2, point=FALSE, 
                            ahead=0.07, cex=0.7) 
{
                                # A function to draw two biplots (scaling 1 and scaling 2) from an object 
                                # of class "rda" (PCA or RDA result from vegan's rda() function)
                                #
                                # License: GPL-2 
                                # Authors: Francois Gillet & Daniel Borcard, 24 August 2012
                                
                                require("vegan")
                                
                                par(mfrow=c(1,2))
                                p <- length(res.pca$CA$eig)
                                
                                # Scaling 1: "species" scores scaled to relative eigenvalues
                                sit.sc1 <- scores(res.pca, display="wa", scaling=1, choices=c(1:p))
                                spe.sc1 <- scores(res.pca, display="sp", scaling=1, choices=c(1:p))
                                plot(res.pca, choices=c(ax1, ax2), display=c("wa", "sp"), type="n", 
                                     main="PCA - scaling 1", scaling=1)
                                if (point)
                                {
                                    points(sit.sc1[,ax1], sit.sc1[,ax2], pch=20)
                                    text(res.pca, display="wa", choices=c(ax1, ax2), cex=cex, pos=3, scaling=1)
                                }
                                else
                                {
                                    text(res.pca, display="wa", choices=c(ax1, ax2), cex=cex, scaling=1)
                                }
                                text(res.pca, display="sp", choices=c(ax1, ax2), cex=cex, pos=4, 
                                     col="red", scaling=1)
                                arrows(0, 0, spe.sc1[,ax1], spe.sc1[,ax2], length=ahead, angle=20, col="red")
                                pcacircle(res.pca)
                                
                                # Scaling 2: site scores scaled to relative eigenvalues
                                sit.sc2 <- scores(res.pca, display="wa", choices=c(1:p))
                                spe.sc2 <- scores(res.pca, display="sp", choices=c(1:p))
                                plot(res.pca, choices=c(ax1,ax2), display=c("wa","sp"), type="n", 
                                     main="PCA - scaling 2")
                                if (point) {
                                    points(sit.sc2[,ax1], sit.sc2[,ax2], pch=20)
                                    text(res.pca, display="wa", choices=c(ax1 ,ax2), cex=cex, pos=3)
                                }
                                else
                                {
                                    text(res.pca, display="wa", choices=c(ax1, ax2), cex=cex)
                                }
                                text(res.pca, display="sp", choices=c(ax1, ax2), cex=cex, pos=4, col="red")
                                arrows(0, 0, spe.sc2[,ax1], spe.sc2[,ax2], length=ahead, angle=20, col="red")
                                par(mfrow=c(1,1))
                            }



"pcacircle" <- function (pca) 
{
    # Draws a circle of equilibrium contribution on a PCA plot 
    # generated from a vegan analysis.
    # vegan uses special constants for its outputs, hence 
    # the 'const' value below.
    
    eigenv <- pca$CA$eig
    p <- length(eigenv)
    n <- nrow(pca$CA$u)
    tot <- sum(eigenv)
    const <- ((n - 1) * tot)^0.25
    radius <- (2/p)^0.5
    radius <- radius * const
    symbols(0, 0, circles=radius, inches=FALSE, add=TRUE, fg=2)
}

pseudo_r2 = function(glm_mod) {
    1 -  glm_mod$deviance / glm_mod$null.deviance
}

get_spat_mods = function(gls_mod) {
    err_mods = c('corExp', 'corGaus', 'corLin', 'corRatio', 'corSpher')
    out = vector('list', length(err_mods))
    names(out) = sub('cor', '', err_mods)
    for(i in seq_along(err_mods)) {
        mods = vector('list', 2)
        names(mods) = c('nonug', 'nug')
        mods[[1]] = try(eval(parse(text=paste('update(gls_mod, corr=',
                                             err_mods[i],
                            '(form = ~ x + y, nugget=F))', sep=''))))
        mods[[2]] = try(eval(parse(text=paste('update(gls_mod, corr=',
                                             err_mods[i],
                            '(form = ~ x + y, nugget=T))', sep=''))))
        out[[i]] = mods
    }
    out
}

get_spat_AIC = function(spat_mods) {
    out = data.frame(mods = names(spat_mods), 
                     AIC_no_nug = NA, AIC_nug=NA)
    for(i in seq_along(spat_mods))
        for(j in 1:2)
            if(class(spat_mods[[i]][[j]]) == 'gls')
                out[i, j + 1] = AIC(spat_mods[[i]][[j]])
    out
}
