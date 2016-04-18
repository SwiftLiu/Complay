//
//  BasicButton.m
//  FineExCRM
//
//  Created by FineexMac on 16/3/16.
//  Copyright © 2016年 FineEx_iOS. All rights reserved.
//

#import "BasicButton.h"
#import "CommonConstants.h"

@implementation BasicButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initialize];
}

//初始化属性
- (void)initialize
{
    [self setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:(UIControlStateNormal)];
    [self setBackgroundImage:[UIImage imageNamed:@"login_btn_pre"] forState:(UIControlStateHighlighted)];
    
    [self setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

@end
