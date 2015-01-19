//
//  FindPasswordController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/2.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FindPasswordController.h"
#import "NetworkInterface.h"
#import "AdjustPervious7.h"

@interface FindPasswordController()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *validateField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *confirmField;

@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIButton *checkBtn;

@property (nonatomic, strong) UIImageView *checkImageView; //验证小图标

@property (nonatomic, strong) UILabel *countDownLabel; //倒计时

@property (nonatomic, strong) UILabel *resetLabel; //重置提示

@property (nonatomic, assign) BOOL isFirstSend;

@property (nonatomic, strong) NSString *validateCode;

@end

@implementation FindPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Find Password";
    [self initAndLayoutUI];
}

#pragma mark - Set

- (void)setIsFirstSend:(BOOL)isFirstSend {
    _isFirstSend = isFirstSend;
    if (_isFirstSend) {
        [_sendBtn setTitle:@"Resend Code" forState:UIControlStateNormal];
        _checkBtn.hidden = NO;
        _countDownLabel.hidden = NO;
    }
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(16, 20, kScreenWidth - 32, 40);
    sureBtn.layer.cornerRadius = 4;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [sureBtn setTitle:@"Sure" forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
    [sureBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:sureBtn];
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
    //验证码
    _validateField = [[UITextField alloc] init];
    _validateField.borderStyle = UITextBorderStyleNone;
    _validateField.backgroundColor = kColor(247, 250, 251, 1);
    _validateField.delegate = self;
    _validateField.placeholder = @"Verification Code";
    _validateField.font = [UIFont systemFontOfSize:15.f];
    UIView *validateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, imageSize)];
    UIImageView *validateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, imageSize, imageSize)];
    validateImageView.image = [UIImage imageNamed:@"validate.png"];
    [validateView addSubview:validateImageView];
    _validateField.leftView = validateView;
    _validateField.leftViewMode = UITextFieldViewModeAlways;
    _validateField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _validateField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
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
    
    //按钮
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_sendBtn setTitleColor:kColor(43, 188, 71, 1) forState:UIControlStateNormal];
    [_sendBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
    [_sendBtn addTarget:self action:@selector(sendCode:) forControlEvents:UIControlEventTouchUpInside];
    [_sendBtn setTitle:@"Send Code" forState:UIControlStateNormal];
    
    _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_checkBtn setTitleColor:kColor(43, 188, 71, 1) forState:UIControlStateNormal];
    [_checkBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
    [_checkBtn addTarget:self action:@selector(checkCode:) forControlEvents:UIControlEventTouchUpInside];
    [_checkBtn setTitle:@"Check" forState:UIControlStateNormal];
    _checkBtn.hidden = YES;
    
    _checkImageView = [[UIImageView alloc] init];
    _checkImageView.hidden = YES;
}

- (void)refreshUIAfterSend {
    //发送请求成功后
    if (!_isFirstSend) {
        self.isFirstSend = YES;
    }
    _sendBtn.userInteractionEnabled = NO;
    [self countDownStart];
}

#pragma mark - Data



#pragma mark - Action

- (IBAction)sendCode:(id)sender {
    [_usernameField becomeFirstResponder];
    [_usernameField resignFirstResponder];
    if (!_usernameField.text || [_usernameField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                        message:@"Email can't be empty!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Sure"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    _resetLabel.hidden = YES;
    _checkImageView.hidden = YES;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Sending...";
    [NetworkInterface getValidateCodeWithEmail:_usernameField.text finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",object);
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == requestSuccess) {
                    hud.labelText = @"Send success";
                    NSDictionary *results = [object objectForKey:@"result"];
                    _validateCode = [NSString stringWithFormat:@"%@",[results objectForKey:@"activationCode"]];
                    [self refreshUIAfterSend];
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
            NSLog(@"send failed!");
            hud.labelText = @"Send failed";
        }
    }];
}

- (IBAction)checkCode:(id)sender {
    [_usernameField becomeFirstResponder];
    [_usernameField resignFirstResponder];
    if ([_validateCode isEqualToString:_validateField.text]) {
        _resetLabel.hidden = NO;
        _checkImageView.image = [UIImage imageNamed:@"check2.png"];
        _checkImageView.hidden = NO;
    }
    else {
        _resetLabel.hidden = YES;
        _checkImageView.image = [UIImage imageNamed:@"check1.png"];
        _checkImageView.hidden = NO;
    }
}

- (IBAction)sure:(id)sender {
    [_usernameField becomeFirstResponder];
    [_usernameField resignFirstResponder];
    //输入验证
    if (!_usernameField.text || [_usernameField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                        message:@"Email can't be empty!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Sure"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_validateField.text || [_validateField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                        message:@"Activation can't be empty!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Sure"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_passwordField.text || [_passwordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                        message:@"Password can't be empty!"
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
    if (!_validateCode || [_validateCode isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                        message:@"Please get activation code first!"
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
    [NetworkInterface findPasswordWithStudentEmail:_usernameField.text activationCode:_validateField.text studentPassword:_passwordField.text finished:^(BOOL success, NSData *response) {
        if (success) {
            [hud hide:YES];
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",object);
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == requestSuccess) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                                    message:@"Modify password success!"
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
            hud.labelText = @"Submit failed";
        }
    }];
}

#pragma mark - Logic
//倒计时
- (void)countDownStart {
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){
            //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //UI更新
                _sendBtn.userInteractionEnabled = YES;
                [_sendBtn setTitleColor:kColor(43, 188, 71, 1) forState:UIControlStateNormal];
                _countDownLabel.hidden = YES;
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _sendBtn.userInteractionEnabled = NO;
                [_sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                _countDownLabel.hidden = NO;
                NSString *text = [NSString stringWithFormat:@"The remaining %d seconds",timeout];
                NSRange range = NSMakeRange(14, [[NSString stringWithFormat:@"%d",timeout] length]);
                NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
                [attrText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
                _countDownLabel.attributedText = attrText;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 1;
            break;
        case 1:
            row = 1;
            break;
        case 2:
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
                    //username
                    CGFloat btnWidth = 100;
                    _usernameField.frame = CGRectMake(0, 0, kScreenWidth - btnWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_usernameField];
                    _sendBtn.frame = CGRectMake(kScreenWidth - btnWidth, 0, btnWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_sendBtn];
                    cell.contentView.backgroundColor = kColor(247, 250, 251, 1);
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
                    //Validate Code
                    CGFloat imageSize = 20.f;
                    CGFloat btnWidth = 60.f;
                    _validateField.frame = CGRectMake(0, 0, kScreenWidth - imageSize - btnWidth - 40, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_validateField];
                    _checkImageView.frame = CGRectMake(_validateField.bounds.size.width + 10, (cell.contentView.bounds.size.height - imageSize ) / 2, imageSize, imageSize);
                    [cell.contentView addSubview:_checkImageView];
                    _checkBtn.frame = CGRectMake(kScreenWidth - btnWidth, 0, btnWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_checkBtn];
                    cell.contentView.backgroundColor = kColor(247, 250, 251, 1);
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    //new password
                    _passwordField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_passwordField];
                }
                    break;
                case 1: {
                    //confirm password
                    _confirmField.frame = CGRectMake(0, 0, kScreenWidth, cell.contentView.bounds.size.height);
                    [cell.contentView addSubview:_confirmField];
                }
                    break;
                default:
                    break;
            }
        }
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.f;
    switch (section) {
        case 1:
            height = 20.f;
            break;
        case 2:
            height = 35.f;
            break;
        default:
            break;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        headerView.backgroundColor = [UIColor clearColor];
        if (!_resetLabel) {
            _resetLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, kScreenWidth - 60, 20)];
            _resetLabel.backgroundColor = [UIColor clearColor];
            _resetLabel.font = [UIFont systemFontOfSize:12.f];
            _resetLabel.text = @"Reset Your Password";
        }
        _resetLabel.hidden = YES;
        [headerView addSubview:_resetLabel];
        return headerView;
    }
    return [AdjustPervious7 tableviewHeaderOrFooterView];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        footerView.backgroundColor = [UIColor clearColor];
        if (!_countDownLabel) {
            _countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, kScreenWidth - 60, 20)];
            _countDownLabel.backgroundColor = [UIColor clearColor];
            _countDownLabel.font = [UIFont systemFontOfSize:12.f];
        }
        _countDownLabel.hidden = YES;
        [footerView addSubview:_countDownLabel];
        return footerView;
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
