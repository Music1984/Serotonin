#!/bin/sh
set -e # why wasn't this there earlier – bomberfish
echo "Building IPA"
xcodebuild clean build -sdk iphoneos -configuration Release CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED="NO"
echo "done building"
cd RootHelperSample
ldid -Sentitlements.plist -Cadhoc ../usprebooter/ldid
ldid -Sentitlements.plist -Cadhoc ../usprebooter/fastPathSign
gmake -j$(sysctl -n hw.ncpu)
ldid -Sentitlements.plist -Cadhoc .theos/obj/debug/arm64/trolltoolsroothelper
mv .theos/obj/debug/arm64/trolltoolsroothelper ../build/Release-iphoneos/usprebooter.app/trolltoolsroothelper
cd ../build/Release-iphoneos
rm -rf Payload
rm -rf FUCK.tipa
mkdir Payload
cp -r usprebooter.app Payload
ldid -S../../ent.xml -Cadhoc Payload/usprebooter.app/usprebooter
zip -vr FUCK.tipa Payload/ -x "*.DS_Store"
