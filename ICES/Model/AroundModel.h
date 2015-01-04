//
//  AroundModel.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/17.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AroundModel : NSObject

@property (nonatomic, strong) NSString *aroundName;

@property (nonatomic, strong) NSString *aroundSummary;

@property (nonatomic, assign) int aroundType;

@property (nonatomic, strong) NSString *aroundID;

@property (nonatomic, strong) NSString *aroundSmallImage;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
