//
//  AroundHeaderView.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/5.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "AroundHeaderView.h"

static NSInteger _aroundMenuLine = 2;    //around菜单行数
static NSInteger _aroundMenuColumn = 4;  //around菜单列数

@implementation AroundHeaderView

- (id)initWithFrame:(CGRect)frame
             target:(id)target
             action:(SEL)action {
    if (self = [super initWithFrame:frame]) {
        _target = target;
        _action = action;
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

- (void)initUI {
    CGFloat headerHeight = 16.f;  //表头高度
    CGFloat footerHeight = 24.f;  //表尾高度
    //headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, headerHeight)];
    headerView.backgroundColor = kColor(247, 250, 251, 1);
    [self addSubview:headerView];
    
    //按钮菜单
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, headerHeight, self.bounds.size.width, self.bounds.size.height - headerHeight - footerHeight)];
    menuView.backgroundColor = [UIColor whiteColor];
    [self addSubview:menuView];
    
    //footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, headerHeight + menuView.bounds.size.height, self.bounds.size.width, footerHeight)];
    footerView.backgroundColor = kColor(247, 250, 251, 1);
    [self addSubview:footerView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, footerView.bounds.size.width - 40, footerView.bounds.size.height)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont systemFontOfSize:10.f];
    textLabel.text = @"I guess you would like";
    [footerView addSubview:textLabel];
    
    [self addMenuButtonForView:menuView];
}

- (void)addMenuButtonForView:(UIView *)panelView {
    CGFloat topSpace = 10.f;      //顶部间距
    CGFloat leftSpace = 30.f;     //左侧间距
    CGFloat rightSpace = 30.f;    //右侧间距
    CGFloat btnWidth = 50.f;      //按钮宽度
    CGFloat btnHeight = 80.f;     //按钮高度
    CGFloat hSpace = (panelView.bounds.size.width - leftSpace - rightSpace - btnWidth * _aroundMenuColumn) / (_aroundMenuColumn - 1);
    //名称数组
    NSArray *nameArray = [NSArray arrayWithObjects:
                          @"Food",
                          @"Sports",
                          @"Drink",
                          @"Other",
                          @"  Super  -market",
                          @"Bank",
                          @"Post",
                          @"Hotel", nil];
    CGRect rect = CGRectMake(leftSpace, topSpace, btnWidth, btnHeight);
    for (int i = 0; i < _aroundMenuLine; i++) {
        for (int j = 1; j <= _aroundMenuColumn; j++) {
            //计算偏移量
            rect.origin.x += btnWidth + hSpace;
            if (j == 1) {
                rect.origin.x = leftSpace;
            }
            //计算在第几个位置
            NSInteger index = j + i * _aroundMenuColumn - 1;
            NSString *titleName = [nameArray objectAtIndex:index];
            NSString *imageName = [NSString stringWithFormat:@"around_big_%ld.png",index + 1];
            AroundMenuView *menuView = [[AroundMenuView alloc] initWithFrame:rect
                                                                   titleName:titleName
                                                                   imageName:imageName
                                                                       index:index + 1
                                                                      target:_target
                                                                      action:_action];
            [panelView addSubview:menuView];
        }
        rect.origin.y = panelView.bounds.size.height / 2 + topSpace;
    }
    //line
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(leftSpace, panelView.bounds.size.height / 2 - kLineHeight, panelView.bounds.size.width - leftSpace - rightSpace, kLineHeight)];
    line.backgroundColor = kColor(228, 227, 227, 1);
    [panelView addSubview:line];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, panelView.bounds.size.width, kLineHeight)];
    topLine.backgroundColor = kColor(228, 227, 227, 1);
    [panelView addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, panelView.bounds.size.height - kLineHeight, panelView.bounds.size.width, kLineHeight)];
    bottomLine.backgroundColor = kColor(228, 227, 227, 1);
    [panelView addSubview:bottomLine];
}


@end
