//
//  ChoosedTableViewCell.m
//  ShopDemo
//
//  Created by mac on 2017/9/22.
//  Copyright © 2017年 wenzhe. All rights reserved.
//

#import "ChoosedTableViewCell.h"

@implementation ChoosedTableViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ChoosedTableViewCell" owner:nil options:nil] lastObject];
    }
    return self;
}

-(void)layoutSubviews{
    CGRect rect = self.frame;
    rect.size.width = self.frame.size.width;
    rect.size.height = 50;
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
