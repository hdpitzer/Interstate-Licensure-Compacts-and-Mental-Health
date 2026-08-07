clear all

global wd "/Users/Student/Library/CloudStorage/OneDrive-Emory/03 Spring 2025/Interstate Licensure"

use "${wd}/data/output/clean_state_2011_2023_master.dta", clear



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



***Suicide rate
**IMLC
*Canonical ES
eststo m1: reghdfe ageadjustedrate imlc_enacted_ffy_bef_* imlc_enacted_ffy_aft_* psypact_active_ffy perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_ffy_y, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract ageadjustedrate imlc_enacted_ffy_bef_* imlc_enacted_ffy_aft_*, ///
	absorb(stfips year) ///
	cohort(min_imlc_enacted_ffy) ///
	control_cohort(imlc_enacted_ffy_never) ///
	covariates(psypact_active_ffy perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) ///
	vce(cluster stfips)
	
matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)

*Graph
event_plot m1 sa_b#sa_v , ciplottype(rcap) ///
				graph_opt(xtitle("") xline(-1, lcolor(gs8) lpattern(dash)) ///
				yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ///
				ytitle("Suicide rate") ///
				title(`"`titletext'"') ///
				legend(rows(2) order(1 3) ///
				region(lstyle(none)) ///
				label(1 "Canonical") label(3 "S&A") on)) ///
				lead_opt1(msymbol(D) color(navy)) lag_opt1(msymbol(D) color(navy)) ///
				lead_opt2(color(green)) lag_opt2(color(green)) ///
				lag_ci_opt(color(gs5)) lead_ci_opt(color(gs5)) ///
				stub_lead(imlc_enacted_ffy_bef_# imlc_enacted_ffy_bef_#) stub_lag(imlc_enacted_ffy_aft_# imlc_enacted_ffy_aft_#) trimlag(3) trimlead(3) ///
                together plottype(scatter) perturb(-.2 -.0)

graph save "Graph" "${wd}/analysis/figures/event_suicide_imlc.gph", replace
graph export "${wd}/analysis/figures/event_suicide_imlc.tif", as(tif) replace

**PSYPACT
*Canonical ES
eststo m2: reghdfe ageadjustedrate psypact_active_ffy_bef_* psypact_active_ffy_aft_* imlc_enacted_ffy perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity psypact_active_ffy_y, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract ageadjustedrate psypact_active_ffy_bef_* psypact_active_ffy_aft_*, ///
	absorb(stfips year) ///
	cohort(min_psypact_active_ffy) ///
	control_cohort(psypact_active_ffy_never) ///
	covariates(imlc_enacted_ffy perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) ///
	vce(cluster stfips)

matrix sa_b2 = e(b_iw)
matrix sa_v2 = e(V_iw)

*Graph
event_plot m2 sa_b2#sa_v2 , ciplottype(rcap) ///
				graph_opt(xtitle("") xline(-1, lcolor(gs8) lpattern(dash)) ///
				yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ///
				ytitle("Suicide rate") ///
				title(`"`titletext'"') ///
				legend(rows(2) order(1 3) ///
				region(lstyle(none)) ///
				label(1 "Canonical") label(3 "S&A") on)) ///
				lead_opt1(msymbol(D) color(navy)) lag_opt1(msymbol(D) color(navy)) ///
				lead_opt2(color(green)) lag_opt2(color(green)) ///
				lag_ci_opt(color(gs5)) lead_ci_opt(color(gs5)) ///
				stub_lead(psypact_active_ffy_bef_# psypact_active_ffy_bef_#) stub_lag(psypact_active_ffy_aft_# psypact_active_ffy_aft_#) trimlag(3) trimlead(3) ///
                together plottype(scatter) perturb(-.2 -.0)

graph save "Graph" "${wd}/analysis/figures/event_suicide_psypact.gph", replace
graph export "${wd}/analysis/figures/event_suicide_psypact.tif", as(tif) replace

**Either
*Canonical ES
eststo m3: reghdfe ageadjustedrate compact_ffy_bef_* compact_ffy_aft_* perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity compact_ffy_y, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract ageadjustedrate compact_ffy_bef_* compact_ffy_aft_*, ///
	absorb(stfips year) ///
	cohort(min_compact_ffy) ///
	control_cohort(compact_ffy_never) ///
	covariates(perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) ///
	vce(cluster stfips)
	
matrix sa_b3 = e(b_iw)
matrix sa_v3 = e(V_iw)

*Graph
event_plot m3 sa_b3#sa_v3 , ciplottype(rcap) ///
				graph_opt(xtitle("") xline(-1, lcolor(gs8) lpattern(dash)) ///
				yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ///
				ytitle("Suicide rate") ///
				title(`"`titletext'"') ///
				legend(rows(2) order(1 3) ///
				region(lstyle(none)) ///
				label(1 "Canonical") label(3 "S&A") on)) ///
				lead_opt1(msymbol(D) color(navy)) lag_opt1(msymbol(D) color(navy)) ///
				lead_opt2(color(green)) lag_opt2(color(green)) ///
				lag_ci_opt(color(gs5)) lead_ci_opt(color(gs5)) ///
				stub_lead(compact_ffy_bef_# compact_ffy_bef_#) stub_lag(compact_ffy_aft_# compact_ffy_aft_#) trimlag(3) trimlead(3) ///
                together plottype(scatter) perturb(-.2 -.0)

graph save "Graph" "${wd}/analysis/figures/event_suicide_compact.gph", replace
graph export "${wd}/analysis/figures/event_suicide_compact.tif", as(tif) replace



***SSRI rate
**IMLC
*Canonical ES
eststo m4: reghdfe ssri_prscr_rate imlc_enacted_ffy_bef_* imlc_enacted_ffy_aft_* psypact_active_ffy perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity imlc_enacted_ffy_y, absorb(stfips year) cluster(stfips)

*SA ES
eventstudyinteract ssri_prscr_rate imlc_enacted_ffy_bef_* imlc_enacted_ffy_aft_*, ///
	absorb(stfips year) ///
	cohort(min_imlc_enacted_ffy) ///
	control_cohort(imlc_enacted_ffy_never) ///
	covariates(psypact_active_ffy perc_black perc_hispanic perc_nointernet perc_unemp perc_uninsured parity) ///
	vce(cluster stfips) 
	
matrix sa_b4 = e(b_iw)
matrix sa_v4 = e(V_iw)

*Graph
event_plot m4 sa_b4#sa_v4 , ciplottype(rcap) ///
	graph_opt(xtitle("") xline(-1, lcolor(gs8) lpattern(dash)) ///
	yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ///
	ytitle("SSRI prescribing rate") ///
	title(`"`titletext'"') ///
	legend(rows(2) order(1 3) ///
	region(lstyle(none)) ///
	label(1 "Canonical") label(3 "S&A") on)) ///
	lead_opt1(msymbol(D) color(navy)) lag_opt1(msymbol(D) color(navy)) ///
	lead_opt2(color(green)) lag_opt2(color(green)) ///
	lag_ci_opt(color(gs5)) lead_ci_opt(color(gs5)) ///
	stub_lead(imlc_enacted_ffy_bef_# imlc_enacted_ffy_bef_#) stub_lag(imlc_enacted_ffy_aft_# imlc_enacted_ffy_aft_#) trimlag(3) trimlead(3) ///
	together plottype(scatter) perturb(-.2 -.0)

graph save "Graph" "${wd}/analysis/figures/event_rx_imlc.gph", replace
graph export "${wd}/analysis/figures/event_rx_imlc.tif", as(tif) replace

