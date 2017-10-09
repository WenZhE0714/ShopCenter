//
//  BigImageView.m
//  ShopDemo
//
//  Created by mac on 2017/9/25.
//  Copyright © 2017年 wenzhe. All rights reserved.
//

#import "BigImageView.h"
#define IPHONE_H ([UIScreen mainScreen].bounds.size.height)
#define IPHONE_W ([UIScreen mainScreen].bounds.size.width)
@implementation BigImageView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.imageView = [[UIImageView alloc]init];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDismiss)];
        [self addGestureRecognizer:tapGestureRecognizer];
        [self addSubview:self.imageView];
    }
    return self;
}

-(void)layoutSubviews{
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.imageView.frame = CGRectMake(0, (IPHONE_H-IPHONE_W)/2, IPHONE_W, IPHONE_W);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)tapDismiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
