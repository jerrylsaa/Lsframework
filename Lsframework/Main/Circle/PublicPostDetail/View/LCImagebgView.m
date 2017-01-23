//
//  LCImagebgView.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "LCImagebgView.h"

@implementation LCImagebgView

-(instancetype)init{
    self= [super init];
    if(self){
        
        
        
        UIImageView* showImageView = [UIImageView new];
        showImageView.userInteractionEnabled = YES;
        showImageView.layer.masksToBounds = YES;
        showImageView.layer.cornerRadius = 5;
        showImageView.layer.borderWidth = 0.5;
        showImageView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;

        
        UIButton* deletebt = [UIButton new];
        [deletebt setBackgroundImage:[UIImage imageNamed:@"circle_del_icon1"] forState:UIControlStateNormal];
//        deletebt.clipsToBounds = YES;
        
        UIButton* button = [UIButton new];
        [button addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self sd_addSubviews:@[showImageView,deletebt,button]];
        
        self.showImageView = showImageView;
        self.deleteButton = deletebt;
        

        showImageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        deletebt.sd_layout.topSpaceToView(self,-8).rightSpaceToView(self,-8).widthIs(16).heightEqualToWidth();
        button.sd_layout.topSpaceToView(self,-8).rightSpaceToView(self,-8).widthIs(35).heightEqualToWidth();

        
    }
    return self;
}

- (void)deleteAction{
//    NSLog(@"删除－－－");
    if(self.delegate && [self.delegate respondsToSelector:@selector(deleteImageViewWith:)]){
        [self.delegate deleteImageViewWith:self];
    }
}



@end
