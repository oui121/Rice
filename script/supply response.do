clear all
cd "C:\Users\Piyayut\Google Drive\OAE\Rice-OAE"
import excel "data\1_prod.xlsx", sheet("1") firstrow

tsset year

replace yp = prod*1000/pa
replace yh = prod*1000/ha

foreach var of varlist pa-value {
	gen ln`var' = log(`var')
}

gen lnrf = log(rf)

reg lnpa L.lnpa L.lnprice
reg lnyp lnrf year
