//
//  CircleCommentCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CircleCommentCell.h"
#import "ApiMacro.h"

#define   kImageXspace     11
#define   kImageTopspace     7.5
#define   kImageWidth   (kScreenWidth-85-2*kImageXspace)/3

@interface CircleCommentCell (){

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
    
    UIImageView* leftPhoto1;
    UIImageView* midlePhoto2;
    UIImageView* rightpPoto3;
    
    UIImageView* timeImageView;
    UILabel* timeLabel;
    UIImageView* commentImageView;
    UILabel* hearLabel;
    
    UIView* replybgView;
    UIView* replyLine;
    UILabel* reply1Label;
    UILabel* reply2Label;

    UIView* grayBarView;
}


@end


@implementation CircleCommentCell

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
    consultation.font = [UIFont systemFontOfSize:bigFont];
    consultation.isAttributedContent = YES;
    consultation.backgroundColor = [UIColor clearColor];
    [containerView addSubview:consultation];
    
    //文字咨询
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
    
    leftPhoto1 = [self imageWithTag:204];
    midlePhoto2 = [self imageWithTag:205];
    rightpPoto3 = [self imageWithTag:206];
    
    [photoWallBgView sd_addSubviews:@[photo1,photo2,photo3,leftPhoto1,midlePhoto2,rightpPoto3]];
    
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
    [containerView addSubview:timeLabel];
    //评论
    _commentLabel = [UILabel new];
    _commentLabel.textColor = timeLabel.textColor;
    _commentLabel.font = timeLabel.font;
    [containerView addSubview:_commentLabel];
    //评论图片
    commentImageView = [UIImageView new];
    commentImageView.userInteractionEnabled = YES;
    commentImageView.image = [UIImage imageNamed:@"circle_pl_icon"];
    [containerView addSubview:commentImageView];
    
    //回复
    replybgView = [UIView new];
    [containerView addSubview:replybgView];
    replyLine = [UIView new];
    replyLine.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [replybgView addSubview:replyLine];
    reply1Label = [UILabel new];
    reply1Label.backgroundColor = [UIColor clearColor];
    reply1Label.font = [UIFont systemFontOfSize:sbigFont];
    reply1Label.textColor = UIColorFromRGB(0x666666);
    reply1Label.isAttributedContent = YES;
    [replybgView addSubview:reply1Label];
    reply2Label = [UILabel new];
    reply2Label.backgroundColor = [UIColor clearColor];
    reply2Label.textColor = UIColorFromRGB(0x666666);
    reply2Label.font = [UIFont systemFontOfSize:sbigFont];
    reply2Label.isAttributedContent = YES;
    [replybgView addSubview:reply2Label];
    
    //底部灰色条
    grayBarView = [UIView new];
    grayBarView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [containerView addSubview:grayBarView];
    
    
    
}

-(void)setCommentEntity:(ConsultationCommenList *)commentEntity{
    _commentEntity = commentEntity;
    
    //baby头像
    [babyImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,commentEntity.CHILD_IMG]] placeholderImage:[UIImage imageNamed:@"circle_default_baby"]];
    //baby昵称
    babyNickName.text = commentEntity.NickName;
    
    //楼
    floor.text = [NSString  stringWithFormat:@"%ld楼",(long)commentEntity.RowID];
    
    //咨询内容
    consultation.attributedText = [UILabel getAttributeTextWithString:commentEntity.CommentContent];
    
    //照片墙
    [photo1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,commentEntity.Image1]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photo2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,commentEntity.Image2]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photo3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,commentEntity.Image3]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [leftPhoto1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,commentEntity.Image4]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [midlePhoto2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,commentEntity.Image5]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [rightpPoto3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,commentEntity.Image6]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    photo1.hidden = !(commentEntity.Image1 && commentEntity.Image1.length > 10);
    photo2.hidden = !(commentEntity.Image2 && commentEntity.Image2.length > 10);
    photo3.hidden = !(commentEntity.Image3 && commentEntity.Image3.length > 10);
    leftPhoto1.hidden = !(self.commentEntity.Image4 && self.commentEntity.Image4.length > 10);
    midlePhoto2.hidden = !(self.commentEntity.Image5 && self.commentEntity.Image5.length > 10);
    rightpPoto3.hidden = !(self.commentEntity.Image6 && self.commentEntity.Image6.length > 10);
    
    
    
    
    
    
    //添加约束
    containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    babyImageView.sd_layout.topSpaceToView(containerView,15).leftSpaceToView(containerView,15).widthIs(40).heightEqualToWidth();
    babyImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    babyNickName.sd_layout.leftSpaceToView(babyImageView,15).topSpaceToView(containerView,20).heightIs(14);
    [babyNickName setSingleLineAutoResizeWithMaxWidth:250];
    floor.sd_layout.centerYEqualToView(babyImageView).heightIs(14).rightSpaceToView(containerView,15);
    [floor setSingleLineAutoResizeWithMaxWidth:250];
    //    postTitle.sd_layout.topSpaceToView(babyImageView,15).leftEqualToView(babyImageView).rightSpaceToView(containerView,15).autoHeightRatio(0);
    
    consultation.sd_layout.topSpaceToView(babyImageView,8).leftEqualToView(babyNickName).rightSpaceToView(containerView,15).autoHeightRatio(0);
    
    if(photo1.hidden && photo2.hidden && photo3.hidden && leftPhoto1.hidden && midlePhoto2.hidden && rightpPoto3.hidden){
        
        photoWallBgView.sd_layout.topSpaceToView(consultation,10).leftEqualToView(babyNickName).widthIs(0).heightIs(0);
        
    }else if (leftPhoto1.hidden == YES) {
        
        photoWallBgView.sd_layout.topSpaceToView(consultation,10).leftEqualToView(babyNickName).widthIs(kScreenWidth-30).heightIs(kImageWidth);
        
        photo1.sd_layout.topSpaceToView(photoWallBgView,0).leftSpaceToView(photoWallBgView,0).widthIs(kImageWidth).heightEqualToWidth();
        photo1.sd_cornerRadius = @5;
        photo2.sd_layout.topEqualToView(photo1).leftSpaceToView(photo1,kImageXspace).widthIs(kImageWidth).heightEqualToWidth();
        photo2.sd_cornerRadius = @5;
        photo3.sd_layout.topEqualToView(photo1).leftSpaceToView(photo2,kImageXspace).widthIs(kImageWidth).heightEqualToWidth();
        photo3.sd_cornerRadius = @5;
        
    }else{
        
        photoWallBgView.sd_layout.topSpaceToView(consultation,10).leftEqualToView(babyNickName).widthIs(kScreenWidth-30).heightIs(kImageWidth*2+kImageTopspace);
        
        photo1.sd_layout.topSpaceToView(photoWallBgView,0).leftSpaceToView(photoWallBgView,0).widthIs(kImageWidth).heightEqualToWidth();
        photo1.sd_cornerRadius = @5;
        photo2.sd_layout.topEqualToView(photo1).leftSpaceToView(photo1,kImageXspace).widthIs(kImageWidth).heightEqualToWidth();
        photo2.sd_cornerRadius = @5;
        photo3.sd_layout.topEqualToView(photo1).leftSpaceToView(photo2,kImageXspace).widthIs(kImageWidth).heightEqualToWidth();
        photo3.sd_cornerRadius = @5;
        
        leftPhoto1.sd_layout.topSpaceToView(photo1,kImageTopspace).leftEqualToView(photo1).widthRatioToView(photo1,1).heightEqualToWidth();
        leftPhoto1.sd_cornerRadius = @5;
        midlePhoto2.sd_layout.topEqualToView(leftPhoto1).leftEqualToView(photo2).widthRatioToView(photo2,1).heightEqualToWidth();
        midlePhoto2.sd_cornerRadius = @5;
        rightpPoto3.sd_layout.topEqualToView(leftPhoto1).leftEqualToView(photo3).widthRatioToView(photo3,1).heightEqualToWidth();
        rightpPoto3.sd_cornerRadius = @5;
    }

    if (photoWallBgView.height == 0) {
        
        timeImageView.sd_layout.topSpaceToView(consultation,20).leftEqualToView(babyNickName).widthIs(30/2).heightIs(30/2);
    }else if (photoWallBgView.height == kImageWidth){
        
        timeImageView.sd_layout.topSpaceToView(consultation,20+kImageWidth).leftEqualToView(babyNickName).widthIs(30/2).heightIs(30/2);
        
    }else{
        
        timeImageView.sd_layout.topSpaceToView(consultation,20+kImageWidth*2+kImageTopspace).leftEqualToView(babyNickName).widthIs(30/2).heightIs(30/2);
    }
    
    //创建时间
//    timeImageView.sd_layout.topSpaceToView(photoWallBgView,20).leftEqualToView(babyNickName).widthIs(30/2).heightIs(30/2);
    timeLabel.sd_layout.centerYEqualToView(timeImageView).leftSpaceToView(timeImageView,5).heightIs(10).widthIs(10);
    
    timeLabel.text = commentEntity.publicTime;
    timeLabel.width = kJMWidth(timeLabel);
    [timeLabel  updateLayout];
    //    [timeLabel setSingleLineAutoResizeWithMaxWidth:250];
    //评论
    _commentLabel.sd_layout.centerYEqualToView(timeLabel).heightRatioToView(timeLabel,1).rightSpaceToView(containerView,15);
    [_commentLabel setSingleLineAutoResizeWithMaxWidth:250];
    //评论图片
    commentImageView.sd_layout.centerYEqualToView(timeLabel).widthIs(16).heightEqualToWidth().rightSpaceToView(_commentLabel,7);
    
    //回复
    replybgView.sd_layout.topSpaceToView(timeImageView,15).leftEqualToView(babyNickName).rightSpaceToView(containerView,0);
    replyLine.sd_layout.topSpaceToView(replybgView,0).heightIs(1).leftSpaceToView(replybgView,0).rightSpaceToView(replybgView,0);
    reply1Label.sd_layout.topSpaceToView(replyLine,10).leftEqualToView(replyLine).rightSpaceToView(replybgView,5).autoHeightRatio(0);
    reply2Label.sd_layout.topSpaceToView(reply1Label,10).leftEqualToView(replyLine).rightSpaceToView(replybgView,5).autoHeightRatio(0);
    [replybgView setupAutoHeightWithBottomView:reply2Label bottomMargin:0];
    
    //灰色条
    grayBarView.sd_layout.topSpaceToView(replybgView,15).leftSpaceToView(containerView,0).rightSpaceToView(containerView,0).heightIs(1);
    
    if(commentEntity.ReplyCommentList.count == 0){
        //        NSLog(@"无回复");
        
        replybgView.hidden = YES;
        grayBarView.sd_layout.topSpaceToView(timeImageView,20).leftSpaceToView(containerView,0).rightSpaceToView(containerView,0).heightIs(1);
    }else{
        replybgView.hidden = NO;
        grayBarView.sd_layout.topSpaceToView(replybgView,20).leftSpaceToView(containerView,0).rightSpaceToView(containerView,0).heightIs(1);
        
        if(commentEntity.ReplyCommentList.count == 1){
            
            [replybgView setupAutoHeightWithBottomView:reply1Label bottomMargin:0];
            reply2Label.hidden = YES;
            
            NSString* nickName = [commentEntity.ReplyCommentList firstObject].NickName;
            NSString* comentContent = [commentEntity.ReplyCommentList firstObject].CommentContent;
            
            NSMutableAttributedString* reply1Attribute = [UILabel getAttributeTextWithString:[NSString stringWithFormat:@"%@：%@",nickName,comentContent]];
            [reply1Attribute addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x61d8d3) range:NSMakeRange(0, nickName.length)];
            reply1Label.attributedText = reply1Attribute;
            
        }else if(commentEntity.ReplyCommentList.count == 2){
            
            [replybgView setupAutoHeightWithBottomView:reply2Label bottomMargin:0];
            reply2Label.hidden = NO;
            
            NSString* nickName = [commentEntity.ReplyCommentList firstObject].NickName;
            NSString* comentContent = [commentEntity.ReplyCommentList firstObject].CommentContent;
            NSMutableAttributedString* reply1Attribute = [UILabel getAttributeTextWithString:[NSString stringWithFormat:@"%@：%@",nickName,comentContent]];
            [reply1Attribute addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x61d8d3) range:NSMakeRange(0, nickName.length)];
            reply1Label.attributedText = reply1Attribute;
            
            NSString* nickName2 = [commentEntity.ReplyCommentList lastObject].NickName;
            NSString* comentContent2 = [commentEntity.ReplyCommentList lastObject].CommentContent;
            NSMutableAttributedString* reply2Attribute = [UILabel getAttributeTextWithString:[NSString stringWithFormat:@"%@：%@",nickName2,comentContent2]];
            [reply2Attribute addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x61d8d3) range:NSMakeRange(0, nickName2.length)];
            reply2Label.attributedText = reply2Attribute;
            
        }
        [reply1Label updateLayout];
        [reply2Label updateLayout];
        [replybgView updateLayout];
        
    }
    [grayBarView updateLayout];
    
    
    [containerView setupAutoHeightWithBottomView:grayBarView bottomMargin:0];
    
    
    [self setupAutoHeightWithBottomView:containerView bottomMargin:0];
    
    
//    reply1Label.backgroundColor = [UIColor blueColor];
//    reply2Label.backgroundColor = [UIColor redColor];
//    replybgView.backgroundColor = [UIColor yellowColor];

}

#pragma mark - 手势监听
#pragma mark * 点击照片墙
- (void)clickPhototAction:(UITapGestureRecognizer*) tapGesture{
    UIImageView* photo = (UIImageView*)tapGesture.view;
//        NSLog(@"点击了照片---%ld",(long)photo.tag);
    
    NSMutableArray* tempPhoto = [NSMutableArray array];
    NSMutableArray* tempPhotoURL = [NSMutableArray array];
    if(self.commentEntity.Image1 && self.commentEntity.Image1.length > 4){
        [tempPhoto addObject:photo1];
        [tempPhotoURL addObject:[NSString stringWithFormat:@"%@%@",ICON_URL,self.commentEntity.Image1]];
    }
    if(self.commentEntity.Image2 && self.commentEntity.Image2.length > 4){
        [tempPhoto addObject:photo2];
        [tempPhotoURL addObject:[NSString stringWithFormat:@"%@%@",ICON_URL,self.commentEntity.Image2]];
    }
    if(self.commentEntity.Image3 && self.commentEntity.Image3.length > 4){
        [tempPhoto addObject:photo3];
        [tempPhotoURL addObject:[NSString stringWithFormat:@"%@%@",ICON_URL,self.commentEntity.Image3]];
    }
    
    if(self.commentEntity.Image4 && self.commentEntity.Image4.length > 4){
        [tempPhoto addObject:leftPhoto1];
        [tempPhotoURL addObject:[NSString stringWithFormat:@"%@%@",ICON_URL,self.commentEntity.Image4]];
    }
    if(self.commentEntity.Image5 && self.commentEntity.Image5.length > 4){
        [tempPhoto addObject:midlePhoto2];
        [tempPhotoURL addObject:[NSString stringWithFormat:@"%@%@",ICON_URL,self.commentEntity.Image5]];
    }
    if(self.commentEntity.Image6 && self.commentEntity.Image6.length > 4){
        [tempPhoto addObject:rightpPoto3];
        [tempPhotoURL addObject:[NSString stringWithFormat:@"%@%@",ICON_URL,self.commentEntity.Image6]];
    }
    
    
    NSArray* photoDataSource = tempPhoto;
    NSArray* photoURLDataSource = tempPhotoURL;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickPhotoWallWithCircleEntity:currentPhoto:photoDataSource:photoURLDataSource:)]){
        
        CircleEntity* circleEntity = [CircleEntity new];
        
        [self.delegate clickPhotoWallWithCircleEntity:circleEntity currentPhoto:photo photoDataSource:photoDataSource photoURLDataSource:photoURLDataSource];
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
