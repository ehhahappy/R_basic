# [ 문제 1 ]
# 
# 미세먼지와 교통사고 사이의 상관 관계 확인
# 
# 1. 데이터 읽기
# - pm10.traffic.accident.csv 파일에서 데이터 읽기
# - 데이터 확인
# 
# 
# 2. 미세먼지와 교통사고 사이의 상관 관계를 확인하고 검정 수행

pt <- read.csv("data-files/pm10.traffic.accident.csv", header=T)
pt

library(ggplot2)
ggplot(pt, aes(pm10, ta)) + geom_point(colour="blue", size=3) + theme_bw() + xlab("미세먼지(PM10)") + ylab("교통사고 발생건수")

cor.test(pt$pm10, pt$ta)

# 
# [ 문제 2 ]
# 
# 순종의 둥글고 황색인 완두(RRYY)콩과 주름지고 녹색인 완두(rryy)콩을 교배하면 
# 2대째 발현되는 완두콩의 형질은 둥글고 황색, 둥글고녹색, 주름지고 황색, 주름지고 녹색이 9:3:3:1의 비율로 나타난다.
# 
# 관측 결과 : 둥글고 황색 : 315, 둥글고 녹색 : 101, 주름지고 황색 : 108, 주름지고 녹색 : 32
# 
# 주어진 관찰 결과를 기반으로 가설에 대한 검정 수행

x <- c(315, 101, 108, 32)

x / sum(x)
c(9, 3, 3, 1)/16

chisq.test(x, p=c(9, 3, 3, 1)/16)

# [ 문제 3 ]
# 
# 20대에서 40대까지 연령대별로 서로 조금씩 그 특성이 다른 SNS 서비스들에 대해 이용 현황을 조사한 자료를 바탕으로 연령대별로 홍보 전략을 세우고자 합니다.
# 연령대별로 이용 패턴이 서로 동일한지 검정 수행.
# 
# 1. 데이터 읽기
# - snsbyage.csv 파일에서 데이터 읽기
# - 데이터 확인
# 
# 2. 분할표 만들기
# table 함수를 사용해서 분할표 만들기
# 
# 3. 나이에 따라 서비스 사용 패턴에 차이가 있는지 검정

library(dplyr)

sns.c <- read.csv("data-files/snsbyage.csv", header=T, stringsAsFactors=FALSE)
str(sns.c)
head(sns.c)

sns.c <- sns.c %>% 
  mutate(age.c = factor(age, 
                        levels=c(1, 2, 3), 
                        labels=c("20대", "30대", "40대")),
         service.c = factor(service, 
                            levels=c("F", "T", "K", "C", "E")))

sns.c

c.tab <- table(sns.c$age.c, sns.c$service.c)
c.tab

chisq.test(c.tab) 

 
# [ 문제 4 ]
# 
# 어느 대학원 입시에서 입학 과정 중 여성에 대한 성차별이 있었다는 내용의 소송 발생. 
# 고소인은 근거 자료로 성별에 따라 합격에 영향을 미쳤음을 주장
# 고소인의 주장의 타당성에 대한 검정 수행
# 
# 1. 데이터 읽기
# - R 내장 UCBAdmissions 데이터셋 사용
# - 데이터 확인
# 
# 2. 집계표 만들기
# - Admin 속성과 Gender 속성의 집계표 생성
# - apply 함수 검토 및 적용
# 
# 3. 성별에 따라 합격률이 다른지 검정

UCBAdmissions
ucba.tab <- apply(UCBAdmissions, c(1, 2), sum)
ucba.tab

round(prop.table(ucba.tab, margin=2) * 100, 1)

chisq.test(ucba.tab)


# [ 문제 5 ]
# 여아 신생아의 몸무게는 2800(g)으로 알려져 왔으나, 
# 산모에 대한 관리가 더 세심해진 요즘 신생아의 몸무게가 증가할 것으로 판단되어, 
# 이를 확인하고자 부모의 동의를 얻은 신생아 중 표본으로 18명을 대상으로 체중을 측정. 
# ‘여아 신생아의 체중이 2800(g)보다 크다’는 주장을 받아들일 수 있는지 검정 수행.
# 
# 
# 1. 데이터 읽기
# - http://www.amstat.org/publications/jse/datasets/babyboom.dat.txt 데이터를 read.table 함수로 읽기
# - 데이터 확인
# 
# 2. 여아의 몸무게 데이터만 추출
# 
# 3. 가설 검정

data <- read.table("http://www.amstat.org/publications/jse/datasets/babyboom.dat.txt", header=F)
str( data )
names(data) <- c("time", "gender", "weight", "minutes")
data
female_weight <- data %>% filter(gender == 1) %>% select(weight)
female_weight
mean(female_weight$weight)

t.test(female_weight, mu=2800, alternative="greater")

 
# [ 문제 6 ]
# KBO 공인구의 정상 반발계수 범위 0.4131 ~ 0.4373
# 공인구 제조사의 야구공 표본 100개를 뽑아서 반발계수 측정 
# 불량률이 10%를 초과하는지 모비율에 대한 가설 검정 수행
# 
# 1. 데이터 읽기
# - restitution.txt 파일의 데이터를 read.table 함수로 읽기
# - 데이터 확인
# 
# 2. 공인구 조건에 포함되는지 여부 (검사 통과 여부)를 저장하는 새 컬럼을 만들고 통과한 경우 1, 실패한 경우 0 저장
# 
# 3. 새로 만든 컬럼의 값을 사용해서 가설 검정

tmp <- read.table("data-files/restitution.txt", header=T)
tmp
rel <- ifelse(tmp$rst < 0.4131 | tmp$rst > 0.4373, 1, 0)
rel
sum(rel) / length(rel)


prop.test(sum(rel), length(rel), p = 0.1, alternative = 'less')


# [ 문제 7 ]
# 
# 남/여 신생아의 체중에 차이가 있는지 검정 수행
# 
# 1. 데이터 읽기
# - baby-age-by-gender.txt 파일의 데이터를 read.table 함수를 사용해서 읽기
# - 데이터 확인
# 
# 2. 남/여 신생아 체중의 분산 동일성 검정 수행
# 
# 3. 남 / 연 신생아의 체중에 차이가 있는지 검정 수행

data <- read.table("data-files/baby-age-by-gender.txt", header=T)
data

var.test(data$weight ~ data$gender)

t.test(data$weight ~ data$gender, var.equal=TRUE)

 
# [ 문제 8 ]
# 
# 17명의 관찰대상으로부터 식욕부진증 치료제 투여 이전의 사전관찰(Pre) 및 투여 이후 사후관찰(Post) 데이터를 사용해서 약효에 대한 검정 수행
# 
# 1. 데이터 읽기
# - anorexia.csv 파일의 데이터 읽기
# - 데이터 확인
# 
# 2. 약효에 대한 검정 수행

data2 <- read.csv("data-files/anorexia.csv", header=T)
str( data2 )
data2
t.test(data2$Prior, data2$Post, paired=T)


