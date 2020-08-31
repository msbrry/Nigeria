
clear all
set more off
log using ng_data.smcl


global src "/Users/mamadou/Desktop/NG/w1/Post_Planting_Wave_1/Household/"
global sh  "/Users/mamadou/Desktop/NG/w1/Post_Harvest_Wave_1/Household/"
global com "/Users/mamadou/Desktop/NG/w1/Geodata/"
global sv  "/Users/mamadou/Desktop/NG/w1/Data"

global w2 "/Users/mamadou/Desktop/NG/w2/Post_Planting_Wave_2/Household/"
global sh2 "/Users/mamadou/Desktop/NG/w2/Post_Harvest_Wave_2/Household/"
global com2 "/Users/mamadou/Desktop/NG/w2/Geodata_Wave_2/"

global w3 "/Users/mamadou/Desktop/NG/w3/"



*-----------
* Wave 1
*-----------

* Household composition

use $src/sect1_plantingw1, clear
gen m_child=1 if s1q3==3 & s1q4<=20 & s1q2==1
gen f_child=1 if s1q3==3 & s1q4<=20 & s1q2==2
replace m_child=0 if m_child==.
replace f_child=0 if f_child==.
egen m_ch_ratio=sum(m_child), by(hhid)
egen f_ch_ratio=sum(f_child), by(hhid)
label var m_ch_ratio "Male child ratio"
label var f_ch_ratio "Female child ratio"
gen f=1 if s1q2==2
replace f=0 if f==.
egen fem_ratio=sum(f), by(hhid)
label var fem_ratio "Share of women in HH"
keep if indiv==1
gen fem_head=1 if s1q2==2
replace fem_head=0 if fem_head==.
label var fem_head "HH head is female"
tab s1q12, gen(rel_)
rename s1q4 head_age
keep zone state lga sector ea hhid m_ch_ratio f_ch_ratio fem_ratio fem_head rel_1 rel_2 rel_3 rel_4 head_age
save $sv/hh_w_1, replace

* Head's education

use $src/sect2_plantingw1, clear 
keep zone state lga sector ea hhid indiv s2q3 s2q7 s2q8
gen literacy=s2q3
replace literacy=0 if literacy==2
label var literacy "Head can read/write"
gen primary=1 if s2q8==2 
replace primary=0 if primary==.
label var primary "Primary sch is highest qualification attained"
gen secondary=1 if s2q8==3 | s2q8==5 | s2q8==6
replace secondary=0 if secondary==.
label var secondary "Secondary sch is highest qualification attained"
gen university=1 if s2q8==7 | s2q8==8 | s2q8==9 | s2q8==10 | s2q8==11 | s2q8==12
replace university=0 if university==.
label var university "Univ is highest qualification attained "
keep if indiv==1
keep zone state lga sector ea hhid literacy primary secondary university
save $sv/hh_edu_w_1, replace

* Financial services

use $src/sect4_plantingw1, clear
gen bank_acc=1 if s4q1==1
replace bank_acc=0 if s4q1==2 & bank_acc==.
label var bank_acc "Ownership of bank account"
keep if indiv==1
keep zone state lga sector ea hhid bank_acc
save $sv/fin_w_1, replace


* House conditions

use $sh/sect8_harvestw1, clear
keep zone state lga sector ea hhid s8q11 s8q17 s8q31 s8q33c s8q33a s8q36a
gen electricity=1 if s8q17==1 
replace electricity=0 if electricity==.
label var electricity "Access to electricity"
gen m_ckg_fuel=1 if s8q11==5 | s8q11==7 | s8q11==6
replace m_ckg_fuel=0 if m_ckg_fuel==.
label var m_ckg_fuel "Cooking fuel is elec, gas or kerosene"
rename s8q11 ckg_fuel
gen mob_phne=1 if s8q31==1 
replace mob_phne=0 if mob_phne==.
label var mob_phne "HH has mobile phone"
gen m_toil=1 if s8q36==3 | s8q36==4 | s8q36==8
replace m_toil=0 if m_toil==.
label var m_toil "Access to mdrn toilet facility"
gen clean_water=1 if s8q33a==1 | s8q33a==3 | s8q33a==4
replace clean_water=0 if clean_water==.
label var clean_water "Access to clean drinking water"
keep zone zone state lga sector ea hhid ckg_fuel electricity m_ckg_fuel mob_phne m_toil clean_water
save $sv/h_cond_w_1, replace


* Community level data

use $com/NGA_HouseholdGeovariables_Y1, clear
keep zone state lga sector ea hhid dist_road dist_popcenter dist_market dist_admctr
save $sv/dist_w_1, replace

* Consumption data

use  "/Users/mamadou/Desktop/NG/w1/cons_agg_wave1_visit2.dta", clear
keep wave zone state lga ea rururb hhid hhsize hhsize nfdelec nfdgas nfdfwood nfdchar nfdkero totcons
save $sv/cons_w_1, replace


* Merging wave 1 data

use $sv/dist_w_1, clear
merge 1:1 hhid using $sv/cons_w_1, gen(_mergecons)
merge 1:1 hhid using $sv/fin_w_1, gen(_mergefin)
merge 1:1 hhid using $sv/h_cond_w_1, gen(_mergecon)
merge 1:1 hhid using $sv/hh_edu_w_1, gen(_mergeedu)
merge 1:1 hhid using $sv/hh_w_1, gen(_mergehh)
drop if wave==.
drop _merge*
save $sv/ng_w_1, replace


*----------
* Wave 2
*----------

* Household composition

use $w2/sect1_plantingw2, clear
gen m_child=1 if s1q3==3 & s1q4<=20 & s1q2==1
gen f_child=1 if s1q3==3 & s1q4<=20 & s1q2==2
replace m_child=0 if m_child==.
replace f_child=0 if f_child==.
egen m_ch_ratio=sum(m_child), by(hhid)
egen f_ch_ratio=sum(f_child), by(hhid)
label var m_ch_ratio "Male child ratio"
label var f_ch_ratio "Female child ratio"
gen f=1 if s1q2==2
replace f=0 if f==.
egen fem_ratio=sum(f), by(hhid)
label var fem_ratio "Share of women in HH"
keep if indiv==1
gen fem_head=1 if s1q2==2
replace fem_head=0 if fem_head==.
label var fem_head "HH head is female"
rename s1q6 head_age
keep zone state lga sector ea hhid m_ch_ratio f_ch_ratio fem_ratio fem_head head_age
save $sv/hh_w_2, replace

* Head's education

use $w2/sect2_plantingw2, clear 
keep zone state lga sector ea hhid indiv s2q4 s2q8 s2q9
gen literacy=s2q4
replace literacy=0 if literacy==2
label var literacy "Head can read/write"
gen primary=1 if s2q9==2 
replace primary=0 if primary==.
label var primary "Primary sch is highest qualification attained"
gen secondary=1 if s2q9==3 | s2q9==5 | s2q9==6
replace secondary=0 if secondary==.
label var secondary "Secondary sch is highest qualification attained"
gen university=1 if s2q9==7 | s2q9==8 | s2q9==9 | s2q9==10 | s2q9==11 | s2q9==12
replace university=0 if university==.
label var university "Univ is highest qualification attained "
keep if indiv==1
keep zone state lga sector ea hhid literacy primary secondary university
save $sv/hh_edu_w_2, replace

* Financial services

use $w2/sect4a_plantingw2, clear
gen bank_acc=1 if s4aq1==1
replace bank_acc=0 if s4aq1==2 & bank_acc==.
label var bank_acc "Ownership of bank account"
keep if indiv==1
keep zone state lga sector ea hhid bank_acc
save $sv/fin_w_2, replace

* House conditions

use $sh2/sect8_harvestw2, clear
keep zone state lga sector ea hhid s8q11 s8q17 s8q31 s8q33a s8q36
gen electricity=1 if s8q17==1 
replace electricity=0 if electricity==.
label var electricity "Access to electricity"
gen m_ckg_fuel=1 if s8q11==5 | s8q11==7 | s8q11==6
replace m_ckg_fuel=0 if m_ckg_fuel==.
label var m_ckg_fuel "Cooking fuel is elec, gas or kerosene"
rename s8q11 ckg_fuel
gen mob_phne=1 if s8q31==1 
replace mob_phne=0 if mob_phne==.
label var mob_phne "HH has mobile phone"
gen m_toil=1 if s8q36==3 | s8q36==4 | s8q36==8
replace m_toil=0 if m_toil==.
label var m_toil "Access to mdrn toilet facility"
gen clean_water=1 if s8q33a==1 | s8q33a==3 | s8q33a==4
replace clean_water=0 if clean_water==.
label var clean_water "Access to clean drinking water"
keep zone zone state lga sector ea hhid ckg_fuel electricity m_ckg_fuel mob_phne m_toil clean_water
save $sv/h_cond_w_2, replace


* Community level data

use $com2/NGA_HouseholdGeovars_Y2, clear
keep zone state lga sector ea hhid dist_road dist_popcenter dist_market dist_admctr
save $sv/dist_w_2, replace

* Consumption data

use "/Users/mamadou/Desktop/NG/w2/cons_agg_wave2_visit2.dta", clear
keep wave zone state lga ea rururb hhid hhsize hhsize nfdelec nfdgas nfdfwood nfdchar nfdkero totcons
save $sv/cons_w_2, replace

* Merging wave 1 data

use $sv/dist_w_2, clear
merge 1:1 hhid using $sv/cons_w_2, gen(_mergecons)
merge 1:1 hhid using $sv/fin_w_2, gen(_mergefin)
merge 1:1 hhid using $sv/h_cond_w_2, gen(_mergecon)
merge 1:1 hhid using $sv/hh_edu_w_2, gen(_mergeedu)
merge 1:1 hhid using $sv/hh_w_1, gen(_mergehh)
drop if wave==.
drop _merge*
save $sv/ng_w_2, replace


*---------
* Wave 3
*---------

* Household composition

use $w3/sect1_plantingw3, clear
gen m_child=1 if s1q3==3 & s1q6<=20 & s1q2==1
gen f_child=1 if s1q3==3 & s1q6<=20 & s1q2==2
replace m_child=0 if m_child==.
replace f_child=0 if f_child==.
egen m_ch_ratio=sum(m_child), by(hhid)
egen f_ch_ratio=sum(f_child), by(hhid)
label var m_ch_ratio "Male child ratio"
label var f_ch_ratio "Female child ratio"
gen f=1 if s1q2==2
replace f=0 if f==.
egen fem_ratio=sum(f), by(hhid)
label var fem_ratio "Share of women in HH"
keep if indiv==1
gen fem_head=1 if s1q2==2
replace fem_head=0 if fem_head==.
label var fem_head "HH head is female"
rename s1q6 head_age
keep zone lga sector ea hhid m_ch_ratio f_ch_ratio fem_ratio fem_head head_age
save $sv/hh_w_3, replace


* Head's education

use $w3/sect2_harvestw3, clear 
keep zone state lga sector ea hhid indiv s2aq5 s2aq10
gen literacy=s2aq5
replace literacy=0 if literacy==2
label var literacy "Head can read/write"
gen primary=1 if s2aq10==2 
replace primary=0 if primary==.
label var primary "Primary sch is highest qualification attained"
gen secondary=1 if s2aq10==3 | s2aq10==5 | s2aq10==6
replace secondary=0 if secondary==.
label var secondary "Secondary sch is highest qualification attained"
gen university=1 if s2aq10==7 | s2aq10==8 | s2aq10==9 | s2aq10==10 | s2aq10==11 | s2aq10==12
replace university=0 if university==.
label var university "Univ is highest qualification attained "
keep if indiv==1
keep zone state lga sector ea hhid literacy primary secondary university
save $sv/hh_edu_w_3, replace


* Financial services

use $w3/sect4a_plantingw3, clear
gen bank_acc=1 if s4aq1==1
replace bank_acc=0 if s4aq1==2 & bank_acc==.
label var bank_acc "Ownership of bank account"
keep if indiv==1
keep zone state lga sector ea hhid bank_acc
save $sv/fin_w_3, replace


* House conditions

use $w3/sect11_plantingw3, clear
keep zone state lga sector ea hhid s11q17b s11q11 s11q33a s11q31 s11q36
gen electricity=1 if s11q17b==1 
replace electricity=0 if electricity==.
label var electricity "Access to electricity"
gen m_ckg_fuel=1 if s11q11==5 | s11q11==7 | s11q11==6
replace m_ckg_fuel=0 if m_ckg_fuel==.
label var m_ckg_fuel "Cooking fuel is elec, gas or kerosene"
rename s11q11 ckg_fuel
gen m_toil=1 if s11q36==3 | s11q36==4 | s11q36==8
replace m_toil=0 if m_toil==.
label var m_toil "Access to mdrn toilet facility"
gen clean_water=1 if s11q33a==1 | s11q33a==3 | s11q33a==4
replace clean_water=0 if clean_water==.
label var clean_water "Access to clean drinking water"
gen mob_phne=1 if s11q31==1 
replace mob_phne=0 if mob_phne==.
label var mob_phne "HH has mobile phone"
keep zone zone state lga sector ea hhid ckg_fuel electricity mob_phne m_ckg_fuel m_toil clean_water
save $sv/h_cond_w_3, replace


* Community level data

use $w3/NGA_HouseholdGeovars_Y3, clear
keep zone state lga sector ea hhid dist_road dist_popcenter dist_market dist_admctr
save $sv/dist_w_3, replace

* Consumption data

use $w3/cons_agg_wave3_visit2, clear
keep wave zone state lga ea rururb hhid hhsize hhsize nfdelec nfdgas nfdfwood nfdchar nfdkero totcons
save $sv/cons_w_3, replace


*--------
* Wave 4
*--------

