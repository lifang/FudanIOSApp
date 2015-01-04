
//
//  EventCell.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/10.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "EventCell.h"

@implementation EventCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initAndLayoutUI];
    }
    return self;
}

#pragma mark - UI

- (void)initAndLayoutUI {
    CGFloat topSpace = 10.f;     //顶部间距
    CGFloat leftSpace = 15.f;    //左侧间距
    CGFloat rightSpace = 15.f;   //右侧间距
    CGFloat bottomSpace = 10.f;  //底部间距
    CGFloat imageWidth = 124.f;  //图片宽
    CGFloat imageHeight = 75.f;  //图片高
    
    //背景
    UIView *backView = [[UIView alloc] init];
    backView.translatesAutoresizingMaskIntoConstraints = NO;
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:backView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:backView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:backView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-rightSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:backView
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
                                                                  constant:leftSpace + 5]];
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
    _titleLabel.numberOfLines = 0;
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
                                                                  constant:10]];
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
                                                                  constant:36.f]];
    //summary
    _summaryLabel = [[UILabel alloc] init];
    _summaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _summaryLabel.backgroundColor = [UIColor clearColor];
    _summaryLabel.font = [UIFont systemFontOfSize:11.f];
    _summaryLabel.textColor = kColor(136, 136, 136, 1);
    _summaryLabel.numberOfLines = 0;
    [self.contentView addSubview:_summaryLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_summaryLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_titleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_summaryLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:10]];
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
//    //line
//    UIImageView *lineView = [[UIImageView alloc] init];
//    lineView.translatesAutoresizingMaskIntoConstraints = NO;
//    lineView.image = [UIImage imageNamed:@"linecolor.png"];
//    [self.contentView addSubview:lineView];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lineView
//                                                                 attribute:NSLayoutAttributeTop
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:self.contentView
//                                                                 attribute:NSLayoutAttributeBottom
//                                                                multiplier:1.0
//                                                                  constant:-kLineHeight]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lineView
//                                                                 attribute:NSLayoutAttributeLeft
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:self.contentView
//                                                                 attribute:NSLayoutAttributeLeft
//                                                                multiplier:1.0
//                                                                  constant:leftSpace]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lineView
//                                                                 attribute:NSLayoutAttributeRight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:self.contentView
//                                                                 attribute:NSLayoutAttributeRight
//                                                                multiplier:1.0
//                                                                  constant:-rightSpace]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lineView
//                                                                 attribute:NSLayoutAttributeHeight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:nil
//                                                                 attribute:NSLayoutAttributeHeight
//                                                                multiplier:0.0
//                                                                  constant:kLineHeight]];
}

@end
