//
//  AudioPhotoTableViewCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "AudioPhotoTableViewCell.h"
#import "ApiMacro.h"

#define   kImageXspace     11
#define   kImageTopspace     7.5
#define   kImageWidth   (kScreenWidth-15*2-2*kImageXspace)/3



@interface AudioPhotoTableViewCell (){
    UIView* containerView;
    
    UIImageView* babyImageView;
    UILabel* babyNickName;
    UILabel* expertPrice;
    
    UILabel* consultation;
    
    UIView* photoWallBgView;
    UIImageView* photo1;
    UIImageView* photo2;
    UIImageView* photo3;
    
    
    UIImageView* photo4;
    UIImageView* photo5;
    UIImageView* photo6;


    
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
    UIView* grayBarView ;
    
    UILabel *wordContentLabel;

}

@end

@implementation AudioPhotoTableViewCell

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
    
    photoWallBgView = [UIView new];
    [containerView addSubview:photoWallBgView];
    
    photo1 = [UIImageView new];
    photo1.tag = 201;
    photo1.userInteractionEnabled = YES;
    photo1.contentMode =UIViewContentModeScaleAspectFill;
    [photo1.layer setBorderWidth:1];
    [photo1.layer setBorderColor:RGB(80,199, 192).CGColor];
    photo1.clipsToBounds =YES;
    
    UITapGestureRecognizer* photo1Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhototAction:)];
    [photo1 addGestureRecognizer:photo1Tap];
    
    photo2 = [UIImageView new];
    photo2.tag = 202;
    photo2.userInteractionEnabled = YES;
    photo2.contentMode =UIViewContentModeScaleAspectFill;
    [photo2.layer setBorderWidth:1];
    [photo2.layer setBorderColor:RGB(80,199, 192).CGColor];
    UITapGestureRecognizer* photo2Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhototAction:)];
    [photo2 addGestureRecognizer:photo2Tap];
    
    photo3 = [UIImageView new];
    photo3.tag = 203;
    photo3.contentMode =UIViewContentModeScaleAspectFill;
    [photo3.layer setBorderWidth:1];
    [photo3.layer setBorderColor:RGB(80,199, 192).CGColor];
    photo3.userInteractionEnabled = YES;
    UITapGestureRecognizer* photo3Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhototAction:)];
    [photo3 addGestureRecognizer:photo3Tap];
    
    photo4 = [self imageWithTag:204];
    photo5 = [self imageWithTag:205];
    photo6 = [self imageWithTag:206];
    
    [photoWallBgView sd_addSubviews:@[photo1,photo2,photo3,photo4,photo5,photo6]];

    


    
    
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
    
    //照片墙
    [photo1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,circleEntity.image1]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photo2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,circleEntity.image2]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photo3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,circleEntity.image3]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    
    [photo4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,circleEntity.image4]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photo5 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,circleEntity.image5]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photo6 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,circleEntity.image6]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];

    
    
    photo1.hidden = !(self.circleEntity.image1 && self.circleEntity.image1.length > 4);
    photo2.hidden = !(self.circleEntity.image2 && self.circleEntity.image2.length > 4);
    photo3.hidden = !(self.circleEntity.image3 && self.circleEntity.image3.length > 4);
    
    photo4.hidden = !(self.circleEntity.image4 && self.circleEntity.image4.length > 4);
    photo5.hidden = !(self.circleEntity.image5 && self.circleEntity.image5.length > 4);
    photo6.hidden = !(self.circleEntity.image6 && self.circleEntity.image6.length > 4);
    
    
    //医生头像
    [doctorImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",circleEntity.doctorImageUrl]] placeholderImage:[UIImage imageNamed:@"HEADoctorIcon"]];
    
    //医生姓名
    doctorName.text = circleEntity.doctorName;
    //医生职称
    doctorTitle.text = circleEntity.title;
    //文字补充
     wordContentLabel.text = @"文字补充";
    
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
    
    //听过
//    hearLabel.sd_layout.centerYEqualToView(expertPrice).heightRatioToView(expertPrice,1).rightSpaceToView(expertPrice,15);
//    [hearLabel setSingleLineAutoResizeWithMaxWidth:250];
    
    expertPrice.sd_layout.centerYEqualToView(babyImageView).heightIs(14).rightSpaceToView(containerView,15);
    [expertPrice setSingleLineAutoResizeWithMaxWidth:250];
    
    consultation.sd_layout.topSpaceToView(babyImageView,15).leftEqualToView(babyImageView).rightSpaceToView(containerView,15).autoHeightRatio(0);
    
    //文字咨询
    
    if(photo1.hidden && photo2.hidden && photo3.hidden && photo4.hidden && photo5.hidden && photo6.hidden){
        
        photoWallBgView.sd_layout.topSpaceToView(consultation,10).leftEqualToView(babyImageView).widthIs(0).heightIs(0);
        
    }else if (photo4.hidden == YES) {
        
        photoWallBgView.sd_layout.topSpaceToView(consultation,10).leftEqualToView(babyImageView).widthIs(kScreenWidth-30).heightIs(kImageWidth);
        
        photo1.sd_layout.topSpaceToView(photoWallBgView,0).leftSpaceToView(photoWallBgView,0).widthIs(kImageWidth).heightEqualToWidth();
        photo1.sd_cornerRadius = @5;
        photo2.sd_layout.topEqualToView(photo1).leftSpaceToView(photo1,kImageXspace).widthIs(kImageWidth).heightEqualToWidth();
        photo2.sd_cornerRadius = @5;
        photo3.sd_layout.topEqualToView(photo1).leftSpaceToView(photo2,kImageXspace).widthIs(kImageWidth).heightEqualToWidth();
        photo3.sd_cornerRadius = @5;
        
    }else{
        
        photoWallBgView.sd_layout.topSpaceToView(consultation,10).leftEqualToView(babyImageView).widthIs(kScreenWidth-30).heightIs(kImageWidth*2+kImageTopspace);
        
        photo1.sd_layout.topSpaceToView(photoWallBgView,0).leftSpaceToView(photoWallBgView,0).widthIs(kImageWidth).heightEqualToWidth();
        photo1.sd_cornerRadius = @5;
        photo2.sd_layout.topEqualToView(photo1).leftSpaceToView(photo1,kImageXspace).widthIs(kImageWidth).heightEqualToWidth();
        photo2.sd_cornerRadius = @5;
        photo3.sd_layout.topEqualToView(photo1).leftSpaceToView(photo2,kImageXspace).widthIs(kImageWidth).heightEqualToWidth();
        photo3.sd_cornerRadius = @5;
        
        photo4.sd_layout.topSpaceToView(photo1,kImageTopspace).leftEqualToView(photo1).widthRatioToView(photo1,1).heightEqualToWidth();
        photo4.sd_cornerRadius = @5;
        photo5.sd_layout.topEqualToView(photo4).leftEqualToView(photo2).widthRatioToView(photo2,1).heightEqualToWidth();
        photo5.sd_cornerRadius = @5;
        photo6.sd_layout.topEqualToView(photo4).leftEqualToView(photo3).widthRatioToView(photo3,1).heightEqualToWidth();
        photo6.sd_cornerRadius = @5;
    }
    
    
    
    if (photoWallBgView.height == 0) {
        
        
    doctorInfoBgView.sd_layout.topSpaceToView(consultation,15).leftEqualToView(babyImageView).rightEqualToView(expertPrice);
        
    }else if (photoWallBgView.height == kImageWidth){
        
        
    doctorInfoBgView.sd_layout.topSpaceToView(consultation,20+kImageWidth).leftEqualToView(babyImageView).rightEqualToView(expertPrice);
        
    }else{
        
        
    doctorInfoBgView.sd_layout.topSpaceToView(consultation,20+kImageWidth*2+kImageTopspace).leftEqualToView(babyImageView).rightEqualToView(expertPrice);
    }
    
    [doctorInfoBgView updateLayout];
    //语音咨询
    doctorImageView.sd_layout.topSpaceToView(doctorInfoBgView,0).leftSpaceToView(doctorInfoBgView,0).widthIs(40).heightEqualToWidth();
    doctorImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    voicebt.sd_layout.topSpaceToView(doctorInfoBgView,2).leftSpaceToView(doctorImageView,10).widthIs(262/2.0).heightIs(30);
    voiceTimeLabel.sd_layout.leftSpaceToView(voicebt,20).centerYEqualToView(voicebt).heightIs(14).rightSpaceToView(doctorInfoBgView,0);
    
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

    
    [doctorInfoBgView setupAutoHeightWithBottomViewsArray:@[doctorName,doctorTitle] bottomMargin:0];
    
    
    timeLabel.sd_layout.topSpaceToView(doctorInfoBgView,20).leftEqualToView(babyImageView).heightIs(10);
    [timeLabel setSingleLineAutoResizeWithMaxWidth:250];

    //听过
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
#pragma mark * 点击用户头像
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
#pragma mark * 点击照片墙
- (void)clickPhototAction:(UITapGestureRecognizer*) tapGesture{
    UIImageView* photo = (UIImageView*)tapGesture.view;
    //    NSLog(@"点击了照片---%ld",(long)photo.tag);
    
    NSMutableArray* tempPhoto = [NSMutableArray array];
    NSMutableArray* tempPhotoURL = [NSMutableArray array];
    if(self.circleEntity.image1 && self.circleEntity.image1.length > 4){
        [tempPhoto addObject:photo1];
        [tempPhotoURL addObject:[NSString stringWithFormat:@"%@%@",ICON_URL,self.circleEntity.image1]];
    }
    if(self.circleEntity.image2 && self.circleEntity.image2.length > 4){
        [tempPhoto addObject:photo2];
        [tempPhotoURL addObject:[NSString stringWithFormat:@"%@%@",ICON_URL,self.circleEntity.image2]];
    }
    if(self.circleEntity.image3 && self.circleEntity.image3.length > 4){
        [tempPhoto addObject:photo3];
        [tempPhotoURL addObject:[NSString stringWithFormat:@"%@%@",ICON_URL,self.circleEntity.image3]];
    }
    if(self.circleEntity.image4 && self.circleEntity.image4.length > 4){
        [tempPhoto addObject:photo4];
        [tempPhotoURL addObject:[NSString stringWithFormat:@"%@%@",ICON_URL,self.circleEntity.image4]];
    }

    if(self.circleEntity.image5 && self.circleEntity.image5.length > 4){
        [tempPhoto addObject:photo5];
        [tempPhotoURL addObject:[NSString stringWithFormat:@"%@%@",ICON_URL,self.circleEntity.image5]];
    }

    if(self.circleEntity.image6 && self.circleEntity.image6.length > 4){
        [tempPhoto addObject:photo6];
        [tempPhotoURL addObject:[NSString stringWithFormat:@"%@%@",ICON_URL,self.circleEntity.image6]];
    }

    
    
    NSArray* photoDataSource = tempPhoto;
    NSArray* photoURLDataSource = tempPhotoURL;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickPhotoWallWithCircleEntity:currentPhoto:photoDataSource:photoURLDataSource:)]){
        [self.delegate clickPhotoWallWithCircleEntity:self.circleEntity currentPhoto:photo photoDataSource:photoDataSource photoURLDataSource:photoURLDataSource];
    }
}
#pragma mark - 点击事件
- (void)clickAudiobt:(UIButton*) audiobt{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickAudioButton:circleEntity:currentCell:)]){
        [self.delegate clickAudioButton:audiobt circleEntity:self.circleEntity currentCell:self];
    }
}

-(UIImageView *)imageWithTag:(NSInteger )tag
{
    UIImageView *newImage = [UIImageView new];
    newImage.tag = tag;
    newImage.userInteractionEnabled = YES;
    newImage.contentMode =UIViewContentModeScaleAspectFill;
    [newImage.layer setBorderWidth:1];
    [newImage.layer setBorderColor:RGB(80,199, 192).CGColor];
    newImage.clipsToBounds =YES;
    
    UITapGestureRecognizer* newImagetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhototAction:)];
    [newImage addGestureRecognizer:newImagetap];
    
    return newImage;
}





@end
