//
//  PArcheryKeyBoard.m
//  Archery Score
//
//  Created by Staff on 2017/2/19.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "PArcheryKeyBoard.h"
#define kLineWidth 1
#define kNumFont [UIFont systemFontOfSize:27]
#define DefaultFrame CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 324)

@implementation PArcheryKeyBoard

+(instancetype)pooArcheryKeyBoard
{
    return [[PArcheryKeyBoard alloc] initWithFrame:DefaultFrame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 324);
        for (int i=0; i<4; i++)
        {
            for (int j=0; j<3; j++)
            {
                UIButton *button = [self creatButtonWithX:i Y:j];
                [self addSubview:button];
            }
        }

        UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pBtn.frame = CGRectMake(0, 216, screenWidth, 54);
        pBtn.backgroundColor = [UIColor redColor];
        [pBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [pBtn setTitle:@"删除" forState:UIControlStateNormal];
        [pBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        pBtn.tag = 13;
        [self addSubview:pBtn];

        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(0, pBtn.y+pBtn.height, screenWidth, 54);
        doneBtn.backgroundColor = PRGBAColor(0, 149, 227,1);
        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doneBtn setTitle:@"录入" forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        doneBtn.tag = 14;
        [self addSubview:doneBtn];

        UIColor *color = [UIColor colorWithRed:188/255.0 green:192/255.0 blue:199/255.0 alpha:1];
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake((screenWidth-2)/3, 0, kLineWidth, 216)];
        line1.backgroundColor = color;
        [self addSubview:line1];
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake((screenWidth-2)/3*2, 0, kLineWidth, 216)];
        line2.backgroundColor = color;
        [self addSubview:line2];
        for (int i=0; i<4; i++)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 54*(i+1), [UIScreen mainScreen].bounds.size.width, kLineWidth)];
            line.backgroundColor = color;
            [self addSubview:line];
        }
    }
    return self;
}

-(UIButton *)creatButtonWithX:(NSInteger) x Y:(NSInteger) y
{
    UIButton *button;
    CGFloat frameX = 0.0;
    CGFloat frameW = 0.0;
    switch (y)
    {
        case 0:
            frameX = 0.0;
            frameW = ([UIScreen mainScreen].bounds.size.width-2)/3;
            break;
        case 1:
            frameX = ([UIScreen mainScreen].bounds.size.width-2)/3;
            frameW = ([UIScreen mainScreen].bounds.size.width-2)/3;
            break;
        case 2:
            frameX = ([UIScreen mainScreen].bounds.size.width-2)/3*2;
            frameW = ([UIScreen mainScreen].bounds.size.width-2)/3;
            break;

        default:
            break;
    }
    CGFloat frameY = 54*x;
    button = [[UIButton alloc] initWithFrame:CGRectMake(frameX, frameY, frameW, 54)];
    NSInteger num = y+3*x+1;
    button.tag = num;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];

    UIColor *colorNormal = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1];
    UIColor *colorHightlighted = [UIColor colorWithRed:186.0/255 green:189.0/255 blue:194.0/255 alpha:1.0];

    //    if (num == 10 || num == 12)
    //    {
    //        UIColor *colorTemp = colorNormal;
    //        colorNormal = colorHightlighted;
    //        colorHightlighted = colorTemp;
    //    }
    button.backgroundColor = colorNormal;
    CGSize imageSize = CGSizeMake(frameW, 54);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [colorHightlighted set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [button setImage:pressedColorImg forState:UIControlStateHighlighted];


    if (num<10)
    {
        UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
        labelNum.text = [NSString stringWithFormat:@"%ld",(long)num];
        labelNum.textColor = [UIColor blackColor];
        labelNum.textAlignment = NSTextAlignmentCenter;
        //        labelNum.font = kNumFont;
        [button addSubview:labelNum];
    }
    else if (num == 11)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
        label.text = @"X";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        //        label.font = kNumFont;
        [button addSubview:label];
    }
    else if (num == 10)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
        label.text = @"10";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
    }
    else if (num == 12)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
        label.text = @"M";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
    }
    return button;
}

-(void)clickButton:(UIButton *)sender
{
    if(sender.tag == 13)
    {
        [self.delegate archeryKeyboardBackspace:self];
    }
    else if (sender.tag == 14)
    {
        [self.delegate archeryKeyboadrDone:self];
    }
    else
    {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        if (sender.tag == 11)
        {
            num = @"X";
        }
        else if (sender.tag == 10)
        {
            num = @"10";
        }
        else if (sender.tag == 12)
        {
            num = @"M";
        }
        [self.delegate archeryberKeyboard:self input:num];
    }
}

@end

