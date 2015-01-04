//
//  DirectoryController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "DirectoryController.h"
#import "TreeView.h"
#import "DirectoryDataHandle.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "RefreshView.h"
#import "DirectoryDeatilController.h"

@interface DirectoryController ()<TreeDelegate,RefreshDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) TreeView *treeView;

@property (nonatomic, strong) NSMutableArray *dataItem;

@property (nonatomic, strong) RefreshView *topRefreshView;

@property (nonatomic, assign) BOOL reloading;

@property (nonatomic, assign) CGFloat primaryOffsetY;

@end

@implementation DirectoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [DirectoryDataHandle titleForModuleType:self.moduleType];
    if (kDeviceVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [self initAndLayoutUI];
    [self downloadDataWithStyle:DownloadNormal];
}

#pragma mark - UI

- (void)initAndLayoutUI {
    CGRect rect = self.view.bounds;
    rect.size.height -= self.navigationController.navigationBar.frame.size.height;
    if (kDeviceVersion >= 7.0) {
        rect.size.height -= [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    _treeView = [[TreeView alloc] initWithFrame:rect];
    _treeView.backgroundColor = kColor(244, 244, 244, 1);
    _treeView.TreeDelegate = self;
    [self.view addSubview:_treeView];
    if (self.moduleType == ModuleCampus) {
        [self addHeaderView];
    }
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, self.view.bounds.size.width, 80)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_treeView.tableView addSubview:_topRefreshView];
}

//Campus模块添加headerview
- (void)addHeaderView {
    //图片比例320x188
    CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenWidth / 320 * 188);
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:rect];
    headerView.image = [UIImage imageNamed:@"campus.png"];
    _treeView.tableView.tableHeaderView = headerView;
}

#pragma mark - Data

- (void)downloadDataWithStyle:(DownloadStyle)style {
    int directoryType = [DirectoryDataHandle typeForModuleType:self.moduleType];
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if (directoryType > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText = @"Loading...";
        [NetworkInterface directoryListWithStudentID:delegate.userID token:delegate.token type:directoryType finished:^(BOOL success, NSData *response) {
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:0.3f];
            if (success) {
                hud.labelText = @"finished";
                id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
                if ([object isKindOfClass:[NSDictionary class]]) {
                    if ([[object objectForKey:@"code"] intValue] == requestSuccess) {
                        NSLog(@"%@",object);
                        [self parseWithInfo:object];
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
                NSLog(@"directory load failed");
                hud.labelText = @"Load failed";
            }
            if (style == DownloadFormTop) {
                [self refreshViewFinishedLoadingWithDirection:PullFromTop];
            }
        }];
    }
}

- (void)parseWithInfo:(NSDictionary *)object {
    self.dataItem = [DirectoryDataHandle parseData:object];
    [_treeView reloadData];
}

#pragma mark - TreeDelegate

- (NSInteger)treeView:(TreeView *)treeView numberOfChildrenOfItem:(id)item {
    if (item == nil) {
        return [self.dataItem count];
    }
    return [[(TreeDirectory *)item children] count];
}

- (id)treeView:(TreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    if (item == nil) {
        return [self.dataItem objectAtIndex:index];
    }
    return [[(TreeDirectory *)item children] objectAtIndex:index];
}

- (UITableViewCell *)treeView:(TreeView *)treeView cellForItem:(id)item treeNodeInfo:(TreeNodeInfo *)treeNodeInfo {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [treeView.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [(TreeDirectory *)item directoryName];
    cell.textLabel.textColor = kColor(3, 39, 65, 1);
    cell.textLabel.backgroundColor = [UIColor clearColor];
    if ([treeNodeInfo.childrenTreeNodes count] > 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 10)];
        imageView.image = [UIImage imageNamed:@"arrow.png"];
        cell.accessoryView = imageView;
    }
    else {
        cell.accessoryView = nil;
    }
    return cell;
}

- (void)treeView:(TreeView *)treeView didSelectRowForCell:(UITableViewCell *)cell ofItem:(id)item treeNodeInfo:(TreeNodeInfo *)treeNodeInfo {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    if (treeNodeInfo.expanded) {
        animation.values = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI / 2, 0, 0, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],nil];
    }
    else {
        animation.values = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI / 2, 0, 0, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)],nil];
    }
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [cell.accessoryView.layer addAnimation:animation forKey:@"transform"];
    if ([treeNodeInfo.children count] == 0) {
        DirectoryDeatilController *detailC = [[DirectoryDeatilController alloc] init];
        detailC.directoryID = [(TreeDirectory *)item directoryID];
        detailC.directoryTitle = [(TreeDirectory *)item directoryName];
        [self.navigationController pushViewController:detailC animated:YES];
    }
}

- (NSInteger)treeView:(TreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(TreeNodeInfo *)treeNodeInfo {
    return 3 * treeNodeInfo.treeDepthLevel;
}

- (void)treeView:(TreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(TreeNodeInfo *)treeNodeInfo {
    if (treeNodeInfo.treeDepthLevel == 1) {
        cell.contentView.backgroundColor = kColor(222, 240, 250, 1);
    }
    else {
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - Refresh

- (void)refreshViewReloadData {
    _reloading = YES;
}

- (void)refreshViewFinishedLoadingWithDirection:(PullDirection)direction {
    _reloading = NO;
    if (direction == PullFromTop) {
        [_topRefreshView refreshViewDidFinishedLoading:_treeView.tableView];
    }
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
}

#pragma mark - treeView scrollView

- (void)treeViewWillBeginDragging:(UIScrollView *)scrollView {
    _primaryOffsetY = scrollView.contentOffset.y;
}

- (void)treeViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _treeView.tableView) {
        CGPoint newPoint = scrollView.contentOffset;
        NSLog(@"%f,%f",_primaryOffsetY,newPoint.y);
        if (_primaryOffsetY > newPoint.y) {
            [_topRefreshView refreshViewDidScroll:scrollView];
        }
    }
}

- (void)treeViewDidEndDragging:(UIScrollView *)scrollView {
    if (scrollView == _treeView.tableView) {
        CGPoint newPoint = scrollView.contentOffset;
        if (_primaryOffsetY > newPoint.y) {
            [_topRefreshView refreshViewDidEndDragging:scrollView];
        }
    }
}

#pragma mark - 下拉刷新

- (void)pullDownToLoadData {
    [self downloadDataWithStyle:DownloadFormTop];
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
