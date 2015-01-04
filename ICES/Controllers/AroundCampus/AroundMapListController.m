//
//  AroundMapListController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/24.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "AroundMapListController.h"
#import "RefreshView.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "BMapKit.h"
#import "AroundMapDetailController.h"

#define kLoadingViewTag   400

#define kLatitude   31.302398
#define kLongitude  121.510424

@interface AroundMapListController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate,BMKPoiSearchDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataItem;

@property (nonatomic, strong) RefreshView *topRefreshView;

@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;

@property (nonatomic, assign) CGFloat primaryOffsetY;

@property (nonatomic, assign) int page;

@property (nonatomic, assign) int isMore;

@property (nonatomic, strong) BMKPoiSearch *POISearch;

@end

@implementation AroundMapListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColor(244, 244, 244, 1);
    self.title = [AroundDataHandle titleForAroundCampusType:_aroundType];
    if (kDeviceVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [self initAndLayoutUI];
    _dataItem = [[NSMutableArray alloc] init];
    _POISearch = [[BMKPoiSearch alloc] init];
    _POISearch.delegate = self;
    [self firstSearch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    _POISearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    _POISearch.delegate = nil;
}

#pragma mark - UI

- (void)initAndLayoutUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kColor(244, 244, 244, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
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

- (NSString *)keywordForType {
    NSString *keyword = nil;
    switch (_aroundType) {
        case AroundMenuSupermarket:
            keyword = @"超市";
            break;
        case AroundMenuBank:
            keyword = @"银行";
            break;
        case AroundMenuPost:
            keyword = @"邮局";
            break;
        case AroundMenuHotel:
            keyword = @"酒店";
            break;
        default:
            break;
    }
    return keyword;
}

- (void)firstSearch {
    _page = 0;
    [self searchDataWithPage:_page isMore:NO];
}

- (void)searchDataWithPage:(int)page isMore:(BOOL)isMore {
    _isMore = isMore;
    NSLog(@"page = %d",page);
    for (UIView *view in self.navigationController.view.subviews) {
        if (view.tag == kLoadingViewTag) {
            [view removeFromSuperview];
            break;
        }
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Loading...";
    hud.tag = kLoadingViewTag;
    BMKNearbySearchOption *searchOption = [[BMKNearbySearchOption alloc] init];
    searchOption.keyword = [self keywordForType];
    searchOption.pageIndex = page;
    searchOption.pageCapacity = kPageSize;
    searchOption.location = CLLocationCoordinate2DMake(kLatitude, kLongitude);
    searchOption.radius = 5000;
    BOOL flag = [_POISearch poiSearchNearBy:searchOption];
    if (flag) {
        NSLog(@"YES");
    }
    else {
        NSLog(@"NO");
        [hud hide:YES];
        [self resetStatus];
    }
}

- (void)resetStatus {
    if (!_isMore) {
        [self refreshViewFinishedLoadingWithDirection:PullFromTop];
    }
    else {
        [self refreshViewFinishedLoadingWithDirection:PullFromBottom];
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
    static NSString *identifier = @"nearby";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    BMKPoiInfo *poi = [_dataItem objectAtIndex:indexPath.row];
    cell.textLabel.textColor = kColor(3, 39, 65, 1);
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = poi.address;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AroundMapDetailController *mapC = [[AroundMapDetailController alloc] init];
    BMKPoiInfo *poi = [_dataItem objectAtIndex:indexPath.row];
    mapC.name = poi.name;
    mapC.coor = poi.pt;
    [self.navigationController pushViewController:mapC animated:YES];
}

#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    MBProgressHUD *hud = (MBProgressHUD *)[self.navigationController.view viewWithTag:kLoadingViewTag];
    for (UIView *view in self.navigationController.view.subviews) {
        NSLog(@"%@",view);
    }
    if (error == BMK_SEARCH_NO_ERROR) {
        [hud hide:YES];
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo *poi = [result.poiInfoList objectAtIndex:i];
            [list addObject:poi];
        }
        if (!_isMore) {
            [_dataItem removeAllObjects];
        }
        [_dataItem addObjectsFromArray:list];
        [_tableView reloadData];
        if ([result.poiInfoList count] > 0) {
            _page ++;
        }
    }
    else {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR) {
            hud.labelText = @"The starting point is ambiguous";
        }
        else if (error == BMK_SEARCH_RESULT_NOT_FOUND) {
            hud.labelText = @"No Result";
        }
    }
    [self resetStatus];
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
    [self firstSearch];
}

//上拉刷新
- (void)pullUpToLoadData {
    [self searchDataWithPage:self.page isMore:YES];
}


@end
