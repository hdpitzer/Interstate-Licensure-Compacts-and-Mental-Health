clear all

global wd "/Users/Student/Library/CloudStorage/OneDrive-Emory/03 Spring 2025/Interstate Licensure"

// ssc install ftools
// ssc install reghdfe


use "${wd}/data/output/clean_state_2011_2023_master.dta", clear


**Suicide rate regressions
replace ageadjustedrate = ageadjustedrate*100

reghdfe ageadjustedrate imlc_enacted_dd perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity if year<2020, absorb(stfips year) cluster(stfips)
eststo reg0

reghdfe ageadjustedrate imlc_enacted_dd perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity, absorb(stfips year) cluster(stfips)
eststo reg1

// reghdfe ageadjustedrate psypact_active_dd perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity, absorb(stfips year) cluster(stfips)
// eststo reg2

reghdfe ageadjustedrate imlc_enacted_dd psypact_active_dd perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity, absorb(stfips year) cluster(stfips)
eststo reg2

reghdfe ageadjustedrate compact perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity, absorb(stfips year) cluster(stfips)
eststo reg3

*Export results
estout reg0 reg1 reg2 reg3 using "${wd}/analysis/tables/suicide_reg.csv", style(tab) replace label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) order(imlc_enacted_dd psypact_active_dd compact perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) stats(N r2 mean, fmt(%6.0f %8.3f %8.2f) labels("Observations" "R^2" "Mean dependent variable")) cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers


**Prescription rate regressions
reghdfe ssri_prscr_rate imlc_enacted_dd perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity if year<2020, absorb(stfips year) cluster(stfips)
eststo reg4

reghdfe ssri_prscr_rate imlc_enacted_dd perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity, absorb(stfips year) cluster(stfips)
eststo reg5

reghdfe ssri_prscr_rate imlc_enacted_dd psypact_active_dd perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity, absorb(stfips year) cluster(stfips)
eststo reg6

reghdfe ssri_prscr_rate compact perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity, absorb(stfips year) cluster(stfips)
eststo reg7


*Export results
estout reg4 reg5 reg6 reg7 using "${wd}/analysis/tables/rx_reg.csv", style(tab) replace label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) order(imlc_enacted_dd psypact_active_dd compact perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) stats(N r2 mean, fmt(%6.0f %8.3f %8.2f) labels("Observations" "R^2" "Mean dependent variable")) cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers
