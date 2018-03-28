#!/bin/bash

#使用前是需要Xcode配置证书的
#直接 打开命令行 cd到工程的根目录，然后执行 sh ipa.sh

#工程名字 project name
SCHEMENAME=ipaProject
#修改记录txt文件
UPLOADLOG=uploadLog.txt
#ipa生成路径
DIRPATH=/Users/youname/Desktop/IPA
#文件夹生成ipa的名字
DATE=$(DATE +%Y_%m%d_%H%M)

SOURCEPATH=$( cd $DIRPATH && pwd)
IPAPATH=$SOURCEPATH/$DATE
DIRIPAPATH=$IPAPATH
IPANAME=$DATE.ipa
NEWIPANAME=$IPANAME


LogContent=""
for lineC in $(<$UPLOADLOG)
do
LogContent=$LogContent$lineC"\n"
done

# build 非pod文件
#xcodebuild \
#-project $SCHEMENAME.xcodeproj \
#-scheme $SCHEMENAME \
#-configuration Debug \
#clean \
#build \
#-derivedDataPath $DIRIPAPATH

# build pod文件
xcodebuild \
-workspace $SCHEMENAME.xcworkspace \
-scheme $SCHEMENAME \
-configuration Debug \
clean \
build \
-derivedDataPath $DIRIPAPATH

# xcrun .ipa
xcrun -sdk iphoneos PackageApplication \
-v $DIRIPAPATH/Build/Products/Debug-iphoneos/$SCHEMENAME.app \
-o $DIRIPAPATH/$NEWIPANAME


#删除build文件
cd $DIRIPAPATH
shopt -s extglob
rm -rf !($NEWIPANAME)


#fir上传
#fir login -T {key}
#fir publish $DIRIPAPATH/$NEWIPANAME


##pgyer上传
curl -F "file=@$DIRIPAPATH/$NEWIPANAME" \
-F "uKey={uKey}" \
-F "_api_key={api_key}" \
-F "updateDescription=$LogContent"  \
https://www.pgyer.com/apiv1/app/upload


