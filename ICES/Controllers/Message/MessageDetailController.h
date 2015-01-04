//
//  MessageDetailController.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "DetailViewController.h"
#import "MessageModel.h"

static NSString *MessageListReadNotification = @"MessageListReadNotification";

@interface MessageDetailController : DetailViewController

@property (nonatomic, strong) MessageModel *messageData;

@property (nonatomic, strong) NSString *messageID; //推送使用的ID

@end
