![image](https://user-images.githubusercontent.com/12896162/37324908-8a0ca7ea-26c6-11e8-86cf-d4697f34cab3.png)   
<br />
<br />
![xxx](https://travis-ci.org/Imputes/Instagram.svg?branch=master&style=flat-square)
![xxx](https://img.shields.io/badge/language-Swift%204.X-orange.svg?style=flat-square)
![xxx](https://img.shields.io/badge/platform-iOS%2011.X-48196e.svg?style=flat-square)
![xxx](https://img.shields.io/badge/Server--Side-Parse-ff69b4.svg?style=flat-square) 
![xxx](https://img.shields.io/badge/database-MongoDB-0096FF.svg?style=flat-square)   
<br />
A native and simple imitating Instagram iOS app. It must run in **iPhone 8 - iPhone X** without landscape direction.   

<br />
<br />
- # [Instruction](#instruction)
- # [Screenshot](#screenshot)
   - [Login Page Part](#login) 
   - [Feed Page Part](#feed)
   - [Users Page Part](#users)
   - [Upload Page Part](#upload)
   - [News Page Part](#news)
   - [Home Page Part](#home)
- # [The Third Party](#party)
<br />
<br />

## <span id = "party">The Third Party</span>
**This simple app use RxSwift module. So if you have no installed CocoaPods before, you had to install it.**  
<br />
**CocoaPods** is a dependency manager for Cocoa projects. You can install it with the following command:
```shell
$ gem install cocoapods
```
To integrate **RxSwift** into this Xcode project using CocoaPods, specify it in your Podfile:
```shell
platform :ios, '10.0'
use_frameworks!
target '<Your Target Name>' do
    pod 'RxSwift'
end
```
Then, run the following command:
```shell
$ pod install
```  
  
## <span id = "instruction">Instruction</span>
This app use Parse server to save and load user info.  
Sign in and up both will save user in UserDefault because AppDelegate class will check which page user should go if the app dosn't exist in backend.  
To see more detail in source code.  

## <span id = "screenshot">Screenshot</span>
<h4 id = "login">Login Page Part</span>
<br />
<br />
<img src ="https://github.com/Imputes/Instagram/blob/master/Gif/xx1.gif" width="200" height="433">&nbsp<img src ="https://github.com/Imputes/Instagram/blob/master/Gif/xx2.gif" width="200" height="433">&nbsp<img src ="https://github.com/Imputes/Instagram/blob/master/Gif/xx3.gif" width="200" height="433">&nbsp<img src ="https://github.com/Imputes/Instagram/blob/master/Gif/xx4.gif" width="200" height="433"> 
<br />
<br />
<h4 id = "feed">Feed Page Part</span>
<br />
<br />
<img src ="https://github.com/Imputes/Instagram/blob/master/Gif/feed1.gif" width="200" height="433">&nbsp<img src ="https://github.com/Imputes/Instagram/blob/master/Gif/feed2.gif" width="200" height="433"> 
<br />
<br />
<h4 id = "users">Users Page Part</span>
<br />
<br />
<img src ="https://github.com/Imputes/Instagram/blob/master/Gif/User%20Part.gif" width="200" height="433">
<br />
<br />
<h4 id = "upload">Upload Page Part</span>
<br />
<br />
<img src ="https://github.com/Imputes/Instagram/blob/master/Gif/upload1.gif" width="200" height="433">&nbsp<img src ="https://github.com/Imputes/Instagram/blob/master/Gif/upload2.gif" width="200" height="433">
<br />
<br />
<h4 id = "news">News Page Part</span>
<br />
<br />
<img src ="https://github.com/Imputes/Instagram/blob/master/Gif/Notification.gif" width="200" height="433">&nbsp<img src="https://github.com/Imputes/Instagram/blob/master/Gif/notification1.gif" width="200" height="433">
<br />
<br />
<h4 id = "home">Home Page Part</span>
<br />
<br />
<img src ="https://github.com/Imputes/Instagram/blob/master/Gif/home1.gif" width="200" height="433">&nbsp<img src ="https://github.com/Imputes/Instagram/blob/master/Gif/home2.gif" width="200" height="433">&nbsp<img src ="https://github.com/Imputes/Instagram/blob/master/Gif/home3.gif" width="200" height="433">&nbsp<img src ="https://github.com/Imputes/Instagram/blob/master/Gif/home4.gif" width="200" height="433">&nbsp<img src ="https://github.com/Imputes/Instagram/blob/master/Gif/log%20out.gif" width="200" height="433">


  

