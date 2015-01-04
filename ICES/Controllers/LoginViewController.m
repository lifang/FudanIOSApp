//
//  LoginViewController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/2.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "LoginViewController.h"
#import "FindPasswordController.h"
#import "SignUpController.h"
#import "AppDelegate.h"
#import "NetworkInterface.h"
#import "UserArchiverHelper.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Sign In";
    
    self.view.backgroundColor = kColor(244, 244, 244, 1);
    if (kDeviceVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    UserModel *user = [UserArchiverHelper getLastestUser];
    if (user) {
        _usernameField.text = user.username;
    }
}

#pragma mark - UI

- (void)initAndLayoutUI {
    CGFloat topSpace = 44.0f;  //距顶部
    CGFloat textFieldHeight = 44.0f; //输入框高度
    CGFloat imageSize = 20.0f; //输入框图片大小
    CGFloat btnOriginX = 60.0f; //忘记密码左侧
    CGFloat signBtnOriginX = 16.f; //登录按钮左侧
    
    //first line
    UIView *firstLine = [[UIView alloc] init];
    firstLine.translatesAutoresizingMaskIntoConstraints = NO;
    firstLine.backgroundColor = kColor(194, 213, 224, 1);
    [self.view addSubview:firstLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:topSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0
                                                           constant:kLineHeight]];
    //用户名
    _usernameField = [[UITextField alloc] init];
    _usernameField.translatesAutoresizingMaskIntoConstraints = NO;
    _usernameField.borderStyle = UITextBorderStyleNone;
    _usernameField.backgroundColor = kColor(247, 250, 251, 1);
    _usernameField.delegate = self;
    _usernameField.placeholder = @"Email";
    _usernameField.font = [UIFont systemFontOfSize:15.f];
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, imageSize)];
    UIImageView *nameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, imageSize, imageSize)];
    nameImageView.image = [UIImage imageNamed:@"email.png"];
    [nameView addSubview:nameImageView];
    _usernameField.leftView = nameView;
    _usernameField.leftViewMode = UITextFieldViewModeAlways;
    _usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:_usernameField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_usernameField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_usernameField
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_usernameField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:firstLine
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_usernameField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:textFieldHeight]];
    
    //second line
    UIView *secondLine = [[UIView alloc] init];
    secondLine.translatesAutoresizingMaskIntoConstraints = NO;
    secondLine.backgroundColor = kColor(194, 213, 224, 1);
    [self.view addSubview:secondLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_usernameField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0
                                                           constant:kLineHeight]];
    //密码
    _passwordField = [[UITextField alloc] init];
    _passwordField.translatesAutoresizingMaskIntoConstraints = NO;
    _passwordField.borderStyle = UITextBorderStyleNone;
    _passwordField.backgroundColor = kColor(247, 250, 251, 1);
    _passwordField.delegate = self;
    _passwordField.placeholder = @"Password";
    _passwordField.font = [UIFont systemFontOfSize:15.f];
    _passwordField.secureTextEntry = YES;
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, imageSize)];
    UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, imageSize, imageSize)];
    passwordImageView.image = [UIImage imageNamed:@"password.png"];
    [passwordView addSubview:passwordImageView];
    _passwordField.leftView = passwordView;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:_passwordField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:secondLine
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:textFieldHeight]];
    //third line
    UIView *thirdLine = [[UIView alloc] init];
    thirdLine.translatesAutoresizingMaskIntoConstraints = NO;
    thirdLine.backgroundColor = kColor(194, 213, 224, 1);
    [self.view addSubview:thirdLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_passwordField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0
                                                           constant:kLineHeight]];
    
    //忘记密码
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.translatesAutoresizingMaskIntoConstraints = NO;
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgetBtn setTitle:@"I forget my password!" forState:UIControlStateNormal];
    [forgetBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateHighlighted];
    [forgetBtn addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forgetBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:thirdLine
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forgetBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:btnOriginX]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forgetBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:124]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forgetBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0
                                                           constant:18]];
    //登录
    UIButton *signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signInBtn.translatesAutoresizingMaskIntoConstraints = NO;
    signInBtn.layer.cornerRadius = 4;
    signInBtn.layer.masksToBounds = YES;
    signInBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [signInBtn setTitle:@"Sign In" forState:UIControlStateNormal];
    [signInBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [signInBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
    [signInBtn addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signInBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:forgetBtn
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:40]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signInBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:signBtnOriginX]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signInBtn
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-signBtnOriginX]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signInBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0
                                                           constant:40]];
    //注册
    UIButton *signUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpBtn.translatesAutoresizingMaskIntoConstraints = NO;
    signUpBtn.layer.cornerRadius = 4;
    signUpBtn.layer.masksToBounds = YES;
    signUpBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [signUpBtn setTitle:@"Sign Up" forState:UIControlStateNormal];
    [signUpBtn setBackgroundImage:[UIImage imageNamed:@"yellow.png"] forState:UIControlStateNormal];
    [signUpBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
    [signUpBtn addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signUpBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:signInBtn
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:15]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signUpBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:signBtnOriginX]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signUpBtn
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-signBtnOriginX]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signUpBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0
                                                           constant:40]];
}

#pragma mark - Action

//忘记密码
- (IBAction)forgetPassword:(id)sender {
    FindPasswordController *findC = [[FindPasswordController alloc] init];
    [self.navigationController pushViewController:findC animated:YES];
}

//登录
- (IBAction)signIn:(id)sender {
    [_passwordField becomeFirstResponder];
    [_passwordField resignFirstResponder];
    if (!_usernameField.text || [_usernameField.text isEqualToString:@""] || !_passwordField.text || [_passwordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                        message:@"User name or password can't be empty!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Sure"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Login...";
    [NetworkInterface loginWithStudentEmail:_usernameField.text studentPassword:_passwordField.text deviceToken:delegate.deviceToken alreadyEncrypt:NO finished:^(BOOL success, NSData *response) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",object);
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == requestSuccess) {
                    [[AppDelegate shareAppDelegate] setLoginInfo:object];
                    [[[AppDelegate shareAppDelegate] rootViewController] saveLoginUserWithUsername:_usernameField.text password:_passwordField.text info:object];
                    [[[AppDelegate shareAppDelegate] rootViewController] showMainViewController];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                                    message:[object objectForKey:@"message"]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Sure"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            }
        }
        else {
            NSLog(@"login failed!");
        }
    }];
}

//注册
- (IBAction)signUp:(id)sender {
    SignUpController *signUpC = [[SignUpController alloc] init];
    [self.navigationController pushViewController:signUpC animated:YES];
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
