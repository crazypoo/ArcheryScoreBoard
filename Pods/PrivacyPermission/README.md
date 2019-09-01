# PrivacyPermission
![License](https://img.shields.io/badge/License-MIT-orange.svg)&nbsp;
![Platform](https://img.shields.io/badge/Platform-iOS-yellowgreen.svg)&nbsp;
![Support](https://img.shields.io/badge/Support-iOS%208%2B-lightgrey.svg)&nbsp;
![Cocoapods](https://img.shields.io/badge/cocoapods-support-red.svg)&nbsp;
![Language](https://img.shields.io/badge/language-Objective--C-B9D3EE.svg)&nbsp;


## &emsp;&emsp; PrivacyPermission is a library for accessing various system privacy permissions,you can use it for more friendly access.

## Privacy Permission Supported
 - Photo
 	- Privacy - Photo Library Usage Description
 - Camera
 	- Privacy - Camera Usage Description
 - Media
 	- Privacy - Media Library Usage Description
 - Microphone
 	- Privacy - Microphone Usage Description
 - Location
 	- Privacy - Location Usage Description
 	- Privacy - Location Always Usage Description
 	- Privacy - Location When In Use Usage Description
 - Bluetooth
 	- Privacy - Bluetooth Peripheral Usage Description
 - PushNotification
 - Speech
 	- Privacy - Speech Recognition Usage Description
 - Event
 	- Privacy - Calendars Usage Description
 - Contact
 	- Privacy - Contacts Usage Description
 - Reminder
 	- Privacy - Reminders Usage Description 
 - <del>Health</del>
 	- <del>Privacy - Health Share Usage Description</del>
 	- <del>Privacy - Health Update Usage Description</del>
  
## Preview
 mainpage CN  | mainpage USA
  -----|-----
 ![Asset/screenshot-CN.png](Asset/screenshot-CN.png) |  ![Asset/screenshot-USA.png](Asset/screenshot-USA.png) 
 ---  
 GIF Animated CN  | GIF Animated USA
 -----|-----
 ![Asset/GIF-CN.gif](Asset/GIF-CN.gif) | ![Asset/GIF-USA.gif](Asset/GIF-USA.gif) 


## License
`PrivacyPermission `use [__MIT license__][1]

## Installation with cocoapods
<pre>
 pod 'PrivacyPermission'
</pre>
![Asset/cocoapods.png](Asset/cocoapods.png)

## Usage
- [Example for access the photo permission](#EXAMPLE)
- [Start the project to see more example](./PrivacyPermissionExample)

<a name="EXAMPLE"></a>
### EXAMPLE
```
     [[PrivacyPermission sharedInstance]accessPrivacyPermissionWithType:PrivacyPermissionTypePhoto completion:^(BOOL response, PrivacyPermissionAuthorizationStatus status) {
          NSLog(@"response:%d \n status:%ld",response,status);
     }];
```

## CHANGELOG
- Version 2.0.1

```
 delete func releate to 'HealthyKit' 
```




[1]:  https://github.com/GREENBANYAN/PrivacyPermission/blob/master/LICENSE "MIT License"	

