//
//  AroundCampusCell.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/5.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "AroundCampusCell.h"

@implementation AroundCampusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initAndLayoutUI];
    }
    return self;
}

#pragma mark - UI

- (void)initAndLayoutUI {
    CGFloat topSpace = 15.f;     //顶部间距
    CGFloat leftSpace = 15.f;    //左侧间距
    CGFloat rightSpace = 15.f;   //右侧间距
    CGFloat bottomSpace = 15.f;  //底部间距
    CGFloat imageWidth = 124.f;  //图片宽
    CGFloat imageHeight = 75.f;  //图片高
    
    //背景
    _backView = [[UIView alloc] init];
    _backView.translatesAutoresizingMaskIntoConstraints = NO;
    _backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_backView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_backView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_backView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-rightSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_backView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0]];
    
    //picture
    _pictureView = [[UIImageView alloc] init];
    _pictureView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_pictureView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.0
                                                                  constant:imageWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:0.0
                                                                  constant:imageHeight]];
    //title
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:15.f];
    _titleLabel.textColor = kColor(3, 39, 61, 1);
    [self.contentView addSubview:_titleLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-rightSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:0.0
                                                                  constant:19.f]];
    //typeView
    _typeView = [[UIImageView alloc] init];
    _typeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_typeView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_typeView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_titleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:2.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_typeView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_typeView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.0
                                                                  constant:12.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_typeView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:0.0
                                                                  constant:12.0]];
    //summary
    _summaryLabel = [[UILabel alloc] init];
    _summaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _summaryLabel.backgroundColor = [UIColor clearColor];
    _summaryLabel.font = [UIFont systemFontOfSize:11.f];
    _summaryLabel.textColor = kColor(59, 62, 62, 1);
    _summaryLabel.numberOfLines = 0;
    [self.contentView addSubview:_summaryLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_summaryLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_typeView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:2]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_summaryLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_summaryLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-rightSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_summaryLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-bottomSpace]];
    
    //line
    UIImageView *lineView = [[UIImageView alloc] init];
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    lineView.image = [UIImage imageNamed:@"linecolor.png"];
    [self.contentView addSubview:lineView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lineView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-kLineHeight]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lineView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lineView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-rightSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lineView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:0.0
                                                                  constant:kLineHeight]];
}

- (void)hiddenBackground:(BOOL)hide {
    if (hide) {
        _backView.hidden = YES;
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    else {
        _backView.hidden = NO;
        self.contentView.backgroundColor = kColor(244, 244, 244, 1);
    }
}

@end
