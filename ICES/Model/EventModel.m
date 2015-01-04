
//
//  EventModel.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/18.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "EventModel.h"

@implementation EventModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _eventName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"eventsName"]];
        _eventID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        _eventSummary = [NSString stringWithFormat:@"%@",[dict objectForKey:@"eventsIntroductionShort"]];
        _eventIsRead = [[dict objectForKey:@"eventsIsRead"] intValue];
        _eventIsJoined = [[dict objectForKey:@"eventsIsJoin"] intValue];
        if (![[dict objectForKey:@"pictureSmallFilePath"] isKindOfClass:[NSNull class]]) {
            _eventSmallImage = [NSString stringWithFormat:@"%@",[dict objectForKey:@"pictureSmallFilePath"]];
        }
    }
    return self;
}

@end
