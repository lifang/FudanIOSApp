//
//  ModuleView.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/3.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ModulePreArrival = 1,
    ModuleArrival,
    ModuleCampus,
    ModuleEvents,
    ModuleAroundCampus,
    ModuleMore,
}ModuleViewTag;

@interface ModuleView : UIButton

@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, strong) NSString *titleName;

- (void)setTitleName:(NSString *)titleName
           imageName:(NSString *)imageName;

@end
