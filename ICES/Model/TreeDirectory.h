//
//  TreeDirectory.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeDirectory : NSObject

@property (nonatomic, strong) NSString *directoryName;

@property (nonatomic, strong) NSArray *children;

@property (nonatomic, strong) NSString *directoryID;

- (id)initWithDirectoryName:(NSString *)name
                   children:(NSArray *)children
                directoryID:(NSString *)directoryID;

@end
