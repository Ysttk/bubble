all:
	#xctool -project frameworks/runtime-src/proj.ios_mac/tc.xcodeproj -configuration Debug -sdk iphonesimulator6.1 -scheme libcocos2d\ iOS
	#xctool -project frameworks/runtime-src/proj.ios_mac/tc.xcodeproj -configuration Debug -sdk iphonesimulator6.1 -scheme libluacocos2d\ iOS
	xctool -project frameworks/runtime-src/proj.ios_mac/tc.xcodeproj -configuration Debug -sdk iphonesimulator7.1 -scheme tc\ iOS -arch x86_64 VALID_ARCHS="i386 armv7 x86_64" build install
