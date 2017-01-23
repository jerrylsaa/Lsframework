//
//  MineTableViewCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/10.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MineTableViewCell.h"

#define kCornerRadius 10

@interface MineTableViewCell (){
    
    UIView* container;
    UIView* topView;
    UIView* bottomView;
    UIView* bottomLine;
    UIImageView* icon;
    UILabel* menuTitle;
    UIView* line;
    UIImageView* indactor;//指示箭头
    
}

@end

@implementation MineTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.backgroundColor = [UIColor clearColor];
        
        topView = [UIView new];
        topView.backgroundColor = UIColorFromRGB(0xffffff);
        [self.contentView addSubview:topView];

        
        container = [UIView new];
        container.backgroundColor = UIColorFromRGB(0xffffff);
        [self.contentView addSubview:container];
        
        bottomView = [UIView new];
        bottomView.backgroundColor = UIColorFromRGB(0xffffff);
        [self.contentView addSubview:bottomView];
//        bottomView.backgroundColor = [UIColor redColor];
        bottomLine = [UIView new];
        bottomLine.backgroundColor = UIColorFromRGB(0xebebeb);
        [bottomView addSubview:bottomLine];

        
        
        icon = [UIImageView new];
        icon.userInteractionEnabled = YES;
        [container addSubview:icon];
        
        menuTitle = [UILabel new];
        menuTitle.font = [UIFont systemFontOfSize:bigFont];
        menuTitle.textColor = UIColorFromRGB(0x666666);
        [container addSubview:menuTitle];
        
        indactor = [UIImageView new];
        indactor.userInteractionEnabled = YES;
        indactor.image = [UIImage imageNamed:@"go_icon"];
        [container addSubview:indactor];
        
        line = [UIView new];
        line.backgroundColor = UIColorFromRGB(0xebebeb);
        [container addSubview:line];
        
        //添加约束
        topView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15).heightIs(10);
        
        container.sd_layout.topSpaceToView(topView,-10).leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15);
        container.sd_cornerRadius = @(kCornerRadius);
        
        icon.sd_layout.topSpaceToView(container,12).leftSpaceToView(container,31/2.0).widthIs(22).heightIs(23);
        
        menuTitle.sd_layout.centerYEqualToView(icon).leftSpaceToView(icon,18).autoHeightRatio(0);
        [menuTitle setSingleLineAutoResizeWithMaxWidth:250];
        
        indactor.sd_layout.topSpaceToView(container,16).rightSpaceToView(container,15).widthIs(22).heightIs(23);
        
        line.sd_layout.topSpaceToView(icon,15).heightIs(0.8).leftSpaceToView(icon,16).rightSpaceToView(container,15);
        [container setupAutoHeightWithBottomView:line bottomMargin:0];
        
        bottomView.sd_layout.topSpaceToView(container,-10).heightIs(10).leftEqualToView(container).rightEqualToView(container);
        bottomLine.sd_layout.bottomSpaceToView(bottomView,0).heightIs(0.8).leftSpaceToView(bottomView,31/2.0+22+15).rightSpaceToView(bottomView,15);

        
        [self setupAutoHeightWithBottomViewsArray:@[container,bottomView] bottomMargin:0];
        
    }
    return self;
}





-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    
    icon.image = [UIImage imageNamed:[dic objectForKey:@"icon"]];
    
    menuTitle.text = [dic objectForKey:@"title"];
    
    [menuTitle updateLayout];
    
}

-(void)setSectionDataSource:(NSArray *)sectionDataSource{
    _sectionDataSource = sectionDataSource;
    
    topView.hidden = self.row == 0;
    
    
    line.hidden = self.row == (sectionDataSource.count - 1);
    
    bottomView.hidden = self.row == (sectionDataSource.count - 1);
    
    
    
}



@end
