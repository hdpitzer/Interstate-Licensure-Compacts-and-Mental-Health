clear all

global wd "/Users/Student/Library/CloudStorage/OneDrive-Emory/03 Spring 2025/Interstate Licensure"

ssc install ftools
ssc install reghdfe


use "${wd}/data/output/clean_brfss_2011_2023_master.dta", clear
drop if mdy==.

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

***Poor mental health days

**Total population
jwdid menthlth imlc_enacted_dd, tvar(year) gvar(imlc_enacted_dd_y) never method(poisson) vce(cluster stfips)

summ menthlth if e(sample)
estadd scalar mean = r(mean)

eststo reg1


jwdid menthlth psypact_active_dd, tvar(year) gvar(psypact_active_dd_y) never method(poisson)

summ menthlth if e(sample)
estadd scalar mean = r(mean)

eststo reg2


jwdid menthlth compact, tvar(year) gvar(compact_y) never method(poisson)

summ menthlth if e(sample)
estadd scalar mean = r(mean)

eststo reg3



estout reg1 reg2 reg3 using "${wd}/analysis/tables/pmhd_jwdid1.csv", style(tab) replace label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd) order(imlc_enacted_dd psypact_active_dd compact) stats(N mean , fmt(%6.0f %8.2f) labels("Observations" "Mean dependent variable")) cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers



**Ever diagnosed with depression population
jwdid menthlth imlc_enacted_dd if depev==1, tvar(year) gvar(imlc_enacted_dd_y) never method(poisson) vce(cluster stfips)

summ menthlth if e(sample)
estadd scalar mean = r(mean)

eststo reg4


jwdid menthlth psypact_active_dd if depev==1, tvar(year) gvar(psypact_active_dd_y) never method(poisson) vce(cluster stfips)

summ menthlth if e(sample)
estadd scalar mean = r(mean)

eststo reg5


jwdid menthlth compact if depev==1, tvar(year) gvar(compact_y) never method(poisson) vce(cluster stfips)

summ menthlth if e(sample)
estadd scalar mean = r(mean)

eststo reg6



estout reg4 reg5 reg6 using "${wd}/analysis/tables/pmhd_jwdid2.csv", style(tab) replace label delimiter(",") keep(compact imlc_enacted_dd psypact_active_dd) order(imlc_enacted_dd psypact_active_dd compact) stats(N mean , fmt(%6.0f %8.2f) labels("Observations" "Mean dependent variable")) cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers





