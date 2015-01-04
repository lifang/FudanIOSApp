//
//  TreeDirectory.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "TreeDirectory.h"

@implementation TreeDirectory

- (id)initWithDirectoryName:(NSString *)name
                   children:(NSArray *)children
                directoryID:(NSString *)directoryID {
    if (self = [super init]) {
        _directoryName = name;
        _children = children;
        _directoryID = directoryID;
    }
    return self;
}

@end
