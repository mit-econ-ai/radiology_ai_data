import excel "C:\Users\mkutwal\OneDrive - Massachusetts Institute of Technology\Documents\AI Project\debrief_responses.xlsx", sheet("Sheet1") firstrow clear

*--- AI Influence
foreach tool in ai ph {
	generate order = 1 if `tool'_pathology_present == "Strongly Agree"
	replace order = 2 if `tool'_pathology_present == "Agree"
	replace order = 3 if `tool'_pathology_present == "Neutral"
	replace order = 4 if `tool'_pathology_present == "Disagree"
	replace order = 4 if `tool'_pathology_present == "Strongly Disagree"
	
	graph hbar, over(`tool'_pathology_present, sort(order)) ///
	scheme(plotplain) ///
	title("Influenced the assessment" "of which pathologies were present") ///
	name("`tool'_as", replace)

	graph hbar, over(`tool'_treatment) ///
	scheme(plotplain) ///
	title("Influenced the" "treatment/follow-up recommendation") ///
	name("`tool'_dec", replace)

	graph hbar, over(`tool'_effort) ///
	scheme(plotplain) /// 
	title("Influenced the" "effort exerted overall") ///
	name("`tool'_eff", replace)

	graph combine `tool'_as `tool'_dec `tool'_eff, graphregion(color(white))

	graph set window fontface "Times New Roman"
	
	*graph export "C:/Users/mkutwal/Dropbox (MIT)/data_rts/draft/manuscript/dataset_documentation/`tool'_influence.pdf", replace
}

