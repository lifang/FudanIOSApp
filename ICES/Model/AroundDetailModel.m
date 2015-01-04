//
//  AroundDetailModel.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/17.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "AroundDetailModel.h"

@implementation AroundDetailModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"aroundcampusName"]];
        _address = [NSString stringWithFormat:@"%@",[dict objectForKey:@"aroundcampusAddress"]];
        _startHour = [NSString stringWithFormat:@"%@",[dict objectForKey:@"aroundcampusStartHour"]];
        _startMinute = [NSString stringWithFormat:@"%@",[dict objectForKey:@"aroundcampusStartMinute"]];
        _finishHour = [NSString stringWithFormat:@"%@",[dict objectForKey:@"aroundcampusFinshHour"]];
        _finishMinute = [NSString stringWithFormat:@"%@",[dict objectForKey:@"aroundcampusFinshMinute"]];
        _phoneNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"aroundcampusPhone"]];
        _content = [NSString stringWithFormat:@"%@",[dict objectForKey:@"aroundcampusIntroduction"]];
        _latitude = [NSString stringWithFormat:@"%@",[dict objectForKey:@"aroundcampusLatitude"]];
        _longitude = [NSString stringWithFormat:@"%@",[dict objectForKey:@"aroundcampusLongitude"]];
        _imageList = [[NSMutableArray alloc] init];
        NSArray *list = [dict objectForKey:@"pictures"];
        for (int i = 0; i < [list count]; i++) {
            NSDictionary *pictureDict = [list objectAtIndex:i];
            id picturePath = [pictureDict objectForKey:@"pictureLargeFilePath"];
            if (picturePath && ![picturePath isKindOfClass:[NSNull class]]) {
                [_imageList addObject:[NSString stringWithFormat:@"%@",picturePath]];
            }
        }
    }
    return self;
}

@end
