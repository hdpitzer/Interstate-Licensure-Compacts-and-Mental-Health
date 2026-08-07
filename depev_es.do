clear all

global wd "/Users/Student/Library/CloudStorage/OneDrive-Emory/03 Spring 2025/Interstate Licensure"

ssc install coefplot

use "${wd}/data/output/clean_brfss_2011_2023_master.dta", clear
drop if mdy==.
drop if depev!=1

**Create event time vars
foreach law in imlc_enacted_dd psypact_active_dd compact {
	egen min_`law'=min(cond(`law'==1,year,.)), by(stfips)

	
	gen `law'_y = year - min_`law'
	gen `law'_never = (min_`law'==.)
			
	replace `law'_y = -3 if `law'_y<-3
	replace `law'_y = 3 if `law'_y>3
	replace `law'_y = -1 if `law'_y==.
	
	forvalues n=-3/-2 {
		local n2 = abs(`n')
			gen `law'_bef_`n2' = (`law'_y==`n')
			lab var `law'_bef_`n2' "`n'"
		}

	forvalues n=0/3 {
			gen `law'_aft_`n' = (`law'_y==`n')
			lab var `law'_aft_`n' "`n'"
		}
			
}


****PMHD
**IMLC
*Canonical ES
eststo m1: poisson menthlth imlc_enacted_dd_bef_* imlc_enacted_dd_aft_* psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips imlc_enacted_dd_y, cluster(stfips)


*Stacked ES
stackedev menthlth imlc_enacted_dd_bef_* imlc_enacted_dd_aft_*, cohort(min_imlc_enacted_dd) time(year) never_treat(imlc_enacted_dd_never) unit_fe(stfips) clust_unit(stfips) covariates(psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity)

eststo s1: poisson menthlth imlc_enacted_dd_bef_* imlc_enacted_dd_aft_* psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips imlc_enacted_dd_y  i.stfips##i.stack i.year##i.stack, cluster(stfips)


*Graph
#delimit;
coefplot (s1, label(Stacked) msymbol(D)) (m1, label(Canonical) msymbol(O)),
keep(imlc_enacted_dd_bef_* imlc_enacted_dd_y imlc_enacted_dd_aft_*) vertical 

base
                     
order(imlc_enacted_dd_bef_3 imlc_enacted_dd_bef_2 imlc_enacted_dd_y imlc_enacted_dd_aft_0 imlc_enacted_dd_aft_1 imlc_enacted_dd_aft_2 imlc_enacted_dd_aft_3) 
coeflabels( ///
        imlc_enacted_dd_bef_3 = "-3" ///
        imlc_enacted_dd_bef_2 = "-2" ///
		imlc_enacted_dd_y = "-1" ///
        imlc_enacted_dd_aft_0 = "0" ///
        imlc_enacted_dd_aft_1 = "1" ///
        imlc_enacted_dd_aft_2 = "2" ///
        imlc_enacted_dd_aft_3 = "3") ///          
ytitle("Poor mental health days")
xline(3, lcolor(gs8) lwidth(thin) lpattern(dash))
yline(0, lcolor(gs8) lwidth(thin))
ciopts(recast(rcap))
xlabel(1 "-3" 2 "-2" 3 "-1" 4 "0" 5 "1" 6 "2" 7 "3",labsize(small))
graphregion(color(white))
;
graph save "Graph" "${wd}/analysis/figures/event_pmhd_depev_imlc.gph", replace;
graph export "${wd}/analysis/figures/event_pmhd_depev_imlc.tif", as(tif) replace;


**PSYPACT
*Canonical ES
eststo m2: poisson menthlth psypact_active_dd_bef_* psypact_active_dd_aft_* imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips imlc_enacted_dd_y, cluster(stfips)

*Stacked ES
stackedev menthlth psypact_active_dd_bef_* psypact_active_dd_aft_*, cohort(min_psypact_active_dd) time(year) never_treat(psypact_active_dd_never) unit_fe(stfips) clust_unit(stfips) covariates(imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity)

eststo s2: poisson menthlth psypact_active_dd_bef_* psypact_active_dd_aft_* imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips psypact_active_dd_y i.stfips##i.stack i.year##i.stack, cluster(stfips)

*Graph
#delimit;
coefplot (s2, label(Stacked) msymbol(D)) (m2, label(Canonical) msymbol(O)),
keep(psypact_active_dd_bef_* psypact_active_dd_y psypact_active_dd_aft_*) vertical 

base
                     
order(psypact_active_dd_bef_3 psypact_active_dd_bef_2 psypact_active_dd_y psypact_active_dd_aft_0 psypact_active_dd_aft_1 psypact_active_dd_aft_2 psypact_active_dd_aft_3) 
coeflabels( ///
        psypact_active_dd_bef_3 = "-3" ///
        psypact_active_dd_bef_2 = "-2" ///
		psypact_active_dd_y = "-1" ///
        psypact_active_dd_aft_0 = "0" ///
        psypact_active_dd_aft_1 = "1" ///
        psypact_active_dd_aft_2 = "2" ///
        psypact_active_dd_aft_3 = "3") ///          
ytitle("Poor mental health days")
xline(3, lcolor(gs8) lwidth(thin) lpattern(dash))
yline(0, lcolor(gs8) lwidth(thin))
ciopts(recast(rcap))
xlabel(1 "-3" 2 "-2" 3 "-1" 4 "0" 5 "1" 6 "2" 7 "3",labsize(small))
graphregion(color(white))
;
graph save "Graph" "${wd}/analysis/figures/event_pmhd_depev_psypact.gph", replace;
graph export "${wd}/analysis/figures/event_pmhd_depev_psypact.tif", as(tif) replace;

**Either
*Canonical ES
eststo m3: poisson menthlth compact_bef_* comapct_aft_* sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips compact_y, cluster(stfips)

*Stacked ES
stackedev menthlth compact_bef_* compact_aft_*, cohort(min_compact) time(year) never_treat(compact_never) unit_fe(stfips) clust_unit(stfips) covariates(sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity)

eststo s3: poisson menthlth compact_bef_* compact_aft_* sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity i.year i.stfips compact_y i.stfips##i.stack i.year##i.stack, cluster(stfips)

*Graph
#delimit;
coefplot (s3, label(Stacked) msymbol(D)) (m3, label(Canonical) msymbol(O)),
keep(compact_bef_* compact_y compact_aft_*) vertical keepzeros

base
                     
order(compact_bef_3 compact_bef_2 compact_y compact_aft_0 compact_aft_1 compact_aft_2 compact_aft_3) 
coeflabels( ///
        compact_bef_3 = "-3" ///
        compact_bef_2 = "-2" ///
		compact_y = "-1" ///
        compact_aft_0 = "0" ///
        compact_aft_1 = "1" ///
        compact_aft_2 = "2" ///
        compact_aft_3 = "3") ///          
ytitle("Poor mental health days")
xline(3, lcolor(gs8) lwidth(thin) lpattern(dash))
yline(0, lcolor(gs8) lwidth(thin))
ciopts(recast(rcap))
xlabel(1 "-3" 2 "-2" 3 "-1" 4 "0" 5 "1" 6 "2" 7 "3",labsize(small))
graphregion(color(white))
;
graph save "Graph" "${wd}/analysis/figures/event_pmhd_depev_compact.gph", replace;
graph export "${wd}/analysis/figures/event_pmhd_depev_compact.tif", as(tif) replace;


****MDD14
**IMLC
*Canonical ES
eststo m6: reghdfe mdd14 imlc_enacted_dd_bef_* imlc_enacted_dd_aft_* psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_dd_y, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract mdd14 imlc_enacted_dd_bef_* imlc_enacted_dd_aft_*, ///
	absorb(stfips year) ///
	cohort(min_imlc_enacted_dd) ///
	control_cohort(imlc_enacted_dd_never) ///
	covariates(psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss ///
             uninsured ins_miss mar_mar mar_ds mar_wid mar_miss ///
             age_35 age_45 age_55 age_65 age_miss educ_low educ_miss ///
             income_15 income_25 income_35 income_50 income_75 income_miss ///
             emp_self emp_nojob emp_home emp_stud emp_ret emp_miss ///
             perc_black perc_hispanic perc_nointernet perc_unemp ///
             perc_uninsured parity) ///
	vce(cluster stfips)

	
*Graph
event_plot e(b_iw)#e(V_iw) m6, ciplottype(rcap) ///
				graph_opt(xtitle("") xline(-1, lcolor(gs8) lpattern(dash)) ///
				yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ///
				ytitle("Major depressive disorder") ///
				title(`"`titletext'"') ///
				legend(rows(2) order(1 3) ///
				region(lstyle(none)) ///
				label(1 "S&A") label(3 "Canonical") on)) ///
				lead_opt1(msymbol(D) color(navy)) lag_opt1(msymbol(D) color(navy)) ///
				lead_opt2(color(green)) lag_opt2(color(green)) ///
				lag_ci_opt(color(gs5)) lead_ci_opt(color(gs5)) ///
				stub_lead(imlc_enacted_dd_bef_# imlc_enacted_dd_bef_#) stub_lag(imlc_enacted_dd_aft_# imlc_enacted_dd_aft_#) trimlag(3) trimlead(3) ///
                together plottype(scatter) perturb(-.2 -.0)

graph save "Graph" "${wd}/analysis/figures/event_mdd14_depev_imlc.gph", replace
graph export "${wd}/analysis/figures/event_mdd14_depev_imlc.tif", as(tif) replace


**PSYPACT
*Canonical ES
eststo m7: reghdfe mdd14 psypact_active_dd_bef_* psypact_active_dd_aft_* imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_dd_y, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract mdd14 psypact_active_dd_bef_* psypact_active_dd_aft_*, ///
	absorb(stfips year) ///
	cohort(min_psypact_active_dd) ///
	control_cohort(psypact_active_dd_never) ///
	covariates(imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss ///
             uninsured ins_miss mar_mar mar_ds mar_wid mar_miss ///
             age_35 age_45 age_55 age_65 age_miss educ_low educ_miss ///
             income_15 income_25 income_35 income_50 income_75 income_miss ///
             emp_self emp_nojob emp_home emp_stud emp_ret emp_miss ///
             perc_black perc_hispanic perc_nointernet perc_unemp ///
             perc_uninsured parity) ///
	vce(cluster stfips)

	
*Graph
event_plot e(b_iw)#e(V_iw) m7, ciplottype(rcap) ///
				graph_opt(xtitle("") xline(-1, lcolor(gs8) lpattern(dash)) ///
				yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ///
				ytitle("Major depressive disorder") ///
				title(`"`titletext'"') ///
				legend(rows(2) order(1 3) ///
				region(lstyle(none)) ///
				label(1 "S&A") label(3 "Canonical") on)) ///
				lead_opt1(msymbol(D) color(navy)) lag_opt1(msymbol(D) color(navy)) ///
				lead_opt2(color(green)) lag_opt2(color(green)) ///
				lag_ci_opt(color(gs5)) lead_ci_opt(color(gs5)) ///
				stub_lead(psypact_active_dd_bef_# psypact_active_dd_bef_#) stub_lag(psypact_active_dd_aft_# psypact_active_dd_aft_#) trimlag(3) trimlead(3) ///
                together plottype(scatter) perturb(-.2 -.0)

graph save "Graph" "${wd}/analysis/figures/event_mdd14_depev_psypact.gph", replace
graph export "${wd}/analysis/figures/event_mdd14_depev_psypact.tif", as(tif) replace


**Either
*Canonical ES
eststo m8: reghdfe mdd14 compact_bef_* compact_aft_* sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_dd_y, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract mdd14 compact_bef_* compact_aft_*, ///
	absorb(stfips year) ///
	cohort(min_compact) ///
	control_cohort(compact_never) ///
	covariates(sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss ///
             uninsured ins_miss mar_mar mar_ds mar_wid mar_miss ///
             age_35 age_45 age_55 age_65 age_miss educ_low educ_miss ///
             income_15 income_25 income_35 income_50 income_75 income_miss ///
             emp_self emp_nojob emp_home emp_stud emp_ret emp_miss ///
             perc_black perc_hispanic perc_nointernet perc_unemp ///
             perc_uninsured parity) ///
	vce(cluster stfips)
	
*Graph
event_plot e(b_iw)#e(V_iw) m8, ciplottype(rcap) ///
				graph_opt(xtitle("") xline(-1, lcolor(gs8) lpattern(dash)) ///
				yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ///
				ytitle("Major depressive disorder") ///
				title(`"`titletext'"') ///
				legend(rows(2) order(1 3) ///
				region(lstyle(none)) ///
				label(1 "S&A") label(3 "Canonical") on)) ///
				lead_opt1(msymbol(D) color(navy)) lag_opt1(msymbol(D) color(navy)) ///
				lead_opt2(color(green)) lag_opt2(color(green)) ///
				lag_ci_opt(color(gs5)) lead_ci_opt(color(gs5)) ///
				stub_lead(compact_bef_# compact_bef_#) stub_lag(compact_aft_# compact_aft_#) trimlag(3) trimlead(3) ///
                together plottype(scatter) perturb(-.2 -.0)

graph save "Graph" "${wd}/analysis/figures/event_mdd14_depev_compact.gph", replace
graph export "${wd}/analysis/figures/event_mdd14_depev_compact.tif", as(tif) replace



****MDD21
**IMLC
*Canonical ES
eststo m9: reghdfe mdd21 imlc_enacted_dd_bef_* imlc_enacted_dd_aft_* psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_dd_y, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract mdd21 imlc_enacted_dd_bef_* imlc_enacted_dd_aft_*, ///
	absorb(stfips year) ///
	cohort(min_imlc_enacted_dd) ///
	control_cohort(imlc_enacted_dd_never) ///
	covariates(psypact_active_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss ///
             uninsured ins_miss mar_mar mar_ds mar_wid mar_miss ///
             age_35 age_45 age_55 age_65 age_miss educ_low educ_miss ///
             income_15 income_25 income_35 income_50 income_75 income_miss ///
             emp_self emp_nojob emp_home emp_stud emp_ret emp_miss ///
             perc_black perc_hispanic perc_nointernet perc_unemp ///
             perc_uninsured parity) ///
	vce(cluster stfips)
	
*Graph
event_plot e(b_iw)#e(V_iw) m9, ciplottype(rcap) ///
				graph_opt(xtitle("") xline(-1, lcolor(gs8) lpattern(dash)) ///
				yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ///
				ytitle("Major depressive disorder") ///
				title(`"`titletext'"') ///
				legend(rows(2) order(1 3) ///
				region(lstyle(none)) ///
				label(1 "S&A") label(3 "Canonical") on)) ///
				lead_opt1(msymbol(D) color(navy)) lag_opt1(msymbol(D) color(navy)) ///
				lead_opt2(color(green)) lag_opt2(color(green)) ///
				lag_ci_opt(color(gs5)) lead_ci_opt(color(gs5)) ///
				stub_lead(imlc_enacted_dd_bef_# imlc_enacted_dd_bef_#) stub_lag(imlc_enacted_dd_aft_# imlc_enacted_dd_aft_#) trimlag(3) trimlead(3) ///
                together plottype(scatter) perturb(-.2 -.0)

graph save "Graph" "${wd}/analysis/figures/event_mdd21_depev_imlc.gph", replace
graph export "${wd}/analysis/figures/event_mdd21_depev_imlc.tif", as(tif) replace


**PSYPACT
*Canonical ES
eststo m10: reghdfe mdd21 psypact_active_dd_bef_* psypact_active_dd_aft_* imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_dd_y, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract mdd21 psypact_active_dd_bef_* psypact_active_dd_aft_*, ///
	absorb(stfips year) ///
	cohort(min_psypact_active_dd) ///
	control_cohort(psypact_active_dd_never) ///
	covariates(imlc_enacted_dd sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss ///
             uninsured ins_miss mar_mar mar_ds mar_wid mar_miss ///
             age_35 age_45 age_55 age_65 age_miss educ_low educ_miss ///
             income_15 income_25 income_35 income_50 income_75 income_miss ///
             emp_self emp_nojob emp_home emp_stud emp_ret emp_miss ///
             perc_black perc_hispanic perc_nointernet perc_unemp ///
             perc_uninsured parity) ///
	vce(cluster stfips)
	
*Graph
event_plot e(b_iw)#e(V_iw) m10, ciplottype(rcap) ///
				graph_opt(xtitle("") xline(-1, lcolor(gs8) lpattern(dash)) ///
				yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ///
				ytitle("Major depressive disorder") ///
				title(`"`titletext'"') ///
				legend(rows(2) order(1 3) ///
				region(lstyle(none)) ///
				label(1 "S&A") label(3 "Canonical") on)) ///
				lead_opt1(msymbol(D) color(navy)) lag_opt1(msymbol(D) color(navy)) ///
				lead_opt2(color(green)) lag_opt2(color(green)) ///
				lag_ci_opt(color(gs5)) lead_ci_opt(color(gs5)) ///
				stub_lead(psypact_active_dd_bef_# psypact_active_dd_bef_#) stub_lag(psypact_active_dd_aft_# psypact_active_dd_aft_#) trimlag(3) trimlead(3) ///
                together plottype(scatter) perturb(-.2 -.0)

graph save "Graph" "${wd}/analysis/figures/event_mdd21_depev_psypact.gph", replace
graph export "${wd}/analysis/figures/event_mdd21_depev_psypact.tif", as(tif) replace


**Either
*Canonical ES
eststo m11: reghdfe mdd21 compact_bef_* compact_aft_* sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss uninsured ins_miss mar_mar mar_ds mar_wid mar_miss age_35 age_45 age_55 age_65 age_miss educ_low educ_miss income_15 income_25 income_35 income_50 income_75 income_miss emp_self emp_nojob emp_home emp_stud emp_ret emp_miss perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_dd_y, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract mdd21 compact_bef_* compact_aft_*, ///
	absorb(stfips year) ///
	cohort(min_compact) ///
	control_cohort(compact_never) ///
	covariates(sex sex_miss race_bl race_oth race_miss hispanic hispanic_miss ///
             uninsured ins_miss mar_mar mar_ds mar_wid mar_miss ///
             age_35 age_45 age_55 age_65 age_miss educ_low educ_miss ///
             income_15 income_25 income_35 income_50 income_75 income_miss ///
             emp_self emp_nojob emp_home emp_stud emp_ret emp_miss ///
             perc_black perc_hispanic perc_nointernet perc_unemp ///
             perc_uninsured parity) ///
	vce(cluster stfips)
	
*Graph
event_plot e(b_iw)#e(V_iw) m11, ciplottype(rcap) ///
				graph_opt(xtitle("") xline(-1, lcolor(gs8) lpattern(dash)) ///
				yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ///
				ytitle("Major depressive disorder") ///
				title(`"`titletext'"') ///
				legend(rows(2) order(1 3) ///
				region(lstyle(none)) ///
				label(1 "S&A") label(3 "Canonical") on)) ///
				lead_opt1(msymbol(D) color(navy)) lag_opt1(msymbol(D) color(navy)) ///
				lead_opt2(color(green)) lag_opt2(color(green)) ///
				lag_ci_opt(color(gs5)) lead_ci_opt(color(gs5)) ///
				stub_lead(compact_bef_# compact_bef_#) stub_lag(compact_aft_# compact_aft_#) trimlag(3) trimlead(3) ///
                together plottype(scatter) perturb(-.2 -.0)

graph save "Graph" "${wd}/analysis/figures/event_mdd21_depev_compact.gph", replace
graph export "${wd}/analysis/figures/event_mdd21_depev_compact.tif", as(tif) replace
