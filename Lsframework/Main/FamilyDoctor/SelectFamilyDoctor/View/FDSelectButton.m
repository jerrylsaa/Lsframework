//
//  FDSelectButton.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FDSelectButton.h"

@implementation FDSelectButton

-(instancetype)init{
    self= [super init];
    if(self){
        [self setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        self.backgroundColor = UIColorFromRGB(0xffffff);

    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"ac_down"] forState:UIControlStateNormal];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(15, 0, 15, 35)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(20, kScreenWidth/2 - 35, 20, 0)];
}





@end
