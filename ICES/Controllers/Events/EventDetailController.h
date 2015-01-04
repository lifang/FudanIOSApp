//
//  EventDetailController.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/18.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "DetailViewController.h"
#import "EventModel.h"

@interface EventDetailController : DetailViewController

@property (nonatomic, strong) EventModel *eventData;

//从通知中跳转的event
@property (nonatomic, strong) NSString *eventID;

@end
