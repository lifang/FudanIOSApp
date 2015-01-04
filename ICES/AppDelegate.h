//
//  AppDelegate.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/1.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "BMapKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) RootViewController *rootViewController;

@property (nonatomic, strong) BMKMapManager *mapManager;

//登录后返回验证
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *mobilePhone;
//1.待激活  2.正常  3.过期
@property (nonatomic, assign) int authority;

@property (nonatomic, strong) NSString *deviceToken; //推送设备号

//从通知中心打开
@property (nonatomic, strong) NSDictionary *launchFromPushDict;

+ (AppDelegate *)shareAppDelegate;

//登录保存数据
- (void)setLoginInfo:(NSDictionary *)loginInfo;
//退出清空数据
- (void)clearLoginInfo;
//是否有通知处理
- (void)handlePushNotification;

@end

