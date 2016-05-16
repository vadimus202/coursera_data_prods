
# prep model data
# reacts to STATE dataset
react_mod_dt <- reactive({
    cat('Reactive mod_dt \n')
    
    dt_mod <- 
        tbl_fha %>% 
        filter(state==input$st) %>% 
        select(-county, -city, -source) %>% 
        collect() %>% 
        setDT() %>%
        .[,list(rate, amount, rate_type, 
                down_pmt_src, purpose, property, year, lender,
                zip, yr_mo)]
    
    # Add Zip info
    setkey(dt_mod, zip)
    dt_mod <- 
        tbl_acs_zip %>% 
        select(-city, -state) %>% 
        collect() %>% 
        setDT(key = 'zip') %>% 
        .[dt_mod] %>% 
        .[,zip:=NULL]
    
    # Add Time series
    setkey(dt_mod, yr_mo)
    dt_mod <- dt_ts[dt_mod][, yr_mo:=NULL]
    
    # factor dates
    if(dt_mod$year %>% unique() %>% length()>1){
        ref_yr <- max(dt_mod$year) %>% as.character()
        dt_mod[, year:=factor(year)]
        dt_mod[, year:=relevel(year, ref = ref_yr)]
    } else {
        dt_mod[, year:=NULL]
    }
    
    # factor lenders
    dt_lend_cnt <- 
        dt_mod[, .N, by=lender][N/nrow(dt_mod) > 0.05][order(-N)]
    
    if(nrow(dt_lend_cnt)>0){
        lend_top <- dt_lend_cnt$lender[1:min(5, nrow(dt_lend_cnt)-1)]
        dt_mod[!(lender %in% lend_top), lender:='Other']
        dt_mod[, lender:=factor(lender)]
        dt_mod[, lender:=relevel(lender,'Other')]
    } else {
        dt_mod[, lender:=NULL]
    }
})


##### Update List of Available Variables
observeEvent(react_mod_dt(), {
    vars <- names(react_mod_dt())
    vars <- vars[vars!='rate']
    updateSelectInput(session, "sel_mod_vars", choices = vars)
})

# open first panel after model fit
observeEvent(react_mod_fit(), {
    updateCollapse(session, id = 'clps_mod_out', open = 'clps_mod_out_1')
})

# Estimate Model
react_mod_fit <- eventReactive(input$btn_mod_run, {
    cat('Reactive mod_fit \n')
    
    sel_mod_vars <- input$sel_mod_vars
    
    if(length(sel_mod_vars)>0){
        fmla_mod <- 
            sel_mod_vars %>% 
            paste(collapse = ' + ') %>% 
            paste('rate ~', .) %>% 
            formula()
        
        lm_mod <- 
            lm(formula = fmla_mod, 
               data = react_mod_dt())
        
        return(lm_mod)
        
    } else {
        NULL
    }  
})
