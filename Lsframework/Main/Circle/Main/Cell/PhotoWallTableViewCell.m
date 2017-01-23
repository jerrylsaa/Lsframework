//
//  PhotoWallTableViewCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PhotoWallTableViewCell.h"
#import "ApiMacro.h"

#define   kImageXspace     11
#define   kImageTopspace     7.5
#define   kImageWidth   (kScreenWidth-15*2-2*kImageXspace)/3

@interface PhotoWallTableViewCell (){
    UIView* containerView;
    
    UIImageView* babyImageView;
    UILabel* babyNickName;
    UILabel* expertPrice;
    
    UILabel* postTitle;
    UILabel* consultation;
    
    UIView* photoWallBgView;
    UIImageView* photo1;
    UIImageView* photo2;
    UIImageView* photo3;
    
    UIImageView* photo4;
    UIImageView* photo5;
    UIImageView* photo6;
    
    UILabel* timeLabel;
    UIImageView* commentImageView;
    UILabel* commentLabel;
    UILabel* hearLabel;
    UIImageView *praiseImageView;
    UILabel *praiseLabel;
    UIView   *praiseBgView;

    UIView* grayBarView;
}

@end

@implementation PhotoWallTableViewCell

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
//    expertPrice = [UILabel new];
//    expertPrice.textAlignment = NSTextAlignmentRight;
//    expertPrice.textColor = RGB(215, 23, 0);
//    expertPrice.font = [UIFont systemFontOfSize:smidFont];
//    expertPrice.textAlignment = NSTextAlignmentRight;
//    [containerView addSubview:expertPrice];
    //帖子标题
    postTitle = [UILabel new];
    postTitle.textColor = UIColorFromRGB(0x333333);
    postTitle.font = [UIFont systemFontOfSize:bigFont];
    [containerView addSubview:postTitle];
    
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
    
    
    //时间
    timeLabel = [UILabel new];
    timeLabel.textColor = UIColorFromRGB(0x999999);
    timeLabel.font = [UIFont systemFontOfSize:11];
    [containerView addSubview:timeLabel];
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
//    expertPrice.text = [NSString stringWithFormat:@"¥%@",circleEntity.expertPrice];
    [expertPrice updateLayout];
    //帖子标题
    postTitle.attributedText = [UILabel getAttributeTextWithString:circleEntity.title];
    //咨询内容
    consultation.attributedText = [UILabel getAttributeTextWithString:circleEntity.consultationContent];
    
    //照片墙
    [photo1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,circleEntity.image1]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photo2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,circleEntity.image2]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photo3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,circleEntity.image3]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photo4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,circleEntity.image4]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photo5 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,circleEntity.image5]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [photo6 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,circleEntity.image6]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    photo1.hidden = !(self.circleEntity.image1 && self.circleEntity.image1.length > 10);
    photo2.hidden = !(self.circleEntity.image2 && self.circleEntity.image2.length > 10);
    photo3.hidden = !(self.circleEntity.image3 && self.circleEntity.image3.length > 10);
    photo4.hidden = !(self.circleEntity.image4 && self.circleEntity.image4.length > 10);
    photo5.hidden = !(self.circleEntity.image5 && self.circleEntity.image5.length > 10);
    photo6.hidden = !(self.circleEntity.image6 && self.circleEntity.image6.length > 10);
    
    
    
    
//    if (photo1.hidden == NO) {
//        photoWallBgView.sd_layout.topSpaceToView(consultation,10).leftEqualToView(babyImageView).widthIs(kScreenWidth-30).heightIs(kImageWidth);
//        photo1.sd_layout.topSpaceToView(photoWallBgView,0).leftSpaceToView(photoWallBgView,0).widthIs(kImageWidth).heightEqualToWidth();
//        photo1.sd_cornerRadius = @5;
//        if (photo2.hidden == NO) {
//            photo2.sd_layout.topEqualToView(photo1).leftSpaceToView(photo1,kImageXspace).widthIs(kImageWidth).heightEqualToWidth();
//            photo2.sd_cornerRadius = @5;
//            
//            if (photo3.hidden == NO) {
//                photo3.sd_layout.topEqualToView(photo1).leftSpaceToView(photo2,kImageXspace).widthIs(kImageWidth).heightEqualToWidth();
//                photo3.sd_cornerRadius = @5;
//                
//                if (photo4.hidden == NO) {
//                    
//                    photoWallBgView.sd_layout.topSpaceToView(consultation,10).leftEqualToView(babyImageView).widthIs(kScreenWidth-30).heightIs(kImageWidth);
//                    
//                    photo4.sd_layout.topSpaceToView(photoWallBgView,kImageWidth+kImageTopspace).leftEqualToView(photo1).widthIs(kImageWidth).heightEqualToWidth();
//                    photo4.sd_cornerRadius = @5;
//                    
//                    
//                    if (photo5.hidden == NO) {
//                        
//                        photo5.sd_layout.topEqualToView(photo4).leftEqualToView(photo2).widthIs(kImageWidth).heightEqualToWidth();
//                        photo5.sd_cornerRadius = @5;
//                        
//                        
//                        if (photo6.hidden == NO) {
//                            
//                            photo6.sd_layout.topEqualToView(photo4).leftEqualToView(photo3).widthIs(kImageWidth).heightEqualToWidth();
//                            photo6.sd_cornerRadius = @5;
//                            
//                            
//                        }else{
//                            // 5
//                            
//                            
//                        }
//                    }else{
//                        //4
//                        
//                    }
//                    
//                }else{
//                    // 3
//                }
//                
//            }else{
//                // 2
//            }
//            
//        }else{
//            // 1
//            
//        }
//        
//    }else{
//      photoWallBgView.sd_layout.topSpaceToView(consultation,10).leftEqualToView(babyImageView).widthIs(0).heightIs(0);
//        
//    }
    
    
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
        
        photo4.sd_layout.topSpaceToView(photoWallBgView,kImageWidth+kImageTopspace).leftEqualToView(photo1).widthIs(kImageWidth).heightEqualToWidth();
        photo4.sd_cornerRadius = @5;
        photo5.sd_layout.topEqualToView(photo4).leftEqualToView(photo2).widthIs(kImageWidth).heightEqualToWidth();
        photo5.sd_cornerRadius = @5;
        photo6.sd_layout.topEqualToView(photo4).leftEqualToView(photo3).widthIs(kImageWidth).heightEqualToWidth();
        photo6.sd_cornerRadius = @5;

    }
    

    //创建时间
//    timeLabel.text = [NSDate getDateCompare:[circleEntity.createTime format2String:@"yyyy-MM-dd HH:mm:ss"]];
    timeLabel.text = circleEntity.createTime;
    //评论
    commentLabel.text = (circleEntity.commentCount)? [NSString stringWithFormat:@"%@",circleEntity.commentCount]: @"0";
    [commentLabel updateLayout];
    

    //赞
    praiseLabel.text = (circleEntity.praiseCount)? [NSString stringWithFormat:@"%@",circleEntity.praiseCount]: @"0";
    if ([circleEntity.isPraise integerValue] == 1) {
        praiseImageView.image = [UIImage imageNamed:@"Heart_red_icon"];
    }else{
        praiseImageView.image = [UIImage imageNamed:@"Heart_icon"];
    }
    
    //添加约束
    containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    babyImageView.sd_layout.topSpaceToView(containerView,15).leftSpaceToView(containerView,15).widthIs(40).heightEqualToWidth();
    babyImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    babyNickName.sd_layout.leftSpaceToView(babyImageView,15).topSpaceToView(containerView,20).heightIs(14);
    [babyNickName setSingleLineAutoResizeWithMaxWidth:250];
    //    expertPrice.sd_layout.centerYEqualToView(babyImageView).heightIs(14).rightSpaceToView(containerView,15);
    //    [expertPrice setSingleLineAutoResizeWithMaxWidth:250];
    postTitle.sd_layout.topSpaceToView(babyImageView,15).leftEqualToView(babyImageView).rightSpaceToView(containerView,15).autoHeightRatio(0);
    
    consultation.sd_layout.topSpaceToView(postTitle,10).leftEqualToView(babyImageView).rightSpaceToView(containerView,15).autoHeightRatio(0);
    
    
    if (photoWallBgView.height == 0) {
        
        timeLabel.sd_layout.topSpaceToView(consultation,15).leftEqualToView(babyImageView).heightIs(10);
        [timeLabel setSingleLineAutoResizeWithMaxWidth:250];
    }else if (photoWallBgView.height == kImageWidth){
        
        timeLabel.sd_layout.topSpaceToView(consultation,20+kImageWidth).leftEqualToView(babyImageView).heightIs(10);
        [timeLabel setSingleLineAutoResizeWithMaxWidth:250];
        
    }else{
        
        timeLabel.sd_layout.topSpaceToView(consultation,20+kImageWidth*2+kImageTopspace).leftEqualToView(babyImageView).heightIs(10);
        [timeLabel setSingleLineAutoResizeWithMaxWidth:250];
    }
    
    [timeLabel updateLayout];
    
    //    [containerView setupAutoHeightWithBottomView:photoWallBgView bottomMargin:20];
    
    //创建时间
//    timeLabel.sd_layout.topSpaceToView(photoWallBgView,20).leftEqualToView(babyImageView).heightIs(10);
//    [timeLabel setSingleLineAutoResizeWithMaxWidth:250];
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
            [self.delegate praiseAtIndexPath:self.sd_indexPath type:2];
        }
    }else{
        if (self.delegate) {
            [self.delegate cancelPraiseAtIndexPath:self.sd_indexPath type:2];
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
