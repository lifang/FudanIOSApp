//
//  MainViewController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/2.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "MainViewController.h"
#import "HomeNavView.h"
#import "ModuleView.h"
#import "DirectoryController.h"
#import "EventMenuController.h"
#import "AroundMenuController.h"
#import "MessageViewController.h"
#import "MoreViewController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"

static NSInteger _lineCount = 2;   //首页模块行数
static NSInteger _columnCount = 3; //首页模块列数

@interface MainViewController ()

@property (nonatomic, strong) HomeNavView *homeNavView;

@property (nonatomic, strong) UIImageView *homeImageView;

@property (nonatomic, assign) int numberOfUnread;

- (IBAction)showMessage:(id)sender;

@end

@implementation MainViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    if (kDeviceVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self initAndLayoutUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPushInfo:) name:GetPushMessageNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //检测是否有新消息
    [self checkMessage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - UI

- (void)initAndLayoutUI {
    //导航
    [self initNavView];
    //首页图片
    [self initHomeImageView];
    //模块
    [self initModuleViews];
}

- (void)initNavView {
    CGRect rect = CGRectMake(0, 0, kScreenWidth, 94);
    if (kDeviceVersion < 7.0) {
        rect.size.height -= [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    _homeNavView = [[HomeNavView alloc] initWithFrame:rect imageName:@"hometitle.png"];
    [_homeNavView addRightButtonWithImage:@"homemessage.png" target:self action:@selector(showMessage:)];
    [self.view addSubview:_homeNavView];
}

- (void)initHomeImageView {
    //图片比例320x188
    CGRect rect = CGRectMake(0, _homeNavView.bounds.size.height, kScreenWidth, kScreenWidth / 320 * 188);
    _homeImageView = [[UIImageView alloc] initWithFrame:rect];
    _homeImageView.image = [UIImage imageNamed:@"homedefault.png"];
    [self.view addSubview:_homeImageView];
}

- (void)initModuleViews {
    //名称数组
    NSArray *nameArray = [NSArray arrayWithObjects:
                          @"Pre-Arrival",
                          @"Arrival",
                          @"Campus",
                          @"Events",
                          @"Around Campus",
                          @"More", nil];
    //背景数组
    NSArray *backColorArray = [NSArray arrayWithObjects:
                               kColor(17, 87, 185, 1),
                               kColor(14, 73, 154, 1),
                               kColor(16, 79, 163, 1),
                               kColor(25, 95, 189, 1),
                               kColor(18, 80, 162, 1),
                               kColor(10, 66, 140, 1), nil];
    CGFloat pre_os6 = 0;
    if (kDeviceVersion < 7.0) {
        pre_os6 = [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    CGFloat moduleWidth = kScreenWidth / _columnCount;
    CGFloat moduleHeight = (kScreenHeight - _homeNavView.bounds.size.height - _homeImageView.bounds.size.height - pre_os6) / _lineCount;
    CGRect rect = CGRectMake(0, _homeImageView.frame.origin.y + _homeImageView.bounds.size.height, moduleWidth, moduleHeight);
    for (int i = 0; i < _lineCount; i++) {
        for (int j = 1; j <= _columnCount; j++) {
            //计算偏移量
            rect.origin.x += moduleWidth;
            if (j == 1) {
                rect.origin.x = 0;
            }
            //计算在第几个位置
            NSInteger index = j + i * _columnCount - 1;
            NSString *titleName = [nameArray objectAtIndex:index];
            NSString *imageName = [NSString stringWithFormat:@"module%ld.png",index + 1];
            UIColor *backColor = [backColorArray objectAtIndex:index];
            ModuleView *moduleView = [ModuleView buttonWithType:UIButtonTypeCustom];
            moduleView.frame = rect;
            [moduleView setTitleName:titleName imageName:imageName];
            [moduleView setBackgroundColor:backColor];
            moduleView.tag = index + 1;
            [moduleView addTarget:self action:@selector(moduleSelected:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:moduleView];
        }
        rect.origin.y += moduleHeight;
    }
}

#pragma mark - Data 

- (void)checkMessage {
    [_homeNavView needShowTipView:NO];
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface checkMessageWithStudentID:delegate.userID token:delegate.token finished:^(BOOL success, NSData *response) {
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",object);
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == requestSuccess) {
                    NSString *countNumber = [NSString stringWithFormat:@"%@",[object objectForKey:@"result"]];
                    _numberOfUnread = [countNumber intValue];
                    if (_numberOfUnread > 0) {
                        [_homeNavView needShowTipView:YES];
                    }
                }
            }
        }
    }];
}

#pragma mark - Action

- (IBAction)showMessage:(id)sender {
    MessageViewController *messageC = [[MessageViewController alloc] init];
    messageC.numberOfUnread = _numberOfUnread;
    [self.navigationController pushViewController:messageC animated:YES];
}

- (IBAction)moduleSelected:(id)sender {
    ModuleView *moduleView = (ModuleView *)sender;
    NSLog(@"%ld",moduleView.tag);
    switch (moduleView.tag) {
        case ModulePreArrival: {
            DirectoryController *directoryC = [[DirectoryController alloc] init];
            directoryC.moduleType = ModulePreArrival;
            [self.navigationController pushViewController:directoryC animated:YES];
        }
            break;
        case ModuleArrival: {
            DirectoryController *directoryC = [[DirectoryController alloc] init];
            directoryC.moduleType = ModuleArrival;
            [self.navigationController pushViewController:directoryC animated:YES];
        }
            break;
        case ModuleCampus: {
            DirectoryController *directoryC = [[DirectoryController alloc] init];
            directoryC.moduleType = ModuleCampus;
            [self.navigationController pushViewController:directoryC animated:YES];
        }
            break;
        case ModuleEvents: {
            EventMenuController *eventC = [[EventMenuController alloc] init];
            [self.navigationController pushViewController:eventC animated:YES];
        }
            break;
        case ModuleAroundCampus: {
            AroundMenuController *aroundC = [[AroundMenuController alloc] init];
            [self.navigationController pushViewController:aroundC animated:YES];
        }
            break;
        case ModuleMore: {
            MoreViewController *moreC = [[MoreViewController alloc] init];
            [self.navigationController pushViewController:moreC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 推送通知

- (void)getPushInfo:(NSNotification *)notification {
    [_homeNavView needShowTipView:YES];
}

@end
