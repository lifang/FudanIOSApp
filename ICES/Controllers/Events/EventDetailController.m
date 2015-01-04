//
//  EventDetailController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/18.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "EventDetailController.h"
#import "EventDetailModel.h"
#import "TimeFormat.h"

static NSInteger phoneTag = 100;
static NSInteger joinTag  = 101;

@interface EventDetailController ()<ImageScrollViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

//显示全部内容的scrollview
@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *createLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *costLabel;
@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, assign) CGFloat contentOriginY;  //内容label的origin

@property (nonatomic, strong) EventDetailModel *detailData;

@property (nonatomic, strong) UIButton *joinBtn;

@end

@implementation EventDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_eventData) {
        self.title = _eventData.eventName;
    }
    [self initAndLayoutUI];
    [self downloadDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    [super initAndLayoutUI];
    
    _mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _mainScrollView.backgroundColor = kColor(247, 250, 251, 1);
    [self.view addSubview:_mainScrollView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mainScrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mainScrollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mainScrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mainScrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
    CGFloat width = self.view.bounds.size.width - leftSpace - rightSpace;
    CGRect rect = CGRectMake(leftSpace, topSpace, width, width * imageScale);
    self.topImageScrollView = [[UIScrollView alloc] initWithFrame:rect];
    self.topImageScrollView.showsHorizontalScrollIndicator = NO;
    self.topImageScrollView.showsVerticalScrollIndicator = NO;
    self.topImageScrollView.pagingEnabled = YES;
    self.topImageScrollView.delegate = self;
    self.topImageScrollView.backgroundColor = [UIColor blackColor];
    [_mainScrollView addSubview:self.topImageScrollView];
    
    //黄色背景
    CGFloat backWidth = 140.f;
    UIImageView *durationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - backWidth - 10, topSpace - 5, backWidth, 26.f)];
    durationImageView.image = [UIImage imageNamed:@"duration.png"];
    [_mainScrollView addSubview:durationImageView];
    //活动时间
    _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, backWidth - 10, durationImageView.bounds.size.height)];
    _durationLabel.backgroundColor = [UIColor clearColor];
    _durationLabel.font = [UIFont systemFontOfSize:14.f];
    [durationImageView addSubview:_durationLabel];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.userInteractionEnabled = NO;
    [_mainScrollView addSubview:self.pageControl];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.topImageScrollView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:20]];
    
    //标题背景
    CGFloat titleHeight = 40.f;
    rect.origin.y = rect.origin.y + rect.size.height;
    rect.size.height = titleHeight;
    UIView *titleView = [[UIView alloc] initWithFrame:rect];
    titleView.backgroundColor = kColor(233, 233, 232, 1);
    [_mainScrollView addSubview:titleView];
    
    [self layoutTitleView:titleView];
    
    CGFloat viewHeight = 36.f;
    CGFloat space = 4.f;
    rect.origin.y += rect.size.height + space;
    rect.size.height = viewHeight;
    //地址
    UIView *addressView = [[UIView alloc] initWithFrame:rect];
    addressView.backgroundColor = kColor(253, 254, 254, 1);
    addressView.layer.borderWidth = kLineHeight;
    addressView.layer.borderColor = kColor(219, 221, 222, 1).CGColor;
    [_mainScrollView addSubview:addressView];
    
    [self layoutAddressView:addressView];
    //花费和电话
    rect.origin.y += rect.size.height - kLineHeight;
    UIView *contactView = [[UIView alloc] initWithFrame:rect];
    contactView.backgroundColor = kColor(253, 254, 254, 1);
    contactView.layer.borderWidth = kLineHeight;
    contactView.layer.borderColor = kColor(219, 221, 222, 1).CGColor;
    [_mainScrollView addSubview:contactView];
    
    [self layoutContactView:contactView];
    
    _contentOriginY = rect.origin.y + rect.size.height;
}

//标题和创建时间
- (void)layoutTitleView:(UIView *)titleView {
    CGRect rect = titleView.bounds;
    CGFloat originX = 4.f;
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, rect.size.width - originX, 20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = kColor(3, 39, 65, 1);
    _titleLabel.font = [UIFont systemFontOfSize:15.f];
    [titleView addSubview:_titleLabel];
    //创建时间
    _createLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 20, rect.size.width - originX, 16)];
    _createLabel.backgroundColor = [UIColor clearColor];
    _createLabel.textColor = kColor(3, 39, 65, 1);
    _createLabel.font = [UIFont systemFontOfSize:11.f];
    [titleView addSubview:_createLabel];
}

- (void)layoutAddressView:(UIView *)view {
    CGRect rect = view.bounds;
    CGFloat imageSize = 18.f;
    CGFloat imageOriginX = 6.f;
    CGFloat imageOriginY = (rect.size.height - imageSize ) / 2;
    CGFloat space = 2.f;
    CGFloat textOriginX = imageOriginX + imageSize + space;
    CGFloat arrowWidth = 30;
    CGFloat infoLabelHeight = 14.f;
    CGFloat addressLabelHeight = 18.f;
    //图标
    UIImageView *locationView = [[UIImageView alloc] initWithFrame:CGRectMake(imageOriginX, imageOriginY, imageSize, imageSize)];
    locationView.image = [UIImage imageNamed:@"location.png"];
    [view addSubview:locationView];
    
    //说明文字
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(textOriginX, space, 100, infoLabelHeight)];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font = [UIFont systemFontOfSize:10.f];
    infoLabel.textColor = kColor(150, 150, 150, 1);
    infoLabel.text = @"Location";
    [view addSubview:infoLabel];
    
    CGFloat width = view.bounds.size.width - textOriginX - arrowWidth;
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(textOriginX, infoLabelHeight + space, width, addressLabelHeight)];
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:_addressLabel];
}

- (void)layoutContactView:(UIView *)view {
    CGRect rect = view.bounds;
    CGFloat imageSize = 18.f;
    CGFloat imageOriginX = 6.f;
    CGFloat imageOriginY = (rect.size.height - imageSize ) / 2;
    CGFloat space = 2.f;
    CGFloat textOriginX = imageOriginX + imageSize + space;
    CGFloat arrowWidth = 30;
    CGFloat infoLabelHeight = 14.f;
    CGFloat timeLabelHeight = 18.f;
    CGFloat halfWidth = rect.size.width / 2;
    
    //图标
    UIImageView *phoneView = [[UIImageView alloc] initWithFrame:CGRectMake(imageOriginX, imageOriginY, imageSize, imageSize)];
    phoneView.image = [UIImage imageNamed:@"phone.png"];
    [view addSubview:phoneView];
    
    //说明文字
    UILabel *phoneInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(textOriginX, space, halfWidth - textOriginX, infoLabelHeight)];
    phoneInfoLabel.backgroundColor = [UIColor clearColor];
    phoneInfoLabel.font = [UIFont systemFontOfSize:10.f];
    phoneInfoLabel.textColor = kColor(150, 150, 150, 1);
    phoneInfoLabel.text = @"Contact number";
    [view addSubview:phoneInfoLabel];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(textOriginX, infoLabelHeight + space, halfWidth - textOriginX, timeLabelHeight)];
    _phoneLabel.backgroundColor = [UIColor clearColor];
    _phoneLabel.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:_phoneLabel];
    
    //花费
    UIImageView *costView = [[UIImageView alloc] initWithFrame:CGRectMake(imageOriginX + halfWidth, imageOriginY, imageSize, imageSize)];
    costView.image = [UIImage imageNamed:@"cost.png"];
    [view addSubview:costView];
    
    UILabel *costInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(textOriginX + halfWidth, space, halfWidth - textOriginX, infoLabelHeight)];
    costInfoLabel.backgroundColor = [UIColor clearColor];
    costInfoLabel.font = [UIFont systemFontOfSize:10.f];
    costInfoLabel.textColor = kColor(150, 150, 150, 1);
    costInfoLabel.text = @"Cost";
    [view addSubview:costInfoLabel];
    
    _costLabel = [[UILabel alloc] initWithFrame:CGRectMake(textOriginX + halfWidth, infoLabelHeight + space, halfWidth - textOriginX - arrowWidth, timeLabelHeight)];
    _costLabel.backgroundColor = [UIColor clearColor];
    _costLabel.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:_costLabel];
    
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(0, 0, halfWidth, view.bounds.size.height);
    [phoneButton setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
    [phoneButton addTarget:self action:@selector(ringUp:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:phoneButton];
}

//数据加载完毕更新UI
- (void)updateUI {
    self.totalPage = [_detailData.eventImageList count];
    self.imagesScrollView.contentSize = CGSizeMake(self.totalPage * self.view.bounds.size.width, self.view.bounds.size.height);
    self.pageControl.numberOfPages = self.totalPage;
    CGRect rect = self.topImageScrollView.bounds;
    self.topImageScrollView.contentSize = CGSizeMake(self.topImageScrollView.bounds.size.width * [_detailData.eventImageList count], self.topImageScrollView.bounds.size.height);
    for (int i = 0; i < [_detailData.eventImageList count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        imageView.tag = i + 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [imageView sd_setImageWithURL:[_detailData.eventImageList objectAtIndex:i]];
        [self.topImageScrollView addSubview:imageView];
        rect.origin.x += self.topImageScrollView.bounds.size.width;
    }
    //计算文字高度
    CGFloat width = self.view.bounds.size.width - leftSpace - rightSpace;
    CGSize size = [_detailData.eventContent sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
    CGFloat space = 10.f;//图片和文字间距10
    rect = CGRectMake(leftSpace, _contentOriginY + space, width, size.height + 1);
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:rect];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:14.f];
    contentLabel.text = _detailData.eventContent;
    [_mainScrollView addSubview:contentLabel];
    
    //填充
    _titleLabel.text = _detailData.eventName;
    if (_detailData.eventCreateTime) {
        _createLabel.text = [NSString stringWithFormat:@"Created:%@",_detailData.eventCreateTime];
    }
    _addressLabel.text = _detailData.eventAddress;
    _phoneLabel.text = _detailData.eventPhone;
    _costLabel.text = _detailData.eventCost;
    NSString *startTime = [TimeFormat timeFromString:_detailData.eventStartTime];
    NSString *endTime = [TimeFormat timeFromString:_detailData.eventFinishTime];
    _durationLabel.text = [NSString stringWithFormat:@"%@.-%@",startTime,endTime];
    self.title = _detailData.eventName;
    BOOL canJoined = [TimeFormat isCurrentTimeBeforeTime:_detailData.eventFinishTime];
    
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if (delegate.authority == 2 && canJoined) {
        rect.origin.y += contentLabel.bounds.size.height + 10;
        rect.origin.x = 16.f;
        rect.size.width = self.view.bounds.size.width - 32.f;
        rect.size.height = 40.f;
        _joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _joinBtn.frame = rect;
        _joinBtn.layer.cornerRadius = 4;
        _joinBtn.layer.masksToBounds = YES;
        _joinBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        if (_detailData.eventIsJoined == EventJoined) {
            _joinBtn.userInteractionEnabled = NO;
            [_joinBtn setTitle:@"Joined" forState:UIControlStateNormal];
            [_joinBtn setBackgroundImage:[UIImage imageNamed:@"lightblue.png"] forState:UIControlStateNormal];
        }
        else {
            _joinBtn.userInteractionEnabled = YES;
            [_joinBtn setTitle:@"Join" forState:UIControlStateNormal];
            [_joinBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
            [_joinBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
            [_joinBtn addTarget:self action:@selector(joinIn:) forControlEvents:UIControlEventTouchUpInside];
        }
        [_mainScrollView addSubview:_joinBtn];
    }
    
    CGFloat maxHeight = rect.origin.y + rect.size.height + 10;
    if (maxHeight > _mainScrollView.bounds.size.height) {
        _mainScrollView.contentSize = CGSizeMake(_mainScrollView.bounds.size.width, maxHeight);
    }
}

#pragma mark - Data

- (void)downloadDetail {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Loading...";
    NSString *ID = _eventData.eventID;
    if (!ID || [ID isEqualToString:@""]) {
        ID = _eventID;
    }
    [NetworkInterface eventDetailWithStudentID:delegate.userID token:delegate.token eventID:ID finished:^(BOOL success, NSData *response) {
        if (success) {
            [hud hide:YES];
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == requestSuccess) {
                    NSLog(@"%@",object);
                    [self parseDataWithInfo:object];
                    //修改列表已读状态
                    if (_eventData) {
                        _eventData.eventIsRead = EventRead;
                    }
                    _detailData.eventIsRead = EventRead;
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
            hud.labelText = @"Load failed";
        }
    }];
}

- (void)parseDataWithInfo:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *object = [dict objectForKey:@"result"];
    _detailData = [[EventDetailModel alloc] initWithParseDictionary:object];
    
    [self updateUI];
}

#pragma mark - Action

- (IBAction)joinIn:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Join the event?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:@"Sure"
                                              otherButtonTitles:nil];
    sheet.tag = joinTag;
    [sheet showInView:self.view];
}

- (IBAction)ringUp:(id)sender {
    if (!_detailData.eventPhone) {
        return;
    }
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Ring up?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:_detailData.eventPhone
                                              otherButtonTitles:nil];
    sheet.tag = phoneTag;
    [sheet showInView:self.view];
}

- (void)joinEvent {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Submitting...";
    NSString *ID = _eventData.eventID;
    if (!ID || [ID isEqualToString:@""]) {
        ID = _eventID;
    }
    [NetworkInterface joinEventWithStudentID:delegate.userID token:delegate.token eventID:ID finished:^(BOOL success, NSData *response) {
        if (success) {
            [hud hide:YES];
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",object);
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == requestSuccess) {
                    _joinBtn.userInteractionEnabled = NO;
                    [_joinBtn setTitle:@"Joined" forState:UIControlStateNormal];
                    [_joinBtn setBackgroundImage:[UIImage imageNamed:@"lightblue.png"] forState:UIControlStateNormal];
                    //修改列表报名状态
                    if (_eventData) {
                        _eventData.eventIsJoined = EventJoined;
                    }
                    _detailData.eventIsJoined = EventJoined;
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
            hud.labelText = @"Join failed";
        }
    }];
}

#pragma mark - Gesture

- (void)tapImageView:(UITapGestureRecognizer *)tap {
    [self.view bringSubviewToFront:self.scrollPanel];
    self.scrollPanel.alpha = 1.0;
    
    UIImageView *imageView = (UIImageView *)[tap view];
    self.currentIndex = imageView.tag;
    
    CGRect convertRect = [[imageView superview] convertRect:imageView.frame toView:self.view];
    CGPoint contentOffset = self.imagesScrollView.contentOffset;
    contentOffset.x = (self.currentIndex - 1) * self.view.bounds.size.width;
    self.imagesScrollView.contentOffset = contentOffset;
    
    [self addImageScrollViewForController:self];
    
    ImageScrollView *imagescroll = [[ImageScrollView alloc] initWithFrame:(CGRect){contentOffset,self.imagesScrollView.bounds.size}];
    [imagescroll setContentWithFrame:convertRect];
    [imagescroll setImage:imageView.image];
    [self.imagesScrollView addSubview:imagescroll];
    imagescroll.tapDelegate = self;
    [self performSelector:@selector(setOriginFrame:) withObject:imagescroll afterDelay:0.1f];
}

#pragma mark - ImageScrollViewDelegate

- (void)tapImageViewWithObject:(ImageScrollView *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBarHidden = NO;
        self.markView.alpha = 0;
        [sender rechangeInitRdct];
    } completion:^(BOOL finished) {
        self.scrollPanel.alpha = 0;
    }];
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.topImageScrollView) {
        self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
}

#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (actionSheet.tag == phoneTag) {
            NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",title]];
            [[UIApplication sharedApplication] openURL:phoneURL];
        }
        else if (actionSheet.tag == joinTag) {
            [self joinEvent];
        }
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

@end
