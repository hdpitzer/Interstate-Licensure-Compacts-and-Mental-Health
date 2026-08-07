clear all

global wd "/Users/Student/Library/CloudStorage/OneDrive-Emory/03 Spring 2025/Interstate Licensure"

ssc install ftools
ssc install reghdfe





use "${wd}/data/output/clean_brfss_2011_2023_master2.dta", clear
drop if mdy==.

***Poor mental health days

**Total population
qui poisson menthlth imlc_enacted_dd psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele i.year i.stfips, cluster(stfips)
eststo reg1

margins, dydx(imlc_enacted_dd psypact_active_dd)
eststo marg1 /*0.0438188, 0.10346*/

qui poisson menthlth compact sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele i.year i.stfips, cluster(stfips)
eststo reg2

margins, dydx(compact)
eststo marg2 /*0.0774609*/

*Export results
estout reg1 reg2 using "${wd}/analysis/tables/pmhd_covid1.csv", style(tab) replace label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low educ_mid educ_high income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele) order(imlc_enacted_dd psypact_active_dd compact sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low educ_mid educ_high income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele) stats(N mean , fmt(%6.0f %8.2f) labels("Observations" "Mean dependent variable")) cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers

**Ever diagnosed with depression population
qui poisson menthlth imlc_enacted_dd psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele i.year i.stfips if depev==1, cluster(stfips)
eststo reg3

margins, dydx(imlc_enacted_dd psypact_active_dd)
eststo marg3 /*0.184585, 0.0439839*/

qui poisson menthlth compact sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele i.year i.stfips if depev==1, cluster(stfips)
eststo reg4

margins, dydx(compact)
eststo marg4 /*0.1986317*/

*Export results
estout reg3 reg4 using "${wd}/analysis/tables/pmhd_covid2.csv", style(tab) replace label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low educ_mid educ_high income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele) order(imlc_enacted_dd psypact_active_dd compact sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low educ_mid educ_high income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele) stats(N mean, fmt(%6.0f %8.2f) labels("Observations" "Mean dependent variable")) cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers



***Major Depressive Disorder

**Total population
* MDD14 on compacts
qui reghdfe mdd14 imlc_enacted_dd psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele, absorb(stfips year) cluster(stfips)
eststo reg5

qui reghdfe mdd14 compact sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele, absorb(stfips year) cluster(stfips)
eststo reg6

*MDD21 on compacts
qui reghdfe mdd21 imlc_enacted_dd psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele, absorb(stfips year) cluster(stfips)
eststo reg7

qui reghdfe mdd21 compact sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele, absorb(stfips year) cluster(stfips)
eststo reg8

*Export results
estout reg5 reg6 reg7 reg8 using "${wd}/analysis/tables/mdd_covid1.csv", style(tab) replace label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low educ_mid educ_high income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele) order(imlc_enacted_dd psypact_active_dd compact sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low educ_mid educ_high income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele) stats(N r2 mean, fmt(%6.0f %8.3f %8.2f) labels("Observations" "R^2" "Mean dependent variable")) cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers


** Ever diagnosed with depression population
*MDD14 on compacts
qui reghdfe mdd14 imlc_enacted_dd psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele if depev==1, absorb(stfips year) cluster(stfips)
eststo reg9

qui reghdfe mdd14 compact sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele if depev==1, absorb(stfips year) cluster(stfips)
eststo reg10

*MDD21 on compacts
qui reghdfe mdd21 imlc_enacted_dd psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele if depev==1, absorb(stfips year) cluster(stfips)
eststo reg11

qui reghdfe mdd21 compact sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele if depev==1, absorb(stfips year) cluster(stfips)
eststo reg12

*Export results
estout reg9 reg10 reg11 reg12 using "${wd}/analysis/tables/mdd_covid2.csv", style(tab) replace label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low educ_mid educ_high income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele) order(imlc_enacted_dd psypact_active_dd compact sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low educ_mid educ_high income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity oos tele) stats(N r2 mean, fmt(%6.0f %8.3f %8.2f) labels("Observations" "R^2" "Mean dependent variable")) cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers
