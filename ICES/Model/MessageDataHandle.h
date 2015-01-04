//
//  MessageDataHandle.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"

@interface MessageDataHandle : NSObject

+ (NSMutableArray *)parseData:(NSDictionary *)object;

@end
