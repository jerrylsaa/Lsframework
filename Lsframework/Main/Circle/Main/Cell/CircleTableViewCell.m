//
//  CircleTableViewCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CircleTableViewCell.h"
#import "ApiMacro.h"

@interface CircleTableViewCell (){
    
    UIView* containerView;
    
    UIImageView* babyImageView;
    UILabel* babyNickName;
    UILabel* expertPrice;
    
    UILabel* consultation;
    
    UIView* doctorInfoBgView;
    UIImageView* doctorImageView;
    UIButton* voicebt;
    UILabel* voiceTimeLabel;
    UILabel* doctorName;
    UILabel* doctorTitle;
    
    UILabel* timeLabel;
    UIImageView* commentImageView;
    UILabel* commentLabel;
    UILabel* hearLabel;
    UIImageView *praiseImageView;
    UILabel *praiseLabel;
    UIView   *praiseBgView;
    
    UILabel *wordContentLabel;
    
    UIView* grayBarView;
    
}

@end

@implementation CircleTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self setupView];
    }
    return self;
}

- (void)setupView{
    containerView = [UIView new];
    [self.contentView addSubview:containerView];
    //宝贝头像
    babyImageView = [UIImageView new];
    babyImageView.userInteractionEnabled = YES;
    [containerView addSubview:babyImageView];
    UITapGestureRecognizer* babyIconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBabyAction:)];
    [babyImageView addGestureRecognizer:babyIconTap];
    //baby昵称
    babyNickName = [UILabel new];
    babyNickName.textColor = UIColorFromRGB(0x333333);
    babyNickName.font = [UIFont systemFontOfSize:midFont];
    [containerView addSubview:babyNickName];
    //专家价格
    expertPrice = [UILabel new];
    expertPrice.textAlignment = NSTextAlignmentRight;
//    expertPrice.textColor = RGB(215, 23, 0);
    expertPrice.textColor = UIColorFromRGB(0x61d8d3);
    expertPrice.font = [UIFont systemFontOfSize:smidFont];
    expertPrice.textAlignment = NSTextAlignmentRight;
    [containerView addSubview:expertPrice];
    //咨询内容
    consultation = [UILabel new];
    consultation.textColor = UIColorFromRGB(0x666666);
    consultation.font = [UIFont systemFontOfSize:sbigFont];
    [containerView addSubview:consultation];
    
    //语音咨询
    doctorInfoBgView = [UIView new];
    [containerView addSubview:doctorInfoBgView];
        //医生头像
    doctorImageView = [UIImageView new];
    doctorImageView.userInteractionEnabled = YES;
    [doctorInfoBgView addSubview:doctorImageView];
    
    // 文字补充
    wordContentLabel = [UILabel new];
    wordContentLabel.backgroundColor = [UIColor clearColor];
    wordContentLabel.textColor = UIColorFromRGB(0x61d8d3);
    wordContentLabel.font = [UIFont systemFontOfSize:sbigFont];
    [doctorInfoBgView addSubview:wordContentLabel];

        //医生姓名
    doctorName = [UILabel new];
    doctorName.textColor = babyNickName.textColor;
    doctorName.font = babyNickName.font;
    [doctorInfoBgView addSubview:doctorName];
        //医生职称
    doctorTitle = [UILabel new];
    doctorTitle.textColor = UIColorFromRGB(0x999999);
    doctorTitle.font = [UIFont systemFontOfSize:smallFont];
    [doctorInfoBgView addSubview:doctorTitle];
    
    
    
        //语音按钮
    voicebt = [UIButton buttonWithType:UIButtonTypeCustom];
    voicebt.titleLabel.font = [UIFont boldSystemFontOfSize:smallFont];
    [voicebt addTarget:self action:@selector(clickAudiobt:) forControlEvents:UIControlEventTouchUpInside];
    [doctorInfoBgView addSubview:voicebt];
        //语音时间
    voiceTimeLabel = [UILabel new];
    voiceTimeLabel.textColor = UIColorFromRGB(0x999999);
    voiceTimeLabel.font = babyNickName.font;
    [doctorInfoBgView addSubview:voiceTimeLabel];
        //时间
    timeLabel = [UILabel new];
    timeLabel.textColor = UIColorFromRGB(0x999999);
    timeLabel.font = [UIFont systemFontOfSize:11];
    [containerView addSubview:timeLabel];
        //听过
    hearLabel = [UILabel new];
    hearLabel.textColor = timeLabel.textColor;
    hearLabel.font = timeLabel.font;
    [containerView addSubview:hearLabel];
        //评论
    commentLabel = [UILabel new];
    commentLabel.textColor = timeLabel.textColor;
    commentLabel.font = timeLabel.font;
    [containerView addSubview:commentLabel];
        //评论图片
    commentImageView = [UIImageView new];
    commentImageView.userInteractionEnabled = YES;
    commentImageView.image = [UIImage imageNamed:@"circle_pl_icon"];
    [containerView addSubview:commentImageView];
    
        //赞
    praiseLabel = [UILabel new];
    praiseLabel.textColor = timeLabel.textColor;
    praiseLabel.font = timeLabel.font;
    praiseLabel.userInteractionEnabled = YES;
    [containerView addSubview:praiseLabel];
    
    //点赞大图
    praiseBgView = [UIView new];
    [containerView  addSubview:praiseBgView];

        //赞图片
    praiseImageView = [UIImageView new];
    praiseImageView.userInteractionEnabled = YES;
    [praiseBgView addSubview:praiseImageView];
    
    //手势
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [praiseLabel addGestureRecognizer:tap1];
    [praiseImageView addGestureRecognizer:tap2];
    [praiseBgView addGestureRecognizer:tap3];
    
        //底部灰色条
    grayBarView = [UIView new];
    grayBarView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [containerView addSubview:grayBarView];
    


    
}



-(void)setCircleEntity:(CircleEntity *)circleEntity{
    _circleEntity = circleEntity;
    
    //baby头像
    [babyImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,circleEntity.childImg]] placeholderImage:[UIImage imageNamed:@"circle_default_baby"]];
    //baby昵称
    babyNickName.text = circleEntity.nickName;
    //专家价格
    expertPrice.text = [NSString stringWithFormat:@"¥%@",circleEntity.expertPrice];
    [expertPrice updateLayout];
    //咨询内容
    consultation.text = circleEntity.consultationContent;

    wordContentLabel.text = @"文字补充";
    //医生头像
    [doctorImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",circleEntity.doctorImageUrl]] placeholderImage:[UIImage imageNamed:@"HEADoctorIcon"]];
    
    //假数据
//    circleEntity.doctorName = @"赵东门";
//    circleEntity.title = @"儿童专家教授";
//    circleEntity.voiceTime = 30;
    //医生姓名
    doctorName.text = circleEntity.doctorName;
    //医生职称
    doctorTitle.text = circleEntity.title;
    //语音按钮
    if(circleEntity.isListen && [circleEntity.isListen intValue] == 1){
    //点击播放
        [voicebt setBackgroundImage:[UIImage imageNamed:@"HEAVoice"] forState:UIControlStateNormal];
        [voicebt setTitle:@"点击播放" forState:UIControlStateNormal];
        [voicebt setTitle:@"暂停播放" forState:UIControlStateSelected];
    }else if(circleEntity.isListen && [circleEntity.isListen intValue] == 0){
    //一元旁听
        [voicebt setBackgroundImage:[UIImage imageNamed:@"HEAVoice"] forState:UIControlStateNormal];
        [voicebt setTitle:@"一元旁听" forState:UIControlStateNormal];
    }
    if(circleEntity.isFree && [circleEntity.isFree intValue] == 1){
        [voicebt setBackgroundImage:[UIImage imageNamed:@"HEAVoice_Free"] forState:UIControlStateNormal];
        [voicebt setTitle:@"限时免费" forState:UIControlStateNormal];

    }
    if(!circleEntity.voiceUrl || circleEntity.voiceUrl.length == 0){
        [voicebt setBackgroundImage:[UIImage imageNamed:@"HEAVoice"] forState:UIControlStateNormal];
        [voicebt setTitle:@"未回答" forState:UIControlStateNormal];
    }
    
    //语音时间
    voiceTimeLabel.text = [NSString stringWithFormat:@"%ld\"",(long)circleEntity.voiceTime];
    
    //创建时间
//    timeLabel.text = [NSDate getDateCompare:[circleEntity.createTime format2String:@"yyyy-MM-dd HH:mm:ss"]];
    timeLabel.text = circleEntity.createTime;
    //听过
    hearLabel.text = (circleEntity.hearCount)? [NSString stringWithFormat:@"听过 %@",circleEntity.hearCount]: @"听过 0";
    [hearLabel updateLayout];
    //评论
    commentLabel.text = (circleEntity.commentCount)? [NSString stringWithFormat:@"%@",circleEntity.commentCount]: @"0";
    //赞
    praiseLabel.text = (circleEntity.praiseCount)? [NSString stringWithFormat:@"%@",circleEntity.praiseCount]: @"0";
//    NSLog(@"%@-%d",circleEntity.isPraise,[circleEntity.isPraise integerValue]);
    if ([circleEntity.isPraise integerValue] == 1) {
        praiseImageView.image = [UIImage imageNamed:@"Heart_red_icon"];
    }else{
        praiseImageView.image = [UIImage imageNamed:@"Heart_icon"];
    }
    
    
    
    
    
    //添加约束
    containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    babyImageView.sd_layout.topSpaceToView(containerView,10).leftSpaceToView(containerView,15).widthIs(40).heightEqualToWidth();
    babyImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    babyNickName.sd_layout.leftSpaceToView(babyImageView,15).topSpaceToView(containerView,20).heightIs(14);
    [babyNickName setSingleLineAutoResizeWithMaxWidth:250];
    expertPrice.sd_layout.centerYEqualToView(babyImageView).heightIs(14).rightSpaceToView(containerView,15);
    [expertPrice setSingleLineAutoResizeWithMaxWidth:250];
    consultation.sd_layout.topSpaceToView(babyImageView,15).leftEqualToView(babyImageView).rightSpaceToView(containerView,15).autoHeightRatio(0);
    
    //语音咨询
    doctorInfoBgView.sd_layout.topSpaceToView(consultation,15).leftEqualToView(babyImageView).rightEqualToView(expertPrice);
    doctorImageView.sd_layout.topSpaceToView(doctorInfoBgView,0).leftSpaceToView(doctorInfoBgView,0).widthIs(40).heightEqualToWidth();
    doctorImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    
    if (circleEntity.WordContent.length == 0 || circleEntity.WordContent == nil) {
        
        wordContentLabel.sd_layout.topSpaceToView(doctorImageView,8).widthIs(0).heightIs(0);
        
        doctorName.sd_layout.topSpaceToView(wordContentLabel,7).leftEqualToView(doctorImageView).heightRatioToView(babyNickName,1);
        [doctorName setSingleLineAutoResizeWithMaxWidth:250];
        
    }else{
        wordContentLabel.sd_layout.topSpaceToView(doctorImageView,8).leftSpaceToView(doctorImageView,14).widthIs(100).heightIs(15);
        
        doctorName.sd_layout.topSpaceToView(wordContentLabel,15).leftEqualToView(doctorImageView).heightRatioToView(babyNickName,1);
        [doctorName setSingleLineAutoResizeWithMaxWidth:250];
        
        
    }
    doctorTitle.sd_layout.centerYEqualToView(doctorName).leftSpaceToView(doctorName,20).heightRatioToView(doctorName,1).rightSpaceToView(doctorInfoBgView,0);
    voicebt.sd_layout.topSpaceToView(doctorInfoBgView,2).leftSpaceToView(doctorImageView,10).widthIs(262/2.0).heightIs(30);
    voiceTimeLabel.sd_layout.leftSpaceToView(voicebt,20).centerYEqualToView(voicebt).heightIs(14).rightSpaceToView(doctorInfoBgView,0);
    [doctorInfoBgView setupAutoHeightWithBottomViewsArray:@[doctorName,doctorTitle] bottomMargin:0];
    
    //创建时间
    timeLabel.sd_layout.topSpaceToView(doctorInfoBgView,20).leftEqualToView(babyImageView).heightIs(10);
    [timeLabel setSingleLineAutoResizeWithMaxWidth:250];
    //听过
//    hearLabel.sd_layout.centerYEqualToView(expertPrice).heightRatioToView(expertPrice,1).rightSpaceToView(expertPrice,15);
//    [hearLabel setSingleLineAutoResizeWithMaxWidth:250];
    hearLabel.sd_layout.centerYEqualToView(timeLabel).heightRatioToView(timeLabel,1).leftSpaceToView(timeLabel,15);
    [hearLabel setSingleLineAutoResizeWithMaxWidth:250];
    //评论
    commentLabel.sd_layout.centerYEqualToView(timeLabel).heightRatioToView(timeLabel,1).rightSpaceToView(containerView,15);
    [commentLabel setSingleLineAutoResizeWithMaxWidth:250];
    //评论图片
    commentImageView.sd_layout.centerYEqualToView(timeLabel).widthIs(16).heightEqualToWidth().rightSpaceToView(commentLabel,7);
    //点赞
    praiseLabel.sd_layout.centerYEqualToView(timeLabel).heightRatioToView(timeLabel,1).rightSpaceToView(commentImageView,15);
    [praiseLabel setSingleLineAutoResizeWithMaxWidth:250];
    praiseBgView.sd_layout.centerYEqualToView(timeLabel).widthIs(40).heightIs(16).rightSpaceToView(praiseLabel,7);
    //点赞图片
    praiseImageView.sd_layout.topEqualToView(praiseBgView).widthIs(16).heightEqualToWidth().rightSpaceToView(praiseBgView,0);
    //灰色条
    grayBarView.sd_layout.topSpaceToView(timeLabel,20).leftSpaceToView(containerView,0).rightSpaceToView(containerView,0).heightIs(5);
    
    [containerView setupAutoHeightWithBottomView:grayBarView bottomMargin:0];
    
    [self setupAutoHeightWithBottomView:containerView bottomMargin:0];



}
-(void)setVoicebtIsSelect:(int)voicebtIsSelect{
    _voicebtIsSelect = voicebtIsSelect;
    
    voicebt.selected = voicebtIsSelect != 0 ;
    
}

#pragma mark - 手势监听
- (void)clickBabyAction:(UITapGestureRecognizer*) tapGesture{
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickBabyIconWithCircleEntity:)]){
        [self.delegate clickBabyIconWithCircleEntity:self.circleEntity];
    }
}
- (void)tapAction{
    if ([self.circleEntity.isPraise integerValue] == 0) {
        if (self.delegate) {
            [self.delegate praiseAtIndexPath:self.sd_indexPath type:0];
        }
    }else{
        if (self.delegate) {
            [self.delegate cancelPraiseAtIndexPath:self.sd_indexPath type:0];
        }
    }
}

#pragma mark - 点击事件
- (void)clickAudiobt:(UIButton*) audiobt{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickAudioButton:circleEntity:currentCell:)]){
        [self.delegate clickAudioButton:audiobt circleEntity:self.circleEntity currentCell:self];
    }
}


@end
