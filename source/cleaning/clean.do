*------------------------------------------------------------------------------*
* Purpose: Load data and clean 
* Authors : Angelo Kisil Marino > Manasi Kutwal > Ray Huang
* Inputs : data_public.dta
* Outputs: cleaned/experiment.dta
*------------------------------------------------------------------------------*
cap log close

* --- Load raw file for cleaning
use "source/data/data_public.dta", clear

* Drop if row has warmup string in treatment column
drop if treatment == "warmup"

* Drop gt cases
* Drop row if uid_clean column contains the string gt
local gt_rads "gt_us_1 gt_us_2 gt_us_3 gt_us_4 gt_us_5 gt_vietnam_1 gt_vietnam_2 gt_vietnam_3 gt_vietnam_4 gt_vietnam_5"
foreach rad of local gt_rads {
    drop if uid_clean == "`rad'"
}

* --- Encode string variables for analysis
encode patient_id, gen(npatientid)
encode treatment, gen(ntreatment)
encode pathology, gen(npathology)
encode uid, gen(nuid)
gen _radid = substr(uid_clean,1,length(uid_clean) - 2) 
encode _radid, gen(radid)

* --- Discretizes AI signal by 5 bins
egen bins_ai_5 = cut(alg_pred), at(0,.2,.4,.6,.8,1) icodes 
replace bins_ai_5 =bins_ai_5 + 1

* --- Discretizes AI signal by 3 bins
egen bins_ai_3 = cut(alg_pred), at(0,.3,.7,1) icodes 
replace bins_ai_3 =bins_ai_3 + 1

* --- Discretizes AI accuracy(compared to the ground truth) by 5 bins
tempvar dev_ai_gt
gen `dev_ai_gt' = abs(alg_pred - gt_binary_simple_us)
egen bins_ai_gt = cut(`dev_ai_gt'), at(0,.2,.4,.6,.8,1) icodes 
replace bins_ai_gt = bins_ai_gt+1 

* --- Winsorize effort variables (To limit extreme values)
winsor active_time, p(.05) gen(active_time_w5)
winsor num_clicks, p(.05) gen(num_clicks_w5)
	
* --- Dummy for incentivized radiologists
gen incentivized = 1 if incentive_round == 1
replace incentivized = 0 if incentive_round == 1000

* --- Redefine pathology label to use in figures
split pathology, p(_)
replace pathology2 = proper(pathology2)
replace pathology3 = "(shoulders)" if pathology1 == "68"
replace pathology3 = "(ribs)" if pathology1 == "58"
gen path = pathology2 + " " + pathology3 + " " + pathology4 + " " +  pathology5
drop pathology1- pathology6 _radid 

* --- Calibrated radiologist probabilities (to simple US ground truth) for top-level pathologies
preserve
    keep if level == 0 & !inlist(pathology, "106_abnormal", "78_support_device_hardware") & !missing(alg_pred)
    logit gt_binary_simple_us i.npathology##c.probability##i.radid
    predict pr_gt_binary_simple_us
restore

predict robust_rad_prob

* --- Segregate the top 3 conditions mentioned in post-experiment questionnaire from other frequently mentioned conditions 
foreach word in "no trauma" "no pneumonia" "no infect" edema sepsis "chest pain" frac interstitial cardiac fever {
	tempvar `word'
	egen ``word'' = incss(ch_indication), sub(`word') insensitive
}
	gen top_three = .
	foreach var of varlist `no trauma'-`no infect'{
		replace top_three = 1 if `var' == 1
	}
	replace top_three = 0 if top_three == .

	gen word_cloud = .
	foreach var of varlist `edema'-`fever'{
		replace word_cloud = 1 if `var' == 1
	}
	replace word_cloud = 0 if word_cloud == .

	gen not_word_cloud = .
	foreach var of varlist `no trauma'-`fever'{
		replace not_word_cloud = 0 if `var' == 1
	}
	replace not_word_cloud = 1 if not_word_cloud == .

	gen trauma = 1 if `no trauma' == 1
	replace trauma = 0 if trauma == .
	
	gen infection = 1 if `no infect' == 1
	replace infection = 0 if infection == .
	
	gen pneumonia = 1 if `no pneumonia' == 1
	replace pneumonia = 0 if pneumonia == .

	drop __000*


* --- Generate variable for experiment sessions
egen sess = group(design experiment_session)
tab sess, gen (sess_)
gen sess_d = . 
foreach x in 1 2 3 4 5 6 {
    replace sess_d = `x' if sess_`x' == 1
}
drop sess_1 - sess_6


save "source/data/data_cleaned.dta", replace
