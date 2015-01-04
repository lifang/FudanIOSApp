//
//  RootViewController.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/2.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "MainViewController.h"

@interface RootViewController : UIViewController

@property (nonatomic, strong) UINavigationController *loginNav;

@property (nonatomic, strong) UINavigationController *mainNav;

- (void)showLoginViewController;

- (void)showMainViewController;

- (void)saveLoginUserWithUsername:(NSString *)username
                         password:(NSString *)password
                             info:(NSDictionary *)object;

- (void)checkToken;

@end
