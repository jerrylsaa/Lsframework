//
//  MineHeaderCollectionCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MineHeaderCollectionCell.h"
#import "ApiMacro.h"

@interface MineHeaderCollectionCell (){
    UIView* container;
    UIImageView* iconbgImageView;
    
    
    UILabel* nickNameLabel;
    UIImageView* sexImageView;
    UILabel* birthdayLabel;
}

@end

@implementation MineHeaderCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
//        self.backgroundColor = [UIColor redColor];
        
        container = [UIView new];
        [self.contentView addSubview:container];
        

        iconbgImageView = [UIImageView new];
        iconbgImageView.userInteractionEnabled = YES;
        iconbgImageView.image = [UIImage imageNamed:@"GB_MineICON"];
        [container addSubview:iconbgImageView];
        

        nickNameLabel = [UILabel new];
        nickNameLabel.textColor = UIColorFromRGB(0xffffff);
        nickNameLabel.font = [UIFont systemFontOfSize:bigFont];
        nickNameLabel.textAlignment = NSTextAlignmentCenter;
        [container addSubview:nickNameLabel];
        
        sexImageView = [UIImageView new];
        sexImageView.userInteractionEnabled = YES;
        [container addSubview:sexImageView];
        
        birthdayLabel = [UILabel new];
        birthdayLabel.textColor = UIColorFromRGB(0x999999);
        birthdayLabel.font = [UIFont systemFontOfSize:midFont];
        birthdayLabel.textAlignment = NSTextAlignmentCenter;
        [container addSubview:birthdayLabel];


        
        //添加约束
        container.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
        
        
        iconbgImageView.sd_layout.topSpaceToView(container,0).centerXEqualToView(container).widthIs(85).heightEqualToWidth();
        iconbgImageView.sd_cornerRadiusFromWidthRatio = @0.5;
        
        
        nickNameLabel.sd_layout.topSpaceToView(iconbgImageView,5).centerXEqualToView(iconbgImageView).heightIs(15);
//        [nickNameLabel setSingleLineAutoResizeWithMaxWidth:60];
        
        sexImageView.sd_layout.centerYEqualToView(nickNameLabel).leftSpaceToView(nickNameLabel,2).widthIs(15).heightEqualToWidth();
        
        birthdayLabel.sd_layout.topSpaceToView(nickNameLabel,10).leftEqualToView(iconbgImageView).rightEqualToView(iconbgImageView).heightIs(15);
        
        [container setupAutoHeightWithBottomView:birthdayLabel bottomMargin:0];
        
        
    }
    return self ;
}

-(void)setBaby:(BabayArchList *)baby{
    _baby = baby;

    [iconbgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,baby.childImg]] placeholderImage:[UIImage imageNamed:@"GB_MineICON"]];
    
    nickNameLabel.text = baby.childName;
    
  nickNameLabel.width = [JMFoundation  calLabelWidth:nickNameLabel];
    [nickNameLabel updateLayout];
    
    if([baby.sex isEqualToString:@"男"]){
        sexImageView.image = [UIImage imageNamed:@"nan"];
    }else{
        sexImageView.image = [UIImage imageNamed:@"nv"];
    }
    
    sexImageView.hidden = baby.sex.length == 0;
    
    
    birthdayLabel.text = [baby.nL trimming];


}



@end
