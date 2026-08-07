clear all


global brfsspath "/Users/Student/Library/CloudStorage/OneDrive-Emory/brfss_downloads_1993_2023"

global wd "/Users/Student/Library/CloudStorage/OneDrive-Emory/03 Spring 2025/Interstate Licensure"





forvalues year=2011/2023 {
	local year2 = `year'
	import sasxport5 "${brfsspath}/SAS Transport/LLCP`year'.xpt", clear
	
	gen year=`year'
	
	qui compress
	
	save "${brfsspath}/Stata Data/rawbrfss_`year'", replace
	
}


use "${brfsspath}/Stata Data/rawbrfss_2011", clear

forvalues year=2012/2023 {
    append using "${brfsspath}/Stata Data/rawbrfss_`year'", force
}

save "${wd}/data/input/dependent vars/BRFSS/raw_brfss_2011_2023", replace


*************************************************************************************
ren _state stfips
gen month=real(imonth)
gen day=real(iday)

drop if stfips>56


*Sex, 0=F 1=M
replace sex = sex1 if sex==.
replace sex = sexvar if sex==.
replace sex = . if sex==7
replace sex = . if sex==9
replace sex = 0 if sex==2

gen sex_miss = (sex==.)

*Race and Ethnicity
gen race_wh=(_racegr2==1 | _racegr3==1 | _racegr4==1)
gen race_bl=(_racegr2==2 | _racegr3==2 | _racegr4==2)
gen race_oth=(inlist(_racegr2,3,4) | inlist(_racegr3,3,4) | inlist(_racegr4,3,4))
gen race_miss=(inlist(_racegr2,9) | inlist(_racegr3,9) | inlist(_racegr4,9) | _racegr2==. & _racegr3==. & _racegr4==.)


*replace hispanic=1 if hispanc2==1
*replace hispanic=0 if inlist(hispanic,2,7,9)
gen hispanic=(_hispanc==1 | hispanc2==1)
gen hispanic_miss = (_hispanc==9 | hispanc2==9)


*Education
*gen educ_lths=(inlist(educa,1,2,3))
*gen educ_hs=(educa==4)
*gen educ_sc=(inlist(educa,4,5,6))
*gen educ_ba=(inlist(educa,7,8))
*gen educ_miss=(inlist(educa,9,.))

gen educ_low=(inlist(educa,1,2,3,4)) /* <=hs */
gen educ_mid=(educa==5) /*some college*/
gen educ_high=(educa==6) /* >=ba */
gen educ_miss=(inlist(educa,9,.))


*Employment
gen emp_wages=(employ==1 | employ1==1)
gen emp_self=(employ==2 | employ1==2)
gen emp_nojob=(inlist(employ,3,4,8) | inlist(employ1,3,4,8))
gen emp_home=(employ==5 | employ1==5)
gen emp_stud=(employ==6 | employ1==6)
gen emp_ret=(employ==7 | employ1==7)
gen emp_miss=(employ==9 | employ1==9 | employ==. & employ1==.)


*Marital Status
gen mar_mar=(marital==1)
gen mar_ds=(inlist(marital,2,4))
gen mar_wid=(marital==3)
gen mar_nm=(inlist(marital,5,6))
gen mar_miss=(inlist(marital,9,.))


*Health Insurance
gen insured=(hlthpln1==1 | _hlthpln==1 | _hlthpl1==1)
gen uninsured=(hlthpln1==2 | _hlthpln==2 | _hlthpl1==2)
gen ins_miss=(inlist(hlthpln1,7,9) | _hlthpln==9 | _hlthpl1==9 | hlthpln1==. & _hlthpln==. & _hlthpl1==.)


*Age
gen age_18=(inlist(_ageg5yr,1,2,3))
gen age_35=(inlist(_ageg5yr,4,5))
gen age_45=(inlist(_ageg5yr,6,7))
gen age_55=(inlist(_ageg5yr,8,9))
gen age_65=(inlist(_ageg5yr,10,11,12,13))
gen age_miss=(_ageg5yr==14)


*Income
gen incomecat=.
	replace incomecat=income2 if year<2021
	replace incomecat=income3 if year>2020
	
gen income_15=(inlist(incomecat,1,2)) /* Less than 15,000 */
gen income_25=(inlist(incomecat,3,4)) /* 15,000 to < 25,000 */
gen income_35=(incomecat==5) /* 25,000 to < 35,000 */
gen income_50=(incomecat==6) /* 35,000 to < 50,000 */
gen income_75=(incomecat==7) /* 50,000 to < 75,000 */
gen income_75p=(inlist(incomecat,8,9,10,11)) /* 75,000+ */
gen income_miss=(inlist(incomecat,77,99,.))
	
	
	
*Self-Reported Health
replace genhlth=. if inlist(genhlth,7,9)	

replace menthlth=. if inlist(menthlth,77,99)
	replace menthlth=0 if menthlth==88
	
replace physhlth=. if inlist(physhlth,77,99)
	replace physhlth=0 if physhlth==88	
	

drop if menthlth==.

gen mdd14=(menthlth>=14) /* MDD >= 2 consecutive weeks poor menthlth */
gen mdd21=(menthlth>=21)
gen nobaddays=(menthlth==0)



*Depressive disorder ever
gen depev=.
	replace depev=addepev2 if year<2019
	replace depev=addepev3 if year>2018
	
replace depev=0 if depev==2
replace depev=. if inlist(depev,7,9)



save "${wd}/data/output/raw_brfss_2011_2023", replace

*****************************************************************************************


keep stfips idate year month day sex sex_miss age_* race_* hispanic hispanic_miss educ_* emp_* mar_* insured uninsured ins_miss income_* genhlth physhlth menthlth mdd14 mdd21 nobaddays depev
	
	
order stfips idate year month day sex sex_miss age_* race_* hispanic hispanic_miss educ_* emp_* mar_* insured uninsured ins_miss income_* genhlth physhlth menthlth mdd14 mdd21 nobaddays depev

save "${wd}/data/output/clean_brfss_2011_2023", replace
