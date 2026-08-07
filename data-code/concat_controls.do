clear all

global wd "/Users/Student/Library/CloudStorage/OneDrive-Emory/03 Spring 2025/Interstate Licensure"


** Demographics

forvalues year=2011/2016 {
    local year2 = `year'
	import delimited "${wd}/data/input/controls/demographics_acs/ACSDP1Y`year2'.DP05-Data.csv", clear
	
	gen year=`year'
	
	qui compress
	
	keep v2 v241 v265 year
	
	rename v2 state
	rename v241 perc_black
	rename v265 perc_hispanic
	
	save "${wd}/data/input/controls/demographics_acs/demographics_`year'", replace
	
}

import delimited "${wd}/data/input/controls/demographics_acs/ACSDP1Y2017.DP05-Data.csv", clear
	
	gen year=2017
	
	qui compress
	
	keep v2 v261 v285 year
	
	rename v2 state
	rename v261 perc_black
	rename v285 perc_hispanic
	
save "${wd}/data/input/controls/demographics_acs/demographics_2017", replace
	

forvalues year=2018/2019 {
    local year2 = `year'
	import delimited "${wd}/data/input/controls/demographics_acs/ACSDP1Y`year2'.DP05-Data.csv", clear
	
	gen year=`year'
	
	qui compress
	
	keep v2 v309 v321 year
	
	rename v2 state
	rename v309 perc_black
	rename v321 perc_hispanic
	
	save "${wd}/data/input/controls/demographics_acs/demographics_`year'", replace
	
}


import delimited "${wd}/data/input/controls/demographics_acs/ACSDP1Y2021.DP05-Data.csv", clear
	
	gen year=2021
	
	qui compress
	
	keep v2 v309 v321 year
	
	rename v2 state
	rename v309 perc_black
	rename v321 perc_hispanic
	
save "${wd}/data/input/controls/demographics_acs/demographics_2021", replace
	

import delimited "${wd}/data/input/controls/demographics_acs/ACSDP1Y2022.DP05-Data.csv", clear
	
	gen year=2022
	
	qui compress
	
	keep v2 v317 v329 year
	
	rename v2 state
	rename v317 perc_black
	rename v329 perc_hispanic
	
save "${wd}/data/input/controls/demographics_acs/demographics_2022", replace
	

import delimited "${wd}/data/input/controls/demographics_acs/ACSDP1Y2023.DP05-Data.csv", clear
	
	gen year=2023
	
	qui compress
	
	keep v2 v329 v341 year
	
	rename v2 state
	rename v329 perc_black
	rename v341 perc_hispanic
	
	
save "${wd}/data/input/controls/demographics_acs/demographics_2023", replace
	
	
	

use "${wd}/data/input/controls/demographics_acs/demographics_2011", clear

forvalues year=2012/2019 {
    append using "${wd}/data/input/controls/demographics_acs/demographics_`year'", force
}
forvalues year=2021/2023 {
    append using "${wd}/data/input/controls/demographics_acs/demographics_`year'", force
}

drop if state=="NAME"
drop if state=="Geographic Area Name"

destring perc_black, replace
destring perc_hispanic, replace

append using "${wd}/data/input/controls/demographics_acs/demographics_2020", force

replace perc_black = perc_black/100
replace perc_hispanic = perc_hispanic/100

save "${wd}/data/input/controls/demographics_acs/demographics_2011_2023", replace




** Employment
clear

forvalues year=2011/2017 {
    local year2 = `year'
	import delimited "${wd}/data/input/controls/employment_acs/ACSDP1Y`year2'.DP03-Data.csv", clear
	
	gen year=`year'
	
	qui compress
	
	keep v2 v37 year
	
	rename v2 state
	rename v37 perc_unemp
	
	save "${wd}/data/input/controls/employment_acs/employment_`year'", replace
	
}

forvalues year=2018/2019 {
    local year2 = `year'
	import delimited "${wd}/data/input/controls/employment_acs/ACSDP1Y`year2'.DP03-Data.csv", clear
	
	gen year=`year'
	
	qui compress
	
	keep v2 v293 year
	
	rename v2 state
	rename v293 perc_unemp
	
	save "${wd}/data/input/controls/employment_acs/employment_`year'", replace
	
}

forvalues year=2021/2023 {
    local year2 = `year'
	import delimited "${wd}/data/input/controls/employment_acs/ACSDP1Y`year2'.DP03-Data.csv", clear
	
	gen year=`year'
	
	qui compress
	
	keep v2 v293 year
	
	rename v2 state 
	rename v293 perc_unemp
	
	save "${wd}/data/input/controls/employment_acs/employment_`year'", replace
	
}



use "${wd}/data/input/controls/employment_acs/employment_2011", clear

forvalues year=2012/2019 {
    append using "${wd}/data/input/controls/employment_acs/employment_`year'", force
}
forvalues year=2021/2023 {
    append using "${wd}/data/input/controls/employment_acs/employment_`year'", force
}

drop if state=="NAME"
drop if state=="Geographic Area Name"

destring perc_unemp, replace

append using "${wd}/data/input/controls/employment_acs/employment_2020", force

replace perc_unemp = perc_unemp/100

save "${wd}/data/input/controls/employment_acs/employment_2011_2023", replace




*Insurance
clear

forvalues year=2011/2014 {
    local year2 = `year'
	import delimited "${wd}/data/input/controls/insurance_acs/ACSST1Y`year2'.S2701-Data.csv", clear
	
	gen year=`year'
	
	qui compress
	
	keep v2 v7 year

	rename v2 state
	rename v7 perc_uninsured
	
	save "${wd}/data/input/controls/insurance_acs/insurance_`year'", replace
	
}

forvalues year=2015/2017 {
    local year2 = `year'
	import delimited "${wd}/data/input/controls/insurance_acs/ACSST1Y`year2'.S2701-Data.csv", clear
	
	gen year=`year'
	
	qui compress
	
	keep v2 v11 year

	rename v2 state
	rename v11 perc_uninsured
	
	save "${wd}/data/input/controls/insurance_acs/insurance_`year'", replace
	
}

import delimited "${wd}/data/input/controls/insurance_acs/ACSST1Y2018.S2701-Data.csv", clear
	
	gen year=2018
	
	qui compress
	
	keep v2 v131 year

	rename v2 state
	rename v131 perc_uninsured
	
save "${wd}/data/input/controls/insurance_acs/insurance_2018", replace
	

import delimited "${wd}/data/input/controls/insurance_acs/ACSST1Y2019.S2701-Data.csv", clear
	
	gen year=2019
	
	qui compress
	
	keep v2 v491 year

	rename v2 state
	rename v491 perc_uninsured
	
save "${wd}/data/input/controls/insurance_acs/insurance_2019", replace
	

forvalues year=2021/2023 {
    local year2 = `year'
	import delimited "${wd}/data/input/controls/insurance_acs/ACSST1Y`year2'.S2701-Data.csv", clear
	
	gen year=`year'
	
	qui compress
	
	keep v2 v491 year

	rename v2 state
	rename v491 perc_uninsured
	
	save "${wd}/data/input/controls/insurance_acs/insurance_`year'", replace
	
}


use "${wd}/data/input/controls/insurance_acs/insurance_2011", clear

forvalues year=2012/2019 {
    append using "${wd}/data/input/controls/insurance_acs/insurance_`year'", force
}
forvalues year=2021/2023 {
    append using "${wd}/data/input/controls/insurance_acs/insurance_`year'", force
}

drop if state=="NAME"
drop if state=="Geographic Area Name"

destring perc_uninsured, replace

append using "${wd}/data/input/controls/insurance_acs/insurance_2020", force

replace perc_uninsured = perc_uninsured/100

save "${wd}/data/input/controls/insurance_acs/insurance_2011_2023", replace


*Internet
clear

forvalues year=2013/2015 {
    local year2 = `year'
	import delimited "${wd}/data/input/controls/internet_acs/ACSDT1Y`year2'.B28002-Data.csv", clear
	
	gen year=`year'
	
	qui compress
	
	keep v2 v3 v43 year

	rename v2 state
	rename v3 total_pop
	rename v43 no_internet_pop
	
	save "${wd}/data/input/controls/internet_acs/internet_`year'", replace
	
}

forvalues year=2016/2019 {
    local year2 = `year'
	import delimited "${wd}/data/input/controls/internet_acs/ACSDT1Y`year2'.B28002-Data.csv", clear
	
	gen year=`year'
	
	qui compress
	
	keep v2 v3 v27 year

	rename v2 state
	rename v3 total_pop
	rename v27 no_internet_pop
	
	save "${wd}/data/input/controls/internet_acs/internet_`year'", replace
	
}

forvalues year=2021/2023 {
    local year2 = `year'
	import delimited "${wd}/data/input/controls/internet_acs/ACSDT1Y`year2'.B28002-Data.csv", clear
	
	gen year=`year'
	
	qui compress
	
	keep v2 v3 v27 year

	rename v2 state
	rename v3 total_pop
	rename v27 no_internet_pop
	
	save "${wd}/data/input/controls/internet_acs/internet_`year'", replace
	
}


use "${wd}/data/input/controls/internet_acs/internet_2013", clear

forvalues year=2014/2019 {
    append using "${wd}/data/input/controls/internet_acs/internet_`year'", force
}
forvalues year=2021/2023 {
    append using "${wd}/data/input/controls/internet_acs/internet_`year'", force
}


save "${wd}/data/input/controls/internet_acs/internet_2013_2023", replace



drop if state=="NAME"
drop if state=="Geographic Area Name"

destring total_pop no_internet_pop, replace

append using "${wd}/data/input/controls/internet_acs/internet_2020", force


gen perc_nointernet= (no_internet_pop/total_pop)*100

keep state perc_nointernet year
order state perc_nointernet year

save "${wd}/data/input/controls/internet_acs/internet_2013_2023", replace


import excel "${wd}/data/input/controls/internet_acs/internet_2011.xls", clear
	
	gen year=2011
	
	keep A F year
	
	rename A state
	rename F perc_internet
	
	drop if year==2011 & perc_internet==""
	drop if state=="United States"
	drop if perc_internet=="Percent"
	
	destring perc_internet, replace
	
	gen perc_nointernet= (100-perc_internet)
	
	keep state perc_nointernet year
	order state perc_nointernet year
	
save "${wd}/data/input/controls/internet_acs/internet_2011", replace

import excel "${wd}/data/input/controls/internet_acs/internet_2012.xls", clear
	
	gen year=2012
	
	keep A D year
	
	rename A state
	rename D perc_internet
	
	drop if year==2012 & perc_internet==""
	drop if state=="United States"
	drop if perc_internet=="Percent"
	
	destring perc_internet, replace
	
	gen perc_nointernet= (100-perc_internet)
	
	keep state perc_nointernet year
	order state perc_nointernet year
	
save "${wd}/data/input/controls/internet_acs/internet_2012", replace


use "${wd}/data/input/controls/internet_acs/internet_2013_2023", clear

forvalues year=2011/2012 {
    append using "${wd}/data/input/controls/internet_acs/internet_`year'", force
}

replace perc_nointernet = perc_nointernet/100

save "${wd}/data/input/controls/internet_acs/internet_2011_2023", replace
	
	