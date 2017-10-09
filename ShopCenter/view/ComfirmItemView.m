//
//  ComfirmItemView.m
//  ShopCenter
//
//  Created by mac on 2017/9/28.
//  Copyright © 2017年 wenzhe. All rights reserved.
//

#import "ComfirmItemView.h"

@implementation ComfirmItemView{
    NSString *limiteNum;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ComfirmItemView" owner:nil options:nil] lastObject];
        self.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 230);
        self.backgroundColor = [UIColor whiteColor];
        self.stepTextField.delegate = self;
        [self.minuteStepButton setEnabled:NO];
        [self.minuteStepButton addTarget:self action:@selector(minuteStep) forControlEvents:UIControlEventTouchUpInside];
        [self.plusStepButton addTarget:self action:@selector(plusStep) forControlEvents:UIControlEventTouchUpInside];
        [self.stepTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.cancelButton addTarget:self action:@selector(dissmissAll) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)layoutSubviews{
    self.minuteStepButton.layer.borderWidth = 1.0;
    self.plusStepButton.layer.borderWidth = 1.0;
    
    limiteNum = [self.limiteLabel.text substringWithRange:NSMakeRange(2, self.limiteLabel.text.length-3)];
    if ([limiteNum isEqual: @"1"] || [limiteNum isEqual: @"0"]) {
        [self buttonToBeDisabled:self.plusStepButton];
        [self buttonToBeDisabled:self.minuteStepButton];
    }
}

-(void)dissmissAll{
    [self.stepTextField resignFirstResponder];
}

- (void)minuteStep{
    if (self.stepTextField.text.integerValue == limiteNum.integerValue) {
        [self buttonToBeEnabled:self.plusStepButton];
    }
    self.stepTextField.text = [NSString stringWithFormat:@"%ld",self.stepTextField.text.integerValue-1];
    if (self.stepTextField.text.integerValue == 1) {
        [self buttonToBeDisabled:self.minuteStepButton];
    }
}

- (void)plusStep{
    if (self.stepTextField.text.integerValue == 1) {
        [self buttonToBeEnabled:self.minuteStepButton];
    }
    self.stepTextField.text = [NSString stringWithFormat:@"%ld",self.stepTextField.text.integerValue+1];
    if (self.stepTextField.text.integerValue == limiteNum.integerValue) {
        [self buttonToBeDisabled:self.plusStepButton];
    }
}

- (void)buttonToBeEnabled:(UIButton *)button{
    [button setEnabled:YES];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)buttonToBeDisabled:(UIButton *)button{
    [button setEnabled:NO];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

- (void)textFieldDidChanged:(UITextField *)textField{
    if (textField.text.integerValue >= limiteNum.integerValue) {
        textField.text = limiteNum;
        [self buttonToBeDisabled:self.plusStepButton];
    }
}

//点击return键，收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField.text.integerValue <= 1) {
        textField.text = @"1";
        [self buttonToBeDisabled:self.minuteStepButton];
    }
    return YES;
}

//开始编辑时 视图上移 如果输入框不被键盘遮挡则不上移。
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat rects = [UIScreen mainScreen].bounds.size.height-self.frame.size.height-210-50;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = rects;
        self.frame = frame;
    }];
    return YES;
}

//结束编辑时键盘下去 视图下移动画
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height-self.frame.size.height;
        self.frame = frame;
    }];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.stepTextField resignFirstResponder];
    if (self.stepTextField.text.integerValue <= 1) {
        self.stepTextField.text = @"1";
        [self buttonToBeDisabled:self.minuteStepButton];
    }
}

@end
