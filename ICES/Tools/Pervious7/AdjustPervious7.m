//
//  AdjustPervious7.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/25.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "AdjustPervious7.h"

@implementation AdjustPervious7

+ (UITableViewStyle)tableviewStyle {
    if (kDeviceVersion >= 7.0) {
        return UITableViewStyleGrouped;
    }
    return UITableViewStylePlain;
}

+ (UIView *)tableviewHeaderOrFooterView {
    if (kDeviceVersion >= 7.0) {
        return nil;
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
