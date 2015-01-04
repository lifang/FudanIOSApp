//
//  MessageModel.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _messageID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"notificationId"]];
        _messageTitle = [NSString stringWithFormat:@"%@",[dict objectForKey:@"notificationTitle"]];
        _messageSummary = [NSString stringWithFormat:@"%@",[dict objectForKey:@"notificationShortContent"]];
        _messageType = [[dict objectForKey:@"notificationType"] intValue];
        _messageStatus = [[dict objectForKey:@"notificationIsRead"] intValue];
        if (![[dict objectForKey:@"pictureSmallFilePath"] isKindOfClass:[NSNull class]]) {
            _messageImagePath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"pictureSmallFilePath"]];
        }
        if ([dict objectForKey:@"eventsId"]) {
            _messageEventID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"eventsId"]];
        }
    }
    return self;
}

@end
