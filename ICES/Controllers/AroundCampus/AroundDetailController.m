//
//  AroundDetailController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/17.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "AroundDetailController.h"
#import "AroundDetailModel.h"
#import "AroundMapController.h"

@interface AroundDetailController ()<ImageScrollViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

//显示全部内容的scrollview
@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, assign) CGFloat contentOriginY;  //内容label的origin

@property (nonatomic, strong) AroundDetailModel *detailData;

@end

@implementation AroundDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _aroundData.aroundName;
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
    
    //标题高度
    CGFloat titleHeight = 30.f;
    rect.origin.y = rect.origin.y + rect.size.height;
    rect.size.height = titleHeight;
    _titleLabel = [[UILabel alloc] initWithFrame:rect];
    _titleLabel.backgroundColor = kColor(233, 233, 232, 1);
    _titleLabel.textColor = kColor(3, 39, 65, 1);
    _titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_mainScrollView addSubview:_titleLabel];
    
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
    //时间和手机
    rect.origin.y += rect.size.height - kLineHeight;
    UIView *timeView = [[UIView alloc] initWithFrame:rect];
    timeView.backgroundColor = kColor(253, 254, 254, 1);
    timeView.layer.borderWidth = kLineHeight;
    timeView.layer.borderColor = kColor(219, 221, 222, 1).CGColor;
    [_mainScrollView addSubview:timeView];
    
    [self layoutTimeView:timeView];
    
    _contentOriginY = rect.origin.y + rect.size.height;
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
    infoLabel.text = @"The shop location";
    [view addSubview:infoLabel];
    
    CGFloat width = view.bounds.size.width - textOriginX - arrowWidth;
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(textOriginX, infoLabelHeight + space, width, addressLabelHeight)];
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:_addressLabel];
    
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(rect.size.width - 20, 10, 12, 16)];
    arrowView.image = [UIImage imageNamed:@"rightarrow.png"];
    [view addSubview:arrowView];
    
    UIButton *addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addressButton.frame = view.bounds;
    [addressButton setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
    [addressButton addTarget:self action:@selector(showLocationInMap:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addressButton];
}

- (void)layoutTimeView:(UIView *)view {
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
    UIImageView *clockView = [[UIImageView alloc] initWithFrame:CGRectMake(imageOriginX, imageOriginY, imageSize, imageSize)];
    clockView.image = [UIImage imageNamed:@"clock.png"];
    [view addSubview:clockView];
    
    //说明文字
    UILabel *clockInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(textOriginX, space, halfWidth - textOriginX, infoLabelHeight)];
    clockInfoLabel.backgroundColor = [UIColor clearColor];
    clockInfoLabel.font = [UIFont systemFontOfSize:10.f];
    clockInfoLabel.textColor = kColor(150, 150, 150, 1);
    clockInfoLabel.text = @"Business Hours";
    [view addSubview:clockInfoLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(textOriginX, infoLabelHeight + space, halfWidth - textOriginX, timeLabelHeight)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:_timeLabel];
    
    //电话信息
    UIImageView *phoneView = [[UIImageView alloc] initWithFrame:CGRectMake(imageOriginX + halfWidth, imageOriginY, imageSize, imageSize)];
    phoneView.image = [UIImage imageNamed:@"phone.png"];
    [view addSubview:phoneView];
    
    UILabel *phoneInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(textOriginX + halfWidth, space, halfWidth - textOriginX, infoLabelHeight)];
    phoneInfoLabel.backgroundColor = [UIColor clearColor];
    phoneInfoLabel.font = [UIFont systemFontOfSize:10.f];
    phoneInfoLabel.textColor = kColor(150, 150, 150, 1);
    phoneInfoLabel.text = @"Contact number";
    [view addSubview:phoneInfoLabel];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(textOriginX + halfWidth, infoLabelHeight + space, halfWidth - textOriginX - arrowWidth, timeLabelHeight)];
    _phoneLabel.backgroundColor = [UIColor clearColor];
    _phoneLabel.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:_phoneLabel];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(rect.size.width - 20, 10, 12, 16)];
    arrowView.image = [UIImage imageNamed:@"rightarrow.png"];
    [view addSubview:arrowView];
    
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(halfWidth, 0, halfWidth, view.bounds.size.height);
    [phoneButton setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
    [phoneButton addTarget:self action:@selector(ringUp:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:phoneButton];
    
}

//数据加载完毕更新UI
- (void)updateUI {
    self.totalPage = [_detailData.imageList count];
    self.imagesScrollView.contentSize = CGSizeMake(self.totalPage * self.view.bounds.size.width, self.view.bounds.size.height);
    self.pageControl.numberOfPages = self.totalPage;
    CGRect rect = self.topImageScrollView.bounds;
    self.topImageScrollView.contentSize = CGSizeMake(self.topImageScrollView.bounds.size.width * [_detailData.imageList count], self.topImageScrollView.bounds.size.height);
    for (int i = 0; i < [_detailData.imageList count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        imageView.tag = i + 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [imageView sd_setImageWithURL:[_detailData.imageList objectAtIndex:i]];
        [self.topImageScrollView addSubview:imageView];
        rect.origin.x += self.topImageScrollView.bounds.size.width;
    }
    //计算文字高度
    CGFloat width = self.view.bounds.size.width - leftSpace - rightSpace;
    CGSize size = [_detailData.content sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
    CGFloat space = 10.f;//图片和文字间距10
    rect = CGRectMake(leftSpace, _contentOriginY + space, width, size.height + 1);
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:rect];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:14.f];
    contentLabel.text = _detailData.content;
    [_mainScrollView addSubview:contentLabel];
    
    //填充
    _titleLabel.text = [NSString stringWithFormat:@"  %@",_detailData.name];
    _addressLabel.text = _detailData.address;
    _timeLabel.text = [NSString stringWithFormat:@"%@:%@-%@:%@",_detailData.startHour,_detailData.startMinute,_detailData.finishHour,_detailData.finishMinute];
    _phoneLabel.text = _detailData.phoneNumber;
    
    CGFloat maxHeight = rect.origin.y + contentLabel.bounds.size.height;
    if (maxHeight > _mainScrollView.bounds.size.height) {
        _mainScrollView.contentSize = CGSizeMake(_mainScrollView.bounds.size.width, maxHeight);
    }
}

#pragma mark - Data

- (void)downloadDetail {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Loading...";
    [NetworkInterface aroundDetailWithStudentID:delegate.userID token:delegate.token aroundID:_aroundData.aroundID finished:^(BOOL success, NSData *response) {
        if (success) {
            [hud hide:YES];
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == requestSuccess) {
                    NSLog(@"%@",object);
                    [self parseDataWithInfo:object];
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
    _detailData = [[AroundDetailModel alloc] initWithParseDictionary:object];
    
    [self updateUI];
}

#pragma mark - Action

- (IBAction)showLocationInMap:(id)sender {
    AroundMapController *mapC = [[AroundMapController alloc] init];
    mapC.addressName = _detailData.name;
    mapC.latitude = _detailData.latitude;
    mapC.longitude = _detailData.longitude;
    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.5f;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = @"oglFlip";
//    transition.subtype = kCATransitionFromRight;
//    transition.delegate = self;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:mapC animated:YES];
    [UIView animateWithDuration:.5 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    }];
}

- (IBAction)ringUp:(id)sender {
    if (!_detailData.phoneNumber) {
        return;
    }
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Ring up?"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:_detailData.phoneNumber
                                             otherButtonTitles:nil];
    [sheet showInView:self.view];
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
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",title]];
        [[UIApplication sharedApplication] openURL:phoneURL];
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
