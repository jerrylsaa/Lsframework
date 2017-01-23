//
//  HealthCaseBlueCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HealthCaseBlueCell.h"

@interface HealthCaseBlueCell (){
    UIImageView* _bgImageView;
    UILabel* _msgLabel;
    
    UILabel* _timeLabel;
    
    
    
}

@end


@implementation HealthCaseBlueCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}



- (void)setupSubviews{
    
    UIView* containerView = [UIView new];
    [self.contentView addSubview:containerView];
    
    _bgImageView = [UIImageView new];
    _bgImageView.image = [UIImage imageNamed:@"doctor_timeLine_blue"];
    [containerView addSubview:_bgImageView];
    
    _msgLabel = [UILabel new];
    _msgLabel.font = [UIFont systemFontOfSize:16];
    _msgLabel.textColor = UIColorFromRGB(0xffffff);
    [_bgImageView addSubview:_msgLabel];
    
    //圆圈
    UIView* cirle = [UIView new];
    cirle.backgroundColor = UIColorFromRGB(0x74CEED);
    [containerView addSubview:cirle];

    //竖线
    UIView* vLine = [UIView new];
    vLine.backgroundColor = UIColorFromRGB(0xdbdbdb);
//    [self.contentView addSubview:vLine];
    [containerView insertSubview:vLine belowSubview:cirle];

    //时间label
    _timeLabel = [UILabel new];
    _timeLabel.textColor = UIColorFromRGB(0x525252);
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [containerView addSubview:_timeLabel];
    
    //添加约束
    _msgLabel.sd_layout.topSpaceToView(_bgImageView,10).leftSpaceToView(_bgImageView,25).rightSpaceToView(_bgImageView,20).autoHeightRatio(0);
    
    _bgImageView.sd_layout.topSpaceToView(containerView,10).rightSpaceToView(containerView,5).widthIs(kScreenWidth/2.0-10);
    [_bgImageView setupAutoHeightWithBottomView:_msgLabel bottomMargin:10];
    
    containerView.sd_layout.topEqualToView(self.contentView).rightEqualToView(self.contentView).widthIs(kScreenWidth/2.0);
    [containerView setupAutoHeightWithBottomView:_bgImageView bottomMargin:10];
    
    cirle.sd_layout.centerYEqualToView(_bgImageView).heightIs(8).widthEqualToHeight().rightSpaceToView(_bgImageView,1);
    cirle.sd_cornerRadius = @4;

    vLine.sd_layout.centerYEqualToView(cirle).topEqualToView(containerView).bottomEqualToView(containerView).widthIs(2).centerXEqualToView(cirle);
    
    _timeLabel.sd_layout.centerYEqualToView(cirle).heightIs(10).rightSpaceToView(cirle,5).widthIs(kScreenWidth/2.0);
    
    //设置cell高度自适应
    [self setupAutoHeightWithBottomView:containerView bottomMargin:0];
}

-(void)setHealthCase:(FDHealthCaseEntity *)healthCase{
    _healthCase = healthCase;
    
    _msgLabel.text = healthCase.healthyName;
    
    _timeLabel.text = [healthCase.starDate format2String:@"yyyy/MM/dd"];
}





@end
