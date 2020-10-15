* Created: 7/29/2019 3:00:16 PM                            
* Modify the path below to point to your data file.		
* The specified subdirectory was not created on			
* your computer. You will need to do this.				
*														
* This read program must be ran against the specified	
* data file. This file is specified in the program		
* and must be saved separately.							
*														
* This program does not provide tab or summaries for all	
* variables.                                             
*														
* There may be missing data for some institutions due    
* to the merge used to create this file.					
*														
* This program does not include reserved values in its   
* calculations for missing values.			            
*														
* You may need to adjust your memory settings depending  
* upon the number of variables and records.				
*														
* The save command may need to be modified per user		
* requirements.											
*														
* For long lists of value labels, the titles may be		
* shortened per program requirements.                    
*	
insheet using "/Users/albertoguzman-alvarez/Desktop/STATA_RV_7292019-942.csv", clear
label data STATA_RV_7292019_942
label variable unitid "UNITID"
label variable instnm "Institution Name"
label variable year "Survey year 2017"
label variable stabbr "State abbreviation"
label variable instnm "Institution (entity) name"
label variable ialias "Institution name alias"
label variable fips "FIPS state code"
label variable longitud "Longitude location of institution"
label variable latitude "Latitude location of institution"

/* label define label_stabbr AL "Alabama"
label values stabbr label_stabbr
label define label_stabbr AK "Alaska", add
label values stabbr label_stabbr
label define label_stabbr AZ "Arizona", add
label values stabbr label_stabbr
label define label_stabbr AR "Arkansas", add
label values stabbr label_stabbr
label define label_stabbr CA "California", add
label values stabbr label_stabbr
label define label_stabbr CO "Colorado", add
label values stabbr label_stabbr
label define label_stabbr CT "Connecticut", add
label values stabbr label_stabbr
label define label_stabbr DE "Delaware", add
label values stabbr label_stabbr
label define label_stabbr DC "District of Columbia", add
label values stabbr label_stabbr
label define label_stabbr FL "Florida", add
label values stabbr label_stabbr
label define label_stabbr GA "Georgia", add
label values stabbr label_stabbr
label define label_stabbr HI "Hawaii", add
label values stabbr label_stabbr
label define label_stabbr ID "Idaho", add
label values stabbr label_stabbr
label define label_stabbr IL "Illinois", add
label values stabbr label_stabbr
label define label_stabbr IN "Indiana", add
label values stabbr label_stabbr
label define label_stabbr IA "Iowa", add
label values stabbr label_stabbr
label define label_stabbr KS "Kansas", add
label values stabbr label_stabbr
label define label_stabbr KY "Kentucky", add
label values stabbr label_stabbr
label define label_stabbr LA "Louisiana", add
label values stabbr label_stabbr
label define label_stabbr ME "Maine", add
label values stabbr label_stabbr
label define label_stabbr MD "Maryland", add
label values stabbr label_stabbr
label define label_stabbr MA "Massachusetts", add
label values stabbr label_stabbr
label define label_stabbr MI "Michigan", add
label values stabbr label_stabbr
label define label_stabbr MN "Minnesota", add
label values stabbr label_stabbr
label define label_stabbr MS "Mississippi", add
label values stabbr label_stabbr
label define label_stabbr MO "Missouri", add
label values stabbr label_stabbr
label define label_stabbr MT "Montana", add
label values stabbr label_stabbr
label define label_stabbr NE "Nebraska", add
label values stabbr label_stabbr
label define label_stabbr NV "Nevada", add
label values stabbr label_stabbr
label define label_stabbr NH "New Hampshire", add
label values stabbr label_stabbr
label define label_stabbr NJ "New Jersey", add
label values stabbr label_stabbr
label define label_stabbr NM "New Mexico", add
label values stabbr label_stabbr
label define label_stabbr NY "New York", add
label values stabbr label_stabbr
label define label_stabbr NC "North Carolina", add
label values stabbr label_stabbr
label define label_stabbr ND "North Dakota", add
label values stabbr label_stabbr
label define label_stabbr OH "Ohio", add
label values stabbr label_stabbr
label define label_stabbr OK "Oklahoma", add
label values stabbr label_stabbr
label define label_stabbr OR "Oregon", add
label values stabbr label_stabbr
label define label_stabbr PA "Pennsylvania", add
label values stabbr label_stabbr
label define label_stabbr RI "Rhode Island", add
label values stabbr label_stabbr
label define label_stabbr SC "South Carolina", add
label values stabbr label_stabbr
label define label_stabbr SD "South Dakota", add
label values stabbr label_stabbr
label define label_stabbr TN "Tennessee", add
label values stabbr label_stabbr
label define label_stabbr TX "Texas", add
label values stabbr label_stabbr
label define label_stabbr UT "Utah", add
label values stabbr label_stabbr
label define label_stabbr VT "Vermont", add
label values stabbr label_stabbr
label define label_stabbr VA "Virginia", add
label values stabbr label_stabbr
label define label_stabbr WA "Washington", add
label values stabbr label_stabbr
label define label_stabbr WV "West Virginia", add
label values stabbr label_stabbr
label define label_stabbr WI "Wisconsin", add
label values stabbr label_stabbr
label define label_stabbr WY "Wyoming", add
label values stabbr label_stabbr
label define label_stabbr AS "American Samoa", add
label values stabbr label_stabbr
label define label_stabbr FM "Federated States of Micronesia", add
label values stabbr label_stabbr
label define label_stabbr GU "Guam", add
label values stabbr label_stabbr
label define label_stabbr MH "Marshall Islands", add
label values stabbr label_stabbr
label define label_stabbr MP "Northern Marianas", add
label values stabbr label_stabbr
label define label_stabbr PW "Palau", add
label values stabbr label_stabbr
label define label_stabbr PR "Puerto Rico", add
label values stabbr label_stabbr
label define label_stabbr VI "Virgin Islands", add
label values stabbr label_stabbr
 */
label define label_fips 1 "Alabama"
label values fips label_fips
label define label_fips 2 "Alaska", add
label values fips label_fips
label define label_fips 4 "Arizona", add
label values fips label_fips
label define label_fips 5 "Arkansas", add
label values fips label_fips
label define label_fips 6 "California", add
label values fips label_fips
label define label_fips 8 "Colorado", add
label values fips label_fips
label define label_fips 9 "Connecticut", add
label values fips label_fips
label define label_fips 10 "Delaware", add
label values fips label_fips
label define label_fips 11 "District of Columbia", add
label values fips label_fips
label define label_fips 12 "Florida", add
label values fips label_fips
label define label_fips 13 "Georgia", add
label values fips label_fips
label define label_fips 15 "Hawaii", add
label values fips label_fips
label define label_fips 16 "Idaho", add
label values fips label_fips
label define label_fips 17 "Illinois", add
label values fips label_fips
label define label_fips 18 "Indiana", add
label values fips label_fips
label define label_fips 19 "Iowa", add
label values fips label_fips
label define label_fips 20 "Kansas", add
label values fips label_fips
label define label_fips 21 "Kentucky", add
label values fips label_fips
label define label_fips 22 "Louisiana", add
label values fips label_fips
label define label_fips 23 "Maine", add
label values fips label_fips
label define label_fips 24 "Maryland", add
label values fips label_fips
label define label_fips 25 "Massachusetts", add
label values fips label_fips
label define label_fips 26 "Michigan", add
label values fips label_fips
label define label_fips 27 "Minnesota", add
label values fips label_fips
label define label_fips 28 "Mississippi", add
label values fips label_fips
label define label_fips 29 "Missouri", add
label values fips label_fips
label define label_fips 30 "Montana", add
label values fips label_fips
label define label_fips 31 "Nebraska", add
label values fips label_fips
label define label_fips 32 "Nevada", add
label values fips label_fips
label define label_fips 33 "New Hampshire", add
label values fips label_fips
label define label_fips 34 "New Jersey", add
label values fips label_fips
label define label_fips 35 "New Mexico", add
label values fips label_fips
label define label_fips 36 "New York", add
label values fips label_fips
label define label_fips 37 "North Carolina", add
label values fips label_fips
label define label_fips 38 "North Dakota", add
label values fips label_fips
label define label_fips 39 "Ohio", add
label values fips label_fips
label define label_fips 40 "Oklahoma", add
label values fips label_fips
label define label_fips 41 "Oregon", add
label values fips label_fips
label define label_fips 42 "Pennsylvania", add
label values fips label_fips
label define label_fips 44 "Rhode Island", add
label values fips label_fips
label define label_fips 45 "South Carolina", add
label values fips label_fips
label define label_fips 46 "South Dakota", add
label values fips label_fips
label define label_fips 47 "Tennessee", add
label values fips label_fips
label define label_fips 48 "Texas", add
label values fips label_fips
label define label_fips 49 "Utah", add
label values fips label_fips
label define label_fips 50 "Vermont", add
label values fips label_fips
label define label_fips 51 "Virginia", add
label values fips label_fips
label define label_fips 53 "Washington", add
label values fips label_fips
label define label_fips 54 "West Virginia", add
label values fips label_fips
label define label_fips 55 "Wisconsin", add
label values fips label_fips
label define label_fips 56 "Wyoming", add
label values fips label_fips
label define label_fips 60 "American Samoa", add
label values fips label_fips
label define label_fips 64 "Federated States of Micronesia", add
label values fips label_fips
label define label_fips 66 "Guam", add
label values fips label_fips
label define label_fips 68 "Marshall Islands", add
label values fips label_fips
label define label_fips 69 "Northern Marianas", add
label values fips label_fips
label define label_fips 70 "Palau", add
label values fips label_fips
label define label_fips 72 "Puerto Rico", add
label values fips label_fips
label define label_fips 78 "Virgin Islands", add
label values fips label_fips

tab stabbr
tab fips

summarize longitud
summarize latitude


save cdsfile_all_STATA_RV_7292019-942.dta
