clear all

global wd "/Users/Student/Library/CloudStorage/OneDrive-Emory/03 Spring 2025/Interstate Licensure"

// ssc install ftools
// ssc install reghdfe


use "${wd}/data/output/clean_state_2011_2023_master2.dta", clear


**Suicide rate regressions
replace ageadjustedrate = ageadjustedrate*100

reghdfe ageadjustedrate imlc_enacted_dd psypact_active_dd perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele, absorb(stfips year) cluster(stfips)
eststo reg1

reghdfe ageadjustedrate compact perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele, absorb(stfips year) cluster(stfips)
eststo reg2

*Export results
estout reg1 reg2 using "${wd}/analysis/tables/suicide_covid.csv", style(tab) replace label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele) order(imlc_enacted_dd psypact_active_dd compact perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele) stats(N r2 mean, fmt(%6.0f %8.3f %8.2f) labels("Observations" "R^2" "Mean dependent variable")) cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers


**Prescription rate regressions
reghdfe ssri_prscr_rate imlc_enacted_dd perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele, absorb(stfips year) cluster(stfips)
eststo reg3

reghdfe ssri_prscr_rate compact perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele, absorb(stfips year) cluster(stfips)
eststo reg4


*Export results
estout reg3 reg4 using "${wd}/analysis/tables/rx_covid.csv", style(tab) replace label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele) order(imlc_enacted_dd psypact_active_dd compact perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele) stats(N r2 mean, fmt(%6.0f %8.3f %8.2f) labels("Observations" "R^2" "Mean dependent variable")) cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers
