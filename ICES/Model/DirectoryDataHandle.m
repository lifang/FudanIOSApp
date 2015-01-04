//
//  DirectoryDataHandle.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/5.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "DirectoryDataHandle.h"

@implementation DirectoryDataHandle

+ (NSString *)titleForModuleType:(ModuleViewTag)type {
    NSString *title = nil;
    switch (type) {
        case ModulePreArrival:
            title = @"Pre-Arrival";
            break;
        case ModuleArrival:
            title = @"Arrival";
            break;
        case ModuleCampus:
            title = @"Campus";
            break;
        default:
            break;
    }
    return title;
}

+ (int)typeForModuleType:(ModuleViewTag)type {
    int directoryType = 0;
    switch (type) {
        case ModulePreArrival: {
            directoryType = 1;
        }
            break;
        case ModuleArrival: {
            directoryType = 2;
        }
            break;
        case ModuleCampus: {
            directoryType = 3;
        }
            break;
        default:
            break;
    }
    return directoryType;
}

+ (NSMutableArray *)parseData:(NSDictionary *)object {
    if (![object objectForKey:@"result"] || ![[object objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSArray *item = [object objectForKey:@"result"];
    //保存构造好的数据类型
    NSMutableArray *treeList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [item count]; i++) {
        NSMutableArray *children = [[NSMutableArray alloc] init];
        //目录信息
        NSDictionary *directory = [item objectAtIndex:i];
        NSMutableArray *contentList = [directory objectForKey:@"contentList"];
        NSString *directoryTitle = [NSString stringWithFormat:@"%@",[directory objectForKey:@"directoryName"]];
        NSString *directoryID = [NSString stringWithFormat:@"%@",[directory objectForKey:@"directorId"]];
        for (int j = 0; j < [contentList count]; j++) {
            //文章信息
            NSDictionary *content = [contentList objectAtIndex:j];
            NSString *contentTitle = [NSString stringWithFormat:@"%@",[content objectForKey:@"contentTitle"]];
            NSString *contentID = [NSString stringWithFormat:@"%@",[content objectForKey:@"id"]];
            TreeDirectory *treeNode = [[TreeDirectory alloc] initWithDirectoryName:contentTitle children:nil directoryID:contentID];
            [children addObject:treeNode];
        }
        TreeDirectory *directoryNode = [[TreeDirectory alloc] initWithDirectoryName:directoryTitle children:children directoryID:directoryID];
        [treeList addObject:directoryNode];
    }
    return treeList;
}

@end
