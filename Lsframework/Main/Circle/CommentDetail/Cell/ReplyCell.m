//
//  ReplyCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ReplyCell.h"


@interface ReplyCell (){
    
    UIView* containerView;
    
    UIImageView* babyImageView;
    UILabel* babyNickName;
    UILabel* expertPrice;
    UILabel* floor;
    
    UILabel* postTitle;
    UILabel* consultation;
    
    UIView* photoWallBgView;
    UIImageView* photo1;
    UIImageView* photo2;
    UIImageView* photo3;
    
    UIImageView* timeImageView;
    UILabel* timeLabel;
    UIImageView* commentImageView;
    UILabel* commentLabel;
    UILabel* hearLabel;
    
    UILabel* replyLabel;
    
    UIButton *smallDeleteBtn;
    
}

@end

@implementation ReplyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;

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
//    UITapGestureRecognizer* babyIconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBabyAction:)];
//    [babyImageView addGestureRecognizer:babyIconTap];
    
    //baby昵称
    babyNickName = [UILabel new];
    babyNickName.textColor = UIColorFromRGB(0x333333);
    babyNickName.font = [UIFont systemFontOfSize:midFont];
    [containerView addSubview:babyNickName];
    //楼
    floor = [UILabel  new];
    floor.textColor = UIColorFromRGB(0x999999);
    floor.font = [UIFont  systemFontOfSize:smallFont];
    floor.textAlignment = NSTextAlignmentRight;
    [containerView   addSubview:floor];
    
    
    //专家价格
    //    expertPrice = [UILabel new];
    //    expertPrice.textAlignment = NSTextAlignmentRight;
    //    expertPrice.textColor = RGB(215, 23, 0);
    //    expertPrice.font = [UIFont systemFontOfSize:smidFont];
    //    expertPrice.textAlignment = NSTextAlignmentRight;
    //    [containerView addSubview:expertPrice];
    //帖子标题
    //    postTitle = [UILabel new];
    //    postTitle.textColor = UIColorFromRGB(0x333333);
    //    postTitle.font = [UIFont systemFontOfSize:bigFont];
    //    [containerView addSubview:postTitle];
    
    //咨询内容
    consultation = [UILabel new];
    consultation.textColor = UIColorFromRGB(0x666666);
    consultation.font = [UIFont systemFontOfSize:sbigFont];
    consultation.isAttributedContent = YES;
    [containerView addSubview:consultation];
    
    //文字咨询
    photoWallBgView = [UIView new];
    [containerView addSubview:photoWallBgView];
    
    photo1 = [UIImageView new];
    photo1.tag = 201;
    photo1.userInteractionEnabled = YES;
    photo1.contentMode =UIViewContentModeScaleAspectFill;
    [photo1.layer setBorderWidth:2];
    [photo1.layer setBorderColor:RGB(80,199, 192).CGColor];
    photo1.clipsToBounds =YES;
    
//    UITapGestureRecognizer* photo1Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhototAction:)];
//    [photo1 addGestureRecognizer:photo1Tap];
    
    photo2 = [UIImageView new];
    photo2.tag = 202;
    photo2.userInteractionEnabled = YES;
    photo2.contentMode =UIViewContentModeScaleAspectFill;
    [photo2.layer setBorderWidth:2];
    [photo2.layer setBorderColor:RGB(80,199, 192).CGColor];
//    UITapGestureRecognizer* photo2Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhototAction:)];
//    [photo2 addGestureRecognizer:photo2Tap];
    
    photo3 = [UIImageView new];
    photo3.tag = 203;
    photo3.contentMode =UIViewContentModeScaleAspectFill;
    [photo3.layer setBorderWidth:2];
    [photo3.layer setBorderColor:RGB(80,199, 192).CGColor];
    photo3.userInteractionEnabled = YES;
//    UITapGestureRecognizer* photo3Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhototAction:)];
//    [photo3 addGestureRecognizer:photo3Tap];
    
    [photoWallBgView sd_addSubviews:@[photo1,photo2,photo3]];
    
    //时间图标
    timeImageView = [UIImageView  new];
    timeImageView.userInteractionEnabled = YES;
    timeImageView.image = [UIImage imageNamed:@"DailyPrise_TimeImage"];
    timeImageView.backgroundColor = [UIColor  clearColor];
    [containerView  addSubview:timeImageView];
    
    //时间
    timeLabel = [UILabel new];
    timeLabel.textColor = UIColorFromRGB(0x999999);
    timeLabel.font = [UIFont systemFontOfSize:11];
    timeLabel.backgroundColor = [UIColor clearColor];
    [containerView addSubview:timeLabel];
    
    _deleteBtn = [UIButton new];
    [_deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:_deleteBtn];
    
    smallDeleteBtn = [UIButton new];
    [smallDeleteBtn setImage:[UIImage imageNamed:@"Trash"] forState:UIControlStateNormal];
    [smallDeleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:smallDeleteBtn];
    
    //评论
//    commentLabel = [UILabel new];
//    commentLabel.textColor = timeLabel.textColor;
//    commentLabel.font = timeLabel.font;
//    [containerView addSubview:commentLabel];
    //评论图片
//    commentImageView = [UIImageView new];
//    commentImageView.userInteractionEnabled = YES;
//    commentImageView.image = [UIImage imageNamed:@"circle_pl_icon"];
//    [containerView addSubview:commentImageView];
    //底部灰色条
    UIView* grayBarView = [UIView new];
    grayBarView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [containerView addSubview:grayBarView];
    
    
    //添加约束
    containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    babyImageView.sd_layout.topSpaceToView(containerView,15).leftSpaceToView(containerView,15).widthIs(40).heightEqualToWidth();
    babyImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    babyNickName.sd_layout.leftSpaceToView(babyImageView,15).topSpaceToView(containerView,20).heightIs(14);
    [babyNickName setSingleLineAutoResizeWithMaxWidth:250];
    floor.sd_layout.centerYEqualToView(babyImageView).heightIs(14).rightSpaceToView(containerView,15);
    [floor setSingleLineAutoResizeWithMaxWidth:250];
    
    //    postTitle.sd_layout.topSpaceToView(babyImageView,15).leftEqualToView(babyImageView).rightSpaceToView(containerView,15).autoHeightRatio(0);
    
    consultation.sd_layout.topSpaceToView(babyImageView,15).leftEqualToView(babyImageView).rightSpaceToView(containerView,15).autoHeightRatio(0);
    
    
    //文字咨询
    photoWallBgView.sd_layout.topSpaceToView(consultation,15).leftEqualToView(babyImageView).rightSpaceToView(containerView,15);
    photoWallBgView.sd_equalWidthSubviews = @[photo1,photo2,photo3];
    photo1.sd_layout.topSpaceToView(photoWallBgView,0).leftSpaceToView(photoWallBgView,0).heightEqualToWidth();
    photo1.sd_cornerRadius = @5;
    photo2.sd_layout.topEqualToView(photo1).leftSpaceToView(photo1,11).heightEqualToWidth();
    photo2.sd_cornerRadius = @5;
    photo3.sd_layout.topEqualToView(photo1).leftSpaceToView(photo2,11).rightSpaceToView(photoWallBgView,0).heightEqualToWidth();
    photo3.sd_cornerRadius = @5;
    [photoWallBgView setupAutoHeightWithBottomViewsArray:@[photo1,photo2,photo3] bottomMargin:0];
    
    //    [containerView setupAutoHeightWithBottomView:photoWallBgView bottomMargin:20];
    
    //创建时间
    timeImageView.sd_layout.topSpaceToView(photoWallBgView,20).leftEqualToView(babyImageView).widthIs(30/2).heightIs(30/2);
    timeLabel.sd_layout.centerYEqualToView(timeImageView).leftSpaceToView(timeImageView,5).heightIs(10).widthIs(10);
    smallDeleteBtn.sd_layout.centerYEqualToView(timeImageView).rightEqualToView(floor).widthIs(15).heightIs(15);
    _deleteBtn.sd_layout.centerYEqualToView(timeImageView).rightEqualToView(smallDeleteBtn).widthIs(50).heightIs(50);
//    [timeLabel setSingleLineAutoResizeWithMaxWidth:250];
    //评论
//    commentLabel.sd_layout.centerYEqualToView(timeLabel).heightRatioToView(timeLabel,1).rightSpaceToView(containerView,15);
//    [commentLabel setSingleLineAutoResizeWithMaxWidth:250];
    //评论图片
//    commentImageView.sd_layout.centerYEqualToView(timeLabel).widthIs(16).heightEqualToWidth().rightSpaceToView(commentLabel,7);
    //灰色条
    grayBarView.sd_layout.topSpaceToView(timeLabel,20).leftSpaceToView(containerView,0).rightSpaceToView(containerView,0).heightIs(1);
    
    [containerView setupAutoHeightWithBottomView:grayBarView bottomMargin:0];
    
    
    [self setupAutoHeightWithBottomView:containerView bottomMargin:0];
}


-(void)setReplyList:(ConsulationReplyList *)replyList{
    _replyList = replyList;
    
    //baby头像
    [babyImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,replyList.UserPic]] placeholderImage:[UIImage imageNamed:@"circle_default_baby"]];
    //baby昵称
    babyNickName.text = replyList.NickName;
    
    //楼
    floor.text = [NSString  stringWithFormat:@"%ld楼",replyList.RowID ];
    
    //咨询内容
    consultation.attributedText = [UILabel getAttributeTextWithString:replyList.CommentContent];
    
    //照片墙
    [photo1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,@""]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photo2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,@""]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photo3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,@""]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    photo1.hidden = YES;
    photo2.hidden = YES;
    photo3.hidden = YES;
    if(photo1.hidden && photo2.hidden && photo3.hidden){
        
        timeImageView.sd_layout.topSpaceToView(consultation,15).leftEqualToView(babyImageView).widthIs(30/2).heightIs(30/2);
        
    }else{
        timeImageView.sd_layout.topSpaceToView(photoWallBgView,20).leftEqualToView(babyImageView).widthIs(30/2).heightIs(30/2);
    }
    [timeImageView updateLayout];
    
    
    //创建时间
//    timeLabel.text = [NSDate getDateCompare:[replyList.replyTime format2String:@"yyyy-MM-dd HH:mm:ss"]];
    timeLabel.text = replyList.replyTime;
    //评论
//    commentLabel.text = (commentEntity.CommentContent)? [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:commentEntity.ReplyCount]]: @"0";
//    [commentLabel updateLayout];
    
    if ((replyList.UserID == kCurrentUser.userId)) {
        
    smallDeleteBtn.hidden = _deleteBtn.hidden = NO;
    
    }else
    {
       smallDeleteBtn.hidden= _deleteBtn.hidden = YES;
    }
    timeLabel.width = kJMWidth(timeLabel);
    [timeLabel  updateLayout];
}
-(void)deleteBtn:(UIButton *)button
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleButtonWithIndexPath:)]) {
        [self.delegate deleButtonWithIndexPath:self];
    }
}

@end
