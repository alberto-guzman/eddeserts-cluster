local direcotry 





*Runs files to do the routing
clear
do "/Users/albertoguzman-alvarez/Box Sync/Geography and Higher Ed/Berto Texas 072919/osrmtime_online/osrmtime.ado"
do "/Users/albertoguzman-alvarez/Box Sync/Geography and Higher Ed/Berto Texas 072919/osrmtime_online/osrmprepare.ado"
do "/Users/albertoguzman-alvarez/Box Sync/Geography and Higher Ed/Berto Texas 072919/osrmtime_online/osrminterface.ado"

*Sets working directory
cd "/Users/albertoguzman-alvarez/Box Sync/Geography and Higher Ed/Berto Texas 072919"
set more off


*download geofabrik map and prepare map file
osrmprepare, mapfile("/Users/albertoguzman-alvarez/Box Sync/Geography and Higher Ed/Berto Texas 072919/texas-latest.osm.pbf") osrmdir("/Users/albertoguzman-alvarez/osrm-backend/build") profile(car)

*import private school data
import excel "C:\Users\djl73\Box Sync\Geography and sdgher Ed\geocodes\EDGE_GEOCODE_PRIVATESCH_15_16\EDGE_GEOCODE_PRIVATESCH_1516.xlsx", sheet("Joined") firstrow case(lower) clear
save "C:\Users\djl73\Box Sync\Geography and sdgher Ed\masterpriv.dta", replace



*creating file that has ipid lat and long for each school
*can easily recreate this file or just use the one provided
*saves a file that has one of the private schools
****run loop for private school data
forvalues num=1/1177 {
	use "/Users/albertoguzman-alvarez/Box Sync/Geography and Higher Ed/masterpriv.dta", clear
	keep if pl_stabb=="TX"
	keep ppin lat1516 lon1516
	rename lat1516 lat_priv
	rename lon1516 lon_priv
	sort ppin
	gen count = _n
	keep if count==`num'
	save "/Users/albertoguzman-alvarez/Desktop/tx_priv`num'.dta", replace
}

*runs calculations
*takes a temp file for each and every high school
*appends it to a file that has all postsecondary institions


forvalues num=1/1177 {
    use "/Users/albertoguzman-alvarez/Box Sync/Geography and Higher Ed/masterpostsec.dta", clear
    keep if stabbr=="TX"
    keep unitid lat lon
    rename lat lat
    rename lon lon
    append using "/Users/albertoguzman-alvarez/Desktop/tx_priv`num'.dta"

    replace lat_priv = lat_priv[_N]
    replace lon_priv = lon_priv[_N]
    replace ppin = ppin[_N]

    drop if lon==.

    osrmtime lat_priv lon_priv lat lon, mapfile("/Users/albertoguzman-alvarez/Desktop/texas-latest.osrm") osrmdir("/Users/albertoguzman-alvarez/osrm-backend-5.14.0/build/") nocleanup

    replace duration = duration/60
    keep unitid lat lon ppin lat_priv lon_priv duration
    keep if duration <=60

    save "/Users/albertoguzman-alvarez/Desktop/tx`num'.dta", replace
}


*save out files


*PSEUCO CODE

*import file that has cordinated of very college in texas
 *import college.tx, ID lat long

*import every high school
 *import highschool.tx, ID lat_2 long_2


 for every college in college.tx
    for every hs in hslist.tx   
        e_dis = calculate_euclid_dis(college, hs, id)
            if e_dis < 200 miles
                r_dis = calculate_route_dis(college, hs)
                append to some table and keep ID
            else 
                continue loop 

                
