//
//  AroundMapController.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/23.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface AroundMapController : UIViewController

@property (nonatomic, strong) NSString *addressName;

@property (nonatomic, strong) NSString *longitude;  //经度
@property (nonatomic, strong) NSString *latitude;   //纬度

@end
