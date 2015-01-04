//
//  MessageDataHandle.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "MessageDataHandle.h"

@implementation MessageDataHandle

+ (NSMutableArray *)parseData:(NSDictionary *)object {
    if (![object objectForKey:@"result"] || ![[object objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSArray *item = [object objectForKey:@"result"];
    NSMutableArray *messageList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [item count]; i++) {
        NSDictionary *messageDict = [item objectAtIndex:i];
        MessageModel *messageObject = [[MessageModel alloc] initWithParseDictionary:messageDict];
        [messageList addObject:messageObject];
    }
    return messageList;
}

@end
