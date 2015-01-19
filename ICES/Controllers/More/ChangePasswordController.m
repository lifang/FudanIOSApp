//
//  ChangePasswordController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/3.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "ChangePasswordController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "AdjustPervious7.h"

@interface ChangePasswordController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *oldPasswordField;

@property (nonatomic, strong) UITextField *passwordField;

@property (nonatomic, strong) UITextField *confirmField;

@end

@implementation ChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Change Password";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePersonInfo:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self initAndLayoutUI];
}

#pragma mark - UI

- (void)initAndLayoutUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:[AdjustPervious7 tableviewStyle]];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.separatorColor = kColor(194, 213, 224, 1);
    _tableView.backgroundColor = kColor(244, 244, 244, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15.f)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView; 
    [self.view addSubview:_tableView];
    if (kDeviceVersion < 7.0) {
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = footerView;
    }
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
    //旧密码
    _oldPasswordField = [[UITextField alloc] init];
    _oldPasswordField.borderStyle = UITextBorderStyleNone;
    _oldPasswordField.backgroundColor = kColor(247, 250, 251, 1);
    _oldPasswordField.delegate = self;
    _oldPasswordField.placeholder = @"Original Password";
    _oldPasswordField.font = [UIFont systemFontOfSize:15.f];
    _oldPasswordField.secureTextEntry = YES;
    UIView *oldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, imageSize)];
    UIImageView *oldImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, imageSize, imageSize)];
    oldImageView.image = [UIImage imageNamed:@"confirm.png"];
    [oldView addSubview:oldImageView];
    _oldPasswordField.leftView = oldView;
    _oldPasswordField.leftViewMode = UITextFieldViewModeAlways;
    _oldPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _oldPasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //新密码
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
    //confirm
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
}

#pragma mark - Action

- (IBAction)savePersonInfo:(id)sender {
    //输入验证
    if (!_oldPasswordField.text || [_oldPasswordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                        message:@"Original password can't be empty!"
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
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface modifyPasswordWithStudentID:delegate.userID token:delegate.token oldPassword:_oldPasswordField.text password:_passwordField.text finished:^(BOOL success, NSData *response) {
        if (success) {
            [hud hide:YES];
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",object);
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == requestSuccess) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                                    message:@"Modify success!"
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
            hud.labelText = @"Modify failed";
        }
    }];

}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 3;
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
                    //old password
                    _oldPasswordField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_oldPasswordField];
                }
                    break;
                case 1: {
                    //new password
                    _passwordField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_passwordField];
                }
                    break;
                case 2: {
                    //confirm password
                    _confirmField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_confirmField];
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
        AppDelegate *delegate = [AppDelegate shareAppDelegate];
        [delegate clearLoginInfo];
        [[delegate rootViewController] showLoginViewController];
    }
}

@end
