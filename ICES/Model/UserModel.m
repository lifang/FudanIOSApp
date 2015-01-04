//
//  UserModel.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/15.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_password forKey:@"password"];
    [aCoder encodeObject:_userID forKey:@"userID"];
    [aCoder encodeObject:_token forKey:@"token"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _username = [aDecoder decodeObjectForKey:@"username"];
        _password = [aDecoder decodeObjectForKey:@"password"];
        _userID = [aDecoder decodeObjectForKey:@"userID"];
        _token = [aDecoder decodeObjectForKey:@"token"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    UserModel *user = [[self class] allocWithZone:zone];
    user.username = [_username copyWithZone:zone];
    user.password = [_password copyWithZone:zone];
    user.userID = [_userID copyWithZone:zone];
    user.token = [_token copyWithZone:zone];
    return user;
}

@end
