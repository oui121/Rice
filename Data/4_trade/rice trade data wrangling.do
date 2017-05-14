clear all
import excel "C:\Users\Piyayut\Desktop\rice trade.xlsx", sheet("exp_vol") firstrow
reshape long vol, i(month) j(year) string
destring year, replace
gen datevar = ym(year,month)
replace vol = vol/1000000
format datevar %tm
sort datevar

tsset datevar

tssmooth shwinters shw1=vol
gen lnvol = log(vol)
reg lnvol i.month L.lnvol L2.lnvol L3.lnvol L4.lnvol year


clear all
import excel "C:\Users\Piyayut\Desktop\rice trade.xlsx", sheet("exp_vol") firstrow
reshape long vol, i(month) j(year) string
destring year, replace
collapse (sum) vol, by (year)
format year %ty
replace vol = vol/1000000
tsset year

gen lnvol = log(vol)
reg lnvol L.lnvol year
