cd "/Users/albertoguzman-alvarez/Desktop"

use "/Users/albertoguzman-alvarez/Box Sync/Geography and Higher Ed/Berto Texas 072919/hs_coordinates.dta"
rename newid market_id



import delimited "/Users/albertoguzman-alvarez/Desktop/Projects/inProgress/2019_eddeserts_cluster/quality.csv",clear
keep market_id clusters
save "/Users/albertoguzman-alvarez/Desktop/Projects/inProgress/2019_eddeserts_cluster/quality.dta", replace


import delimited "/Users/albertoguzman-alvarez/Desktop/Projects/inProgress/2019_eddeserts_cluster/affordability.csv", clear
keep market_id clusters_aff
save "/Users/albertoguzman-alvarez/Desktop/Projects/inProgress/2019_eddeserts_cluster/affordability.dta", replace





use "/Users/albertoguzman-alvarez/Box Sync/Geography and Higher Ed/Berto Texas 072919/hs_coordinates.dta",clear 
merge 1:1 market_id using "/Users/albertoguzman-alvarez/Desktop/Projects/inProgress/2019_eddeserts_cluster/quality.dta"
keep if _merge == 3
drop _merge
merge 1:1 market_id using "/Users/albertoguzman-alvarez/Desktop/Projects/inProgress/2019_eddeserts_cluster/affordability.dta"
keep if _merge == 3
drop _merge
recode   clusters (0=1) (1=3) (2=2)
recode   clusters_aff (0=3) (1=2) (2=1)


save "/Users/albertoguzman-alvarez/Desktop/Projects/inProgress/2019_eddeserts_cluster/highschools_ARCGIS.dta",replace
export excel using "/Users/albertoguzman-alvarez/Desktop/highschools_ARCGIS.xls", firstrow(variables) nolabel replace


count
*9,689

*postsecondary file
use "/Users/albertoguzman-alvarez/Desktop/Projects/inProgress/2019_eddeserts_cluster/latlong.dta"

export excel using "/Users/albertoguzman-alvarez/Desktop/Projects/inProgress/2019_eddeserts_cluster/postsecondary_ARCGIS.xls", firstrow(variables) nolabel replace
