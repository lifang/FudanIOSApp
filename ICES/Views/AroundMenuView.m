//
//  AroundMenuView.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/5.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "AroundMenuView.h"

@implementation AroundMenuView

- (id)initWithFrame:(CGRect)frame
          titleName:(NSString *)titleName
          imageName:(NSString *)imageName
              index:(NSInteger)index
             target:(id)target
             action:(SEL)action {
    if (self = [super initWithFrame:frame]) {
        _titleName = titleName;
        _imageName = imageName;
        _index = index;
        _target = target;
        _action = action;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    CGFloat imageSize = 26.f;
    CGFloat labelHeight = 34.f;
    CGFloat vSpace = 5.f;
    CGFloat topSpace = (self.bounds.size.height - imageSize - labelHeight - vSpace) / 2;
    topSpace = topSpace < 0 ? 0 : topSpace;
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.tag = _index;
    menuButton.frame = CGRectMake((self.bounds.size.width - imageSize) / 2, topSpace, imageSize, imageSize);
    [menuButton setBackgroundImage:[UIImage imageNamed:_imageName] forState:UIControlStateNormal];
    [menuButton addTarget:_target action:_action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:menuButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topSpace + imageSize + vSpace, self.bounds.size.width, labelHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:13.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 2;
    titleLabel.text = _titleName;
    [self addSubview:titleLabel];
    
    //增大点击范围
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:_target action:_action];
    [self addGestureRecognizer:tap];

}
@end
