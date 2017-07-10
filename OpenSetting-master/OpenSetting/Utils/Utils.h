//
//  Utils.h
//  OpenSetting
//
//  Created by bianruifeng on 2017/3/23.
//  Copyright © 2017年 bianruifeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

/**
 打开应用的设置页面 iOS系统版本 >= 8.0
 
 @return 是否可以打开
 */
+(BOOL)openSettings;


/**
 打开系统Wi-Fi设置，私有API 审核不一定通过
 */
+(void)openWiFi;


/**
 打开系统蓝牙设置，私有API 审核不一定通过
 */
+(void)openBluetooth;


/**
 打开系统定位设置，私有API 审核不一定通过
 */
+(void)openLocation;


/*
 
 // iOS 9的时候可以用， iOS 10 之后不可用了。
 // iOS10上，调用canOpenURL:打开系统设置界面时控制台会报如下错误，并且无法跳转：
 // -canOpenURL: failed for URL: "Prefs:root=Privacy&path=LOCATION" - error: "The operation couldn’t be completed. (OSStatus error -10814.)"
 // iOS10只允许如下方式跳转到设置里自己app的界面，对跳转到其他界面做了限制：
 
 // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
 
 
 +(void)openWiFi
 {
     NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
     
     if ([[UIApplication sharedApplication] canOpenURL:url]) {
     
     [[UIApplication sharedApplication] openURL:url]; //iOS 9 的跳转
     [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil]; //iOS 10 的跳转方式
     }
 }
 
 
 */



@end
