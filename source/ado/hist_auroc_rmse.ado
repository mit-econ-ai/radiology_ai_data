program define hist_auroc_rmse
    version 17

    syntax, ///
	Filename(string) Rad_var(string) Alg_var(string) Xatitle(string) [Lab_pos(string) By_path]

	if !missing("`by_path'") {
	
	* --- Figure by pathology
	levelsof treatment if !missing(`rad_var')
	foreach treat in `r(levels)'{
	local i = 1
	levelsof path if !missing(`rad_var') & treatment == "`treat'"
	foreach pat in `r(levels)' {
		
		* AI value
		sum `alg_var' if path == "`pat'" & treatment == "`treat'"
		local ai_value = `r(mean)'
		* AI pctile
		sum alg_pctile if path == "`pat'" & treatment == "`treat'"
		local pctile_value = round(`r(mean)',1)
		* Range for second axis
		sum `rad_var' if path == "`pat'" & treatment == "`treat'"
		local minx = `r(min)' 
		local maxx = `r(max)'
		
		* Figure by pathology
		local i = `i' + 1
		tw hist `rad_var' if path == "`pat'" & treatment == "`treat'", bin(20) xaxis(1) ///
			scheme(plotplain) color(%50) ///
			xtitle("`pat'") xlab(,nogrid) ///
			xline(`ai_value', lw(.5)) ///
			ytitle("") xsc(range(`minx' `maxx') axis(1)) || ///
			scatteri 1 .4, msymbol(i) xaxis(2) xsc(range(`minx' `maxx') axis(2)) /// 
			xtitle("", axis(2)) ///
			xlab(`ai_value' "AI (Pct. `pctile_value')", notick labsize(medsmall) axis(2)) ||, ///
			legend(off) graphr(margin(r+5)) name("graph_`i'", replace) 
		local graphs `graphs' graph_`i'
	}
	* Grid
	graph set window fontface "Times New Roman"
	graph combine `graphs', graphr(color(white))
	gr export "`filename'", replace	
		
	}

	}
	
	else {
	keep if !missing(`rad_var') 
	
	* --- AUROC by radiologist accross the four treatment arms
	tempvar `rad_var'_pooled
	bysort radid treatment: egen ``rad_var'_pooled' = mean(`rad_var') 
	
	* --- AI value
	sum `alg_var' 
	local `alg_var'_pooled = `r(mean)'

	* --- AI pctile for labelling the graph
	tempvar `alg_var'_pctile_pooled
	egen ``alg_var'_pctile_pooled' = mean(100 *(``rad_var'_pooled' < ``alg_var'_pooled') / (``rad_var'_pooled' < .)) 
	sum ``alg_var'_pctile_pooled' 
	local `alg_var'_pctile_pooled_value = round(`r(mean)',1)

	* --- Range for X-axis based on the minimum and maximum values of rad_auroc_pooled
	sum ``rad_var'_pooled'
	local minx = `r(min)'
	local maxx = `r(max)'
	local label_position = ``alg_var'_pooled' `lab_pos'

	* --- Plotting the histogram with the format described above
	tw hist ``rad_var'_pooled', bin(20) scheme(plotplain) xline(``alg_var'_pooled', lw(.5)) ///
		xtitle("`xatitle'", size(large)) ///
		xlab(, labsize(large) nogrid) ylab(,labsize(large)) ///
		ytitle("Density", size(large)) color(%50) ///
		xsc(range(`minx' `maxx')) || ///
		scatteri 1 .7, msymbol(i) xaxis(2) xsc(range(`minx' `maxx') axis(2)) /// 
		xtitle("", axis(2)) ///
		xlab(`label_position' "AI (Pct. ``alg_var'_pctile_pooled_value')", notick labsize(large) axis(2)) ||, ///
		legend(off)

	graph set window fontface "Times New Roman"
	gr export "`filename'", replace	

	}
    
end