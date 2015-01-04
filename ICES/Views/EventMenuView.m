//
//  EventMenuView.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/3.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "EventMenuView.h"

@implementation EventMenuView

- (id)initWithFrame:(CGRect)frame
          titleName:(NSString *)titleName
          imageName:(NSString *)imageName
      highlightName:(NSString *)highName
              index:(NSInteger)index
             target:(id)target
             action:(SEL)action {
    if (self = [super initWithFrame:frame]) {
        _titleName = titleName;
        _imageName = imageName;
        _highlightName = highName;
        _index = index;
        _target = target;
        _action = action;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    CGFloat imageSize = 40.f;
    CGFloat labelHeight = 34.f;
    CGFloat vSpace = 5.f;
    CGFloat topSpace = (self.bounds.size.height - imageSize - labelHeight - vSpace) / 2;
    topSpace = topSpace < 0 ? 0 : topSpace;
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.tag = _index;
    menuButton.frame = CGRectMake((self.bounds.size.width - imageSize) / 2, topSpace, imageSize, imageSize);
    [menuButton setBackgroundImage:[UIImage imageNamed:_imageName] forState:UIControlStateNormal];
    [menuButton setBackgroundImage:[UIImage imageNamed:_highlightName] forState:UIControlStateHighlighted];
    [menuButton addTarget:_target action:_action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:menuButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topSpace + imageSize + vSpace, self.bounds.size.width, labelHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:13.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 2;
    titleLabel.text = _titleName;
    [self addSubview:titleLabel];
    
    CGRect rect = menuButton.frame;
    rect.origin.x = rect.origin.x + rect.size.width;
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _numberLabel.backgroundColor = [UIColor redColor];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.center = rect.origin;
    _numberLabel.layer.cornerRadius = 10;
    _numberLabel.layer.masksToBounds = YES;
    _numberLabel.font = [UIFont systemFontOfSize:14.f];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.hidden = YES;
    [self addSubview:_numberLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:_target action:_action];
    [self addGestureRecognizer:tap];
}

#pragma mark - Set Number

- (void)setTipValue:(NSString *)value {
    if (!value || [value isEqualToString:@""] || [value isEqualToString:@"0"]) {
        _numberLabel.hidden = YES;
    }
    else {
        _numberLabel.hidden = NO;
        _numberLabel.text = value;
        CGFloat width = 0.f;
        if ([value intValue] < 10) {
            width = 20.f;
        }
        else if ([value intValue] < 100) {
            width = 25.f;
        }
        else {
            width = 30.f;
            _numberLabel.text = @"99+";
        }
        CGRect rect = {_numberLabel.center.x - 10,_numberLabel.center.y - 10,width,20};
        _numberLabel.frame = rect;
    }
}

@end
