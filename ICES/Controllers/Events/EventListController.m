//
//  EventListController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/10.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "EventListController.h"
#import "EventCell.h"
#import "RefreshView.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "EventDetailController.h"

@interface EventListController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataItem;

@property (nonatomic, strong) RefreshView *topRefreshView;

@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;

@property (nonatomic, assign) CGFloat primaryOffsetY;

@property (nonatomic, assign) int page;

@end

@implementation EventListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColor(244, 244, 244, 1);
    self.title = [EventDataHandle titleForEventType:_eventType];
    if (kDeviceVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    _dataItem = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self firstLoadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kColor(244, 244, 244, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self; 
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
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, self.view.bounds.size.width, 80)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_tableView addSubview:_topRefreshView];
    
    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    _bottomRefreshView.direction = PullFromBottom;
    _bottomRefreshView.delegate = self;
    _bottomRefreshView.hidden = YES;
    [_tableView addSubview:_bottomRefreshView];
}

#pragma mark - Data

- (void)firstLoadData {
    _page = 1;
    [self downloadDataWithPage:_page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    NSLog(@"page = %d",page);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Loading...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface eventListWithStudentID:delegate.userID token:delegate.token type:self.eventType page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",object);
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == requestSuccess) {
                    if (!isMore) {
                        [self.dataItem removeAllObjects];
                    }
                    if ([[object objectForKey:@"result"] count] > 0) {
                        self.page ++;
                        [hud hide:YES];
                    }
                    else {
                        hud.customView = [[UIImageView alloc] init];
                        hud.mode = MBProgressHUDModeCustomView;
                        [hud hide:YES afterDelay:0.3f];
                        hud.labelText = @"No more data.";
                    }
                    [self parseWithInfo:object];
                }
                else if ([[object objectForKey:@"code"] intValue] == requestTokenOverdue) {
                    [hud hide:YES];
                    //失效
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPromptInfo
                                                                    message:[object objectForKey:@"message"]
                                                                   delegate:self
                                                          cancelButtonTitle:@"Sure"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else {
                    [hud hide:YES];
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
            hud.labelText = @"Load failed";
        }
        if (!isMore) {
            [self refreshViewFinishedLoadingWithDirection:PullFromTop];
        }
        else {
            [self refreshViewFinishedLoadingWithDirection:PullFromBottom];
        }
    }];
}

//解析
- (void)parseWithInfo:(NSDictionary *)dict {
    NSMutableArray *loadingArray = [EventDataHandle parseData:dict];
    [self.dataItem addObjectsFromArray:loadingArray];
    [_tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"EventList";
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[EventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.contentView.backgroundColor = kColor(244, 244, 244, 1);
    EventModel *eventData = [self.dataItem objectAtIndex:indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kImageURL,eventData.eventSmallImage]];
    [cell.pictureView sd_setImageWithURL:imageURL placeholderImage:nil];
    cell.titleLabel.text = eventData.eventName;
    cell.summaryLabel.text = eventData.eventSummary;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kEventCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EventDetailController *detailC = [[EventDetailController alloc] init];
    EventModel *eventData = [self.dataItem objectAtIndex:indexPath.row];
    detailC.eventData = eventData;
    [self.navigationController pushViewController:detailC animated:YES];
}

#pragma mark - Refresh

- (void)refreshViewReloadData {
    _reloading = YES;
}

- (void)refreshViewFinishedLoadingWithDirection:(PullDirection)direction {
    _reloading = NO;
    if (direction == PullFromTop) {
        [_topRefreshView refreshViewDidFinishedLoading:_tableView];
    }
    else if (direction == PullFromBottom) {
        _bottomRefreshView.frame = CGRectMake(0, _tableView.contentSize.height, _tableView.bounds.size.width, 60);
        [_bottomRefreshView refreshViewDidFinishedLoading:_tableView];
    }
    [self updateFooterViewFrame];
}

- (BOOL)refreshViewIsLoading:(RefreshView *)view {
    return _reloading;
}

- (void)refreshViewDidEndTrackingForRefresh:(RefreshView *)view {
    [self refreshViewReloadData];
    //loading...
    if (view == _topRefreshView) {
        [self pullDownToLoadData];
    }
    else if (view == _bottomRefreshView) {
        [self pullUpToLoadData];
    }
}

- (void)updateFooterViewFrame {
    _bottomRefreshView.frame = CGRectMake(0, _tableView.contentSize.height, _tableView.bounds.size.width, 60);
    _bottomRefreshView.hidden = NO;
    if (_tableView.contentSize.height < _tableView.frame.size.height) {
        _bottomRefreshView.hidden = YES;
    }
}

#pragma mark - UIScrollView 

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _primaryOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        CGPoint newPoint = scrollView.contentOffset;
        if (_primaryOffsetY < newPoint.y) {
            //上拉
            if (_bottomRefreshView.hidden) {
                return;
            }
            [_bottomRefreshView refreshViewDidScroll:scrollView];
        }
        else {
            //下拉
            [_topRefreshView refreshViewDidScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _tableView) {
        CGPoint newPoint = scrollView.contentOffset;
        if (_primaryOffsetY < newPoint.y) {
            //上拉
            if (_bottomRefreshView.hidden) {
                return;
            }
            [_bottomRefreshView refreshViewDidEndDragging:scrollView];
        }
        else {
            //下拉
            [_topRefreshView refreshViewDidEndDragging:scrollView];
        }
    }
}

#pragma mark - 上下拉刷新
//下拉刷新
- (void)pullDownToLoadData {
    [self firstLoadData];
}

//上拉加载
- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
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
