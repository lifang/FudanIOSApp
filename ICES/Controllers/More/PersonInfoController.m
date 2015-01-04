//
//  PersonInfoController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/3.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "PersonInfoController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "AdjustPervious7.h"

@interface PersonInfoController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *mobileField;

@property (nonatomic, strong) UITextField *emailField;

@property (nonatomic, strong) UITextField *activeField;

@end

@implementation PersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Your Info";
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
    if (kDeviceVersion >= 7.0) {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 30, 0, 30);
    }
    else {
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = footerView;
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15.f)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
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
    //手机
    _mobileField = [[UITextField alloc] init];
    _mobileField.borderStyle = UITextBorderStyleNone;
    _mobileField.backgroundColor = kColor(247, 250, 251, 1);
    _mobileField.delegate = self;
    _mobileField.placeholder = @"Mobile phone";
    _mobileField.font = [UIFont systemFontOfSize:15.f];
    UIView *mobileView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, imageSize)];
    UIImageView *mobileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, imageSize, imageSize)];
    mobileImageView.image = [UIImage imageNamed:@"mobile.png"];
    [mobileView addSubview:mobileImageView];
    _mobileField.leftView = mobileView;
    _mobileField.leftViewMode = UITextFieldViewModeAlways;
    _mobileField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mobileField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //邮箱
    _emailField = [[UITextField alloc] init];
    _emailField.borderStyle = UITextBorderStyleNone;
    _emailField.backgroundColor = kColor(247, 250, 251, 1);
    _emailField.delegate = self;
    _emailField.placeholder = @"Email";
    _emailField.font = [UIFont systemFontOfSize:15.f];
    UIView *emailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, imageSize)];
    UIImageView *emailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, imageSize, imageSize)];
    emailImageView.image = [UIImage imageNamed:@"email.png"];
    [emailView addSubview:emailImageView];
    _emailField.leftView = emailView;
    _emailField.leftViewMode = UITextFieldViewModeAlways;
    _emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
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
}

#pragma mark - Action

- (IBAction)savePersonInfo:(id)sender {
    //输入验证
    if (!_emailField.text || [_emailField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                        message:@"Email can't be empty!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Sure"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_activeField.text || [_activeField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                        message:@"Activation can't be empty!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Sure"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Submitting...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface modifyUserInfoWithStudentID:delegate.userID token:delegate.token mobilePhone:_mobileField.text studentEmail:_emailField.text activationCode:_activeField.text finished:^(BOOL success, NSData *response) {
        if (success) {
            [hud hide:YES];
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",object);
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == requestSuccess) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                                    message:@"Modify success!"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Sure"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else if ([[object objectForKey:@"code"] intValue] == requestTokenOverdue) {
                    //失效
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                                    message:[object objectForKey:@"message"]
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 1;
            break;
        case 1:
            row = 2;
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
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    //email
                    _emailField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_emailField];
                }
                    break;
                case 1: {
                    //activation
                    _activeField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_activeField];
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
//    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 5.f;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 5.f;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [AdjustPervious7 tableviewHeaderOrFooterView];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        headerView.backgroundColor = [UIColor clearColor];
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, kScreenWidth - 60, 20)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont systemFontOfSize:10.f];
        tipLabel.text = @"Input your activation before change your Email!";
        [headerView addSubview:tipLabel];
        return headerView;
    }
    return [AdjustPervious7 tableviewHeaderOrFooterView];
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        AppDelegate *delegate = [AppDelegate shareAppDelegate];
        [delegate clearLoginInfo];
        [[delegate rootViewController] showLoginViewController];
    }
}

@end
