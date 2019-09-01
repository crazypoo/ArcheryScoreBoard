//
//  CGBaseSearchBar.m
//  CGBase_Example
//
//  Created by crazypoo on 2019/8/15.
//  Copyright © 2019 crazypoo. All rights reserved.
//

#import "CGBaseSearchBar.h"
#import <PooTools/PMacros.h>
#import "CGBaseGobalTools.h"
#import "CGBaseMarcos.h"

@implementation CGBaseSearchBar

-(instancetype)initWithSearchBarPlaceholder:(NSString *)placeholder
{
    self = [super init];
    if (self)
    {
            if (@available(iOS 13.0, *))
            {
                self.searchTextField.backgroundColor = [CGBaseGobalTools AppCellBGColor];
                self.searchTextField.clearButtonMode = UITextFieldViewModeNever;
                self.searchTextField.textColor = [CGBaseGobalTools AppColor];
                [self.searchTextField setTintColor:[CGBaseGobalTools AppColor]];
                self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName: AppFontNormal,NSForegroundColorAttributeName:[CGBaseGobalTools AppGray]}];
                self.searchBarOutViewColor = kClearColor;
                self.backgroundImage = [Utils createImageWithColor:[CGBaseGobalTools AppCellBGColor]];
                [self setImage:kImageNamed(@"image_main_search") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
                kViewBorderRadius(self.searchTextField, 15, 1, [CGBaseGobalTools AppGray]);
            }
            else
            {
                self.searchBarOutViewColor = [CGBaseGobalTools AppCellBGColor];
                self.searchPlaceholderColor = [CGBaseGobalTools AppGray];
                self.searchPlaceholder = placeholder;
                self.searchPlaceholderFont = AppFontNormal;
                self.searchTextColor = [CGBaseGobalTools AppColor];
                self.searchBarImage = kImageNamed(@"image_main_search");
                self.searchTextFieldBackgroundColor = [CGBaseGobalTools AppCellBGColor];
                self.searchBarTextFieldCornerRadius = 15;
                self.cursorColor = [CGBaseGobalTools AppColor];
                self.searchBarTextFieldBorderColor = [CGBaseGobalTools AppGray];
            }

    }
    return self;
}

@end
