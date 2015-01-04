//
//  MessageCell.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/11.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMessageCellWithImageHeight   100.f
#define kMessageCellWithTextHeight    116.f

#define kMessageImageScale  0.59f

typedef enum {
    MessageCellImage = 1,
    MessageCellText,
}MessageCellStyle;

static NSString *messageCellIdentifier_image = @"messageCellIdentifier_image";
static NSString *messageCellIdentifier_text = @"messageCellIdentifier_text";

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *pictureView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *summaryLabel;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
      withCellStyle:(MessageCellStyle)cellStyle;

@end
