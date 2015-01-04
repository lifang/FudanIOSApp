//
//  AroundDataHandle.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/11.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "AroundDataHandle.h"

@implementation AroundDataHandle

+ (NSString *)titleForAroundCampusType:(AroundMenuType)type {
    NSString *title = nil;
    switch (type) {
        case AroundMenuAll:
            title = @"Around Campus";
            break;
        case AroundMenuFood:
            title = @"Food";
            break;
        case AroundMenuSports:
            title = @"Sports";
            break;
        case AroundMenuDrink:
            title = @"Drink";
            break;
        case AroundMenuOther:
            title = @"Other";
            break;
        case AroundMenuSupermarket:
            title = @"Supermarket";
            break;
        case AroundMenuBank:
            title = @"Bank";
            break;
        case AroundMenuPost:
            title = @"Post";
            break;
        case AroundMenuHotel:
            title = @"Hotel";
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
    NSMutableArray *aroundList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [item count]; i++) {
        NSDictionary *aroundDict = [item objectAtIndex:i];
        AroundModel *aroundObject = [[AroundModel alloc] initWithParseDictionary:aroundDict];
        [aroundList addObject:aroundObject];
    }
    return aroundList;
}

@end
