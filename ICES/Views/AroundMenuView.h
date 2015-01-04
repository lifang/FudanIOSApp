//
//  AroundMenuView.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/5.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AroundMenuAll = 0,
    AroundMenuFood,
    AroundMenuSports,
    AroundMenuDrink,
    AroundMenuOther,
    AroundMenuSupermarket,
    AroundMenuBank,
    AroundMenuPost,
    AroundMenuHotel,
}AroundMenuType;

@interface AroundMenuView : UIView

@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, weak) id target;

@property (nonatomic) SEL action;

@property (nonatomic, assign) NSInteger index;

- (id)initWithFrame:(CGRect)frame
          titleName:(NSString *)titleName
          imageName:(NSString *)imageName
              index:(NSInteger)index
             target:(id)target
             action:(SEL)action;

@end
