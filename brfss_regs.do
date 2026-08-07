clear all

global wd "/Users/Student/Library/CloudStorage/OneDrive-Emory/03 Spring 2025/Interstate Licensure"

ssc install ftools
ssc install reghdfe


use "${wd}/data/output/clean_brfss_2011_2023_master.dta", clear
drop if mdy==.

***Poor mental health days

**Total population
qui poisson menthlth imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips if year<2020, cluster(stfips)
eststo reg0

margins, dydx(imlc_enacted_dd)
eststo marg0 /*0.0340964*/

qui poisson menthlth imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips, cluster(stfips)
eststo reg1

margins, dydx(imlc_enacted_dd)
eststo marg1 /*0.0616724*/

// poisson menthlth psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips, cluster(stfips)
// eststo reg
//
// margins, dydx(psypact_active_dd)
// eststo marg

qui poisson menthlth imlc_enacted_dd psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips, cluster(stfips)
eststo reg2

margins, dydx(imlc_enacted_dd psypact_active_dd)
eststo marg2 /*0.0453548, 0.0984957*/

qui poisson menthlth compact sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips, cluster(stfips)
eststo reg3

margins, dydx(compact)
eststo marg3 /*0.0763441*/

*Export results
estout reg2 reg3 reg0 reg1 using "${wd}/analysis/tables/pmhd_reg1.csv", style(tab) replace label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low educ_mid educ_high income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) order(imlc_enacted_dd psypact_active_dd compact sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low educ_mid educ_high income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) stats(N mean , fmt(%6.0f %8.2f) labels("Observations" "Mean dependent variable")) cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers

**Ever diagnosed with depression population
qui poisson menthlth imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips if year<2020 & depev==1, cluster(stfips)
eststo reg4

margins, dydx(imlc_enacted_dd)
eststo marg4 /*0.1409309*/

qui poisson menthlth imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips if depev==1, cluster(stfips)
eststo reg5

margins, dydx(imlc_enacted_dd)
eststo marg5 /*0.194223*/

// poisson menthlth psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips if depev==1, cluster(stfips)
// eststo reg6
//
// margins, dydx(psypact_active_dd)
// eststo marg6

qui poisson menthlth imlc_enacted_dd psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips if depev==1, cluster(stfips)
eststo reg6

margins, dydx(imlc_enacted_dd psypact_active_dd)
eststo marg6 /*0.1896005, 0.0294772*/

qui poisson menthlth compact sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips if depev==1, cluster(stfips)
eststo reg7

margins, dydx(compact)
eststo marg7 /*0.1960681*/

*Export results
estout reg6 reg7 reg4 reg5 using "${wd}/analysis/tables/pmhd_reg2.csv", style(tab) replace label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low educ_mid educ_high income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) order(imlc_enacted_dd psypact_active_dd compact sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low educ_mid educ_high income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) stats(N mean, fmt(%6.0f %8.2f) labels("Observations" "Mean dependent variable")) cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers



***Major Depressive Disorder

**Total population
* MDD14 on compacts
qui reghdfe mdd14 imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity if year<2020, absorb(stfips year) cluster(stfips)
eststo reg8

qui reghdfe mdd14 imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity, absorb(stfips year) cluster(stfips)
eststo reg9

// reghdfe mdd14 psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity, absorb(stfips year) cluster(stfips)
// eststo reg10

qui reghdfe mdd14 imlc_enacted_dd psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity, absorb(stfips year) cluster(stfips)
eststo reg10

qui reghdfe mdd14 compact sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity, absorb(stfips year) cluster(stfips)
eststo reg11

*MDD21 on compacts
qui reghdfe mdd21 imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity if year<2020, absorb(stfips year) cluster(stfips)
eststo reg12

qui reghdfe mdd21 imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity, absorb(stfips year) cluster(stfips)
eststo reg13

// reghdfe mdd21 psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity, absorb(stfips year) cluster(stfips)
// eststo reg14

qui reghdfe mdd21 imlc_enacted_dd psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity, absorb(stfips year) cluster(stfips)
eststo reg14

qui reghdfe mdd21 compact sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity, absorb(stfips year) cluster(stfips)
eststo reg15

*Export results
estout reg10 reg11 reg8 reg9 reg14 reg15 reg12 reg13 using "${wd}/analysis/tables/mdd_reg1.csv", style(tab) replace label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low educ_mid educ_high income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) order(imlc_enacted_dd psypact_active_dd compact sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low educ_mid educ_high income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) stats(N r2 mean, fmt(%6.0f %8.3f %8.2f) labels("Observations" "R^2" "Mean dependent variable")) cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers


** Ever diagnosed with depression population
*MDD14 on compacts
qui reghdfe mdd14 imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity if year<2020 & depev==1, absorb(stfips year) cluster(stfips)
eststo reg16

qui reghdfe mdd14 imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity if depev==1, absorb(stfips year) cluster(stfips)
eststo reg17

// reghdfe mdd14 psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity if depev==1, absorb(stfips year) cluster(stfips)
// eststo reg18

qui reghdfe mdd14 imlc_enacted_dd psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity if depev==1, absorb(stfips year) cluster(stfips)
eststo reg18

qui reghdfe mdd14 compact sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity if depev==1, absorb(stfips year) cluster(stfips)
eststo reg19

*MDD21 on compacts
qui reghdfe mdd21 imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity if year<2020 & depev==1, absorb(stfips year) cluster(stfips)
eststo reg20

qui reghdfe mdd21 imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity if depev==1, absorb(stfips year) cluster(stfips)
eststo reg21

// reghdfe mdd21 psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity if depev==1, absorb(stfips year) cluster(stfips)
// eststo reg22

qui reghdfe mdd21 imlc_enacted_dd psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity if depev==1, absorb(stfips year) cluster(stfips)
eststo reg22

qui reghdfe mdd21 compact sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_mid educ_high educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity if depev==1, absorb(stfips year) cluster(stfips)
eststo reg23

*Export results
estout reg18 reg19 reg16 reg17 reg22 reg23 reg20 reg21 using "${wd}/analysis/tables/mdd_reg2.csv", style(tab) replace label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low educ_mid educ_high income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) order(imlc_enacted_dd psypact_active_dd compact sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low educ_mid educ_high income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) stats(N r2 mean, fmt(%6.0f %8.3f %8.2f) labels("Observations" "R^2" "Mean dependent variable")) cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers
*********************************************************************************

// **Tex tabs
// **Main
// esttab reg0 reg1 reg2 reg3 reg8 reg9 reg10 reg11 reg12 reg13 reg14 reg15 using "${wd}/analysis/tables/pmhd_reg.tex", style(tex) replace ///
//     label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd perc_nointernet parity) ///
//     order(imlc_enacted_dd psypact_active_dd compact perc_nointernet parity) ///
//     stats(N mean, fmt(%6.0f %8.2f) labels("Observations" "Mean dependent variable")) ///
//     cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers ///
//     mtitles("Panel A: All respondents")
// esttab marg0 marg1 marg2 marg3 using "${wd}/analysis/tables/pmhd_reg.tex", style(tex) append ///
//     label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd) ///
//     order(imlc_enacted_dd psypact_active_dd compact) ///
//     cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers
//	
// esttab reg4 reg5 reg6 reg7 reg16 reg17 reg18 reg19 reg20 reg21 reg22 reg23 using "${wd}/analysis/tables/pmhd_reg.tex", style(tex) append ///
//     label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd perc_nointernet parity) ///
//     order(imlc_enacted_dd psypact_active_dd compact perc_nointernet parity) ///
//     stats(N mean, fmt(%6.0f %8.2f) labels("Observations" "Mean dependent variable")) ///
//     cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers ///
//     mtitles("Panel B: Ever diagnosed with depression")
// esttab marg4 marg5 marg6 marg7 using "${wd}/analysis/tables/pmhd_reg.tex", style(tex) append ///
//     label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd) ///
//     order(imlc_enacted_dd psypact_active_dd compact) ///
//     cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers
//	
// **Appendix
// *pmhd
// estout reg0 reg1 reg2 reg3 using "${wd}/analysis/tables/pmhd_reg.tex", style(tex) replace ///
//     label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) ///
//     order(imlc_enacted_dd psypact_active_dd compact sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) ///
//     stats(N mean, fmt(%6.0f %8.2f) labels("Observations" "Mean dependent variable")) ///
//     cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers ///
//     mtitles("Panel A: All respondents")
//
// estout reg4 reg5 reg6 reg7 using "${wd}/analysis/tables/pmhd_reg.tex", style(tex) append ///
//     label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) ///
//     order(imlc_enacted_dd psypact_active_dd compact sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) ///
//     stats(N mean, fmt(%6.0f %8.2f) labels("Observations" "Mean dependent variable")) ///
//     cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers ///
//     mtitles("Panel B: Ever diagnosed with depression")
//
//
// *mdd
// estout reg8 reg9 reg10 reg11 reg12 reg13 reg14 reg15 using "${wd}/analysis/tables/mdd_reg2.csv", style(tab) replace ///
//  label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) ///
//  order(imlc_enacted_dd psypact_active_dd compact sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) ///
//  stats(N r2 mean, fmt(%6.0f %8.3f %8.2f) labels("Observations" "R^2" "Mean dependent variable")) cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers ///
//  mtitles("Panel A: All respondents")
// 
// estout reg16 reg17 reg18 reg19 reg20 reg21 reg22 reg23 using "${wd}/analysis/tables/mdd_reg2.csv", style(tab) replace ///
//  label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) ///
//  order(imlc_enacted_dd psypact_active_dd compact sex race_bl race_oth hispanic uninsured mar_mar mar_ds mar_wid age_35 age_45 age_55 age_65 educ_low income_15 income_25 income_35 income_50 income_75 emp_self emp_nojob emp_home emp_stud emp_ret perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) ///
//  stats(N r2 mean, fmt(%6.0f %8.3f %8.2f) labels("Observations" "R^2" "Mean dependent variable")) cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers ///
//  mtitles("Panel B: Ever diagnosed with depression")


