
clear all

global wd "/Users/Student/Library/CloudStorage/OneDrive-Emory/03 Spring 2025/Interstate Licensure"

** Merge compacts

use "${wd}/data/output/clean_brfss_2011_2023", clear

merge m:1 stfips using "${wd}/data/input/stlookup", keep(1 3) keepusing(state)

merge m:1 state using "${wd}/data/input/independent var/compact_dates", keep(1 3) nogen

gen mdy = mdy(month, day, year)

foreach var in imlc_enacted psypact_enacted psypact_active {
	
	gen `var'_dd = 0
		replace `var'_dd = 1 if mdy>= mdy(month(`var'), day(`var'), year(`var')) & `var' !=.
	
}

replace imlc_enacted_dd=0 if mdy< mdy(4, 1, 2017)


gen compact = imlc_enacted_dd
replace compact = 1 if psypact_active_dd==1




foreach var in imlc_enacted psypact_enacted psypact_active {
	
	gen `var'_ffy = 0
		replace `var'_ffy = 1 if year>= year(`var') & `var' !=.
		replace `var'_ffy = 0 if year== year(`var') & month(`var')>1
	
}


replace imlc_enacted_ffy=0 if year<=2017

gen compact_ffy = imlc_enacted_ffy
replace compact_ffy = 1 if psypact_active_ffy==1


save "${wd}/data/output/clean_brfss_2011_2023_compact.dta", replace


** Merge controls

merge m:1 state year using "${wd}/data/input/controls/demographics_acs/demographics_2011_2023", keep(1 3) nogen
merge m:1 state year using "${wd}/data/input/controls/employment_acs/employment_2011_2023", keep(1 3) nogen
merge m:1 state year using "${wd}/data/input/controls/insurance_acs/insurance_2011_2023", keep(1 3) nogen
merge m:1 state year using "${wd}/data/input/controls/internet_acs/internet_2011_2023", keep(1 3) nogen


save "${wd}/data/output/clean_brfss_2011_2023_master.dta", replace

use "${wd}/data/output/clean_brfss_2011_2023_master", clear
drop _merge

merge m:1 state using "${wd}/data/input/controls/telehealth_dates", keep(1 3) nogen

foreach var in effective_start effective_end {
	
	gen `var'_d = 0
		replace `var'_d = 1 if mdy>= mdy(month(`var'), day(`var'), year(`var')) & `var' !=.
	
}
rename effective_start_d parity_start
rename effective_end_d parity_end

gen parity = parity_start
	replace parity = 0 if parity_end==1

save "${wd}/data/output/clean_brfss_2011_2023_master.dta", replace



use "${wd}/data/output/clean_brfss_2011_2023_master", clear

merge m:1 state using "${wd}/data/input/controls/covid_reciprocity", keep(1 3) nogen

foreach var in OOSstart OOSend Telehealthstart Telehealthend {
	
	gen `var'_d = 0
		replace `var'_d = 1 if mdy>= mdy(month(`var'), day(`var'), year(`var')) & `var' !=.
	
}

gen oos = OOSstart_d
	replace oos = 0 if OOSend_d==1
gen tele = Telehealthstart_d
	replace tele = 0 if Telehealthend_d==1

	
save "${wd}/data/output/clean_brfss_2011_2023_master2.dta", replace
