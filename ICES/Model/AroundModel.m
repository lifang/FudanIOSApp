//
//  AroundModel.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/17.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "AroundModel.h"

@implementation AroundModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _aroundName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"aroundcampusName"]];
        _aroundSummary = [NSString stringWithFormat:@"%@",[dict objectForKey:@"aroundcampusIntroductionShort"]];
        _aroundType = [[dict objectForKey:@"aroundcampusType"] intValue];
        _aroundID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        
        id picturePath = [dict objectForKey:@"pictureSmallFilePath"];
        if (picturePath && ![picturePath isKindOfClass:[NSNull class]]) {
            _aroundSmallImage = [NSString stringWithFormat:@"%@",picturePath];
        }
    }
    return self;
}

@end
