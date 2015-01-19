//
//  MessageDetailController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "MessageDetailController.h"
#import "EventDetailController.h"

@interface MessageDetailController ()<ImageScrollViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

//显示全部内容的scrollview
@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) NSMutableArray *imageURLs;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *createLabel;

@property (nonatomic, strong) NSString *content; //文本内容

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, assign) int messageType;

@property (nonatomic, strong) NSString *eventID;

@property (nonatomic, strong) UIButton *eventBtn;

@end

@implementation MessageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imageURLs = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self downloadDetail];
    if (_messageID && ![_messageID isEqualToString:@""]) {
        //推送弹出
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss:)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
}

- (void)initImageView {
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
}

//数据加载完毕更新UI
- (void)updateUI {
    CGRect rect = CGRectZero;
    //有图 显示imageview
    if ([_imageURLs count] > 0) {
        [self initImageView];
        
        self.totalPage = [_imageURLs count];
        self.imagesScrollView.contentSize = CGSizeMake(self.totalPage * self.view.bounds.size.width, self.view.bounds.size.height);
        self.pageControl.numberOfPages = self.totalPage;
        NSLog(@"%@",NSStringFromCGRect(self.pageControl.frame));
        rect = self.topImageScrollView.bounds;
        self.topImageScrollView.contentSize = CGSizeMake(self.topImageScrollView.bounds.size.width * [_imageURLs count], self.topImageScrollView.bounds.size.height);
        for (int i = 0; i < [_imageURLs count]; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.userInteractionEnabled = YES;
            imageView.tag = i + 1;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
            [imageView addGestureRecognizer:tap];
            NSString *urlString = [NSString stringWithFormat:@"%@/%@",kImageURL,[_imageURLs objectAtIndex:i]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
            [self.topImageScrollView addSubview:imageView];
            rect.origin.x += self.topImageScrollView.bounds.size.width;
        }
    }
    else {
        rect.size.height += topSpace;
    }
    //标题view
    rect = CGRectMake(leftSpace, rect.origin.y + rect.size.height, self.view.bounds.size.width - leftSpace - rightSpace, 60.f);
    UIView *titleView = [[UIView alloc] initWithFrame:rect];
    titleView.backgroundColor = kColor(233, 233, 232, 1);
    [_mainScrollView addSubview:titleView];
    
    [self layoutTitleView:titleView];
    
    //计算文字高度
    CGFloat width = self.view.bounds.size.width - leftSpace - rightSpace;
    CGSize size = [_content sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
    CGFloat space = 10.f;//图片和文字间距10
    rect = CGRectMake(leftSpace, rect.origin.y + rect.size.height + space, width, size.height + 1);
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:rect];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:14.f];
    contentLabel.text = _content;
    [_mainScrollView addSubview:contentLabel];
    
    //填充
    _titleLabel.text = _titleName;
    _createLabel.text = _createTime;
    
    if (_messageType == MessageTypeEvent) {
        rect.origin.y += contentLabel.bounds.size.height + 10;
        rect.origin.x = 16.f;
        rect.size.width = self.view.bounds.size.width - 32.f;
        rect.size.height = 40.f;
        _eventBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _eventBtn.frame = rect;
        _eventBtn.layer.cornerRadius = 4;
        _eventBtn.layer.masksToBounds = YES;
        _eventBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [_eventBtn setTitle:@"Go" forState:UIControlStateNormal];
        [_eventBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
        [_eventBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
        [_eventBtn addTarget:self action:@selector(goEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_eventBtn];
    }
    
    CGFloat maxHeight = rect.origin.y + rect.size.height;
    if (maxHeight > _mainScrollView.bounds.size.height) {
        _mainScrollView.contentSize = CGSizeMake(_mainScrollView.bounds.size.width, maxHeight);
    }
}

- (void)layoutTitleView:(UIView *)view {
    CGRect rect = view.bounds;
    CGFloat originX = 4.f;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originX, rect.size.width - originX * 2, 36.f)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = kColor(3, 39, 65, 1);
    _titleLabel.font = [UIFont systemFontOfSize:15.f];
    _titleLabel.numberOfLines = 2;
    [view addSubview:_titleLabel];
    
    _createLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originX + _titleLabel.bounds.size.height, rect.size.width - originX * 2, 12)];
    _createLabel.backgroundColor = [UIColor clearColor];
    _createLabel.textColor = kColor(3, 39, 65, 1);
    _createLabel.font = [UIFont systemFontOfSize:11.f];
    [view addSubview:_createLabel];
}

#pragma mark - Data

- (void)downloadDetail {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Loading...";
    NSString *ID = _messageData.messageID;
    if (!_messageData) {
        ID = _messageID;
    }
    [NetworkInterface notificationDetailWithStudentID:delegate.userID token:delegate.token notificationID:ID finished:^(BOOL success, NSData *response) {
        if (success) {
            [hud hide:YES];
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == requestSuccess) {
                    NSLog(@"%@",object);
                    [self parseDataWithInfo:object];
                    if (_messageData.messageStatus == MessageStatusNew) {
                        _messageData.messageStatus = MessageStatusRecent;
                        NSDictionary *messageDict = [NSDictionary dictionaryWithObjectsAndKeys:_messageData,@"read",
                                                     nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:MessageListReadNotification object:nil userInfo:messageDict];
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
            hud.labelText = @"Load failed";
        }
    }];
}

- (void)parseDataWithInfo:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *object = [dict objectForKey:@"result"];
    _content = [NSString stringWithFormat:@"%@",[object objectForKey:@"notificationContent"]];
    _createTime = [NSString stringWithFormat:@"%@",[object objectForKey:@"createTime"]];
    _titleName = [NSString stringWithFormat:@"%@",[object objectForKey:@"notificationTitle"]];
    _messageType = [[object objectForKey:@"notificationType"] intValue];
    if ([object objectForKey:@"eventsId"]) {
        _eventID = [NSString stringWithFormat:@"%@",[object objectForKey:@"eventsId"]];
    }
    NSArray *imageList = [object objectForKey:@"pictures"];
    for (int i = 0; i < [imageList count]; i++) {
        NSDictionary *imageDict = [imageList objectAtIndex:i];
        NSString *url = [NSString stringWithFormat:@"%@",[imageDict objectForKey:@"pictureLargeFilePath"]];
        [_imageURLs addObject:url];
    }
    
    [self updateUI];
}

#pragma mark - Action

- (IBAction)goEvent:(id)sender {
    EventDetailController *detailC = [[EventDetailController alloc] init];
    detailC.eventID = _eventID;
    [self.navigationController pushViewController:detailC animated:YES];
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

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        AppDelegate *delegate = [AppDelegate shareAppDelegate];
        [delegate clearLoginInfo];
        [[delegate rootViewController] showLoginViewController];
    }
}

@end
