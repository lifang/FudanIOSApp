//
//  UserModel.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/15.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject<NSCopying,NSCoding>

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSString *userID;

@property (nonatomic, strong) NSString *token;

@end
