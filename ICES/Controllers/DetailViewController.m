//
//  DetailViewController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/16.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UIScrollViewDelegate>

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (kDeviceVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    _scrollPanel = [[UIView alloc] initWithFrame:self.view.bounds];
    _scrollPanel.backgroundColor = [UIColor clearColor];
    _scrollPanel.alpha = 0;
    [self.view addSubview:_scrollPanel];
    
    CGRect rect = _scrollPanel.bounds;
    rect.origin.y = -64;
    rect.size.height += 64;
    _markView = [[UIView alloc] initWithFrame:rect];
    _markView.backgroundColor = [UIColor blackColor];
    _markView.alpha = 0.0;
    [_scrollPanel addSubview:_markView];
    
    _imagesScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [_scrollPanel addSubview:_imagesScrollView];
    _imagesScrollView.pagingEnabled = YES;
    _imagesScrollView.delegate = self;
    
    _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, rect.origin.y + rect.size.height - 40, rect.size.width, 20)];
    _pageLabel.backgroundColor = [UIColor clearColor];
    _pageLabel.textColor = [UIColor whiteColor];
    _pageLabel.font = [UIFont boldSystemFontOfSize:14];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollPanel addSubview:_pageLabel];
}

#pragma mark - 大图

- (void)addImageScrollViewForController:(UIViewController *)controller {
    [self.imagesScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 1; i <= self.totalPage; i++) {
        if (i == self.currentIndex) {
            continue;
        }
        UIImageView *imageView = (UIImageView *)[_topImageScrollView viewWithTag:i];
        CGRect convertRect = [[imageView superview] convertRect:imageView.frame toView:self.view];
        ImageScrollView *imagescroll = [[ImageScrollView alloc] initWithFrame:(CGRect){(i - 1) * self.imagesScrollView.bounds.size.width,0,self.imagesScrollView.bounds.size}];
        [imagescroll setContentWithFrame:convertRect];
        [imagescroll setImage:imageView.image];
        [self.imagesScrollView addSubview:imagescroll];
        imagescroll.tapDelegate = (id<ImageScrollViewDelegate>)controller;
        [imagescroll setAnimationRect];
    }
}

- (void)setOriginFrame:(ImageScrollView *)sender {
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.currentIndex,self.totalPage];
    [UIView animateWithDuration:0.4 animations:^{
        self.navigationController.navigationBarHidden = YES;
        [sender setAnimationRect];
        self.markView.alpha = 1.0;
    }];
}

#pragma mark - scroll delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _imagesScrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        _currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex + 1,_totalPage];
    }
}

@end
