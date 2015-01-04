//
//  EventMenuController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/3.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "EventMenuController.h"
#import "EventMenuView.h"
#import "EventListController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"

static NSInteger _eventMenuLine = 3;    //event菜单行数
static NSInteger _eventMenuColumn = 3;  //event菜单列数

@interface EventMenuController ()<UIAlertViewDelegate>

@end

@implementation EventMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Events";
    self.view.backgroundColor = kColor(244, 244, 244, 1);
    if (kDeviceVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [self initAndLayoutUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [self getTipNumber];
}

#pragma mark - UI

- (void)initAndLayoutUI {
    CGFloat topSpace = 40.f;    //上边界间距
    CGFloat leftSpace = 15.f;   //左边界间距
    CGFloat bottomSpace = 80.f; //下边界间距
    CGFloat rightSpace = 15.f;  //右边界间距
    CGFloat hSpace = 15.f;     //menu之间水平间距
    CGFloat vSpace = 20.f;     //menu之间垂直间距
    CGFloat barHeight = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    //名称数组
    NSArray *nameArray = [NSArray arrayWithObjects:
                          @"Lecture",
                          @"Traveling",
                          @"Sports",
                          @"Ceremony",
                          @"School club",
                          @"Forum",
                          @"Literature  and art",
                          @"Entertainment",
                          @"Other", nil];
    CGFloat menuWidth = (kScreenWidth - leftSpace - rightSpace - (_eventMenuColumn - 1) * hSpace) / _eventMenuColumn;
    CGFloat menuHeight = (kScreenHeight - barHeight - topSpace - bottomSpace - (_eventMenuLine - 1) * vSpace) / _eventMenuLine;
    CGRect rect = CGRectMake(0, topSpace, menuWidth, menuHeight);
    for (int i = 0; i < _eventMenuLine; i++) {
        for (int j = 1; j <= _eventMenuColumn; j++) {
            //计算偏移量
            rect.origin.x += menuWidth + hSpace;
            if (j == 1) {
                rect.origin.x = leftSpace;
            }
            //计算在第几个位置
            NSInteger index = j + i * _eventMenuLine - 1;
            NSString *titleName = [nameArray objectAtIndex:index];
            NSString *imageName = [NSString stringWithFormat:@"event%ld.png",index + 1];
            NSString *highName = [NSString stringWithFormat:@"eventselected%ld.png",index + 1];
            EventMenuView *menuView = [[EventMenuView alloc] initWithFrame:rect
                                                                 titleName:titleName
                                                                 imageName:imageName
                                                             highlightName:highName
                                                                     index:index + 1
                                                                    target:self
                                                                    action:@selector(eventMenuSelected:)];
            [self.view addSubview:menuView];
        }
        rect.origin.y += menuHeight + vSpace;
    }
}

#pragma mark - Data

- (void)getTipNumber {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getEventCountWithStudentID:delegate.userID token:delegate.token finished:^(BOOL success, NSData *response) {
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",object);
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == requestSuccess) {
                    [self parseData:object];
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
                
            }
        }
    }];
}

- (void)parseData:(NSDictionary *)object {
    if (![object objectForKey:@"result"] || ![[object objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *tipList = [object objectForKey:@"result"];
    NSMutableDictionary *countDict = [[NSMutableDictionary alloc] init];
    for (int i = 0 ; i < [tipList count]; i++) {
        NSDictionary *dict = [tipList objectAtIndex:i];
        NSString *typeString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"eventsType"]];
        NSString *numberString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"unReadCount"]];
        NSNumber *type = [NSNumber numberWithInt:[typeString intValue]];
        NSNumber *number = [NSNumber numberWithInt:[numberString intValue]];
        [countDict setObject:number forKey:type];
    }
    //显示
    for (EventMenuView *view in self.view.subviews) {
        if ([view isKindOfClass:[EventMenuView class]]) {
            NSNumber *key = [NSNumber numberWithInt:(int)view.index];
            NSNumber *number = [countDict objectForKey:key];
            if (![countDict objectForKey:key]) {
                number = [NSNumber numberWithInt:0];
            }
            [view setTipValue:[NSString stringWithFormat:@"%@",number]];
        }
    }
}

#pragma mark - Action

- (IBAction)eventMenuSelected:(id)sender {
    NSInteger tag = -1;
    if ([sender isKindOfClass:[UIButton class]]) {
        tag = [(UIButton *)sender tag];
    }
    else if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        tag = [(EventMenuView *)[(UITapGestureRecognizer *)sender view] index];
    }
    EventListController *eventC = [[EventListController alloc] init];
    eventC.eventType = (EventMenuType)tag;
    [self.navigationController pushViewController:eventC animated:YES];
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
