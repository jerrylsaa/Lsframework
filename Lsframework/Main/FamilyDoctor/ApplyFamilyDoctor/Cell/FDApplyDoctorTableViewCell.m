//
//  FDApplyDoctorTableViewCell.m
//  FamilyPlatForm
//
//  Created by tom on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FDApplyDoctorTableViewCell.h"

@interface FDApplyDoctorTableViewCell (){
    UIView* _containerView;
    UILabel* _label;
}

@end

@implementation FDApplyDoctorTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self setupView];
    }
    return self;
}

- (void)setupView{
    _containerView = [UIView new];
    [self.contentView addSubview:_containerView];
    
    _label = [UILabel new];
    _label.font = [UIFont systemFontOfSize:18];
    _label.textColor = RGB(81, 81, 81);
    [_containerView addSubview:_label];
    
    _label.sd_layout.topSpaceToView(_containerView,15).autoHeightRatio(0).leftSpaceToView(_containerView,20).rightSpaceToView(_containerView,20);
    _containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    [_containerView setupAutoHeightWithBottomView:_label bottomMargin:15];
    
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
    
}

-(void)setTitels:(NSString *)titels{
    _titels = titels ;
    
    _label.text = titels;
    [_label updateLayout];
}


@end
