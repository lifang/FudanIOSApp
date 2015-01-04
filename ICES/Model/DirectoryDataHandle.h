//
//  DirectoryDataHandle.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/5.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleView.h"
#import "TreeDirectory.h"

typedef enum {
    DownloadNormal = 0,    //正常加载
    DownloadFormTop,       //下拉加载
    DownloadFormBottom,    //上拉加载
}DownloadStyle;

@interface DirectoryDataHandle : NSObject

//获取分类标题
+ (NSString *)titleForModuleType:(ModuleViewTag)type;
//模块加载数据的的type
+ (int)typeForModuleType:(ModuleViewTag)type;
//解析
+ (NSMutableArray *)parseData:(NSDictionary *)object;

@end
