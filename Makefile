install:
	open facebook-ios-sdk-3.11.pkg
	sudo gem install cocoapods
	pod install

open:
	open app.xcworkspace/
