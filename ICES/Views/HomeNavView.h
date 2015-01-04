//
//  HomeNavView.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/3.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeNavView : UIView

@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) NSString *detailName;
@property (nonatomic, strong) NSString *imageName;

//根据标题和副标题初始化
- (id)initWithFrame:(CGRect)frame
          titleName:(NSString *)title
         detailName:(NSString *)detail;

//根据图片初始化
- (id)initWithFrame:(CGRect)frame
          imageName:(NSString *)imageName;

- (void)addRightButtonWithImage:(NSString *)imageName
                         target:(id)target
                         action:(SEL)action;

- (void)needShowTipView:(BOOL)needShow;

@end
