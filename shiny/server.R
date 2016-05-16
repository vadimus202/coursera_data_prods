

function(input, output, session) {
    
    source('server_helpers.R', local = T)
    source('server_reactives.R', local = T)
    
    #######################################################
    # MODEL OUTPUTS
    #######################################################
    
    # Model Coefs
    output$ui_mod_fit <- renderUI({
        fit <- react_mod_fit()
        isolate(
            htmlreg(fit, single.row = T, caption = '',
                    custom.model.names = input$st, 
                    doctype = F) %>% 
                HTML # this is key
        )
    })
    
    # Coef Conf Intervals
    output$p_mod_coef_ci <- renderPlot({
        fit <- react_mod_fit()
        
        isolate(
            if(class(fit)=='lm'){
                suppressMessages(
                    plotreg(
                        fit,
                        custom.model.names = input$st, 
                        custom.note = 'Red = Significant 90% Conf', 
                        ci.level = 0.90)
                )
            }
        )
    })
    
    
    # Model Plots
    output$p_mod_pred_act <- renderPlot({
        plot_mod_pred_act(react_mod_fit())
    })
    
    output$p_mod_pred_resid <- renderPlot({
        plot_mod_pred_resid(react_mod_fit())
    })
    
    output$p_mod_resid_QQ <- renderPlot({
        plot_mod_resid_QQ(react_mod_fit())
    })
    

    
}
