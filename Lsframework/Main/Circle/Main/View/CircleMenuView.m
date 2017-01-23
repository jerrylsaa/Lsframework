//
//  CircleMenuView.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CircleMenuView.h"

@interface CircleMenuView (){
    UIImageView* menuImageView;
    UILabel* menuTitleLabel;
}

@end

@implementation CircleMenuView


-(instancetype)init{
    self= [super init];
    if(self){
        menuImageView = [UIImageView new];
        menuImageView.userInteractionEnabled = YES;
        
        menuTitleLabel = [UILabel new];
        menuTitleLabel.textAlignment = NSTextAlignmentCenter;
        menuTitleLabel.font = [UIFont systemFontOfSize:13];
        
        
        [self sd_addSubviews:@[menuImageView,menuTitleLabel]];
        
        menuImageView.sd_layout.topSpaceToView(self,0).leftSpaceToView(self,15/2.0).rightSpaceToView(self,15/2.0).widthIs(80/2.0).heightEqualToWidth();
        
        menuTitleLabel.sd_layout.topSpaceToView(menuImageView,20/2.0).leftSpaceToView(self,0).rightSpaceToView(self,0).heightIs(28/2.0);
        
        
        
//        self.backgroundColor = [UIColor redColor];
//        menuImageView.backgroundColor = [UIColor blueColor];
//        menuTitleLabel.backgroundColor = [UIColor greenColor];
        
    }
    return self;
}

-(void)setMenuImage:(NSString *)menuImage{
    _menuImage = menuImage;
    menuImageView.image = [UIImage imageNamed:menuImage];
//    menuImageView.backgroundColor = [UIColor blueColor];
}
-(void)setMenuTitle:(NSString *)menuTitle{
    _menuTitle = menuTitle;
    menuTitleLabel.text = menuTitle;
}
-(void)setMenuTitleColor:(UIColor *)menuTitleColor{
    _menuTitleColor = menuTitleColor;
    menuTitleLabel.textColor = menuTitleColor;
}





@end
