//
//  AroundDataHandle.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/11.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AroundMenuView.h"
#import "AroundModel.h"

@interface AroundDataHandle : NSObject

+ (NSString *)titleForAroundCampusType:(AroundMenuType)type;

+ (NSMutableArray *)parseData:(NSDictionary *)object;

@end
