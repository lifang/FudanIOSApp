//
//  EventDetailModel.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/18.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventDetailModel : NSObject

@property (nonatomic, strong) NSString *eventName;

@property (nonatomic, strong) NSString *eventCreateTime;

@property (nonatomic, strong) NSString *eventAddress;

@property (nonatomic, strong) NSString *eventPhone;

@property (nonatomic, strong) NSString *eventCost;

@property (nonatomic, strong) NSString *eventContent;

@property (nonatomic, strong) NSString *eventStartTime;

@property (nonatomic, strong) NSString *eventFinishTime;

@property (nonatomic, assign) int eventIsJoined;

@property (nonatomic, assign) int eventIsRead;

@property (nonatomic, strong) NSMutableArray *eventImageList;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
