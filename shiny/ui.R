fluidPage(
    h3("FHA Single-Family Housing Loans Multivariable Interest Rates Analysis"),

    sidebarLayout(
        
        sidebarPanel(
            width=2,
            selectInput('st', 'Select a US State:', choices = choice_st, selected = 'DC'),
            selectInput('sel_mod_vars',label = 'Select Multiple Predictors:', choices = NULL, multiple = TRUE),
            actionButton('btn_mod_run',label = 'Run Model', icon = icon('bolt'))
        ),
        mainPanel(
            width=9,
            bsCollapse(
                id = 'clps_mod_out',
                open = 'help',
                
                bsCollapsePanel(
                    title = "About the App", 
                    value = 'help', style = "primary",
                    
                    h4('Purpose'),
                    p('This App allows users to explore the relationshp between
                      the interest rate on newly issued FHA loans and various 
                    loan, borrower, and demographic variables as predictors.'),
                    
                    h4('Inputs'),
                    tags$ul(
                        tags$li(tags$b('Select a US State:'), 
                                'Subset the dataset to a single US state.'),
                        tags$li(tags$b('Select Multiple Predictors:'), 
                                'Select one or more independent variable to include in the regression.',
                                tags$b('It may take a few seconds for the dropdown choices to load.')),
                        tags$li(tags$b('Run Model Button:'), 
                                'Click the button after selecting at least one predictor to estimate the model.')
                       ),
                    
                    h4('Outputs'),
                    tags$ul(
                        tags$li(tags$b('Model Coefficients:'), 
                                "Model fit output from the <em>lm()</em> function.
                                Includes a table of model coefficients and standard errors.
                                In addition, the model's R squared, RMSE, and number of observations 
                                are reported."),
                        
                        tags$li(tags$b('Coefficient Significance Plots:'), 
                                'Visually examine the coefficient estimates and their confidence intervals.
                                The coefficients that are statistically significant are plotted in red.'),
                        
                        tags$li(tags$b('Residuals Diagnostics Plots:'), 
                                'Visually examine model residuals to determine model adequacy.')
                    ),
                    
                    h4('The Data'),
                    p('The data was downloaded from US Housing and Urban Development (HUD)', 
                      tags$a(href="http://portal.hud.gov/hudportal/HUD?src=/program_offices/housing/rmra/oe/rpts/sfsnap/sfsnap",
                             target='_blank',
                             "data portal.")),
                    
                    h4('The Code'),
                    p('The App source code is available on ', 
                      tags$a(href="https://github.com/vadimus202/coursera_data_prods/",
                             target='_blank',
                             "GitHub."))
                ),
                
                bsCollapsePanel(
                    title = "Model Coefficients Output", 
                    value = 'clps_mod_out_1',
                    uiOutput('ui_mod_fit'),
                    style = "primary"
                ),
                
                bsCollapsePanel(
                    title = "Coefficient Significance Plots", 
                    plotOutput('p_mod_coef_ci'), 
                    style = "primary"
                ),
                
                bsCollapsePanel(
                    title = "Residuals Diagnostics Plots", 
                    shinydashboard::tabBox(width = 12,
                           tabPanel('Fitted vs. Actuals', plotOutput('p_mod_pred_act')),
                           tabPanel('Residuals vs. Fitted', plotOutput('p_mod_pred_resid')),
                           tabPanel('Q-Q Plot', plotOutput('p_mod_resid_QQ'))
                    ),                                    
                    style = "primary"
                )
            ) # end collapse
        ) # end sidebar layout MAIN panel
    ) # end sidebar layout
    
)


