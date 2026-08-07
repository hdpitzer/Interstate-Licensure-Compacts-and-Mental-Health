clear all

global wd "/Users/Student/Library/CloudStorage/OneDrive-Emory/03 Spring 2025/Interstate Licensure"

*********************************************************************************************
* Append suicide data

import delimited "${wd}/data/input/dependent vars/CDC Wonder/stsuiciderate_2011_2020.txt", clear
save "${wd}/data/input/dependent vars/CDC Wonder/stsuiciderate_2011_2020.dta", replace

import delimited "${wd}/data/input/dependent vars/CDC Wonder/stsuiciderate_2018_2023.txt", clear
save "${wd}/data/input/dependent vars/CDC Wonder/stsuiciderate_2018_2023.dta", replace


use "${wd}/data/input/dependent vars/CDC Wonder/stsuiciderate_2011_2020.dta", clear

drop if year>=2018
append using "${wd}/data/input/dependent vars/CDC Wonder/stsuiciderate_2018_2023.dta", force
drop if year==.

drop yearcode
drop notes

rename statecode stfips

save "${wd}/data/input/dependent vars/CDC Wonder/stsuiciderate_2011_2023.dta", replace
*********************************************************************************************
* Append presribing data
forvalues year=2013/2022 {
	local year2 = `year'
	import delimited "${wd}/data/input/dependent vars/Part D/Medicare_Part_D_Prescribers_by_Geography_and_Drug_`year'", clear
	
	gen year=`year'
	
	qui compress
	
	save "${wd}/data/input/dependent vars/Part D/part_d_`year'", replace
	
}

use "${wd}/data/input/dependent vars/Part D/part_d_2013", clear

forvalues year=2014/2022 {
	append using  "${wd}/data/input/dependent vars/Part D/part_d_`year'", force
}

save  "${wd}/data/input/dependent vars/Part D/part_d_2013_2022", replace

* Calculate SSRI prescribing rate
** total prescriptions by state and year
use  "${wd}/data/input/dependent vars/Part D/part_d_2013_2022", replace
collapse (sum) tot_30day_fills, by(prscrbr_geo_desc year)
rename prscrbr_geo_desc state
save  "${wd}/data/input/dependent vars/Part D/tot_30day_fills", replace

** 1 fluoxetine precriptions by state and year 
use  "${wd}/data/input/dependent vars/Part D/part_d_2013_2022", replace
collapse (sum) tot_30day_fills if strpos(gnrc_name, "Fluoxetine"), by(prscrbr_geo_desc year)
rename tot_30day_fills flu_30day_fills
rename prscrbr_geo_desc state
save  "${wd}/data/input/dependent vars/Part D/flu_30day_fills", replace

** 2 paroxetine precriptions by state and year 
use  "${wd}/data/input/dependent vars/Part D/part_d_2013_2022", replace
collapse (sum) tot_30day_fills if strpos(gnrc_name, "Paroxetine"), by(prscrbr_geo_desc year)
rename tot_30day_fills par_30day_fills
rename prscrbr_geo_desc state
save  "${wd}/data/input/dependent vars/Part D/par_30day_fills", replace

** 3 sertraline precriptions by state and year 
use  "${wd}/data/input/dependent vars/Part D/part_d_2013_2022", replace
collapse (sum) tot_30day_fills if strpos(gnrc_name, "Sertraline"), by(prscrbr_geo_desc year)
rename tot_30day_fills ser_30day_fills
rename prscrbr_geo_desc state
save  "${wd}/data/input/dependent vars/Part D/ser_30day_fills", replace

** 4 citalopram precriptions by state and year 
use  "${wd}/data/input/dependent vars/Part D/part_d_2013_2022", replace
collapse (sum) tot_30day_fills if strpos(gnrc_name, "Citalopram"), by(prscrbr_geo_desc year)
rename tot_30day_fills cit_30day_fills
rename prscrbr_geo_desc state
save  "${wd}/data/input/dependent vars/Part D/cit_30day_fills", replace

** 5 escitalopram precriptions by state and year 
use  "${wd}/data/input/dependent vars/Part D/part_d_2013_2022", replace
collapse (sum) tot_30day_fills if strpos(gnrc_name, "Escitalopram"), by(prscrbr_geo_desc year)
rename tot_30day_fills esc_30day_fills
rename prscrbr_geo_desc state
save  "${wd}/data/input/dependent vars/Part D/esc_30day_fills", replace

use "${wd}/data/input/dependent vars/Part D/tot_30day_fills", clear
merge m:1 state using "${wd}/data/input/stlookup", keep(1 3) keepusing(stfips)

merge 1:1 state year using "${wd}/data/input/dependent vars/Part D/flu_30day_fills", keep(1 3) nogen
merge 1:1 state year using "${wd}/data/input/dependent vars/Part D/par_30day_fills", keep(1 3) nogen
merge 1:1 state year using "${wd}/data/input/dependent vars/Part D/ser_30day_fills", keep(1 3) nogen
merge 1:1 state year using "${wd}/data/input/dependent vars/Part D/cit_30day_fills", keep(1 3) nogen
merge 1:1 state year using "${wd}/data/input/dependent vars/Part D/esc_30day_fills", keep(1 3) nogen

drop if stfips==.
drop if stfips==72

gen tot_ssri_fills = flu_30day_fills + par_30day_fills + ser_30day_fills + cit_30day_fills + esc_30day_fills
gen ssri_prscr_rate = (tot_ssri_fills/tot_30day_fills)

save  "${wd}/data/input/dependent vars/Part D/part_d_2013_2022_clean", replace


*********************************************************************************************
*Merge state datasets

use "${wd}/data/input/dependent vars/CDC Wonder/stsuiciderate_2011_2023.dta", clear
merge 1:1 stfips year using "${wd}/data/input/dependent vars/Part D/part_d_2013_2022_clean", keep(1 3) nogen

replace ageadjustedrate = ageadjustedrate/100

merge m:1 state year using "${wd}/data/input/controls/demographics_acs/demographics_2011_2023", keep(1 3) nogen
merge m:1 state year using "${wd}/data/input/controls/employment_acs/employment_2011_2023", keep(1 3) nogen
merge m:1 state year using "${wd}/data/input/controls/insurance_acs/insurance_2011_2023", keep(1 3) nogen
merge m:1 state year using "${wd}/data/input/controls/internet_acs/internet_2011_2023", keep(1 3) nogen

merge m:1 state using "${wd}/data/input/controls/telehealth_dates", keep(1 3) nogen

foreach var in effective_start effective_end {
	
	gen `var'_d = 0
		replace `var'_d = 1 if year>= year(`var') & `var' !=.
		replace `var'_d = 0 if year== year(`var') & month(`var')>=7
	
}
rename effective_start_d parity_start
rename effective_end_d parity_end

gen parity = parity_start
	replace parity = 0 if parity_end==1
	


save "${wd}/data/output/clean_state_2011_2023_master.dta", replace


merge m:1 state using "${wd}/data/input/independent var/compact_dates", keep(1 3) nogen

foreach var in imlc_enacted psypact_enacted psypact_active {
	
	gen `var'_dd = 0
		replace `var'_dd = 1 if year>= year(`var') & `var' !=.
		replace `var'_dd = 0 if year== year(`var') & month(`var')>=7
	
}


replace imlc_enacted_dd=0 if year<2017
replace imlc_enacted_dd=0 if year==2017 & month(imlc_enacted)<4

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




save "${wd}/data/output/clean_state_2011_2023_master.dta", replace




use "${wd}/data/output/clean_state_2011_2023_master", clear

merge m:1 state using "${wd}/data/input/controls/covid_reciprocity", keep(1 3) nogen

foreach var in OOSstart OOSend Telehealthstart Telehealthend {
	
	gen `var'_d = 0
		replace `var'_d = 1 if year>= year(`var') & `var' !=.
		replace `var'_d = 0 if year== year(`var') & month(`var')>=7
	
}

gen oos = OOSstart_d
	replace oos = 0 if OOSend_d==1
gen tele = Telehealthstart_d
	replace tele = 0 if Telehealthend_d==1

	
save "${wd}/data/output/clean_state_2011_2023_master2.dta", replace

