//
//  AppDelegate.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/1.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkInterface.h"
#import "UserArchiverHelper.h"
#import "BPush.h"
#import "JSONKit.h"
#import "MessageDetailController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)shareAppDelegate {
    return [UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"r1gaQNPocM8tIgkMHTQQ7w82" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    //百度推送
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    [BPush bindChannel];

    if (kDeviceVersion >= 8.0) {
        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    _rootViewController = [[RootViewController alloc] init];
    self.window.rootViewController = _rootViewController;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.window makeKeyAndVisible];
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        _launchFromPushDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Push

//iOS8
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    _deviceToken = [[[[deviceToken description]
                      stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",_deviceToken);
    [BPush registerDeviceToken:deviceToken];
}

- (void)onMethod:(NSString*)method response:(NSDictionary *)data {
    NSLog(@"On method:%@", method);
    NSLog(@"data:%@", [data description]);
//    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
//    if ([BPushRequestMethod_Bind isEqualToString:method]) {
//        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
//        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
//        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
//        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
//        NSLog(@"tttt = %@,%@,%@",appid ,userid, channelid);
//        if (returnCode == BPushErrorCode_Success) {
//
//        }
//    } else if ([BPushRequestMethod_Unbind isEqualToString:method]) {
//        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
//        if (returnCode == BPushErrorCode_Success) {
//        }
//    }

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Receive Notify: %@", userInfo);
    if (application.applicationState == UIApplicationStateActive) {
        //前台
        NSLog(@"active");
        [[NSNotificationCenter defaultCenter] postNotificationName:GetPushMessageNotification object:nil];
    }
    else {
        //后台
        NSLog(@"unactive");
        [self showNotificationViewWithInfo:userInfo];
    }
    [application setApplicationIconBadgeNumber:0];

    [BPush handleNotification:userInfo];
}

//收到通知弹出到通知界面
- (void)showNotificationViewWithInfo:(NSDictionary *)userInfo {
    NSString *messageID = nil;
    if ([userInfo objectForKey:@"id"] && ![[userInfo objectForKey:@"id"] isKindOfClass:[NSNull class]]) {
        messageID = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
    }
    if (self.token && messageID) {
        MessageDetailController *detailC = [[MessageDetailController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detailC];
        detailC.messageID = messageID;
        [nav.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navbackground.png"]
                                               resizableImageWithCapInsets:UIEdgeInsetsMake(22, 1, 22, 1)]
                                      forBarMetrics:UIBarMetricsDefault];
        NSDictionary *textDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIColor whiteColor],NSForegroundColorAttributeName,
                                  nil];
        nav.navigationBar.titleTextAttributes = textDict;
        if (kDeviceVersion >= 7.0) {
            nav.navigationBar.tintColor = [UIColor whiteColor];
        }
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - 登录与退出

- (void)setLoginInfo:(NSDictionary *)object {
    if (![[object objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *result = [object objectForKey:@"result"];
    self.token = [NSString stringWithFormat:@"%@",[object objectForKey:@"token"]];
    self.email = [NSString stringWithFormat:@"%@",[result objectForKey:@"studentEmail"]];
    self.userID = [NSString stringWithFormat:@"%@",[result objectForKey:@"studentId"]];
    self.mobilePhone = [NSString stringWithFormat:@"%@",[result objectForKey:@"studentMobilePhone"]];
    self.authority = [[result objectForKey:@"studentStatus"] intValue];
    [BPush setTag:self.userID];
}

- (void)clearLoginInfo {
    [BPush delTag:self.userID];
    self.token = nil;
    self.email = nil;
    self.userID = nil;
    self.mobilePhone = nil;
    self.authority = -1;
    UserModel *user = [UserArchiverHelper getLastestUser];
    user.password = nil;
    [UserArchiverHelper savePasswordForUser:user];
}

- (void)handlePushNotification {
    if (_launchFromPushDict) {
        [self showNotificationViewWithInfo:_launchFromPushDict];
        _launchFromPushDict = nil;
    }
}

@end
