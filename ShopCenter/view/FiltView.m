//
//  FiltView.m
//  ShopCenter
//
//  Created by mac on 2017/9/29.
//  Copyright © 2017年 wenzhe. All rights reserved.
//

#import "FiltView.h"
@implementation FiltView{
    BOOL isOneExist;
    BOOL isTwoExist;
    BOOL isThreeExist;
    BOOL isFourExist;
    BOOL isFiveExist;
    BOOL isSixExist;
}

-(PriceRangeTableViewCell *)priceCell{
    if (_priceCell == nil) {
        _priceCell = [[PriceRangeTableViewCell alloc]init];
    }
    return _priceCell;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"FiltView" owner:nil options:nil] lastObject];
        self.frame = CGRectMake(375,0,300, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor whiteColor];
        self.resetButton.layer.borderWidth = 0.5;
        self.resetButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

-(void)layoutSubviews{
    isOneExist = NO;
    isTwoExist = NO;
    isThreeExist = NO;
    isFourExist = NO;
    isFiveExist = NO;
    isSixExist = NO;
    [self.priceCell.firstButton addTarget:self action:@selector(rangButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.priceCell.secButton addTarget:self action:@selector(rangButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.priceCell.thirdButton addTarget:self action:@selector(rangButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.priceCell.fourthButton addTarget:self action:@selector(rangButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.priceCell.fifthButton addTarget:self action:@selector(rangButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.priceCell.sixthButton addTarget:self action:@selector(rangButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.resetButton addTarget:self action:@selector(resetOperation) forControlEvents:UIControlEventTouchUpInside];
}

-(void)resetOperation{
    self.choosedRange = nil;
    [self buttonChangeColor];
}

- (void)rangButtonDidClicked:(UIButton *)button{
    if (button.layer.borderWidth == 1.0) {
        button.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:249.0/255 alpha:1.0];
        button.layer.borderWidth = 0;
        self.choosedRange = nil;
    }else{
        [self buttonChangeColor];
        self.choosedRange = button.titleLabel.text;
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = [UIColor redColor].CGColor;
    }
}

- (void)buttonChangeColor{
    self.priceCell.firstButton.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:249.0/255 alpha:1.0];
    self.priceCell.firstButton.layer.borderWidth = 0;
    self.priceCell.secButton.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:249.0/255 alpha:1.0];
    self.priceCell.secButton.layer.borderWidth = 0;
    self.priceCell.thirdButton.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:249.0/255 alpha:1.0];
    self.priceCell.thirdButton.layer.borderWidth = 0;
    self.priceCell.fourthButton.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:249.0/255 alpha:1.0];
    self.priceCell.fourthButton.layer.borderWidth = 0;
    self.priceCell.fifthButton.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:249.0/255 alpha:1.0];
    self.priceCell.fifthButton.layer.borderWidth = 0;
    self.priceCell.sixthButton.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:249.0/255 alpha:1.0];
    self.priceCell.sixthButton.layer.borderWidth = 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.priceCell.frame.size.height;
}

- (BOOL)judgeRangeExist:(NSString *)string{
    return [[self.dictionary valueForKey:string] isEqual:@"YES"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellidentify = @"cell";
    self.priceCell = (PriceRangeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
    NSLog(@"%@",self.dictionary);
    [self resetButtonLocation];
    self.priceCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return self.priceCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//去除点击后一直灰
}

-(void)resetButtonLocation{
    NSInteger count = 0;
    if ([self judgeRangeExist:@"0-50"]) {
        count++;
        isOneExist = YES;
    }
    if ([[self.dictionary valueForKey:@"51-100"] isEqual: @"YES"]) {
        count++;
        isTwoExist = YES;
    }
    if ([[self.dictionary valueForKey:@"101-200"] isEqual: @"YES"]) {
        count++;
        isThreeExist = YES;
    }
    if ([[self.dictionary valueForKey:@"201-500"] isEqual: @"YES"]) {
        count++;
        isFourExist = YES;
    }
    if ([[self.dictionary valueForKey:@"501-1000"] isEqual: @"YES"]) {
        count++;
        isFiveExist = YES;
    }
    if ([[self.dictionary valueForKey:@"1001-10000"] isEqual: @"YES"]) {
        count++;
        isSixExist = YES;
    }
    
    switch (count) {
        case 0:
            self.priceCell.frame = CGRectMake(0,0,300, 160);
            [self.priceCell.firstButton setHidden:YES];
            [self.priceCell.secButton setHidden:YES];
            [self.priceCell.thirdButton setHidden:YES];
            [self.priceCell.fourthButton setHidden:YES];
            [self.priceCell.fifthButton setHidden:YES];
            [self.priceCell.sixthButton setHidden:YES];
            break;
        case 1:
            if (isOneExist) {
                [self.priceCell.firstButton setTitle:@"0-50" forState:UIControlStateNormal];
            }else if(isTwoExist){
                [self.priceCell.firstButton setTitle:@"51-100" forState:UIControlStateNormal];
            }else if (isThreeExist){
                [self.priceCell.firstButton setTitle:@"101-200" forState:UIControlStateNormal];
            }else if (isFourExist){
                [self.priceCell.firstButton setTitle:@"201-500" forState:UIControlStateNormal];
            }else if (isFiveExist){
                [self.priceCell.firstButton setTitle:@"501-1000" forState:UIControlStateNormal];
            }else if (isSixExist){
                [self.priceCell.firstButton setTitle:@"1001-10000" forState:UIControlStateNormal];
            }
            self.priceCell.frame = CGRectMake(0,0,300, 160);
            [self.priceCell.secButton setHidden:YES];
            [self.priceCell.thirdButton setHidden:YES];
            [self.priceCell.fourthButton setHidden:YES];
            [self.priceCell.fifthButton setHidden:YES];
            [self.priceCell.sixthButton setHidden:YES];
            break;
        case 2:
            if (isOneExist) {
                [self.priceCell.firstButton setTitle:@"0-50" forState:UIControlStateNormal];
                if(isTwoExist){
                    [self.priceCell.secButton setTitle:@"51-100" forState:UIControlStateNormal];
                }else if (isThreeExist){
                    [self.priceCell.secButton setTitle:@"101-200" forState:UIControlStateNormal];
                }else if (isFourExist){
                    [self.priceCell.secButton setTitle:@"201-500" forState:UIControlStateNormal];
                }else if (isFiveExist){
                    [self.priceCell.secButton setTitle:@"501-1000" forState:UIControlStateNormal];
                }else if (isSixExist){
                    [self.priceCell.secButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                }
            }else if(isTwoExist){
                [self.priceCell.firstButton setTitle:@"51-100" forState:UIControlStateNormal];
                if (isThreeExist){
                    [self.priceCell.secButton setTitle:@"101-200" forState:UIControlStateNormal];
                }else if (isFourExist){
                    [self.priceCell.secButton setTitle:@"201-500" forState:UIControlStateNormal];
                }else if (isFiveExist){
                    [self.priceCell.secButton setTitle:@"501-1000" forState:UIControlStateNormal];
                }else if (isSixExist){
                    [self.priceCell.secButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                }
            }else if (isThreeExist){
                [self.priceCell.firstButton setTitle:@"101-200" forState:UIControlStateNormal];
                if (isFourExist){
                    [self.priceCell.secButton setTitle:@"201-500" forState:UIControlStateNormal];
                }else if (isFiveExist){
                    [self.priceCell.secButton setTitle:@"501-1000" forState:UIControlStateNormal];
                }else if (isSixExist){
                    [self.priceCell.secButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                }
            }else if (isFourExist){
                [self.priceCell.firstButton setTitle:@"201-500" forState:UIControlStateNormal];
                if (isFiveExist){
                    [self.priceCell.secButton setTitle:@"501-1000" forState:UIControlStateNormal];
                }else if (isSixExist){
                    [self.priceCell.secButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                }
            }else if (isFiveExist){
                [self.priceCell.firstButton setTitle:@"501-1000" forState:UIControlStateNormal];
                [self.priceCell.secButton setTitle:@"1001-10000" forState:UIControlStateNormal];
            }
            
            self.priceCell.frame = CGRectMake(0,0,300, 160);
            [self.priceCell.thirdButton setHidden:YES];
            [self.priceCell.fourthButton setHidden:YES];
            [self.priceCell.fifthButton setHidden:YES];
            [self.priceCell.sixthButton setHidden:YES];
            break;
        case 3:
            if (isOneExist) {
                [self.priceCell.firstButton setTitle:@"0-50" forState:UIControlStateNormal];
                if(isTwoExist){
                    [self.priceCell.secButton setTitle:@"51-100" forState:UIControlStateNormal];
                    if (isThreeExist){
                        [self.priceCell.thirdButton setTitle:@"101-200" forState:UIControlStateNormal];
                    }else if (isFourExist){
                        [self.priceCell.thirdButton setTitle:@"201-500" forState:UIControlStateNormal];
                    }else if (isFiveExist){
                        [self.priceCell.thirdButton setTitle:@"501-1000" forState:UIControlStateNormal];
                    }else if (isSixExist){
                        [self.priceCell.thirdButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                    }
                }else if (isThreeExist){
                    [self.priceCell.secButton setTitle:@"101-200" forState:UIControlStateNormal];
                    if (isFourExist){
                        [self.priceCell.thirdButton setTitle:@"201-500" forState:UIControlStateNormal];
                    }else if (isFiveExist){
                        [self.priceCell.thirdButton setTitle:@"501-1000" forState:UIControlStateNormal];
                    }else if (isSixExist){
                        [self.priceCell.thirdButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                    }
                }else if (isFourExist){
                    [self.priceCell.secButton setTitle:@"201-500" forState:UIControlStateNormal];
                    if (isFiveExist){
                        [self.priceCell.thirdButton setTitle:@"501-1000" forState:UIControlStateNormal];
                    }else if (isSixExist){
                        [self.priceCell.thirdButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                    }
                }else if (isFiveExist){
                    [self.priceCell.secButton setTitle:@"501-1000" forState:UIControlStateNormal];
                    [self.priceCell.thirdButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                }
            }else if(isTwoExist){
                [self.priceCell.firstButton setTitle:@"51-100" forState:UIControlStateNormal];
                if (isThreeExist){
                    [self.priceCell.secButton setTitle:@"101-200" forState:UIControlStateNormal];
                    if (isFourExist){
                        [self.priceCell.thirdButton setTitle:@"201-500" forState:UIControlStateNormal];
                    }else if (isFiveExist){
                        [self.priceCell.thirdButton setTitle:@"501-1000" forState:UIControlStateNormal];
                    }else if (isSixExist){
                        [self.priceCell.thirdButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                    }
                }else if (isFourExist){
                    [self.priceCell.secButton setTitle:@"201-500" forState:UIControlStateNormal];
                    if (isFiveExist){
                        [self.priceCell.thirdButton setTitle:@"501-1000" forState:UIControlStateNormal];
                    }else if (isSixExist){
                        [self.priceCell.thirdButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                    }
                }else if (isFiveExist){
                    [self.priceCell.secButton setTitle:@"501-1000" forState:UIControlStateNormal];
                    if (isSixExist){
                        [self.priceCell.thirdButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                    }
                }
            }else if (isThreeExist){
                [self.priceCell.firstButton setTitle:@"101-200" forState:UIControlStateNormal];
                if (isFourExist){
                    [self.priceCell.secButton setTitle:@"201-500" forState:UIControlStateNormal];
                    if (isFiveExist){
                        [self.priceCell.thirdButton setTitle:@"501-1000" forState:UIControlStateNormal];
                    }else if (isSixExist){
                        [self.priceCell.thirdButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                    }
                }else if (isFiveExist){
                    [self.priceCell.secButton setTitle:@"501-1000" forState:UIControlStateNormal];
                    if (isSixExist){
                        [self.priceCell.thirdButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                    }
                }
            }else if (isFourExist){
                [self.priceCell.firstButton setTitle:@"201-500" forState:UIControlStateNormal];
                if (isFiveExist){
                    [self.priceCell.secButton setTitle:@"501-1000" forState:UIControlStateNormal];
                    if (isSixExist){
                        [self.priceCell.thirdButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                    }
                }
            }
            self.priceCell.frame = CGRectMake(0,0,300, 120);
            [self.priceCell.fourthButton setHidden:YES];
            [self.priceCell.fifthButton setHidden:YES];
            [self.priceCell.sixthButton setHidden:YES];
            break;
        case 4:
            if (isOneExist) {
                [self.priceCell.firstButton setTitle:@"0-50" forState:UIControlStateNormal];
                if(isTwoExist){
                    [self.priceCell.secButton setTitle:@"51-100" forState:UIControlStateNormal];
                    if (isThreeExist){
                        [self.priceCell.thirdButton setTitle:@"101-200" forState:UIControlStateNormal];
                        if (isFourExist){
                            [self.priceCell.fourthButton setTitle:@"201-500" forState:UIControlStateNormal];
                        }else if (isFiveExist){
                            [self.priceCell.fourthButton setTitle:@"501-1000" forState:UIControlStateNormal];
                        }else if (isSixExist){
                            [self.priceCell.fourthButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                        }
                    }else if (isFourExist){
                        [self.priceCell.thirdButton setTitle:@"201-500" forState:UIControlStateNormal];
                        if (isFiveExist){
                            [self.priceCell.fourthButton setTitle:@"501-1000" forState:UIControlStateNormal];
                        }else if (isSixExist){
                            [self.priceCell.fourthButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                        }
                    }
                }else if (isThreeExist){
                    [self.priceCell.secButton setTitle:@"101-200" forState:UIControlStateNormal];
                    if (isFourExist){
                        [self.priceCell.thirdButton setTitle:@"201-500" forState:UIControlStateNormal];
                        if (isFiveExist){
                            [self.priceCell.fourthButton setTitle:@"501-1000" forState:UIControlStateNormal];
                        }else if (isSixExist){
                            [self.priceCell.fourthButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                        }
                    }else if (isFiveExist){
                        [self.priceCell.thirdButton setTitle:@"501-1000" forState:UIControlStateNormal];
                        [self.priceCell.fourthButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                    }
                }else if (isFourExist){
                    [self.priceCell.secButton setTitle:@"201-500" forState:UIControlStateNormal];
                    [self.priceCell.thirdButton setTitle:@"501-1000" forState:UIControlStateNormal];
                    [self.priceCell.fourthButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                }
                
            }else if(isTwoExist){
                [self.priceCell.firstButton setTitle:@"51-100" forState:UIControlStateNormal];
                if (isThreeExist){
                    [self.priceCell.secButton setTitle:@"101-200" forState:UIControlStateNormal];
                    if (isFourExist){
                        [self.priceCell.thirdButton setTitle:@"201-500" forState:UIControlStateNormal];
                        if (isFiveExist){
                            [self.priceCell.fourthButton setTitle:@"501-1000" forState:UIControlStateNormal];
                        }else if (isSixExist){
                            [self.priceCell.fourthButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                        }
                    }else if (isFiveExist){
                        [self.priceCell.thirdButton setTitle:@"501-1000" forState:UIControlStateNormal];
                        [self.priceCell.fourthButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                    }
                }else if (isFourExist){
                    [self.priceCell.secButton setTitle:@"201-500" forState:UIControlStateNormal];
                    [self.priceCell.thirdButton setTitle:@"501-1000" forState:UIControlStateNormal];
                    [self.priceCell.fourthButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                }
                
            }else if (isThreeExist){
                [self.priceCell.firstButton setTitle:@"101-200" forState:UIControlStateNormal];
                [self.priceCell.secButton setTitle:@"201-500" forState:UIControlStateNormal];
                [self.priceCell.thirdButton setTitle:@"501-1000" forState:UIControlStateNormal];
                [self.priceCell.fourthButton setTitle:@"1001-10000" forState:UIControlStateNormal];
            }
            self.priceCell.frame = CGRectMake(0,0,300, 120);
            [self.priceCell.fifthButton setHidden:YES];
            [self.priceCell.sixthButton setHidden:YES];
            break;
        case 5:
            if (isOneExist) {
                [self.priceCell.firstButton setTitle:@"0-50" forState:UIControlStateNormal];
                if(isTwoExist){
                    [self.priceCell.secButton setTitle:@"51-100" forState:UIControlStateNormal];
                    if (isThreeExist){
                        [self.priceCell.thirdButton setTitle:@"101-200" forState:UIControlStateNormal];
                        if (isFourExist){
                            [self.priceCell.fourthButton setTitle:@"201-500" forState:UIControlStateNormal];
                            if (isFiveExist){
                                [self.priceCell.fifthButton setTitle:@"501-1000" forState:UIControlStateNormal];
                            }else if (isSixExist){
                                [self.priceCell.fifthButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                            }
                        }else if (isFiveExist){
                            [self.priceCell.fourthButton setTitle:@"501-1000" forState:UIControlStateNormal];
                            [self.priceCell.fifthButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                        }
                    }else if (isFourExist){
                        [self.priceCell.thirdButton setTitle:@"201-500" forState:UIControlStateNormal];
                        [self.priceCell.fourthButton setTitle:@"501-1000" forState:UIControlStateNormal];
                        [self.priceCell.fifthButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                    }
                }else if (isThreeExist){
                    [self.priceCell.secButton setTitle:@"101-200" forState:UIControlStateNormal];
                    [self.priceCell.thirdButton setTitle:@"201-500" forState:UIControlStateNormal];
                    [self.priceCell.fourthButton setTitle:@"501-1000" forState:UIControlStateNormal];
                    [self.priceCell.fifthButton setTitle:@"1001-10000" forState:UIControlStateNormal];
                }
                
            }else if(isTwoExist){
                [self.priceCell.firstButton setTitle:@"51-100" forState:UIControlStateNormal];
                [self.priceCell.secButton setTitle:@"101-200" forState:UIControlStateNormal];
                [self.priceCell.thirdButton setTitle:@"201-500" forState:UIControlStateNormal];
                [self.priceCell.fourthButton setTitle:@"501-1000" forState:UIControlStateNormal];
                [self.priceCell.fifthButton setTitle:@"1001-10000" forState:UIControlStateNormal];
            }
            
            self.priceCell.frame = CGRectMake(0,0,300, 120);
            [self.priceCell.sixthButton setHidden:YES];
            break;
        case 6:
            [self.priceCell.firstButton setTitle:@"0-50" forState:UIControlStateNormal];
            [self.priceCell.secButton setTitle:@"51-100" forState:UIControlStateNormal];
            [self.priceCell.thirdButton setTitle:@"101-200" forState:UIControlStateNormal];
            [self.priceCell.fourthButton setTitle:@"201-500" forState:UIControlStateNormal];
            [self.priceCell.fifthButton setTitle:@"501-1000" forState:UIControlStateNormal];
            [self.priceCell.sixthButton setTitle:@"1001-10000" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
@end
