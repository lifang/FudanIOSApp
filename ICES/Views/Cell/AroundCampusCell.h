//
//  AroundCampusCell.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/5.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAroundCampusCellHeight  105.f + kLineHeight

@interface AroundCampusCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *pictureView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *typeView;

@property (nonatomic, strong) UILabel *summaryLabel;

- (void)hiddenBackground:(BOOL)hide;

@end
