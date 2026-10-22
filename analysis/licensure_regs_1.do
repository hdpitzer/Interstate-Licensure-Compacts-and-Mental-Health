clear all 

global wd "/Volumes/Untitled/Interstate Licensure"

*********************************************************************

use "${wd}/data/output/licensure_full_2017_2023", clear

** Limit to PCP and MH 

gen psychiatrist = 0

foreach var in specialty1 specialty2 specialty3 specialty4 specialty5 specialty6 specialty7 specialty8 {
	replace psychiatrist = 1 if strpos(lower(`var'), "psychiatr")
}


gen psychologist = 0

foreach var in specialty1 specialty2 specialty3 specialty4 specialty5 specialty6 specialty7 specialty8 {
	replace psychologist = 1 if strpos(lower(`var'), "psycholog")
}


gen pcp = 0

foreach var in specialty1 specialty2 specialty3 specialty4 specialty5 specialty6 specialty7 specialty8 {
	replace pcp = 1 if ///
		strpos(lower(`var'), "family") | ///
		strpos(lower(`var'), "internal medicine") | ///
		strpos(lower(`var'), "general practice") | ///
		strpos(lower(`var'), "pediatric")
}

keep if psychiatrist | psychologist | pcp


** Additional cleaning

drop if graduationyear>year

gen grad_cohort = floor(graduationyear/10)*10

gen female = 0
replace female = 1 if gender == "F"

save "${wd}/data/output/licensure_ch1_2017_2023", replace


*********************************************************************
***************************************************************************
*** MAIN LICENSURE MODELS
***************************************************************************

gen multistate = n_unique_states > 1 if !missing(n_unique_states)

eststo clear

*** COUNT OLS

* PCP
reghdfe n_unique_states imlc_enacted_dd if pcp == 1, ///
    absorb(npi year) cluster(npi)
summ n_unique_states if e(sample)
estadd scalar mean = r(mean)
eststo count_pcp

* Psychiatry
reghdfe n_unique_states imlc_enacted_dd if psychiatrist == 1, ///
    absorb(npi year) cluster(npi)
summ n_unique_states if e(sample)
estadd scalar mean = r(mean)
eststo count_psych

* Psychology
reghdfe n_unique_states psypact_active_dd if psychologist == 1, ///
    absorb(npi year) cluster(npi)
summ n_unique_states if e(sample)
estadd scalar mean = r(mean)
eststo count_psy


*** LPM: MULTI-STATE LICENSURE

* PCP
reghdfe multistate imlc_enacted_dd if pcp == 1, ///
    absorb(npi year) cluster(npi)
summ multistate if e(sample)
estadd scalar mean = r(mean)
eststo lpm_pcp

* Psychiatry
reghdfe multistate imlc_enacted_dd if psychiatrist == 1, ///
    absorb(npi year) cluster(npi)
summ multistate if e(sample)
estadd scalar mean = r(mean)
eststo lpm_psych

* Psychology
reghdfe multistate psypact_active_dd if psychologist == 1, ///
    absorb(npi year) cluster(npi)
summ multistate if e(sample)
estadd scalar mean = r(mean)
eststo lpm_psy


***************************************************************************
*** ORDERED LOGIT + AVERAGE MARGINAL EFFECTS
***************************************************************************

gen lic_cat = n_unique_states
replace lic_cat = 4 if n_unique_states >= 4
label define lic_cat_lbl 1 "1 state" 2 "2 states" 3 "3 states" 4 "4+ states"
label values lic_cat lic_cat_lbl


ologit lic_cat imlc_enacted_dd i.year if pcp==1 & year>2017, vce(cluster npi)

tab lic_cat if e(sample)

margins, dydx(imlc_enacted_dd) predict(outcome(1))
margins, dydx(imlc_enacted_dd) predict(outcome(2))
margins, dydx(imlc_enacted_dd) predict(outcome(3))
margins, dydx(imlc_enacted_dd) predict(outcome(4))
eststo reg13

ologit lic_cat imlc_enacted_dd i.year if psychiatrist==1 & year>2017, vce(cluster npi)

tab lic_cat if e(sample)

margins, dydx(imlc_enacted_dd) predict(outcome(1))
margins, dydx(imlc_enacted_dd) predict(outcome(2))
margins, dydx(imlc_enacted_dd) predict(outcome(3))
margins, dydx(imlc_enacted_dd) predict(outcome(4))
eststo reg14

ologit lic_cat psypact_active_dd i.year if psychologist==1 & year>2017, vce(cluster npi)

tab lic_cat if e(sample)

margins, dydx(psypact_active_dd) predict(outcome(1))
margins, dydx(psypact_active_dd) predict(outcome(2))
margins, dydx(psypact_active_dd) predict(outcome(3))
margins, dydx(psypact_active_dd) predict(outcome(4))
eststo reg15



// estout reg13 reg14 reg15 using "${wd}/analysis/tables/ch1/lic_num_ologit.csv", style(tab) replace label delimiter(",") keep(imlc_enacted_dd psypact_active_dd) order(imlc_enacted_dd psypact_active_dd) stats(N mean, fmt(%6.0f %8.2f) labels("Observations" "Mean dependent variable")) cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) mlabels(none) nonumbers

