//
//  EventCell.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/10.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kEventCellHeight 97.f

@interface EventCell : UITableViewCell

@property (nonatomic, strong) UIImageView *pictureView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *summaryLabel;

@end
