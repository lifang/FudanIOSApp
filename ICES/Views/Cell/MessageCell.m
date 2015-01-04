//
//  MessageCell.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/11.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
      withCellStyle:(MessageCellStyle)cellStyle {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initAndLayoutUIWithStyle:cellStyle];
    }
    return self;
}

#pragma mark - UI

- (void)initAndLayoutUIWithStyle:(MessageCellStyle)cellStyle {
    if (cellStyle == MessageCellImage) {
        [self initUIWithImage];
    }
    else {
        [self initUIWithText];
    }
}

//带image的message
- (void)initUIWithImage {
    CGFloat topSpace = 15.f;     //顶部间距
    CGFloat leftSpace = 15.f;    //左侧间距
    CGFloat rightSpace = 15.f;   //右侧间距
//    CGFloat bottomSpace = 5.f;   //底部间距
    CGFloat titleBackHeight = 44.f;  //标题背景高度
    CGFloat summaryBackHeight = 46.f; //简介背景高度
    _pictureView = [[UIImageView alloc] init];
    _pictureView.translatesAutoresizingMaskIntoConstraints = NO;
    _pictureView.backgroundColor = [UIColor blackColor];
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
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-rightSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:kMessageImageScale
                                                                  constant:-(leftSpace + rightSpace) * kMessageImageScale]];
    
    UIImageView *backView = [[UIImageView alloc] init];
    backView.translatesAutoresizingMaskIntoConstraints = NO;
    backView.image = [[UIImage imageNamed:@"messageback.png"]
                      resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [self.contentView addSubview:backView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:backView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-titleBackHeight]];
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
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:titleBackHeight]];
    //深色背景
    UIImageView *darkBackView = [[UIImageView alloc] init];
    darkBackView.translatesAutoresizingMaskIntoConstraints = NO;
    darkBackView.image = [[UIImage imageNamed:@"darkblue.png"]
                          resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [self.contentView addSubview:darkBackView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:darkBackView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:darkBackView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:darkBackView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-rightSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:darkBackView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:summaryBackHeight]];
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
    _titleLabel.textColor = kColor(3, 39, 65, 1);
    [backView addSubview:_titleLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:backView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:backView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:4]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:backView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-4]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:backView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0]];
    //简介
    _summaryLabel = [[UILabel alloc] init];
    _summaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _summaryLabel.backgroundColor = [UIColor clearColor];
    _summaryLabel.numberOfLines = 3;
    _summaryLabel.font = [UIFont systemFontOfSize:12.f];
    _summaryLabel.textColor = [UIColor whiteColor];
    [darkBackView addSubview:_summaryLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_summaryLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:darkBackView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_summaryLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:darkBackView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:4]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_summaryLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:darkBackView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-4]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_summaryLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:darkBackView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0]];
}

//无图片
- (void)initUIWithText {
    CGFloat topSpace = 15.f;     //顶部间距
    CGFloat leftSpace = 15.f;    //左侧间距
    CGFloat rightSpace = 15.f;   //右侧间距
    CGFloat titleBackHeight = 44.f;  //标题背景高度
    CGFloat summaryBackHeight = 46.f; //简介背景高度
    UIImageView *backView = [[UIImageView alloc] init];
    backView.translatesAutoresizingMaskIntoConstraints = NO;
    backView.image = [[UIImage imageNamed:@"lightwhite.png"]
                      resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [self.contentView addSubview:backView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:backView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
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
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:titleBackHeight]];
    //深色背景
    UIImageView *darkBackView = [[UIImageView alloc] init];
    darkBackView.translatesAutoresizingMaskIntoConstraints = NO;
    darkBackView.image = [[UIImage imageNamed:@"darkblue.png"]
                          resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [self.contentView addSubview:darkBackView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:darkBackView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:backView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:darkBackView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:darkBackView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-rightSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:darkBackView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:summaryBackHeight]];
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
    _titleLabel.textColor = kColor(3, 39, 65, 1);
    [backView addSubview:_titleLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:backView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:backView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:backView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:backView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0]];
    //简介
    _summaryLabel = [[UILabel alloc] init];
    _summaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _summaryLabel.backgroundColor = [UIColor clearColor];
    _summaryLabel.numberOfLines = 3;
    _summaryLabel.font = [UIFont systemFontOfSize:12.f];
    _summaryLabel.textColor = [UIColor whiteColor];
    [darkBackView addSubview:_summaryLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_summaryLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:darkBackView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_summaryLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:darkBackView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_summaryLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:darkBackView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_summaryLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:darkBackView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0]];
}

@end
