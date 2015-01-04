//
//  MessageModel.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MessageStatusNew = 1,    //新消息
    MessageStatusRecent,     //最近
    MessageStatusAll,        //所有
}MessageStatus;

typedef enum {
    MessageTypeNormal = 1,
    MessageTypeEvent,
}MessageTypes;

@interface MessageModel : NSObject

@property (nonatomic, strong) NSString *messageID;

@property (nonatomic, strong) NSString *messageTitle;

@property (nonatomic, strong) NSString *messageSummary;

@property (nonatomic, assign) int messageStatus;

@property (nonatomic, assign) int messageType;

@property (nonatomic, strong) NSString *messageImagePath;

@property (nonatomic, strong) NSString *messageEventID;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
