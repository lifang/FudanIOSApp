//
//  Constants.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/2.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//


#define kColor(r,g,b,a) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

#define kDeviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define kLineHeight   0.5f

#define kPageSize 10   //分页加载每页行数

#define kServiceURL @"http://192.168.0.250:8080/icesapp/api"

#define kImageURL @"http://192.168.0.250:8080/icesapp"

#define kPromptInfo @"Prompting Information"  //警告框提示

#define kAppID @""  //appID
