//
//  EventDetailModel.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/18.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "EventDetailModel.h"

@implementation EventDetailModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _eventName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"eventsName"]];
        if ([dict objectForKey:@"createTime"] && ![[dict objectForKey:@"createTime"] isKindOfClass:[NSNull class]]) {
            _eventCreateTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"createTime"]];
        }
        _eventAddress = [NSString stringWithFormat:@"%@",[dict objectForKey:@"eventsAddress"]];
        _eventPhone = [NSString stringWithFormat:@"%@",[dict objectForKey:@"eventsPhone"]];
        _eventCost = [NSString stringWithFormat:@"%@",[dict objectForKey:@"eventsCostMoney"]];
        _eventContent = [NSString stringWithFormat:@"%@",[dict objectForKey:@"eventsIntroduction"]];
        
        id startTime = [dict objectForKey:@"eventsStartTime"];
        if (startTime && ![startTime isKindOfClass:[NSNull class]]) {
            _eventStartTime = [NSString stringWithFormat:@"%@",startTime];
        }
        id finishTime = [dict objectForKey:@"eventsFinshTime"];
        if (finishTime && ![finishTime isKindOfClass:[NSNull class]]) {
            _eventFinishTime = [NSString stringWithFormat:@"%@",finishTime];
        }
        _eventIsJoined = [[dict objectForKey:@"eventsIsJoin"] intValue];
        _eventIsRead = [[dict objectForKey:@"eventsIsRead"] intValue];
        _eventImageList = [[NSMutableArray alloc] init];
        NSArray *list = [dict objectForKey:@"pictures"];
        for (int i = 0; i < [list count]; i++) {
            NSDictionary *pictureDict = [list objectAtIndex:i];
            id picturePath = [pictureDict objectForKey:@"pictureLargeFilePath"];
            if (picturePath && ![picturePath isKindOfClass:[NSNull class]]) {
                [_eventImageList addObject:[NSString stringWithFormat:@"%@",picturePath]];
            }
        }
    }
    return self;
}

@end
