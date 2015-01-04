//
//  EventModel.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/18.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    EventNotJoin = 1,
    EventJoined,
}EventIsJoined;

typedef enum {
    EventNotRead = 1,
    EventRead,
}EventIsRead;

@interface EventModel : NSObject

@property (nonatomic, strong) NSString *eventName;

@property (nonatomic, strong) NSString *eventSummary;

@property (nonatomic, strong) NSString *eventID;

@property (nonatomic, assign) int eventIsJoined;

@property (nonatomic, assign) int eventIsRead;

@property (nonatomic, strong) NSString *eventSmallImage;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
