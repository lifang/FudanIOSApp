//
//  AroundHeaderView.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/5.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AroundMenuView.h"

@interface AroundHeaderView : UIView

@property (nonatomic, weak) id target;

@property (nonatomic) SEL action;

- (id)initWithFrame:(CGRect)frame
             target:(id)target
             action:(SEL)action;

@end
