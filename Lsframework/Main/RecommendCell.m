//
//  RecommendCell.m
//  FamilyPlatForm
//
//  Created by Mac on 16/11/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "RecommendCell.h"

@interface RecommendCell ()
/** 背景View*/
@property(nonatomic,strong)UIView*bgView;
/** 背景图片 */
@property(nonatomic,strong)UIImageView *bgImage;
/** 标题label*/
@property(nonatomic,strong)UILabel*titleLabel;
/** 今天*/
@property(nonatomic,strong)UILabel*todayLabel;
/** 查看label*/
@property(nonatomic,strong)UILabel*lookLabel;
/** 查看图片*/
@property(nonatomic,strong)UIImageView*lookImage;
/** 评论label*/
@property(nonatomic,strong)UILabel*commentLabel;
/** 评论图片*/
@property(nonatomic,strong)UIImageView*commentImage;
/** 百科label*/
@property(nonatomic,strong)UILabel*sourceLabel;
/** 百科图片*/
@property(nonatomic,strong)UIImageView*sourceImage;

@property(nonatomic,strong)UIView *blackView;

@end

@implementation RecommendCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self setUpView];
    }
    return  self;
}
-(void)setUpView
{
    // 背景view
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgView];
    
    // 背景image
    self.bgImage  = [UIImageView   new];
    self.bgImage .backgroundColor = [UIColor  clearColor];
    self.bgImage.userInteractionEnabled = YES;
    self.bgImage .layer.cornerRadius = 5/2;
    [self.bgView   addSubview:self.bgImage];
    
    self.blackView = [UIView new];
    self.blackView.userInteractionEnabled = YES;
    self.blackView .layer.cornerRadius = 5/2;
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0.3;
    [self.bgImage addSubview:self.blackView];
    
    // 标题label
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:34/2];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.bgImage addSubview:self.titleLabel];
    
    // 百科label
    self.sourceLabel = [[UILabel alloc]init];
    self.sourceLabel.numberOfLines = 1;
    self.sourceLabel.backgroundColor = [UIColor clearColor];
    self.sourceLabel.font = [UIFont systemFontOfSize:24/2];
    self.sourceLabel.textColor = [UIColor whiteColor];
    [self.bgImage addSubview:self.sourceLabel];
    
    // 百科image
    self.sourceImage = [UIImageView new];
    self.sourceImage.image = [UIImage imageNamed:@"label"];
    [self.bgImage addSubview:self.sourceImage];
    
    // 今天label
    self.todayLabel = [[UILabel alloc]init];
    self.todayLabel.backgroundColor = [UIColor clearColor];
    self.todayLabel.font = [UIFont systemFontOfSize:24/2];
    self.todayLabel.textColor = [UIColor whiteColor];
    [self.bgImage addSubview:self.todayLabel];
    
    // 查看label
    self.lookLabel = [[UILabel alloc]init];
    self.lookLabel.backgroundColor = [UIColor clearColor];
    self.lookLabel.font = [UIFont systemFontOfSize:24/2];
    self.lookLabel.textColor = [UIColor whiteColor];
    [self.bgImage addSubview:self.lookLabel];
    
    // 查看image
    self.lookImage = [UIImageView new];
    self.lookImage.image = [UIImage imageNamed:@"Eye_gray"];
    [self.bgImage addSubview:self.lookImage];
    
    // 品论label
    self.commentLabel = [[UILabel alloc]init];
    self.commentLabel.backgroundColor = [UIColor clearColor];
    self.commentLabel.font = [UIFont systemFontOfSize:24/2];
    self.commentLabel.textColor = [UIColor whiteColor];
    [self.bgImage addSubview:self.commentLabel];
    
    // 品论image
    self.commentImage = [UIImageView new];
    self.commentImage.image = [UIImage imageNamed:@"pl_gray"];
    [self.bgImage addSubview:self.commentImage];
    
   
    // 点赞label
    self.praiseLabel = [[UILabel alloc]init];
    self.praiseLabel.backgroundColor = [UIColor clearColor];
    self.praiseLabel.font = [UIFont systemFontOfSize:24/2];
    self.praiseLabel.textColor = [UIColor whiteColor];
    [self.bgImage addSubview:self.praiseLabel];
    
    // 点赞button
    self.praiseButton = [UIButton new];
    self.praiseButton.backgroundColor = [UIColor clearColor];
//    [self.praiseButton setImage:[UIImage imageNamed:@"Heart_gray"] forState:UIControlStateNormal];
    [self.bgImage addSubview:self.praiseButton];
    
   
    // 添加约束
    
    self.bgView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).widthIs(kScreenWidth).heightIs(542/2);
    self.bgImage.sd_layout.topSpaceToView(self.bgView,5).leftSpaceToView(self.bgView,5).rightSpaceToView(self.bgView,5).bottomSpaceToView(self.bgView,0);
    self.todayLabel.sd_layout.leftSpaceToView(self.bgImage,15).bottomSpaceToView(self.bgImage,25/2).heightIs(18);//
    self.commentLabel.sd_layout.rightSpaceToView(self.bgImage,15).bottomSpaceToView(self.bgImage,25/2).widthIs(24).heightIs(18);
    self.commentImage.sd_layout.rightSpaceToView(self.commentLabel,10).bottomSpaceToView(self.bgImage,25/2).widthIs(18).heightIs(18);
    self.praiseLabel.sd_layout.rightSpaceToView(self.commentImage,10).bottomSpaceToView(self.bgImage,25/2).widthIs(24).heightIs(18);
    self.praiseButton.sd_layout.rightSpaceToView(self.praiseLabel,10).bottomSpaceToView(self.bgImage,25/2).widthIs(18).heightIs(18);
    self.lookLabel.sd_layout.rightSpaceToView(self.praiseButton,10).bottomSpaceToView(self.bgImage,25/2).heightIs(18).widthIs(24);
    self.lookImage.sd_layout.rightSpaceToView(self.lookLabel,10).bottomSpaceToView(self.bgImage,25/2).widthIs(18).heightIs(18);
    self.titleLabel.sd_layout.leftSpaceToView(self.bgImage,15).bottomSpaceToView(self.lookLabel,15).autoHeightRatio(0).rightSpaceToView(self.bgImage,15);//
    self.sourceImage.sd_layout.leftSpaceToView(self.bgImage,15).topSpaceToView(self.bgImage,15).widthIs(18).heightIs(18);
    self.sourceLabel.sd_layout.leftSpaceToView(self.sourceImage,10).topEqualToView(self.sourceImage).heightIs(18).widthIs(18);
    self.blackView.sd_layout.topEqualToView(self.bgImage).leftEqualToView(self.bgImage).rightEqualToView(self.bgImage).bottomEqualToView(self.bgImage);
    [self.bgView setupAutoHeightWithBottomView:self.bgImage bottomMargin:0];
    [self setupAutoHeightWithBottomView:self.bgView bottomMargin:0];
    
}
-(void)setTodayRecommend:(TodayRecommend *)todayRecommend
{
    _todayRecommend = todayRecommend;
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:todayRecommend.BigPhoto]];
    self.sourceLabel.text = todayRecommend.CategoryName;
    self.sourceLabel.width = [JMFoundation calLabelWidth:self.sourceLabel];
    [self.sourceLabel updateLayout];
    self.titleLabel.text = todayRecommend.Title;
    self.todayLabel.text = todayRecommend.ArticleTime;
    
    
//    if ([todayRecommend.CommonCount integerValue] >= 100) {
//        self.commentLabel.text = @"99+";
//    }else{
//        self.commentLabel.text = [NSString  stringWithFormat:@"%@",todayRecommend.CommonCount];
//    }
//    
//    if ([todayRecommend.Clicks integerValue] >= 100) {
//        self.lookLabel.text = @"99+";
//    }else{
//        self.lookLabel.text = [NSString  stringWithFormat:@"%@",todayRecommend.Clicks];
//    }
//    if ([todayRecommend.PraiseCount integerValue] >=100) {
//        self.praiseLabel.text = @"99+";
//    }else{
//        self.praiseLabel.text =[NSString  stringWithFormat:@"%@",todayRecommend.PraiseCount];
//        
//    }
    self.commentLabel.text = [NSString  stringWithFormat:@"%@",todayRecommend.CommonCount];
    self.lookLabel.text = [NSString  stringWithFormat:@"%@",todayRecommend.Clicks];
    self.praiseLabel.text =[NSString  stringWithFormat:@"%@",todayRecommend.PraiseCount];
    
    if([todayRecommend.IsPraise integerValue] == 0){
        //当前用户没有点过赞
        [self.praiseButton  setImage:[UIImage  imageNamed:@"Heart_gray"]  forState:UIControlStateNormal];
    }else{
        //当前用户点过赞
        [self.praiseButton  setImage:[UIImage  imageNamed:@"hear_red"]  forState:UIControlStateNormal];
    }
    
    self.commentLabel.width = [JMFoundation calLabelWidth:self.commentLabel];
    [self.commentLabel updateLayout];
    self.todayLabel.width = [JMFoundation  calLabelWidth:self.todayLabel];
    [self.todayLabel  updateLayout];
    self.praiseLabel.width = [JMFoundation calLabelWidth:self.praiseLabel];
    [self.praiseLabel updateLayout];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
