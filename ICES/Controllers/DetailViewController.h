//
//  DetailViewController.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/16.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "ImageScrollView.h"

static float topSpace = 15.f;
static float leftSpace = 15.f;
static float rightSpace = 15.f;
static float imageScale = 0.59f;  //图片高宽比

@interface DetailViewController : UIViewController

//顶部图片scrollview
@property (nonatomic, strong) UIScrollView *topImageScrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

//点击看大图
@property (nonatomic, strong) UIScrollView *imagesScrollView;

@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) UIView *scrollPanel;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) UILabel *pageLabel;

- (void)initAndLayoutUI;

- (void)addImageScrollViewForController:(UIViewController *)controller;

- (void)setOriginFrame:(ImageScrollView *)sender;

@end
