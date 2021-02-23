* Project: WB COVID
* Created on: July 2020
* Created by: jdm
* Stata v.16.1

* does
	* establishes an identical workspace between users
	* sets globals that define absolute paths
	* serves as the starting point to find any do-file, dataset or output
	* loads any user written packages needed for analysis

* assumes
	* access to all data and code
	

* **********************************************************************
* 0 - setup
* **********************************************************************

* set $pack to 0 to skip package installation
	global 			pack 	0
		
* Specify Stata version in use
    global 			stataVersion 16.1    // set Stata version
    version 		$stataVersion

	
* **********************************************************************
* 0 (a) - Create user specific paths
* **********************************************************************

* Define root folder globals
	if `"`c(username)'"' == "USERNAME" {
		global 		code  	"C:/Users/USERNAME/git/evolving_impacts_covid_africa"
		global 		data	"C:/Users/USERNAME/evolving_impacts/data"
		global 		output  "C:/Users/USERNAME/evolving_impacts/output"
		global		ans		"$data/analysis"
	}

	
* **********************************************************************
* 0 (b) - Check if any required packages are installed:
* **********************************************************************

* install packages if global is set to 1
if $pack == 1 {
	
	* for packages/commands, make a local containing any required packages
		loc userpack "catplot grc1leg2 palettes"
	
	* install packages that are on ssc	
		foreach package in `userpack' {
			capture : which `package', all
			if (_rc) {
				capture window stopbox rusure "You are missing some packages." "Do you want to install `package'?"
				if _rc == 0 {
					capture ssc install `package', replace
					if (_rc) {
						window stopbox rusure `"This package is not on SSC. Do you want to proceed without it?"'
					}
				}
				else {
					exit 199
				}
			}
		}

	* update all ado files
		ado update, update

	* set graph and Stata preferences
		set scheme plotplain, perm
		set more off
}


* **********************************************************************
* 1 - run household data cleaning .do file
* **********************************************************************

	do 			"$code/analysis/pnl_cleaning.do"  
	
	
* **********************************************************************
* 2 - run analysis .do file
* **********************************************************************

	do 			"$code/analysis/evolving_impact.do" 

	
/* END */