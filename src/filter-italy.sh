# <filter-italy.sh>

head -n 1 data/weather-2020-jan.csv > italy.csv

for month in jan feb mar apr may jun;
do
    cat data/weather-2020-$month.csv | grep "Italy" >> italy.csv
done
