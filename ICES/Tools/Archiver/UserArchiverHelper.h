//
//  UserArchiverHelper.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/15.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

#define kLastestPath @"lasteseUserInfo"
#define kLastestFile @"lastestUser"

@interface UserArchiverHelper : NSObject

+ (void)savePasswordForUser:(UserModel *)user;

+ (UserModel *)getLastestUser;

@end
