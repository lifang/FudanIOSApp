//
//  MoreViewController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/3.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "MoreViewController.h"
#import "AppDelegate.h"
#import "PersonInfoController.h"
#import "ChangePasswordController.h"
#import "NetworkInterface.h"
#import "AdjustPervious7.h"

#define kContentTag   100

@interface MoreViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"More";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [self initAndLauoutUI];
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *signOut = [UIButton buttonWithType:UIButtonTypeCustom];
    signOut.frame = CGRectMake(16, 60, kScreenWidth - 32, 40);
    signOut.layer.cornerRadius = 4;
    signOut.layer.masksToBounds = YES;
    signOut.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [signOut setTitle:@"Exit" forState:UIControlStateNormal];
    [signOut setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    [signOut setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
    [signOut addTarget:self action:@selector(signOut:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:signOut];
    _tableView.tableFooterView = footerView;
}

- (void)initAndLauoutUI {
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

}

#pragma mark - Action

- (IBAction)signOut:(id)sender {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Sign out...";
    [NetworkInterface loginOutWithStudentID:delegate.userID token:delegate.token finished:^(BOOL success, NSData *response) {
        [hud hide:YES];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == requestSuccess) {
                    
                }
            }
        }
        //请求成功失败都要跳转
        [[AppDelegate shareAppDelegate] clearLoginInfo];
        [[[AppDelegate shareAppDelegate] rootViewController] showLoginViewController];
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
            row = 2;
            break;
        case 1:
            row = 3;
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
        contentLabel.backgroundColor = kColor(247, 250, 251, 1);
        contentLabel.font = [UIFont systemFontOfSize:15.f];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.textColor = kColor(3, 39, 65, 1);
        contentLabel.tag = kContentTag;
        [cell.contentView addSubview:contentLabel];
    }
    UILabel *contentLabel = (UILabel *)[cell.contentView viewWithTag:kContentTag];
    contentLabel.text = nil;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    //info
                    contentLabel.text = @"Your Info";
                }
                    break;
                case 1: {
                    //change password
                    contentLabel.text = @"Change Password";
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
                    //about us
                    contentLabel.text = @"About Us";
                }
                    break;
                case 1: {
                    //contact us
                    contentLabel.text = @"Contact Us";
                }
                    break;
                case 2: {
                    //update
                    contentLabel.text = @"Update";
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
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    //info
                    PersonInfoController *personC = [[PersonInfoController alloc] init];
                    [self.navigationController pushViewController:personC animated:YES];
                }
                    break;
                case 1: {
                    //change password
                    ChangePasswordController *changeC = [[ChangePasswordController alloc] init];
                    [self.navigationController pushViewController:changeC animated:YES];
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
                    //about us
                }
                    break;
                case 1: {
                    //contact us
                }
                    break;
                case 2: {
                    //update
                    [self checkVersion];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10.f;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [AdjustPervious7 tableviewHeaderOrFooterView];
}

#pragma mark - Check Version

- (void)checkVersion {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Checking...";
    [NetworkInterface checkVersionFinished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSArray *infoArray = [object objectForKey:@"results"];
                if ([infoArray count] > 0) {
                    NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                    NSString *lastVersion = [releaseInfo objectForKey:@"version"];
                    if (![lastVersion isEqualToString:currentVersion]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                                        message:@"Found the new version,Do you want to update?"
                                                                       delegate:self
                                                              cancelButtonTitle:@"Cancel"
                                                              otherButtonTitles:@"Update", nil];
                        [alert show];
                    }
                    else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                                        message:@"It's already the lastest version!"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                }

            }
        }
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSString *url = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",kAppID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

@end
