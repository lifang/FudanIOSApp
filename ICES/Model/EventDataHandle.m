//
//  EventDataHandle.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/11.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "EventDataHandle.h"

@implementation EventDataHandle

+ (NSString *)titleForEventType:(EventMenuType)type {
    NSString *title = nil;
    switch (type) {
        case EventMenuLecture:
            title = @"Lecture";
            break;
        case EventMenuTraveling:
            title = @"Traveling";
            break;
        case EventMenuSports:
            title = @"Sports";
            break;
        case EventMenuCeremony:
            title = @"Ceremony";
            break;
        case EventMenuSchoolClub:
            title = @"School Club";
            break;
        case EventMenuForum:
            title = @"Forum";
            break;
        case EventMenuLiteratureAndArt:
            title = @"Literature and art";
            break;
        case EventMenuEntertainment:
            title = @"Entertainment";
            break;
        case EventMenuOther:
            title = @"Other";
            break;
        default:
            break;
    }
    return title;
}

+ (NSMutableArray *)parseData:(NSDictionary *)object {
    if (![object objectForKey:@"result"] || ![[object objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSArray *item = [object objectForKey:@"result"];
    NSMutableArray *eventList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [item count]; i++) {
        NSDictionary *eventDict = [item objectAtIndex:i];
        EventModel *eventObject = [[EventModel alloc] initWithParseDictionary:eventDict];
        [eventList addObject:eventObject];
    }
    return eventList;
}

@end
