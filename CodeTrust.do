
foreach var in a06 a10 a11 a23 a24 a26 a27 a31 a32 a38 a41 a44 a46 a47 {
    replace `var' = 10 - `var'
}

gen female= .
replace female = 0 if a49 == "男性"
replace female = 1 if a49 == "女性"

gen edu = .
replace edu = 1 if a50 == "小學及以下"
replace edu = 2 if a50 == "初中"
replace edu = 3 if a50 == "高中/中專/職業學校"
replace edu = 4 if a50 == "本科"
replace edu = 5 if a50 == "碩士"
replace edu = 6 if a50 == "博士"

gen religion = .
replace religion = 1 if a51 == "伊斯蘭教"
replace religion = 2 if a51 == "佛教"
replace religion = 3 if a51 == "基督教"
replace religion = 4 if a51 == "道教"
replace religion = 5 if a51 == "天主教"
replace religion = 6 if a51 == "无宗教信仰"
gen religious_belief = .
replace religious_belief = 1 if inlist(religion, 1, 2, 3, 4, 5)
replace religious_belief = 0 if religion == 6
tabulate religious_belief

gen occupation = .
replace occupation = 1 if a52 == "雇主"
replace occupation = 2 if a52 == "自雇"
replace occupation = 3 if a52 == "經理"
replace occupation = 4 if a52 == "專業人員"
replace occupation = 5 if a52 == "非專業人員"
replace occupation = 6 if a52 == "失業"
replace occupation = 7 if a52 == "非任職"

gen institution = .
replace institution = 1 if a53 == "政府"
replace institution = 2 if a53 == "政府資助"
replace institution = 3 if a53 == "私營"
replace institution = 4 if a53 == "沒有特定機構"
gen in_government = .
replace in_government = 1 if inlist(institution, 1, 2)
replace in_government = 0 if inlist(institution, 3, 4)
tabulate in_government

//
gen family_status = .
replace family_status = 1 if a54 == "1=已婚，有子女"
replace family_status = 2 if a54 == "2=已婚，無子女"
replace family_status = 3 if a54 == "3=單身，有子女"
replace family_status = 4 if a54 == "4=單身，無子女"


gen drinking_frequency = .
replace drinking_frequency = 0 if a55 == "不飲酒"
replace drinking_frequency = 1 if a55 == "一年一次"
replace drinking_frequency = 2 if a55 == "一月一次"
replace drinking_frequency = 3 if a55 == "一週一次"
replace drinking_frequency = 4 if a55 == "一周多次"

gen smoking_frequency = .
replace smoking_frequency = 0 if a56 == "不抽煙"
replace smoking_frequency = 1 if a56 == "一年一次"
replace smoking_frequency = 2 if a56 == "一月一次"
replace smoking_frequency = 3 if a56 == "一週一次"
replace smoking_frequency = 4 if a56 == "一周多次"
gen drinking_binary = 0 if drinking_frequency == 0
replace drinking_binary = 1 if drinking_frequency > 0
gen smoking_binary = 0 if smoking_frequency == 0
replace smoking_binary = 1 if smoking_frequency > 0
tabulate drinking_binary
tabulate smoking_binary

gen permanent_resident = .
replace permanent_resident = 1 if a57 == "是"
replace permanent_resident = 0 if a57 == "否"

destring a48, replace

* 定义变量列表
local WeekTrust a02 a03 a04 a05 a06
local WeekSupport a07 a08 a09 a10 a11
local Hypo2 a12 a13 a14 a15
local Hypo3 a16 a17 a18 a19 a20
local Hypo4 a21 a22 a23 a24
local Hypo1 a25 a26 a27
local MonthSupport a28 a29 a30 a31 a32
local Openness a33 a34 a35
local Conscientiousness a36 a37 a38
local Extraversion a39 a40 a41
local Agreeableness a42 a43 a44
local Neuroticism a45 a46 a47

* 计算各量表的总和
egen total_WeekTrust = rowtotal(`WeekTrust')
egen total_WeekSupport = rowtotal(`WeekSupport')
egen total_Hypo2 = rowtotal(`Hypo2')
egen total_Hypo3 = rowtotal(`Hypo3')
egen total_Hypo4 = rowtotal(`Hypo4')
egen total_Hypo1 = rowtotal(`Hypo1')
egen total_MonthSupport = rowtotal(`MonthSupport')
egen total_Openness = rowtotal(`Openness')
egen total_Conscientiousness = rowtotal(`Conscientiousness')
egen total_Extraversion = rowtotal(`Extraversion')
egen total_Agreeableness = rowtotal(`Agreeableness')
egen total_Neuroticism = rowtotal(`Neuroticism')

alpha `WeekTrust'
alpha `WeekSupport'
alpha `Hypo2'
alpha `Hypo3'
alpha `Hypo4'
alpha `Hypo1'
alpha `MonthSupport'
alpha `Openness'
alpha `Conscientiousness'
alpha `Extraversion'
alpha `Agreeableness'
alpha `Neuroticism'


alpha a02 a03 a04 a05 a06
alpha a07 a08 a09 a10 a11
alpha a28 a29 a30 a31 a32

* 运行多元线性回归
regress total_WeekTrust total_Hypo2 total_Hypo3 total_Hypo4 total_Hypo1,beta

pwcorr total_WeekTrust total_Hypo2 total_Hypo3 total_Hypo4 total_Hypo1, sig

regress total_WeekTrust total_Hypo2 total_Hypo3 total_Hypo4 total_Hypo1 female edu a48 in_government permanent_resident,beta

regress total_WeekTrust female edu a48 in_government permanent_resident,beta

regress total_WeekTrust total_Openness total_Conscientiousness total_Extraversion total_Agreeableness total_Neuroticism, beta
pwcorr total_WeekTrust total_Openness total_Conscientiousness total_Extraversion total_Agreeableness total_Neuroticism, sig


* 计算相关系数并显示显著性水平
preserve
keep if permanent_resident == 0
pwcorr total_WeekTrust total_WeekSupport total_MonthSupport, sig star(0.05)
restore
preserve
keep if permanent_resident == 1
pwcorr total_WeekTrust total_WeekSupport total_MonthSupport, sig star(0.05)
restore


regress total_WeekTrust total_WeekSupport
ttest total_WeekTrust, by(permanent_resident)
ttest total_MonthSupport, by(permanent_resident)
ttest total_WeekSupport, by(permanent_resident)


