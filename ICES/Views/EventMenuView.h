//
//  EventMenuView.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/3.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EventMenuLecture = 1,
    EventMenuTraveling,
    EventMenuSports,
    EventMenuCeremony,
    EventMenuSchoolClub,
    EventMenuForum,
    EventMenuLiteratureAndArt,
    EventMenuEntertainment,
    EventMenuOther,
}EventMenuType;

@interface EventMenuView : UIView

@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, strong) NSString *highlightName;

@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, weak) id target;

@property (nonatomic) SEL action;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UILabel *numberLabel;

- (id)initWithFrame:(CGRect)frame
          titleName:(NSString *)titleName
          imageName:(NSString *)imageName
      highlightName:(NSString *)highName
              index:(NSInteger)index
             target:(id)target
             action:(SEL)action;

- (void)setTipValue:(NSString *)value;

@end
