#!/bin/bash

# 包名 所在 文件的目录
packageDir="/root/curlDir/f8-dir/"
fileName="f8-segement-aa"
saveHtmlDir="/root/curlDir/f8-html/"

#url
preUrl="https://play.google.com/store/apps/details?id="
suffixUrl="&hl=en"


# 该文件的log.
log_txt="/root/curlDir/f8-log/log.txt"
log_200="/root/curlDir/f8-log/log_200.txt"
log_404="/root/curlDir/f8-log/log_404.txt"
log_other="/root/curlDir/f8-log/log_other.txt"
log_200_url="/root/curlDir/f8-log/log_200_url.txt"
log_404_url="/root/curlDir/f8-log/log_404_url.txt"
log_other_url="/root/curlDir/f8-log/log_other_url.txt"


# 对任意一个文件,行数
file=$packageDir""$fileName
lines=`wc -l < file`

for i in `seq 1 $lines`
do
	str=""
	tmpLine=$i"p"
	# 取包名
	tmpPackageName=`sed -n $tmpLine $file`
	tmpHtmlName=$saveHtmlDir""$tmpPackageName".html"
	echo $tmpPackageName
	
	#拼接url
	afterUrl=$preUrl""$tmpPackageName""$suffixUrl
	
	# curl 请求，并输出状态码
	str=$str"现在时间是"[`date "+%Y-%m-%d %H:%M:%S"`]",请求地址为"[$afterUrl]",包名为"[$tmpPackageName]
	startTime=`date +%s`
	# curl real
	HTTP_CODE=`curl -o $tmpHtmlName -s -w %{http_code} $afterUrl`
	
	endTime=`date +%s`
	wasteTime=$(($endTime - $startTime))
	
	# 后期判断，如果返回404，则，如果200，
	# 检测状态
	if [ $HTTP_CODE -eq 200 ];then
		str=$str",状态码为[200]"
		echo $tmpPackageName >> $log_200
		echo $afterUrl >> $log_200_url
		echo $str
	elif [ $HTTP_CODE -eq 404 ];then
		str=$str",状态码为[400]"
		echo $tmpPackageName >> $log_404
		echo $afterUrl >> $log_404_url
		echo $str		
	else
		str=$str",状态码为"[$HTTP_CODE]
		echo $tmpPackageName >> $log_other
		echo $afterUrl >> $log_other_url
		echo $str
	fi;
	echo -e $str",耗时"[$wasteTime]"\n" >> $log_txt
done;
