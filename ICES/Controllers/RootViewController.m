//
//  RootViewController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/2.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "RootViewController.h"
#import "UserArchiverHelper.h"
#import "EncryptHelper.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"

@interface RootViewController ()

@property (nonatomic, strong) UIImageView *backView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _backView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _backView.image = [UIImage imageNamed:@"Default.png"];
    [self.view addSubview:_backView];
    [self checkToken];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI

- (void)launchBackground {
    [self performSelector:@selector(showLoginViewController) withObject:nil afterDelay:0.5];
}

#pragma mark - Data

- (void)checkToken {
    UserModel *user = [UserArchiverHelper getLastestUser];
    if (!user || user.password == nil) {
        [self launchBackground];
        return;
    }
    NSLog(@"%@,%@,%@,%@",user.userID,user.token,user.username,user.password);
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface loginWithStudentEmail:user.username studentPassword:user.password deviceToken:delegate.deviceToken alreadyEncrypt:YES finished:^(BOOL success, NSData *response) {
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",object);
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == requestSuccess) {
                    [[AppDelegate shareAppDelegate] setLoginInfo:object];
                    [[AppDelegate shareAppDelegate] handlePushNotification];
//                    [self saveLoginUserWithUsername:user.username password:user.password info:object];
                    [self showMainViewController];
                    return ;
                }
            }
        }
        [self launchBackground];
    }];

}

#pragma mark - 登录与主界面

- (void)showLoginViewController {
    _backView.hidden = YES;
    if (!_loginNav) {
        LoginViewController *loginC = [[LoginViewController alloc] init];
        _loginNav = [[UINavigationController alloc] initWithRootViewController:loginC];
        _loginNav.view.frame = self.view.bounds;
        [_loginNav.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navbackground.png"]
                                                     resizableImageWithCapInsets:UIEdgeInsetsMake(22, 1, 22, 1)]
                                      forBarMetrics:UIBarMetricsDefault];
        [self.view addSubview:_loginNav.view];
        NSDictionary *textDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIColor whiteColor],NSForegroundColorAttributeName,
                                  nil];
        _loginNav.navigationBar.titleTextAttributes = textDict;
        if (kDeviceVersion >= 7.0) {
            _loginNav.navigationBar.tintColor = [UIColor whiteColor];
        }
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:nil
                                                                    action:nil];
        loginC.navigationItem.backBarButtonItem = backItem;
    }
    [UIView animateWithDuration:.5 animations:^{
        if (_mainNav) {
            [_mainNav.view removeFromSuperview];
            _mainNav = nil;
        }
        [self.view bringSubviewToFront:_loginNav.view];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    }];
}

- (void)showMainViewController {
    if (!_mainNav) {
        MainViewController *mainC = [[MainViewController alloc] init];
        _mainNav = [[UINavigationController alloc] initWithRootViewController:mainC];
        _mainNav.view.frame = self.view.bounds;
        [_mainNav.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navbackground.png"]
                                                     resizableImageWithCapInsets:UIEdgeInsetsMake(22, 1, 22, 1)]
                                      forBarMetrics:UIBarMetricsDefault];
        [self.view addSubview:_mainNav.view];
        NSDictionary *textDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIColor whiteColor],NSForegroundColorAttributeName,
                                  nil];
        _mainNav.navigationBar.titleTextAttributes = textDict;
        if (kDeviceVersion >= 7.0) {
            _mainNav.navigationBar.tintColor = [UIColor whiteColor];
        }
    }
    if (_loginNav) {
        [_loginNav.view removeFromSuperview];
        _loginNav = nil;
    }
    [self.view bringSubviewToFront:_mainNav.view];
}

#pragma mark - 数据处理

- (void)saveLoginUserWithUsername:(NSString *)username
                         password:(NSString *)password
                             info:(NSDictionary *)object {
    if (![[object objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *result = [object objectForKey:@"result"];
    UserModel *user = [[UserModel alloc] init];
    user.username = username;
    user.password = [EncryptHelper MD5_encryptWithString:password];
    user.userID = [NSString stringWithFormat:@"%@",[result objectForKey:@"studentId"]];
    user.token = [NSString stringWithFormat:@"%@",[object objectForKey:@"token"]];
    [UserArchiverHelper savePasswordForUser:user];
}

@end
