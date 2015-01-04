//
//  HomeNavView.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/3.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "HomeNavView.h"

@interface HomeNavView ()

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIImageView *tipView;

@end

@implementation HomeNavView

- (id)initWithFrame:(CGRect)frame
          titleName:(NSString *)title
         detailName:(NSString *)detail {
    if (self = [super initWithFrame:frame]) {
        _titleName = title;
        _detailName = detail;
        [self initUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
          imageName:(NSString *)imageName {
    if (self = [super initWithFrame:frame]) {
        _imageName = imageName;
        [self initUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

#pragma mark - UI

- (void)initUI {
    UIImageView *backView = [[UIImageView alloc] initWithFrame:self.bounds];
//    backView.image = [UIImage imageNamed:@"navbackground.png"];
    backView.backgroundColor = kColor(6, 72, 159, 1);
    [self addSubview:backView];
    
    if (_titleName && _detailName) {
        CGFloat h_space = 60.f;
        CGRect rect = CGRectMake(h_space, self.bounds.size.height - 44.f, self.bounds.size.width - 2 * h_space, 18);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:rect];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = _titleName;
        [self addSubview:titleLabel];
        
        rect.origin.y += titleLabel.bounds.size.height;
        rect.size.height = 14;
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:rect];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize:10.f];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.textColor = [UIColor whiteColor];
        detailLabel.text = _detailName;
        [self addSubview:detailLabel];
    }
    else {
        CGFloat imageWidth = 56.f;
        CGFloat imageHeight = 26.f;
        CGRect rect = CGRectMake((self.bounds.size.width - imageWidth) / 2, self.bounds.size.height - 44.f, imageWidth, imageHeight);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.image = [UIImage imageNamed:_imageName];
        [self addSubview:imageView];
    }
}

- (void)addRightButtonWithImage:(NSString *)imageName
                         target:(id)target
                         action:(SEL)action {
    CGRect rect = CGRectMake(self.bounds.size.width - 40.f, self.bounds.size.height - 40.f, 26, 20);
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.tintColor = [UIColor whiteColor];
    _rightButton.frame = rect;
    [_rightButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [_rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightButton];
    
    rect.origin.x = rect.origin.x + _rightButton.bounds.size.width - 6;
    rect.origin.y = rect.origin.y - 2;
    rect.size.width = 8;
    rect.size.height = 8;
    _tipView = [[UIImageView alloc] initWithFrame:rect];
    _tipView.hidden = YES;
    _tipView.image = [UIImage imageNamed:@"redpoint.png"];
    [self addSubview:_tipView];
}

- (void)needShowTipView:(BOOL)needShow {
    if (needShow) {
        _tipView.hidden = NO;
    }
    else {
        _tipView.hidden = YES;
    }
}

@end
