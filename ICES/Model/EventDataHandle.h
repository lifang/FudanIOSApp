//
//  EventDataHandle.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/11.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventMenuView.h"
#import "EventModel.h"

@interface EventDataHandle : NSObject

+ (NSString *)titleForEventType:(EventMenuType)type;
+ (NSMutableArray *)parseData:(NSDictionary *)object;

@end
