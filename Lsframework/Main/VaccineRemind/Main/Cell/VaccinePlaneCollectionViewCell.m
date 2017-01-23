//
//  VaccinePlaneCollectionViewCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "VaccinePlaneCollectionViewCell.h"

@implementation VaccinePlaneCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        
        //选中背景色
        UIView* selectBackgroundView = [UIView new];
        selectBackgroundView.backgroundColor = UIColorFromRGB(0xa9e5e2);
        self.selectedBackgroundView = selectBackgroundView;
        
//        self.backgroundColor = [UIColor redColor];
        
        UIView* container = [UIView new];
        [self.contentView addSubview:container];
        
        
        UILabel* month = [UILabel new];
        month.textColor = UIColorFromRGB(0xcccccc);
        month.font = [UIFont systemFontOfSize:sbigFont];
        month.textAlignment = NSTextAlignmentCenter;
        [container addSubview:month];
        self.vaccineMonth = month;
        
        UIImageView* line = [UIImageView new];
        line.backgroundColor = UIColorFromRGB(0xcccccc);
        [container addSubview:line];
        
        container.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
        
        month.sd_layout.leftSpaceToView(container,0).topSpaceToView(container,22).rightSpaceToView(container,1).heightIs(18);
        
        line.sd_layout.topEqualToView(month).rightSpaceToView(container,0).widthIs(1).heightRatioToView(month,1);
        
        [container setupAutoHeightWithBottomViewsArray:@[month,line] bottomMargin:23];
        
    }
    return self ;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if(selected){
//        WSLog(@"sel");
        self.vaccineMonth.textColor = UIColorFromRGB(0xffffff);
    }else{
//        WSLog(@"nor");
        self.vaccineMonth.textColor = UIColorFromRGB(0xcccccc);

    }
}




@end
