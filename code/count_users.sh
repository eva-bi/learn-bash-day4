#!/bin/bash
# declare STRING variable
START=$(date +%s)
for i in $(seq -f "%02g" 1 10)
do
	if [ ! -f "log$i.tar.gz" ]
		then
		curl "https://s3-ap-northeast-1.amazonaws.com/aucfan-tuningathon/dataset/result.day$i.log.gz" > "log$i.tar.gz"
		zcat "log$i.tar.gz" >> "log_main.log"
	fi
done
echo "================================================"
echo "==  The number of unique user for each days   =="
echo "================================================"
for i in $(seq -f "%02g" 1 10)
do
	DAY=$(zcat "log$i.tar.gz" | cut -f 3 | sort | uniq | wc -l)
	echo "Day $i: " $DAY " users"
done

echo $(cut -f 2- log_main.log | sort | uniq) > log_main_uniq.log
echo "================================================"
echo "== The number of unique user for each regions =="
echo "================================================"
COUNTRY=$(cut -f 2 log_main.log | sort | uniq)
for c in $COUNTRY; 
do 
	
	NUM=$(grep -o $c log_main_uniq.log | wc -l)
	echo $c " : " $NUM " users"; 
done

echo "================================================"
echo "====  The number of unique user in total   ====="
echo "================================================"
TOTAL=$(cut -f 3 log_main.log | sort | uniq | wc -l)
echo "Total : " $TOTAL " users"
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "================================================"
echo "====     END : It took $DIFF seconds       ====="
echo "================================================"