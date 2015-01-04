//
//  SignUpController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/2.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "SignUpController.h"
#import "NetworkInterface.h"
#import "AdjustPervious7.h"

@interface SignUpController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *activeField;
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *confirmField;
@property (nonatomic, strong) UITextField *mobileField;

@end

@implementation SignUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Sign Up";
    [self initAndLayoutUI];
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *signUp = [UIButton buttonWithType:UIButtonTypeCustom];
    signUp.frame = CGRectMake(16, 20, kScreenWidth - 32, 40);
    signUp.layer.cornerRadius = 4;
    signUp.layer.masksToBounds = YES;
    signUp.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [signUp setTitle:@"Sign Up" forState:UIControlStateNormal];
    [signUp setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [signUp setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
    [signUp addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:signUp];
    _tableView.tableFooterView = footerView;
}

- (void)initAndLayoutUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:[AdjustPervious7 tableviewStyle]];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.separatorColor = kColor(194, 213, 224, 1);
    _tableView.backgroundColor = kColor(244, 244, 244, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setHeaderAndFooterView];
    [self.view addSubview:_tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    //输入框
    CGFloat imageSize = 20.0f; //输入框图片大小
    //验证码
    _activeField = [[UITextField alloc] init];
    _activeField.borderStyle = UITextBorderStyleNone;
    _activeField.backgroundColor = kColor(247, 250, 251, 1);
    _activeField.delegate = self;
    _activeField.placeholder = @"Activation";
    _activeField.font = [UIFont systemFontOfSize:15.f];
    UIView *activeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, imageSize)];
    UIImageView *activeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, imageSize, imageSize)];
    activeImageView.image = [UIImage imageNamed:@"active.png"];
    [activeView addSubview:activeImageView];
    _activeField.leftView = activeView;
    _activeField.leftViewMode = UITextFieldViewModeAlways;
    _activeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _activeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //用户名
    _usernameField = [[UITextField alloc] init];
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
    //密码
    _passwordField = [[UITextField alloc] init];
    _passwordField.borderStyle = UITextBorderStyleNone;
    _passwordField.backgroundColor = kColor(247, 250, 251, 1);
    _passwordField.delegate = self;
    _passwordField.placeholder = @"New Password";
    _passwordField.font = [UIFont systemFontOfSize:15.f];
    _passwordField.secureTextEntry = YES;
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, imageSize)];
    UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, imageSize, imageSize)];
    passwordImageView.image = [UIImage imageNamed:@"confirm.png"];
    [passwordView addSubview:passwordImageView];
    _passwordField.leftView = passwordView;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    _confirmField = [[UITextField alloc] init];
    _confirmField.borderStyle = UITextBorderStyleNone;
    _confirmField.backgroundColor = kColor(247, 250, 251, 1);
    _confirmField.delegate = self;
    _confirmField.placeholder = @"Confirm Password";
    _confirmField.font = [UIFont systemFontOfSize:15.f];
    _confirmField.secureTextEntry = YES;
    UIView *confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, imageSize)];
    UIImageView *confirmImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, imageSize, imageSize)];
    confirmImageView.image = [UIImage imageNamed:@"password.png"];
    [confirmView addSubview:confirmImageView];
    _confirmField.leftView = confirmView;
    _confirmField.leftViewMode = UITextFieldViewModeAlways;
    _confirmField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _confirmField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //手机
    _mobileField = [[UITextField alloc] init];
    _mobileField.borderStyle = UITextBorderStyleNone;
    _mobileField.backgroundColor = kColor(247, 250, 251, 1);
    _mobileField.delegate = self;
    _mobileField.placeholder = @"Chine Mobile Phone";
    _mobileField.font = [UIFont systemFontOfSize:15.f];
    UIView *mobileView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, imageSize)];
    UIImageView *mobileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, imageSize, imageSize)];
    mobileImageView.image = [UIImage imageNamed:@"mobile.png"];
    [mobileView addSubview:mobileImageView];
    _mobileField.leftView = mobileView;
    _mobileField.leftViewMode = UITextFieldViewModeAlways;
    _mobileField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mobileField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

#pragma mark - Action

- (IBAction)signUp:(id)sender {
    //输入验证
    if (!_activeField.text || [_activeField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                        message:@"Activation can't be empty!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Sure"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_usernameField.text || [_usernameField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                        message:@"Email can't be empty!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Sure"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_passwordField.text || [_passwordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                        message:@"New password can't be empty!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Sure"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_confirmField.text || [_confirmField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                        message:@"Confirm password can't be empty!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Sure"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![_passwordField.text isEqualToString:_confirmField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                        message:@"New password doesn't match password confirm!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Sure"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Submitting...";
    [NetworkInterface registerWithActivation:_activeField.text studentEmail:_usernameField.text studentPassword:_passwordField.text mobilePhone:_mobileField.text finished:^(BOOL success, NSData *response) {
        if (success) {
            [hud hide:YES];
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",object);
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == requestSuccess) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                                    message:@"Sign up success!"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Sure"
                                                          otherButtonTitles:nil];
                    [alert show];
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
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:0.3f];
            hud.labelText = @"Sign failed";
        }
    }];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 4;
            break;
        case 1:
            row = 1;
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    //activation
                    _activeField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_activeField];
                }
                    break;
                case 1: {
                    //username
                    _usernameField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_usernameField];
                }
                    break;
                case 2: {
                    //password
                    _passwordField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_passwordField];
                }
                    break;
                case 3: {
                    //confirm
                    _confirmField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_confirmField];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    //mobile phone
                    _mobileField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_mobileField];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.f;
    if (section == 1) {
        height = 25;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        headerView.backgroundColor = [UIColor clearColor];
        UILabel *optionLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, kScreenWidth - 60, 20)];
        optionLabel.backgroundColor = [UIColor clearColor];
        optionLabel.font = [UIFont systemFontOfSize:12.f];
        optionLabel.text = @"Optional";
        [headerView addSubview:optionLabel];
        return headerView;
    }
    return [AdjustPervious7 tableviewHeaderOrFooterView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertDelagte

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
