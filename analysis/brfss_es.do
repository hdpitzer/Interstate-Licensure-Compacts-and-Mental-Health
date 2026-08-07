clear all

global wd "/Users/Student/Library/CloudStorage/OneDrive-Emory/03 Spring 2025/Interstate Licensure"

*ssc install coefplot

use "${wd}/data/output/clean_brfss_2011_2023_master.dta", clear
drop if mdy==.

**Create event time vars
foreach law in imlc_enacted_ffy psypact_active_ffy compact_ffy {
	egen min_`law'=min(cond(`law'==1,year,.)), by(stfips)

	
	gen `law'_y = year - min_`law'
	gen `law'_never = (min_`law'==.)
			
	replace `law'_y = -3 if `law'_y<-3
	replace `law'_y = 2 if `law'_y>2
	replace `law'_y = -1 if `law'_y==.
	
	forvalues n=-3/-2 {
		local n2 = abs(`n')
			gen `law'_bef_`n2' = (`law'_y==`n')
			lab var `law'_bef_`n2' "`n'"
		}

	forvalues n=0/2 {
			gen `law'_aft_`n' = (`law'_y==`n')
			lab var `law'_aft_`n' "`n'"
		}
			
}


****PMHD
**IMLC
*Full pop
*Canonical ES
qui eststo m1: poisson menthlth imlc_enacted_ffy_bef_* imlc_enacted_ffy_aft_* psypact_active_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips imlc_enacted_ffy_y, cluster(stfips)

*Stacked ES
preserve
stackedev menthlth imlc_enacted_ffy_bef_* imlc_enacted_ffy_aft_*, cohort(min_imlc_enacted_ffy) time(year) never_treat(imlc_enacted_ffy_never) unit_fe(stfips) clust_unit(stfips) covariates(psypact_active_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity)

eststo s1: poisson menthlth imlc_enacted_ffy_bef_* imlc_enacted_ffy_aft_* psypact_active_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips imlc_enacted_ffy_y  i.stfips##i.stack i.year##i.stack, cluster(stfips)

restore

*Depev pop
*Canonical ES
qui eststo m4: poisson menthlth imlc_enacted_ffy_bef_* imlc_enacted_ffy_aft_* psypact_active_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips imlc_enacted_ffy_y if depev==1, cluster(stfips)

*Stacked ES
preserve 
stackedev menthlth imlc_enacted_ffy_bef_* imlc_enacted_ffy_aft_* if depev==1, cohort(min_imlc_enacted_ffy) time(year) never_treat(imlc_enacted_ffy_never) unit_fe(stfips) clust_unit(stfips) covariates(psypact_active_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity)

eststo s4: poisson menthlth imlc_enacted_ffy_bef_* imlc_enacted_ffy_aft_* psypact_active_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips imlc_enacted_ffy_y  i.stfips##i.stack i.year##i.stack if depev==1, cluster(stfips)

restore

*Graph
#delimit;
coefplot (m1, label(Canonical: All respondents) msymbol(d) color(navy)) (s1, label(Stacked: All respondents) msymbol(o) color(green)) (m4, label(Canonical: Ever diagnosed) msymbol(t) color(navy)) (s4, label(Stacked: Ever diagnosed) msymbol(s) color(green)),
keep(imlc_enacted_ffy_bef_* imlc_enacted_ffy_y imlc_enacted_ffy_aft_*) vertical 

base
                     
order(imlc_enacted_ffy_bef_3 imlc_enacted_ffy_bef_2 . imlc_enacted_ffy_aft_0 imlc_enacted_ffy_aft_1 imlc_enacted_ffy_aft_2 imlc_enacted_ffy_aft_3) 
coeflabels( ///
        imlc_enacted_ffy_bef_3 = "-3" ///
        imlc_enacted_ffy_bef_2 = "-2" ///
		imlc_enacted_ffy_y = "-1" ///
        imlc_enacted_ffy_aft_0 = "0" ///
        imlc_enacted_ffy_aft_1 = "1" ///
        imlc_enacted_ffy_aft_2 = "2" ///
        imlc_enacted_ffy_aft_3 = "3") ///          
ytitle("Poor mental health days")
xline(3, lcolor(gs8) lwidth(thin) lpattern(dash))
yline(0, lcolor(gs8) lwidth(thin))
ciopts(recast(rcap) lcolor(gs5))
xlabel(1 "-3" 2 "-2" 3 "-1" 4 "0" 5 "1" 6 "2" 7 "3",labsize(small))
graphregion(color(white))
;
graph save "Graph" "${wd}/analysis/figures/event_pmhd_imlc.gph", replace;
graph export "${wd}/analysis/figures/event_pmhd_imlc.tif", as(tif) replace;


**PSYPACT
*Full pop
*Canonical ES
eststo m2: poisson menthlth psypact_active_ffy_bef_* psypact_active_ffy_aft_* imlc_enacted_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips imlc_enacted_ffy_y, cluster(stfips)

*Stacked ES
preserve
stackedev menthlth psypact_active_ffy_bef_* psypact_active_ffy_aft_*, cohort(min_psypact_active_ffy) time(year) never_treat(psypact_active_ffy_never) unit_fe(stfips) clust_unit(stfips) covariates(imlc_enacted_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity)

eststo s2: poisson menthlth psypact_active_ffy_bef_* psypact_active_ffy_aft_* imlc_enacted_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips psypact_active_ffy_y i.stfips##i.stack i.year##i.stack, cluster(stfips)

restore

*Depev pop
*Canonical ES
eststo m5: poisson menthlth psypact_active_ffy_bef_* psypact_active_ffy_aft_* imlc_enacted_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips imlc_enacted_ffy_y if depev==1, cluster(stfips)

*Stacked ES
preserve
stackedev menthlth psypact_active_ffy_bef_* psypact_active_ffy_aft_* if depev==1, cohort(min_psypact_active_ffy) time(year) never_treat(psypact_active_ffy_never) unit_fe(stfips) clust_unit(stfips) covariates(imlc_enacted_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity)

eststo s5: poisson menthlth psypact_active_ffy_bef_* psypact_active_ffy_aft_* imlc_enacted_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips psypact_active_ffy_y i.stfips##i.stack i.year##i.stack if depev==1, cluster(stfips)

restore

*Graph
#delimit;
coefplot (m2, label(Canonical: All respondents) msymbol(d) color(navy)) (s2, label(Stacked: All respondents) msymbol(o) color(green)) (m5, label(Canonical: Ever diagnosed) msymbol(t) color(navy)) (s5, label(Stacked: Ever diagnosed) msymbol(s) color(green)),
keep(psypact_active_ffy_bef_* psypact_active_ffy_y psypact_active_ffy_aft_*) vertical 

base
                     
order(psypact_active_ffy_bef_3 psypact_active_ffy_bef_2 . psypact_active_ffy_aft_0 psypact_active_ffy_aft_1 psypact_active_ffy_aft_2 psypact_active_ffy_aft_3) 
coeflabels( ///
        psypact_active_ffy_bef_3 = "-3" ///
        psypact_active_ffy_bef_2 = "-2" ///
		psypact_active_ffy_y = "-1" ///
        psypact_active_ffy_aft_0 = "0" ///
        psypact_active_ffy_aft_1 = "1" ///
        psypact_active_ffy_aft_2 = "2" ///
        psypact_active_ffy_aft_3 = "3") ///          
ytitle("Poor mental health days")
xline(3, lcolor(gs8) lwidth(thin) lpattern(dash))
yline(0, lcolor(gs8) lwidth(thin))
ciopts(recast(rcap) lcolor(gs5))
xlabel(1 "-3" 2 "-2" 3 "-1" 4 "0" 5 "1" 6 "2" 7 "3",labsize(small))
graphregion(color(white))
;
graph save "Graph" "${wd}/analysis/figures/event_pmhd_psypact.gph", replace;
graph export "${wd}/analysis/figures/event_pmhd_psypact.tif", as(tif) replace;

**Either
*Full pop
*Canonical ES
eststo m3: poisson menthlth compact_ffy_bef_* compact_ffy_aft_* sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips compact_ffy_y, cluster(stfips)

*Stacked ES
preserve
stackedev menthlth compact_ffy_bef_* compact_ffy_aft_*, cohort(min_compact_ffy) time(year) never_treat(compact_ffy_never) unit_fe(stfips) clust_unit(stfips) covariates(sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity)

eststo s3: poisson menthlth compact_ffy_bef_* compact_ffy_aft_* sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips compact_ffy_y i.stfips##i.stack i.year##i.stack, cluster(stfips)

restore

*Depev pop
*Canonical ES
eststo m6: poisson menthlth compact_ffy_bef_* compact_ffy_aft_* sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips compact_ffy_y if depev==1, cluster(stfips)

*Stacked ES
preserve
stackedev menthlth compact_ffy_bef_* compact_ffy_aft_* if depev==1, cohort(min_compact_ffy) time(year) never_treat(compact_ffy_never) unit_fe(stfips) clust_unit(stfips) covariates(sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity)

eststo s6: poisson menthlth compact_ffy_bef_* compact_ffy_aft_* sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips compact_ffy_y i.stfips##i.stack i.year##i.stack if depev==1, cluster(stfips)

restore


*Graph
#delimit;
coefplot (m3, label(Canonical: All respondents) msymbol(d) color(navy)) (s3, label(Stacked: All respondents) msymbol(o) color(green)) (m6, label(Canonical: Ever diagnosed) msymbol(t) color(navy)) (s6, label(Stacked: Ever diagnosed) msymbol(s) color(green)),
keep(compact_ffy_bef_* compact_ffy_y compact_ffy_aft_*) vertical

base
                     
order(compact_ffy_bef_3 compact_ffy_bef_2 . compact_ffy_aft_0 compact_ffy_aft_1 compact_ffy_aft_2 compact_ffy_aft_3) 
coeflabels( ///
        compact_ffy_bef_3 = "-3" ///
        compact_ffy_bef_2 = "-2" ///
		compact_ffy_y = "-1" ///
        compact_ffy_aft_0 = "0" ///
        compact_ffy_aft_1 = "1" ///
        compact_ffy_aft_2 = "2" ///
        compact_ffy_aft_3 = "3") ///          
ytitle("Poor mental health days")
xline(3, lcolor(gs8) lwidth(thin) lpattern(dash))
yline(0, lcolor(gs8) lwidth(thin))
ciopts(recast(rcap) lcolor(gs5))
xlabel(1 "-3" 2 "-2" 3 "-1" 4 "0" 5 "1" 6 "2" 7 "3",labsize(small))
graphregion(color(white))
;
graph save "Graph" "${wd}/analysis/figures/event_pmhd_compact.gph", replace;
graph export "${wd}/analysis/figures/event_pmhd_compact.tif", as(tif) replace;




***********************************************************************************
****MDD14
**IMLC
*Full pop
*Canonical ES
eststo m6: reghdfe mdd14 imlc_enacted_ffy_bef_* imlc_enacted_ffy_aft_* psypact_active_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_ffy_y, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract mdd14 imlc_enacted_ffy_bef_* imlc_enacted_ffy_aft_*, ///
	absorb(stfips year) ///
	cohort(min_imlc_enacted_ffy) ///
	control_cohort(imlc_enacted_ffy_never) ///
	covariates(psypact_active_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss ///
             uninsured ins_miss mar_mar mar_ds mar_wid mar_miss ///
             age_35 age_45 age_55 age_65 age_miss educ_low educ_miss ///
             income_15 income_25 income_35 income_50 income_75 income_miss ///
             emp_self emp_nojob emp_home emp_stud emp_ret emp_miss ///
             perc_black perc_hispanic perc_nointernet perc_unemp ///
             perc_uninsured parity) ///
	vce(cluster stfips)
	
matrix sa_b6 = e(b_iw)
matrix sa_v6 = e(V_iw)


*Depev pop
*Canonical ES
eststo m12: reghdfe mdd14 imlc_enacted_ffy_bef_* imlc_enacted_ffy_aft_* psypact_active_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_ffy_y if depev==1, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract mdd14 imlc_enacted_ffy_bef_* imlc_enacted_ffy_aft_* if depev==1, ///
	absorb(stfips year) ///
	cohort(min_imlc_enacted_ffy) ///
	control_cohort(imlc_enacted_ffy_never) ///
	covariates(psypact_active_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss ///
             uninsured ins_miss mar_mar mar_ds mar_wid mar_miss ///
             age_35 age_45 age_55 age_65 age_miss educ_low educ_miss ///
             income_15 income_25 income_35 income_50 income_75 income_miss ///
             emp_self emp_nojob emp_home emp_stud emp_ret emp_miss ///
             perc_black perc_hispanic perc_nointernet perc_unemp ///
             perc_uninsured parity) ///
	vce(cluster stfips)
	
matrix sa_b12 = e(b_iw)
matrix sa_v12 = e(V_iw)

	
*Graph
event_plot m6 sa_b6#sa_v6 m12 sa_b12#sa_v12 , ciplottype(rcap) ///
				graph_opt(xtitle("") xline(-1, lcolor(gs8) lpattern(dash)) ///
				yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ///
				ytitle("Major depressive disorder") ///
				title(`"`titletext'"') ///
				legend(rows(4) order(1 3 5 7) ///
				region(lstyle(none)) ///
				label(1 "Canonical: All respondents") label(3 "S&A: All respondents") label(5 "Canonical: Ever diagnosed") label(7 "S&A: Ever diagnosed") on)) ///
				lead_opt1(msymbol(d) color(navy)) lag_opt1(msymbol(d) color(navy)) ///
				lead_opt2(msymbol(o) color(green)) lag_opt2(msymbol(o) color(green)) ///
				lead_opt3(msymbol(t) color(navy) lpattern(dash)) lag_opt3(msymbol(t) color(navy) lpattern(dash)) ///
				lead_opt4(msymbol(s) color(green)) lag_opt4(msymbol(s) color(green)) ///
				lag_ci_opt(color(gs5)) lead_ci_opt(color(gs5)) ///
				stub_lead(imlc_enacted_ffy_bef_# imlc_enacted_ffy_bef_# imlc_enacted_ffy_bef_# imlc_enacted_ffy_bef_#) stub_lag(imlc_enacted_ffy_aft_# imlc_enacted_ffy_aft_# imlc_enacted_ffy_aft_# imlc_enacted_ffy_aft_#) trimlag(3) trimlead(3) ///
                together plottype(scatter) perturb(-.3 -.1 .1 .3)

graph save "Graph" "${wd}/analysis/figures/event_mdd14_imlc.gph", replace
graph export "${wd}/analysis/figures/event_mdd14_imlc.tif", as(tif) replace


**PSYPACT
*Full pop
*Canonical ES
eststo m7: reghdfe mdd14 psypact_active_ffy_bef_* psypact_active_ffy_aft_* imlc_enacted_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_ffy_y, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract mdd14 psypact_active_ffy_bef_* psypact_active_ffy_aft_*, ///
	absorb(stfips year) ///
	cohort(min_psypact_active_ffy) ///
	control_cohort(psypact_active_ffy_never) ///
	covariates(imlc_enacted_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss ///
             uninsured ins_miss mar_mar mar_ds mar_wid mar_miss ///
             age_35 age_45 age_55 age_65 age_miss educ_low educ_miss ///
             income_15 income_25 income_35 income_50 income_75 income_miss ///
             emp_self emp_nojob emp_home emp_stud emp_ret emp_miss ///
             perc_black perc_hispanic perc_nointernet perc_unemp ///
             perc_uninsured parity) ///
	vce(cluster stfips)
	
matrix sa_b7 = e(b_iw)
matrix sa_v7 = e(V_iw)

*Depev pop
*Canonical ES
eststo m13: reghdfe mdd14 psypact_active_ffy_bef_* psypact_active_ffy_aft_* imlc_enacted_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_ffy_y if depev==1, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract mdd14 psypact_active_ffy_bef_* psypact_active_ffy_aft_* if depev==1, ///
	absorb(stfips year) ///
	cohort(min_psypact_active_ffy) ///
	control_cohort(psypact_active_ffy_never) ///
	covariates(imlc_enacted_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss ///
             uninsured ins_miss mar_mar mar_ds mar_wid mar_miss ///
             age_35 age_45 age_55 age_65 age_miss educ_low educ_miss ///
             income_15 income_25 income_35 income_50 income_75 income_miss ///
             emp_self emp_nojob emp_home emp_stud emp_ret emp_miss ///
             perc_black perc_hispanic perc_nointernet perc_unemp ///
             perc_uninsured parity) ///
	vce(cluster stfips)
	
matrix sa_b13 = e(b_iw)
matrix sa_v13 = e(V_iw)

	
*Graph
event_plot m7 sa_b7#sa_v7 m13 sa_b13#sa_v13 , ciplottype(rcap) ///
				graph_opt(xtitle("") xline(-1, lcolor(gs8) lpattern(dash)) ///
				yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ///
				ytitle("Major depressive disorder") ///
				title(`"`titletext'"') ///
				legend(rows(4) order(1 3 5 7) ///
				region(lstyle(none)) ///
				label(1 "Canonical: All respondents") label(3 "S&A: All respondents") label(5 "Canonical: Ever diagnosed") label(7 "S&A: Ever diagnosed") on)) ///
				lead_opt1(msymbol(d) color(navy)) lag_opt1(msymbol(d) color(navy)) ///
				lead_opt2(msymbol(o) color(green)) lag_opt2(msymbol(o) color(green)) ///
				lead_opt3(msymbol(t) color(navy) lpattern(dash)) lag_opt3(msymbol(t) color(navy) lpattern(dash)) ///
				lead_opt4(msymbol(s) color(green)) lag_opt4(msymbol(s) color(green)) ///
				lag_ci_opt(color(gs5)) lead_ci_opt(color(gs5)) ///
				stub_lead(psypact_active_ffy_bef_# psypact_active_ffy_bef_# psypact_active_ffy_bef_# psypact_active_ffy_bef_#) stub_lag(psypact_active_ffy_aft_# psypact_active_ffy_aft_# psypact_active_ffy_aft_# psypact_active_ffy_aft_#) trimlag(3) trimlead(3) ///
                together plottype(scatter) perturb(-.3 -.1 .1 .3)

graph save "Graph" "${wd}/analysis/figures/event_mdd14_psypact.gph", replace
graph export "${wd}/analysis/figures/event_mdd14_psypact.tif", as(tif) replace


**Either
*Full pop
*Canonical ES
eststo m8: reghdfe mdd14 compact_ffy_bef_* compact_ffy_aft_* sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_ffy_y, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract mdd14 compact_ffy_bef_* compact_ffy_aft_*, ///
	absorb(stfips year) ///
	cohort(min_compact_ffy) ///
	control_cohort(compact_ffy_never) ///
	covariates(sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss ///
             uninsured ins_miss mar_mar mar_ds mar_wid mar_miss ///
             age_35 age_45 age_55 age_65 age_miss educ_low educ_miss ///
             income_15 income_25 income_35 income_50 income_75 income_miss ///
             emp_self emp_nojob emp_home emp_stud emp_ret emp_miss ///
             perc_black perc_hispanic perc_nointernet perc_unemp ///
             perc_uninsured parity) ///
	vce(cluster stfips)
	
matrix sa_b8 = e(b_iw)
matrix sa_v8 = e(V_iw)

*Depev pop
*Canonical ES
eststo m14: reghdfe mdd14 compact_ffy_bef_* compact_ffy_aft_* sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_ffy_y if depev==1, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract mdd14 compact_ffy_bef_* compact_ffy_aft_* if depev==1, ///
	absorb(stfips year) ///
	cohort(min_compact_ffy) ///
	control_cohort(compact_ffy_never) ///
	covariates(sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss ///
             uninsured ins_miss mar_mar mar_ds mar_wid mar_miss ///
             age_35 age_45 age_55 age_65 age_miss educ_low educ_miss ///
             income_15 income_25 income_35 income_50 income_75 income_miss ///
             emp_self emp_nojob emp_home emp_stud emp_ret emp_miss ///
             perc_black perc_hispanic perc_nointernet perc_unemp ///
             perc_uninsured parity) ///
	vce(cluster stfips)
	
matrix sa_b14 = e(b_iw)
matrix sa_v14 = e(V_iw)

	
*Graph
event_plot m8 sa_b8#sa_v8 m14 sa_b14#sa_v14 , ciplottype(rcap) ///
				graph_opt(xtitle("") xline(-1, lcolor(gs8) lpattern(dash)) ///
				yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ///
				ytitle("Major depressive disorder") ///
				title(`"`titletext'"') ///
				legend(rows(4) order(1 3 5 7) ///
				region(lstyle(none)) ///
				label(1 "Canonical: All respondents") label(3 "S&A: All respondents") label(5 "Canonical: Ever diagnosed") label(7 "S&A: Ever diagnosed") on)) ///
				lead_opt1(msymbol(d) color(navy)) lag_opt1(msymbol(d) color(navy)) ///
				lead_opt2(msymbol(o) color(green)) lag_opt2(msymbol(o) color(green)) ///
				lead_opt3(msymbol(t) color(navy)) lag_opt3(msymbol(t) color(navy)) ///
				lead_opt4(msymbol(s) color(green)) lag_opt4(msymbol(s) color(green)) ///
				lag_ci_opt(color(gs5)) lead_ci_opt(color(gs5)) ///
				stub_lead(compact_ffy_bef_# compact_ffy_bef_# compact_ffy_bef_# compact_ffy_bef_#) stub_lag(compact_ffy_aft_# compact_ffy_aft_# compact_ffy_aft_# compact_ffy_aft_#) trimlag(3) trimlead(3) ///
                together plottype(scatter) perturb(-.3 -.1 .1 .3)

graph save "Graph" "${wd}/analysis/figures/event_mdd14_compact.gph", replace
graph export "${wd}/analysis/figures/event_mdd14_compact.tif", as(tif) replace



****MDD21
**IMLC
*Full pop
*Canonical ES
eststo m9: reghdfe mdd21 imlc_enacted_ffy_bef_* imlc_enacted_ffy_aft_* psypact_active_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_ffy_y, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract mdd21 imlc_enacted_ffy_bef_* imlc_enacted_ffy_aft_*, ///
	absorb(stfips year) ///
	cohort(min_imlc_enacted_ffy) ///
	control_cohort(imlc_enacted_ffy_never) ///
	covariates(psypact_active_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss ///
             uninsured ins_miss mar_mar mar_ds mar_wid mar_miss ///
             age_35 age_45 age_55 age_65 age_miss educ_low educ_miss ///
             income_15 income_25 income_35 income_50 income_75 income_miss ///
             emp_self emp_nojob emp_home emp_stud emp_ret emp_miss ///
             perc_black perc_hispanic perc_nointernet perc_unemp ///
             perc_uninsured parity) ///
	vce(cluster stfips)
	
matrix sa_b9 = e(b_iw)
matrix sa_v9 = e(V_iw)

*Depev pop
*Canonical ES
eststo m15: reghdfe mdd21 imlc_enacted_ffy_bef_* imlc_enacted_ffy_aft_* psypact_active_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_ffy_y if depev==1, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract mdd21 imlc_enacted_ffy_bef_* imlc_enacted_ffy_aft_* if depev==1, ///
	absorb(stfips year) ///
	cohort(min_imlc_enacted_ffy) ///
	control_cohort(imlc_enacted_ffy_never) ///
	covariates(psypact_active_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss ///
             uninsured ins_miss mar_mar mar_ds mar_wid mar_miss ///
             age_35 age_45 age_55 age_65 age_miss educ_low educ_miss ///
             income_15 income_25 income_35 income_50 income_75 income_miss ///
             emp_self emp_nojob emp_home emp_stud emp_ret emp_miss ///
             perc_black perc_hispanic perc_nointernet perc_unemp ///
             perc_uninsured parity) ///
	vce(cluster stfips)
	
matrix sa_b15 = e(b_iw)
matrix sa_v15 = e(V_iw)

	
*Graph
event_plot m9 sa_b9#sa_v9 m15 sa_b15#sa_v15 , ciplottype(rcap) ///
				graph_opt(xtitle("") xline(-1, lcolor(gs8) lpattern(dash)) ///
				yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ///
				ytitle("Major depressive disorder") ///
				title(`"`titletext'"') ///
				legend(rows(4) order(1 3 5 7) ///
				region(lstyle(none)) ///
				label(1 "Canonical: All respondents") label(3 "S&A: All respondents") label(5 "Canonical: Ever diagnosed") label(7 "S&A: Ever diagnosed") on)) ///
				lead_opt1(msymbol(d) color(navy)) lag_opt1(msymbol(d) color(navy)) ///
				lead_opt2(msymbol(o) color(green)) lag_opt2(msymbol(o) color(green)) ///
				lead_opt3(msymbol(t) color(navy)) lag_opt3(msymbol(t) color(navy)) ///
				lead_opt4(msymbol(s) color(green)) lag_opt4(msymbol(s) color(green)) ///
				lag_ci_opt(color(gs5)) lead_ci_opt(color(gs5)) ///
				stub_lead(imlc_enacted_ffy_bef_# imlc_enacted_ffy_bef_# imlc_enacted_ffy_bef_# imlc_enacted_ffy_bef_#) stub_lag(imlc_enacted_ffy_aft_# imlc_enacted_ffy_aft_# imlc_enacted_ffy_aft_# imlc_enacted_ffy_aft_#) trimlag(3) trimlead(3) ///
                together plottype(scatter) perturb(-.3 -.1 .1 .3)

graph save "Graph" "${wd}/analysis/figures/event_mdd21_imlc.gph", replace
graph export "${wd}/analysis/figures/event_mdd21_imlc.tif", as(tif) replace


**PSYPACT
*Full pop
*Canonical ES
eststo m10: reghdfe mdd21 psypact_active_ffy_bef_* psypact_active_ffy_aft_* imlc_enacted_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_ffy_y, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract mdd21 psypact_active_ffy_bef_* psypact_active_ffy_aft_*, ///
	absorb(stfips year) ///
	cohort(min_psypact_active_ffy) ///
	control_cohort(psypact_active_ffy_never) ///
	covariates(imlc_enacted_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss ///
             uninsured ins_miss mar_mar mar_ds mar_wid mar_miss ///
             age_35 age_45 age_55 age_65 age_miss educ_low educ_miss ///
             income_15 income_25 income_35 income_50 income_75 income_miss ///
             emp_self emp_nojob emp_home emp_stud emp_ret emp_miss ///
             perc_black perc_hispanic perc_nointernet perc_unemp ///
             perc_uninsured parity) ///
	vce(cluster stfips)
	
matrix sa_b10 = e(b_iw)
matrix sa_v10 = e(V_iw)

*Depev pop
*Canonical ES
eststo m16: reghdfe mdd21 psypact_active_ffy_bef_* psypact_active_ffy_aft_* imlc_enacted_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_ffy_y if depev==1, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract mdd21 psypact_active_ffy_bef_* psypact_active_ffy_aft_* if depev==1, ///
	absorb(stfips year) ///
	cohort(min_psypact_active_ffy) ///
	control_cohort(psypact_active_ffy_never) ///
	covariates(imlc_enacted_ffy sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss ///
             uninsured ins_miss mar_mar mar_ds mar_wid mar_miss ///
             age_35 age_45 age_55 age_65 age_miss educ_low educ_miss ///
             income_15 income_25 income_35 income_50 income_75 income_miss ///
             emp_self emp_nojob emp_home emp_stud emp_ret emp_miss ///
             perc_black perc_hispanic perc_nointernet perc_unemp ///
             perc_uninsured parity) ///
	vce(cluster stfips)
	
matrix sa_b16 = e(b_iw)
matrix sa_v16 = e(V_iw)

	
*Graph
event_plot m10 sa_b10#sa_v10 m16 sa_b16#sa_v16 , ciplottype(rcap) ///
				graph_opt(xtitle("") xline(-1, lcolor(gs8) lpattern(dash)) ///
				yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ///
				ytitle("Major depressive disorder") ///
				title(`"`titletext'"') ///
				legend(rows(4) order(1 3 5 7) ///
				region(lstyle(none)) ///
				label(1 "Canonical: All respondents") label(3 "S&A: All respondents") label(5 "Canonical: Ever diagnosed") label(7 "S&A: Ever diagnosed") on)) ///
				lead_opt1(msymbol(d) color(navy)) lag_opt1(msymbol(d) color(navy)) ///
				lead_opt2(msymbol(o) color(green)) lag_opt2(msymbol(o) color(green)) ///
				lead_opt3(msymbol(t) color(navy)) lag_opt3(msymbol(t) color(navy)) ///
				lead_opt4(msymbol(s) color(green)) lag_opt4(msymbol(s) color(green)) ///
				lag_ci_opt(color(gs5)) lead_ci_opt(color(gs5)) ///
				stub_lead(psypact_active_ffy_bef_# psypact_active_ffy_bef_# psypact_active_ffy_bef_# psypact_active_ffy_bef_#) stub_lag(psypact_active_ffy_aft_# psypact_active_ffy_aft_# psypact_active_ffy_aft_# psypact_active_ffy_aft_#) trimlag(3) trimlead(3) ///
                together plottype(scatter) perturb(-.3 -.1 .1 .3)

graph save "Graph" "${wd}/analysis/figures/event_mdd21_psypact.gph", replace
graph export "${wd}/analysis/figures/event_mdd21_psypact.tif", as(tif) replace


**Either
*Full pop
*Canonical ES
eststo m11: reghdfe mdd21 compact_ffy_bef_* compact_ffy_aft_* sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_ffy_y, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract mdd21 compact_ffy_bef_* compact_ffy_aft_*, ///
	absorb(stfips year) ///
	cohort(min_compact_ffy) ///
	control_cohort(compact_ffy_never) ///
	covariates(sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss ///
             uninsured ins_miss mar_mar mar_ds mar_wid mar_miss ///
             age_35 age_45 age_55 age_65 age_miss educ_low educ_miss ///
             income_15 income_25 income_35 income_50 income_75 income_miss ///
             emp_self emp_nojob emp_home emp_stud emp_ret emp_miss ///
             perc_black perc_hispanic perc_nointernet perc_unemp ///
             perc_uninsured parity) ///
	vce(cluster stfips)
	
matrix sa_b11 = e(b_iw)
matrix sa_v11 = e(V_iw)

*Depev pop
*Canonical ES
eststo m17: reghdfe mdd21 compact_ffy_bef_* compact_ffy_aft_* sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_ffy_y if depev==1, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract mdd21 compact_ffy_bef_* compact_ffy_aft_* if depev==1, ///
	absorb(stfips year) ///
	cohort(min_compact_ffy) ///
	control_cohort(compact_ffy_never) ///
	covariates(sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss ///
             uninsured ins_miss mar_mar mar_ds mar_wid mar_miss ///
             age_35 age_45 age_55 age_65 age_miss educ_low educ_miss ///
             income_15 income_25 income_35 income_50 income_75 income_miss ///
             emp_self emp_nojob emp_home emp_stud emp_ret emp_miss ///
             perc_black perc_hispanic perc_nointernet perc_unemp ///
             perc_uninsured parity) ///
	vce(cluster stfips)
	
matrix sa_b17 = e(b_iw)
matrix sa_v17 = e(V_iw)

	
*Graph
event_plot m11 sa_b11#sa_v11 m17 sa_b17#sa_v17 , ciplottype(rcap) ///
				graph_opt(xtitle("") xline(-1, lcolor(gs8) lpattern(dash)) ///
				yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ///
				ytitle("Major depressive disorder") ///
				title(`"`titletext'"') ///
				legend(rows(4) order(1 3 5 7) ///
				region(lstyle(none)) ///
				label(1 "Canonical: All respondents") label(3 "S&A: All respondents") label(5 "Canonical: Ever diagnosed") label(7 "S&A: Ever diagnosed") on)) ///
				lead_opt1(msymbol(d) color(navy)) lag_opt1(msymbol(d) color(navy)) ///
				lead_opt2(msymbol(o) color(green)) lag_opt2(msymbol(o) color(green)) ///
				lead_opt3(msymbol(t) color(navy)) lag_opt3(msymbol(t) color(navy)) ///
				lead_opt4(msymbol(s) color(green)) lag_opt4(msymbol(s) color(green)) ///
				lag_ci_opt(color(gs5)) lead_ci_opt(color(gs5)) ///
				stub_lead(compact_ffy_bef_# compact_ffy_bef_# compact_ffy_bef_# compact_ffy_bef_#) stub_lag(compact_ffy_aft_# compact_ffy_aft_# compact_ffy_aft_# compact_ffy_aft_#) trimlag(3) trimlead(3) ///
                together plottype(scatter) perturb(-.3 -.1 .1 .3)

graph save "Graph" "${wd}/analysis/figures/event_mdd21_compact.gph", replace
graph export "${wd}/analysis/figures/event_mdd21_compact.tif", as(tif) replace
