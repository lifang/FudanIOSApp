//
//  AroundDetailModel.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/17.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AroundDetailModel : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString *startHour;

@property (nonatomic, strong) NSString *startMinute;

@property (nonatomic, strong) NSString *finishHour;

@property (nonatomic, strong) NSString *finishMinute;

@property (nonatomic, strong) NSString *latitude;   //经度

@property (nonatomic, strong) NSString *longitude;  //纬度

@property (nonatomic, strong) NSString *phoneNumber;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSMutableArray *imageList;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
