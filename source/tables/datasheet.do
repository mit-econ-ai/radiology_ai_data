cap program drop summ_tables
program define summ_tables
	
	syntax [using], ///
	TEXmacro(string) ///
	[ ///
		replace Append ///
		Variable(string)  Format(string) ///
		Cond(string) ///
	]
	
    * Parse file action
    if !missing("`replace'") & !missing("`append'") {
        di as error "{bf:replace} and {bf:append} may not be specified simultaneously"
        exit 198
    }
    local action `replace' `append'

    * Set default format
    if missing("`format'" ) {
        local format %12.3f
    }
    else local format "`format'"	

    * Add backslash to macroname and issue warning if doesn't contain only alph
    local isalph = regexm("`texmacro'","^[a-zA-Z ]*$")
    local texmacro = "\" + "`texmacro'"
    if `isalph' == 0 di as text `""`texmacro'" may not be a valid LaTeX macro name"'

    * String to local
    local variable `variable'

    summarize `variable' 

    * Mean
    scalar mean = string(r(mean), "`format'")
    local mean = scalar(mean)

    * Standard Deviation
    scalar sd = string(r(sd), "`format'")
    local sd = scalar(sd)

    * Minimum
    scalar min = string(r(min), "`format'")
    local min = scalar(min)

    * Maximum
    scalar max = string(r(max), "`format'")
    local max = scalar(max)

    * Observations
    scalar obs = string(r(N), "%12.0fc")
    local obs = scalar(obs)

    * Create or modify macros file
    *------------------------------------------------------------------------------
    file open sum_file `using', write `action'
    file write sum_file "\newcommand{`texmacro'mean}{$`mean'$}" _n
    file write sum_file "\newcommand{`texmacro'sd}{$`sd'$}" _n
    file write sum_file "\newcommand{`texmacro'min}{$`min'$}" _n
    file write sum_file "\newcommand{`texmacro'max}{$`max'$}" _n
    file write sum_file "\newcommand{`texmacro'obs}{$`obs'$}" _n
    file close sum_file

end

cap program drop datasheet_summary
program define datasheet_summary
    syntax, ///
	macros_file(string) var(string) [replace_first] 
	
	* --- Replace tex if first reg
	if missing("`replace_first'") {
	    local decision append
	}
	else {
	    local decision replace
	}

	* --- LaTex macros
    if "`var'" == "weight"{
        local decision replace 
    }
	summ_tables using "`macros_file'", texmacro("`var'") variable(`var') `decision' 
end


use "source/data/data_cleaned.dta", clear
local macro_file "output/tables/patient_summ.tex"

* One observation of patient cases
bysort npatientid: keep if _n == 1 

rename ch_* * 
foreach var of varlist weight temp {
    preserve
    drop if `var' == "Unknown"
    destring `var', replace
    /*if "`var'" == "weight" {
        local table_replace replace_first
    }*/
    datasheet_summary, macros_file(`macro_file') var("`var'") `table_replace'
    restore
}

foreach var of varlist pulse age {
    datasheet_summary, macros_file(`macro_file') var("`var'") 
}

split bp, p(/)
destring bp1, gen(bpsy)
destring bp2, gen(bpdi) ignore("mmHg")
foreach var of varlist bpsy bpdi {
    datasheet_summary, macros_file(`macro_file') var("`var'") 
}

