

* Confounding, spillovers, and interactions influence estimates of social distancing policy effects

* Master do file for main estimates


cd "[CHANGE TO WORKING DIRECTORY]"

* Construct databases

* Epidemeological data
run "Dataset/COVID/DoFile_CleanPanelCOVID.do"
* Lockdown data
run "Dataset/Lockdowns/DoFile_CleanLockdowns.do"
* Facebook mobility data
run "Dataset/Facebook/DoFile_CleanFBMovementRange.do"

* Analysis

* Main analysis
run "Analysis/DoFile_analysis.do"

* Regression tables
run "Analysis/DoFile_regressiontable.do"
