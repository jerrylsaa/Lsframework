//
//  GBDailyRemindCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GBDailyRemindCell.h"

@interface GBDailyRemindCell (){

    UIView* container;
    UIImageView* daybgImageView;
    UILabel* dayTitleLabel;
    UILabel* remindContentLabel;
}

@end

@implementation GBDailyRemindCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        container = [UIView new];
        [self.contentView addSubview:container];
        //GB_gw_tx
        
        daybgImageView = [UIImageView new];
        daybgImageView.userInteractionEnabled = YES;
        daybgImageView.image = [UIImage imageNamed:@"GB_gw_tx"];
        [container addSubview:daybgImageView];
        
        dayTitleLabel = [UILabel new];
        dayTitleLabel.textColor = UIColorFromRGB(0xffffff);
        dayTitleLabel.font = [UIFont systemFontOfSize:midFont];
        dayTitleLabel.textAlignment = NSTextAlignmentRight;
        [daybgImageView addSubview:dayTitleLabel];
        
        remindContentLabel = [UILabel new];
        remindContentLabel.textColor = RGB(51, 51, 51);
        remindContentLabel.font = [UIFont systemFontOfSize:bigFont];
        [container addSubview:remindContentLabel];

        UIView* bottomView = [UIView new];
        bottomView.backgroundColor = RGB(242, 242, 242);
        [container addSubview:bottomView];
        
        
        //添加约束
        container.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
        daybgImageView.sd_layout.topSpaceToView(container,25).leftSpaceToView(container,0).widthIs(85).minHeightIs(40);
        dayTitleLabel.sd_layout.topSpaceToView(daybgImageView,7).leftSpaceToView(daybgImageView,5).rightSpaceToView(daybgImageView,5).autoHeightRatio(0);
        [daybgImageView setupAutoHeightWithBottomView:dayTitleLabel bottomMargin:7];
        
        remindContentLabel.sd_layout.topSpaceToView(container,20).leftSpaceToView(daybgImageView,15).rightSpaceToView(container,15).autoHeightRatio(0);
        
        [container setupAutoHeightWithBottomViewsArray:@[daybgImageView,remindContentLabel] bottomMargin:25];
        
        bottomView.sd_layout.bottomSpaceToView(container,0).heightIs(5).leftSpaceToView(container,0).rightSpaceToView(container,0);

        
        
        [self setupAutoHeightWithBottomView:container bottomMargin:0];
        
    }
    return self;
}

-(void)setDailyRemind:(DailyRemindEntity *)dailyRemind{
    _dailyRemind = dailyRemind;
    
    dayTitleLabel.text = dailyRemind.remindDate;
    
    remindContentLabel.text = dailyRemind.remindContent;
    
    if(self.isCurrentDailRemind){
        remindContentLabel.textColor = RGB(51, 51, 51);
        daybgImageView.image = [UIImage imageNamed:@"GB_jr_tx"];
    }else {
        remindContentLabel.textColor = RGB(153, 153, 153);
        daybgImageView.image = [UIImage imageNamed:@"GB_gw_tx"];
    }
}







@end
