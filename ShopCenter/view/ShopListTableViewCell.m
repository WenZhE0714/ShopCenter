//
//  ShopListTableViewCell.m
//  ShopDemo
//
//  Created by mac on 2017/9/15.
//  Copyright © 2017年 wenzhe. All rights reserved.
//

#import "ShopListTableViewCell.h"

@implementation ShopListTableViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ShopListTableViewCell" owner:nil options:nil] lastObject];
    }
    return self;
}

-(void)layoutSubviews{
    CGRect rect = self.frame;
    rect.size.width = self.frame.size.width;
    rect.size.height = 125;
    self.frame = rect;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
