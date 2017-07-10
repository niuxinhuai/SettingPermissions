# OpenSetting
从App跳转到系统的一些设置（如：Wi-Fi，定位，蓝牙等）

在iOS 10中通过应用自身（除了通知栏Widget）已经不允许任何跳转到系统设置了。
下面是关于跳转系统设置的一些说明。

1、iOS 10 之前可以跳转

   NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];                       
   if ([[UIApplication sharedApplication] canOpenURL:url]) {  
      [[UIApplication sharedApplication] openURL:url]; //iOS 9 的跳转
      [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil]; //iOS 10 新API
   }
（iOS 10通知栏Widget，可以通过设置 URL Scheme 实现像iOS 9一样正常跳转）

2、只能跳到自身应用界面的系统设置

NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
if ([[UIApplication sharedApplication] canOpenURL:url]) {
    [[UIApplication sharedApplication] openURL:url];
}

3、私有API

使用MobileCoreServices.framework里的私有API:
- (BOOL)openSensitiveURL:(id)arg1 withOptions:(id)arg2;

使用方法：
导入MobileCoreServices.framework框架

#import <MobileCoreServices/MobileCoreServices.h>

// Prefs:root=WIFI P要大写

NSURL *url = [NSURL URLWithString:@"Prefs:root=WIFI"];
Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
[[LSApplicationWorkspace performSelector:@selector(defaultWorkspace)] performSelector:@selector(openSensitiveURL:withOptions:) withObject:url withObject:nil];

有被拒的风险，可以通过ASCII混淆私有API绕过审核，混淆可以看代码。

最好还是尝试用 Widget 或者 3DTouch 来跳转。

难道不让你干，你非干？？
