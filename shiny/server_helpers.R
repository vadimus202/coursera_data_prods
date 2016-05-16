

plot_mod_pred_act <- 
    function(fit){
        
        dt <- 
            data.table(Actual = fit$model$rate,
                       Predicted = fit$fitted.values)
        
        lim <- c(min(dt), max(dt))
        
        p <- 
            ggplot(dt, aes(Actual,Predicted))+
            coord_equal(ratio = 1, xlim = lim, ylim = lim)+
            theme_bw()+
            theme(legend.position='none')
        
        
        if(nrow(dt)>10000){
            p <- 
                p + 
                stat_bin_hex(bins = 50, color='grey') + 
                scale_fill_gradient_tableau(palette = 'Blue')
            
        } else {
            p <- p + geom_point(aes(color=1))    
        }
        
        p <- 
            p +
            stat_smooth(method = "lm",se = F, color='black')+
            geom_abline(intercept = 0, slope = 1, linetype=2)
        
        p
        
    }



# Plot  Pred vs Residual
plot_mod_pred_resid <- 
    function(fit){
        dt <- 
            data.table(Predicted = fit$fitted.values,
                       Residual = fit$residuals)
        p <- 
            ggplot(dt, aes(Predicted,Residual))+
            theme_bw()+
            theme(legend.position='none')
        
        if(nrow(dt)>10000){
            p <- 
                p + 
                stat_bin_hex(bins = 50, color='grey') + 
                scale_fill_gradient_tableau(palette = 'Blue')
            
        } else {
            p <- p + geom_point(aes(color=1))    
        }
        
        p + geom_abline(intercept = 0, slope = 0)
    }



# Plot Residual QQ
plot_mod_resid_QQ <- 
    function(fit){
        res <- fit$resid
        
        y <- quantile(res[!is.na(res)], c(0.25, 0.75))
        x <- qnorm(c(0.25, 0.75))
        slope <- diff(y)/diff(x)
        int <- y[1L] - slope * x[1L]
        
        d <- data.table(res=res)
        
        
        ggplot(d, aes(sample = res)) + 
            stat_qq(aes(color=1)) + 
            geom_abline(slope = slope, intercept = int, linetype=2)+
            coord_equal(ratio = 1, xlim = c(-3.75,3.75), ylim = c(-3.75,3.75))+
            theme_bw()+
            theme(legend.position='none')+
            labs(x='Theoretical Quantiles', y='Sample Quantiles')
        
    }



