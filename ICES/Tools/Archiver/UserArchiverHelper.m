//
//  UserArchiverHelper.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/15.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "UserArchiverHelper.h"

@implementation UserArchiverHelper

#pragma mark - 最后登录用户

+ (NSString *)lastestUserPath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:kLastestPath];
}

+ (void)savePasswordForUser:(UserModel *)user {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:user forKey:kLastestFile];
        [archiver finishEncoding];
        [data writeToFile:[[self class] lastestUserPath] atomically:YES];
    });
}

+ (UserModel *)getLastestUser {
    NSString *userPath = [[self class] lastestUserPath];
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:userPath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    return [unarchiver decodeObjectForKey:kLastestFile];
}

@end
