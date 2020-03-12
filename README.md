# Firebase Firestore Data Uploader

A basic macOS app for upload plist, json, string type file to Firebase Firestore

## Instructions

- Clone project to your local storage.
- Open terminal and change directory to project folder.
- Run 'pod install' command and install pods.(You have to install Cocoapod with 'sudo gem install cocoapods' command on terminal.)
- Add your 'GoogleService-Info.plist' file to project.
- Run project on your system.
- Drag and drop your plist, json or string file to app window.
- Write your collection name and push upload button.
- If you get success message everythings done :)
- Go to Firebase console and check it.

## Info	

	Firebase is most important part of mobile apps. We often use it for database. When i begin working at current company, their iOS team working on a base iOS template. When they need create a project, uses this template and it's provide fundamental tools for iOS apps.

	I get the localization part of this template xcode project. I want to design and develop a basic and flexible localization tool. You can use string files but this option not too flexible because you cant change string files at runtime. If you want change some text on your app, you have to change it and send your app to app store connect and wait for Apple confirimation. This is too job! But i choose different way for localization. My localization struct is same with Firebase Remote Config. If you was use this tool you can easily understand this.

	We have a plist file and it stores default localization value. App save this data to UserDefaults. If your app connected to internet it gets localization value from your web api. I cant write web service for now. Threfore i use Firebase. But you can make some little change and use this tool with your web services. Whetever if your app reach to internet gets localization value from web and write this data on default values. Everytime localization update not too right. This is come with a lot of disadvantage. If your app have a lot of user this process may be crash your servers. Users wait every time for this process when app launch and also maybe use cellular data for this. I think this is enough for bad approach. What i need? Maybe version control like git. When i change some values on Firebase, app must understand this and update localization data. I need socket programming? Getting more complicated. But no! I use Firebase remote config tool for version control. I store a double value named like 'localizationVersion'. When i want update localization data, increase localizationVersion and app control this version, when version number increased app update localization data and localizationVersion.
