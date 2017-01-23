//
//  CommentHeaderCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CommentHeaderCell.h"
#import "HotDetailPresenter.h"

@interface CommentHeaderCell (){
    UIView* container;
    
    UIImageView* babyImageView;
    UILabel* babyNickName;
    
    UILabel* postTitle;
    UILabel* consultation;
    
    UIView* photoWallBgView;
    UIImageView* photo1;
    UIImageView* photo2;
    UIImageView* photo3;
    
    UIView* bottomBgView;
    UILabel* timeLabel;
    UIView* grayBarView;
    UILabel* commentLabel;
    
}
@property (nonatomic, strong) HotDetailPresenter *presenter;
@property (nonatomic, strong) UILabel *praiseLabel;
@property (nonatomic, strong) UIButton *praiseButton;

@end

@implementation CommentHeaderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _presenter = [HotDetailPresenter new];
        [self setupView];
    }
    return self;
}

- (void)setupView{
    container = [UIView new];
    [self.contentView addSubview:container];
    
    //宝贝头像
    babyImageView = [UIImageView new];
//    babyImageView.userInteractionEnabled = YES;
    //baby昵称
    babyNickName = [UILabel new];
    babyNickName.textColor = UIColorFromRGB(0x333333);
    babyNickName.font = [UIFont systemFontOfSize:midFont];
    //帖子标题
    postTitle = [UILabel new];
    postTitle.textColor = UIColorFromRGB(0x333333);
    postTitle.font = [UIFont systemFontOfSize:bigFont];
    //咨询内容
    consultation = [UILabel new];
    consultation.textColor = UIColorFromRGB(0x666666);
    consultation.font = [UIFont systemFontOfSize:sbigFont];
    consultation.isAttributedContent = YES;
    
    //照片墙
    photoWallBgView = [UIView new];
    photo1 = [UIImageView new];
    photo1.tag = 201;
//    photo1.userInteractionEnabled = YES;
    //    photo1.contentMode =UIViewContentModeScaleAspectFill;
    //    [photo1.layer setBorderWidth:2];
    //    [photo1.layer setBorderColor:RGB(80,199, 192).CGColor];
    //    photo1.clipsToBounds =YES;
    
    //    UITapGestureRecognizer* photo1Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhototAction:)];
    //    [photo1 addGestureRecognizer:photo1Tap];
    
    photo2 = [UIImageView new];
    photo2.tag = 202;
//    photo2.userInteractionEnabled = YES;
    //    photo2.contentMode =UIViewContentModeScaleAspectFill;
    //    [photo2.layer setBorderWidth:2];
    //    [photo2.layer setBorderColor:RGB(80,199, 192).CGColor];
    //    UITapGestureRecognizer* photo2Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhototAction:)];
    //    [photo2 addGestureRecognizer:photo2Tap];
    
    photo3 = [UIImageView new];
    photo3.tag = 203;
    //    photo3.contentMode =UIViewContentModeScaleAspectFill;
    //    [photo3.layer setBorderWidth:2];
    //    [photo3.layer setBorderColor:RGB(80,199, 192).CGColor];
    //    photo3.userInteractionEnabled = YES;
    //    UITapGestureRecognizer* photo3Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhototAction:)];
    //    [photo3 addGestureRecognizer:photo3Tap];
    
    [photoWallBgView sd_addSubviews:@[photo1,photo2,photo3]];
    //    photoWallBgView.backgroundColor = [UIColor redColor];
    
    
    //底部
    bottomBgView = [UIView new];
    //时间
    timeLabel = [UILabel new];
    timeLabel.textColor = UIColorFromRGB(0x999999);
    timeLabel.font = [UIFont systemFontOfSize:11];
    
    //赞
    _praiseLabel = [UILabel new];
    _praiseLabel.font = timeLabel.font;
    _praiseLabel.userInteractionEnabled = YES;
    _praiseLabel.textColor = timeLabel.textColor;
    _praiseLabel.textAlignment = NSTextAlignmentCenter;
    _praiseLabel.text = [NSString stringWithFormat:@"%@",_circleEntity.praiseCount];
    _praiseButton = [UIButton new];
    [_praiseButton addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *praiseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(praiseTapAction)];
    [_praiseLabel addGestureRecognizer:praiseTap];
    
    //底部灰色条
    grayBarView = [UIView new];
    grayBarView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    //评论
    commentLabel = [UILabel new];
    commentLabel.textColor = timeLabel.textColor;
    commentLabel.font = [UIFont systemFontOfSize:midFont];
    
    
    [bottomBgView sd_addSubviews:@[timeLabel,_praiseLabel,_praiseButton,grayBarView,commentLabel]];
    [container sd_addSubviews:@[babyImageView,babyNickName,postTitle,consultation,photoWallBgView,bottomBgView]];
    
    
    //添加约束
    container.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    babyImageView.sd_layout.topSpaceToView(container,15).leftSpaceToView(container,15).widthIs(40).heightEqualToWidth();
    babyImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    
    babyNickName.sd_layout.leftSpaceToView(babyImageView,15).topSpaceToView(container,20).heightIs(14);
    [babyNickName setSingleLineAutoResizeWithMaxWidth:250];
    
    postTitle.sd_layout.topSpaceToView(babyImageView,15).leftEqualToView(babyImageView).rightSpaceToView(container,15).autoHeightRatio(0);
    
    consultation.sd_layout.topSpaceToView(postTitle,10).leftEqualToView(babyImageView).rightSpaceToView(container,15).autoHeightRatio(0);
    
    //文字咨询
    photoWallBgView.sd_layout.topSpaceToView(consultation,10).leftSpaceToView(container,10).rightSpaceToView(container,10);
    photo1.sd_layout.topSpaceToView(photoWallBgView,0).leftSpaceToView(photoWallBgView,0).rightSpaceToView(photoWallBgView,0).heightIs(490/2.0);
    photo2.sd_layout.topSpaceToView(photo1,10).leftEqualToView(photo1).rightEqualToView(photo1).heightRatioToView(photo1,1);
    photo3.sd_layout.topSpaceToView(photo2,10).leftEqualToView(photo1).rightEqualToView(photo1).heightRatioToView(photo1,1);
    [photoWallBgView setupAutoHeightWithBottomView:photo3 bottomMargin:0];

    
    bottomBgView.sd_layout.topSpaceToView(photoWallBgView,15).leftSpaceToView(container,0).rightSpaceToView(container,0);
    //创建时间
    timeLabel.sd_layout.topSpaceToView(bottomBgView,0).leftSpaceToView(bottomBgView,15).heightIs(10).widthIs(10);
//    [timeLabel setSingleLineAutoResizeWithMaxWidth:250];
    //赞
    _praiseLabel.sd_layout.rightSpaceToView(bottomBgView,0).centerYEqualToView(timeLabel).heightRatioToView(timeLabel,1).widthIs(40);
    _praiseButton.sd_layout.rightSpaceToView(_praiseLabel,0).centerYEqualToView(timeLabel).heightIs(18).widthIs(18);
    
    //灰色条
    grayBarView.sd_layout.topSpaceToView(timeLabel,15).leftSpaceToView(bottomBgView,0).rightSpaceToView(bottomBgView,0).heightIs(5);
    
    //评论
    commentLabel.sd_layout.leftEqualToView(timeLabel).heightIs(20).topSpaceToView(grayBarView,10);
    [commentLabel setSingleLineAutoResizeWithMaxWidth:250];
    
    [bottomBgView setupAutoHeightWithBottomView:commentLabel bottomMargin:15];
    
    [container setupAutoHeightWithBottomView:bottomBgView bottomMargin:0];
    
    [self setupAutoHeightWithBottomView:container bottomMargin:0];
    
}

-(void)setCircleEntity:(CircleEntity *)circleEntity{
    _circleEntity = circleEntity;
    
    //baby头像
    [babyImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,circleEntity.childImg]] placeholderImage:[UIImage imageNamed:@"circle_default_baby"]];
    
    //baby昵称
    babyNickName.text = circleEntity.nickName;
    //帖子标题
    postTitle.attributedText = [UILabel getAttributeTextWithString:circleEntity.title];
    //咨询内容
    consultation.attributedText = [UILabel getAttributeTextWithString:circleEntity.consultationContent];
    [consultation updateLayout];
    
    //照片墙
    [photo1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,circleEntity.image1]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photo2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,circleEntity.image2]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photo3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,circleEntity.image3]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photoWallBgView updateLayout];
    
    photo1.hidden = !(self.circleEntity.image1 && self.circleEntity.image1.length > 10);
    photo2.hidden = !(self.circleEntity.image2 && self.circleEntity.image2.length > 10);
    photo3.hidden = !(self.circleEntity.image3 && self.circleEntity.image3.length > 10);
    
    [photo1 sd_resetLayout];
    [photo2 sd_resetLayout];
    [photo3 sd_resetLayout];
    if(!photo1.hidden && photo2.hidden && photo3.hidden){
        //只有图片1
        photo1.sd_layout.topSpaceToView(photoWallBgView,0).leftSpaceToView(photoWallBgView,0).rightSpaceToView(photoWallBgView,0).heightIs(490/2.0);
        [photoWallBgView setupAutoHeightWithBottomView:photo1 bottomMargin:0];
    }else if (!photo1.hidden && !photo2.hidden && photo3.hidden){
        photo1.sd_layout.topSpaceToView(photoWallBgView,0).leftSpaceToView(photoWallBgView,0).rightSpaceToView(photoWallBgView,0).heightIs(490/2.0);
        photo2.sd_layout.topSpaceToView(photo1,10).leftEqualToView(photo1).rightEqualToView(photo1).heightRatioToView(photo1,1);
        [photoWallBgView setupAutoHeightWithBottomView:photo2 bottomMargin:0];
    }else if(!photo1.hidden && !photo2.hidden && !photo3.hidden){
        photo1.sd_layout.topSpaceToView(photoWallBgView,0).leftSpaceToView(photoWallBgView,0).rightSpaceToView(photoWallBgView,0).heightIs(490/2.0);
        photo2.sd_layout.topSpaceToView(photo1,10).leftEqualToView(photo1).rightEqualToView(photo1).heightRatioToView(photo1,1);
        photo3.sd_layout.topSpaceToView(photo2,10).leftEqualToView(photo1).rightEqualToView(photo1).heightRatioToView(photo1,1);
        [photoWallBgView setupAutoHeightWithBottomView:photo3 bottomMargin:0];
    }else{
        photoWallBgView.sd_layout.heightIs(0);
    }

    
    
    //创建时间
//    timeLabel.text = [NSDate getDateCompare:[circleEntity.createTime format2String:@"yyyy-MM-dd HH:mm:ss"]];
    timeLabel.text = circleEntity.createTime;
    timeLabel.width = kJMWidth(timeLabel);
    [timeLabel  updateLayout];
    
    //赞
    if ([_circleEntity.isPraise integerValue] == 1) {
        [_praiseButton setBackgroundImage:[UIImage imageNamed:@"Heart_red_icon"] forState:UIControlStateNormal];
    }else{
        [_praiseButton setBackgroundImage:[UIImage imageNamed:@"Heart_icon"] forState:UIControlStateNormal];
    }
    //评论
    commentLabel.text = (circleEntity.commentCount)? [NSString stringWithFormat:@"评论 %@",circleEntity.commentCount]: @"0";
    _praiseLabel.text = (circleEntity.praiseCount)? [NSString stringWithFormat:@"%@",circleEntity.praiseCount]: @"0";
    [commentLabel updateLayout];
    
}

- (void)praiseAction:(UIButton *)button{
    WS(ws);
    _praiseButton.userInteractionEnabled = NO;
    _presenter.praiseType = 2;
    if ([_circleEntity.isPraise integerValue] == 1) {
        //取消点赞
        NSString *consulationID = [NSString stringWithFormat:@"%@",_circleEntity.uuid] ;
        [_presenter cancelPraise:consulationID success:^(BOOL success, NSString *message) {
            ws.praiseButton.userInteractionEnabled = YES;
            if (success == YES) {
                [ProgressUtil showSuccess:@"取消点赞成功"];
                ws.circleEntity.isPraise = [NSNumber numberWithInteger:0];
                ws.circleEntity.praiseCount = [NSNumber numberWithInteger:[ws.circleEntity.praiseCount integerValue]-1];
                [ws postCircleSingleRefreshNotification];
                ws.praiseLabel.text = [NSString stringWithFormat:@"%@",ws.circleEntity.praiseCount];
                [ws.praiseButton setBackgroundImage:[UIImage imageNamed:@"Heart_icon"] forState:UIControlStateNormal];
            }else{
                [ProgressUtil showError:@"取消点赞失败"];
            }
        }];
    }else{
        //点赞
        NSString *consulationID = [NSString stringWithFormat:@"%@",_circleEntity.uuid] ;
        [_presenter praise:consulationID success:^(BOOL success, NSString *message) {
            ws.praiseButton.userInteractionEnabled = YES;
            if (success == YES) {
                [ProgressUtil showSuccess:@"点赞成功"];
                ws.circleEntity.isPraise = [NSNumber numberWithInteger:1];
                ws.circleEntity.praiseCount = [NSNumber numberWithInteger:[ws.circleEntity.praiseCount integerValue]+1];
                [ws postCircleSingleRefreshNotification];
                ws.praiseLabel.text = [NSString stringWithFormat:@"%@",ws.circleEntity.praiseCount];
                [ws.praiseButton setBackgroundImage:[UIImage imageNamed:@"Heart_red_icon"] forState:UIControlStateNormal];
            }else{
                [ProgressUtil showError:@"点赞失败"];
            }
        }];
    }
}
- (void)praiseTapAction{
    [self praiseAction:_praiseButton];
}
- (void)postCircleSingleRefreshNotification{

    [kdefaultCenter postNotificationName:Notification_RefreshCircleSingle object:@{self.selectNumber:self.circleEntity}];
}
@end
