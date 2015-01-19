//
//  MessageViewController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/11.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import "RefreshView.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "MessageDataHandle.h"
#import "UIImageView+WebCache.h"
#import "MessageDetailController.h"
#import "KxMenu.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataItem;

@property (nonatomic, strong) RefreshView *topRefreshView;

@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;

@property (nonatomic, assign) CGFloat primaryOffsetY;

@property (nonatomic, assign) int page;

@property (nonatomic, assign) MessageStatus messageStatus;

@property (nonatomic, strong) UIButton *readBtn;

@end

@implementation MessageViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (kDeviceVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    _dataItem = [[NSMutableArray alloc] init];
    NSString *rightName = @"New";
    if (_numberOfUnread <= 0) {
        _messageStatus = MessageStatusRecent;
        rightName = @"Recent";
        self.title = @"Recent";
    }
    else {
        _messageStatus = MessageStatusNew;
        self.title = [NSString stringWithFormat:@"%d unread",_numberOfUnread];
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:rightName style:UIBarButtonItemStyleBordered target:self action:@selector(showMessageStatus:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [self initAndLayoutUI];
    [self firstLoadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setReadStatus:) name:MessageListReadNotification object:nil];
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
    
    _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _readBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_readBtn setBackgroundImage:[UIImage imageNamed:@"readmessage.png"] forState:UIControlStateNormal];
    [_readBtn addTarget:self action:@selector(readAll:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_readBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_readBtn
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_readBtn
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-40]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_readBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:40]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_readBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:40]];
    if (_messageStatus != MessageStatusNew) {
        _readBtn.hidden = YES;
    }
}

#pragma mark - Action

- (IBAction)showMessageStatus:(id)sender {
    NSMutableArray *listArray = [NSMutableArray arrayWithObjects:
                                 [KxMenuItem menuItem:@"New"
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:self.navigationItem.rightBarButtonItem.title],
                                 [KxMenuItem menuItem:@"Recent"
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:self.navigationItem.rightBarButtonItem.title],
                                 [KxMenuItem menuItem:@"All"
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:self.navigationItem.rightBarButtonItem.title],
                                 nil];
    
    CGFloat originY = 60.f;
    if (kDeviceVersion < 7.0) {
        originY = 40.f;
    }
    CGRect rect = CGRectMake(self.view.bounds.size.width - 62, originY, 0, 0);
    [KxMenu showMenuInView:self.navigationController.view fromRect:rect menuItems:listArray];
}

- (IBAction)selectStatus:(id)sender {
    KxMenuItem *item = (KxMenuItem *)sender;
    if ([item.title isEqualToString:self.navigationItem.rightBarButtonItem.title]) {
        return;
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:item.title
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(showMessageStatus:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    _readBtn.hidden = YES;
    self.title = item.title;
    if ([item.title isEqualToString:@"New"]) {
        _messageStatus = MessageStatusNew;
        _readBtn.hidden = NO;
    }
    else if ([item.title isEqualToString:@"Recent"]) {
        _messageStatus = MessageStatusRecent;
    }
    else {
        _messageStatus = MessageStatusAll;
    }
    [self firstLoadData];
}

- (IBAction)readAll:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Mark all as read?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:@"Sure"
                                              otherButtonTitles:nil];
    [sheet showInView:self.view];
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
    [NetworkInterface notificationListWithStudentID:delegate.userID token:delegate.token status:_messageStatus page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
    NSMutableArray *loadingArray = [MessageDataHandle parseData:dict];
    [self.dataItem addObjectsFromArray:loadingArray];
    [_tableView reloadData];
    if (_messageStatus == MessageStatusNew) {
        _numberOfUnread = (int)[self.dataItem count];
        self.title = [NSString stringWithFormat:@"%ld unread",[self.dataItem count]];
    }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = nil;
    MessageModel *messageData = [self.dataItem objectAtIndex:indexPath.row];
    if (messageData.messageImagePath && ![messageData.messageImagePath isEqualToString:@""]) {
        cell = [tableView dequeueReusableCellWithIdentifier:messageCellIdentifier_image];
        if (cell == nil) {
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageCellIdentifier_image withCellStyle:MessageCellImage];
        }
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:messageCellIdentifier_text];
        if (cell == nil) {
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageCellIdentifier_text withCellStyle:MessageCellText];
        }
    }
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kImageURL,messageData.messageImagePath]];
    [cell.pictureView sd_setImageWithURL:imageURL];
    cell.titleLabel.text = messageData.messageTitle;
    cell.summaryLabel.text = messageData.messageSummary;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *messageData = [self.dataItem objectAtIndex:indexPath.row];
    if (messageData.messageImagePath && ![messageData.messageImagePath isEqualToString:@""]) {
        return (self.view.bounds.size.width - 30 ) * kMessageImageScale + 20 + 48;
    }
    else {
        return kMessageCellWithTextHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageModel *messageData = [self.dataItem objectAtIndex:indexPath.row];
    MessageDetailController *detailC = [[MessageDetailController alloc] init];
    detailC.messageData = messageData;
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

//上拉刷新
- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        AppDelegate *delegate = [AppDelegate shareAppDelegate];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText = @"Submitting...";
        [NetworkInterface notificationSetReadStatusWithStudentID:delegate.userID token:delegate.token finished:^(BOOL success, NSData *response) {
            if (success) {
                [hud hide:YES];
                id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
                if ([object isKindOfClass:[NSDictionary class]]) {
                    if ([[object objectForKey:@"code"] intValue] == requestSuccess) {
                        if (_messageStatus == MessageStatusNew) {
                            _numberOfUnread = 0;
                            self.title = @"0 unread";
                            [self.dataItem removeAllObjects];
                            [_tableView reloadData];
                        }
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
                hud.labelText = @"failed";
            }
        }];
    }
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        AppDelegate *delegate = [AppDelegate shareAppDelegate];
        [delegate clearLoginInfo];
        [[delegate rootViewController] showLoginViewController];
    }
}

#pragma mark - Notification

- (void)setReadStatus:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    if (_messageStatus == MessageStatusNew) {
        MessageModel *message = [dict objectForKey:@"read"];
        if ([_dataItem containsObject:message]) {
            [_dataItem removeObject:message];
            [_tableView reloadData];
            if (_numberOfUnread > 0) {
                _numberOfUnread --;
            }
            self.title = [NSString stringWithFormat:@"%d unread",_numberOfUnread];
        }
    }
}

@end
