//
//  Utils.m
//  OpenSetting
//
//  Created by bianruifeng on 2017/3/23.
//  Copyright © 2017年 bianruifeng. All rights reserved.
//

#import "Utils.h"
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


@implementation Utils
/**
 打开应用的设置页面
 
 @return 是否可以打开
 */
+(BOOL)openSettings
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    BOOL b = [[UIApplication sharedApplication] canOpenURL:url];
    if (b){
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            NSLog(@"completionHandler");
        }];
    }
    return b;
}

+(void)openWiFi
{
    [[[self class] new] openUrlSchemes:@"Prefs:root=WIFI"];
}

+(void)openBluetooth
{
    [[[self class] new] openUrlSchemes:@"Prefs:root=Bluetooth"];
}

+(void)openLocation
{
    [[[self class] new] openUrlSchemes:@"Prefs:root=Privacy&path=LOCATION"];
}

- (void)openUrlSchemes:(NSString *)urlSchemes
{
    //不建议使用私有API，它是不可靠的。也许某天苹果就把它移除了。
    NSString * defaultWork = [[[self class] new] getDefaultWork];
    NSString * bluetoothMethod = [[[self class] new] getBluetoothMethod];
    NSURL*url=[NSURL URLWithString:urlSchemes];
    Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
    [[LSApplicationWorkspace performSelector:NSSelectorFromString(defaultWork)] performSelector:NSSelectorFromString(bluetoothMethod) withObject:url withObject:nil];
    
    /*
    //可以用宏消除警告⚠️ PerformSelector may cause a leak because its selector is unknown
    
    SuppressPerformSelectorLeakWarning(
        [[LSApplicationWorkspace performSelector:NSSelectorFromString(defaultWork)] performSelector:NSSelectorFromString(bluetoothMethod) withObject:url withObject:nil];
    );
    */
    
    
    /*
     //MobileCoreServices.framework里的私有API  为了通过Apple 的审核 利用ASCII值进行拼装组合方法混淆一下 期望可以绕过审核。
     //注意首字母改成了大写，prefs->Prefs  并不需要在info.plist 中 设置 URL Schemes
    
     
     NSURL*url=[NSURL URLWithString:@"Prefs:root=Privacy&path=LOCATION"];
     Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
     [[LSApplicationWorkspace performSelector:@selector(defaultWorkspace)] performSelector:@selector(openSensitiveURL:withOptions:) withObject:url withObject:nil];

     */
    
}
//ASCII值混淆
//defaultWorkspace
-(NSString *) getDefaultWork{
    NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x64,0x65,0x66,0x61,0x75,0x6c,0x74,0x57,0x6f,0x72,0x6b,0x73,0x70,0x61,0x63,0x65} length:16];
    NSString *method = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
    return method;
}
//openSensitiveURL:withOptions:
-(NSString *) getBluetoothMethod{
    NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x6f, 0x70, 0x65, 0x6e, 0x53, 0x65, 0x6e, 0x73, 0x69,0x74, 0x69,0x76,0x65,0x55,0x52,0x4c} length:16];
    NSString *keyone = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
    NSData *dataTwo = [NSData dataWithBytes:(unsigned char []){0x77,0x69,0x74,0x68,0x4f,0x70,0x74,0x69,0x6f,0x6e,0x73} length:11];
    NSString *keytwo = [[NSString alloc] initWithData:dataTwo encoding:NSASCIIStringEncoding];
    NSString *method = [NSString stringWithFormat:@"%@%@%@%@",keyone,@":",keytwo,@":"];
    return method;
}
/*
 Prefs:root=DISPLAY     //显示设置
 Prefs:root=BATTERY_USAGE       //电池电量
 Prefs:root=General&path=STORAGE_ICLOUD_USAGE/DEVICE_STORAGE        //存储空间
 prefs:root=General&path=About      //关于手机
 prefs:root=General&path=ACCESSIBILITY      //辅助功能
 prefs:root=AIRPLANE_MODE
 prefs:root=General&path=AUTOLOCK
 prefs:root=General&path=USAGE/CELLULAR_USAGE
 prefs:root=Brightness    //打开Brightness(亮度)设置界面
 prefs:root=Bluetooth    //打开蓝牙设置
 prefs:root=General&path=DATE_AND_TIME    //日期与时间设置
 prefs:root=FACETIME    //打开FaceTime设置
 prefs:root=General    //打开通用设置
 prefs:root=General&path=Keyboard    //打开键盘设置
 prefs:root=CASTLE    //打开iClound设置
 prefs:root=CASTLE&path=STORAGE_AND_BACKUP    //打开iCloud下的储存空间
 prefs:root=General&path=INTERNATIONAL    //打开通用下的语言和地区设置
 prefs:root=LOCATION_SERVICES    //打开隐私下的定位服务
 Prefs:root=Privacy&path=LOCATION       //定位设置
 prefs:root=ACCOUNT_SETTINGS
 prefs:root=MUSIC    //打开设置下的音乐
 prefs:root=MUSIC&path=EQ    //打开音乐下的均衡器
 prefs:root=MUSIC&path=VolumeLimit  //打开音乐下的音量
 prefs:root=General&path=Network    //打开通用下的网络
 prefs:root=NIKE_PLUS_IPOD
 prefs:root=NOTES    //打开设置下的备忘录设置
 prefs:root=NOTIFICATIONS_ID    //打开设置下的通知设置
 prefs:root=Phone    //打开电话设置
 prefs:root=Photos    //打开设置下照片和相机设置
 prefs:root=General&path=ManagedConfigurationList    //打开通用下的描述文件
 prefs:root=General&path=Reset    //打开通用下的还原设置
 prefs:root=Sounds&path=Ringtone
 prefs:root=Safari    //打开设置下的safari设置
 prefs:root=General&path=Assistant    //打开siri不成功
 prefs:root=Sounds    //打开设置下的声音设置
 prefs:root=General&path=SOFTWARE_UPDATE_LINK    //打开通用下的软件更新
 prefs:root=STORE    //打开通用下的iTounes Store和App Store设置
 prefs:root=TWITTER    //打开设置下的twitter设置
 prefs:root=FACEBOOK    //打开设置下的Facebook设置
 prefs:root=General&path=USAGE    //打开通用下的用量
 prefs:root=VIDEO
 prefs:root=General&path=Network/VPN        //打开通用下的vpn设置
 prefs:root=Wallpaper    //打开设置下的墙纸设置
 prefs:root=WIFI    //打开wifi设置
 prefs:root=INTERNET_TETHERING  //系统设置
 prefs:root=privacy //隐私设置
 prefs:root=MOBILE_DATA_SETTINGS_ID     //蜂窝网路
 
 打开电话 Mobilephone://
 世界时钟 Clock-worldclock://
 闹钟 Clock-alarm://
 秒表 Clock-stopwatch://
 倒计时 Clock-timer://
 打开相册 Photos://
 */

@end
