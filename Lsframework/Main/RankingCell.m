//
//  RankingCell.m
//  FamilyPlatForm
//
//  Created by Mac on 16/12/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "RankingCell.h"

@interface RankingCell ()
/** 内容view*/
@property(nonatomic,strong)UIView*bgView;
/** 图片img*/
@property(nonatomic,strong)UIImageView*picImage;
/** 线img*/
@property(nonatomic,strong)UIImageView*lineImage;
/** 评论img*/
@property(nonatomic,strong)UIImageView*commentImage;
/** 查看img*/
@property(nonatomic,strong)UIImageView*lookImage;
/** 膳食btn*/
@property(nonatomic,strong)UIButton*leftBtn;
/** 健康btn*/
@property(nonatomic,strong)UIButton*rightBtn;

/** 标题lb*/
@property(nonatomic,strong)UILabel*titleLabel;
/** 来源lb*/
@property(nonatomic,strong)UILabel*sourceLabel;

/** 查看lable*/
@property(nonatomic,strong)UILabel*lookLabel;

@property(nonatomic,strong)UIView *TagView;

@end

@implementation RankingCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpView];
    }
    return self;
}
-(void)setUpView
{
    // 内容view
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.bgView];
    
    // 图片
    _picImage = [UIImageView new];
    _picImage.backgroundColor = [UIColor clearColor];
    _picImage.layer.cornerRadius = 5/2;
    _picImage.layer.masksToBounds = YES;
    [self.bgView addSubview:_picImage];
    
    // 横线
    self.lineImage = [UIImageView new];
    self.lineImage.backgroundColor = [UIColor clearColor];
    self.lineImage.image = [UIImage imageNamed:@"间隔"];
    [self.bgView addSubview:self.lineImage];
    
    // 评论image
    _commentImage = [UIImageView new];
    _commentImage.backgroundColor = [UIColor clearColor];
    _commentImage.image = [UIImage imageNamed:@"pl_gray"];
    [self.bgView addSubview:_commentImage];
    
    // 查看image
    _lookImage = [UIImageView new];
    _lookImage.backgroundColor = [UIColor clearColor];
    _lookImage.image = [UIImage imageNamed:@"Eye_gray"];
    [self.bgView addSubview:_lookImage];
    
    // 标题
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:32/2];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.bgView addSubview:self.titleLabel];
    
    _TagView = [UIView new];
    _TagView.backgroundColor = [UIColor clearColor];
    [self.bgView  addSubview:_TagView];
    
    
    // 来源
    self.sourceLabel = [[UILabel alloc]init];
    self.sourceLabel.backgroundColor = [UIColor clearColor];
    self.sourceLabel.font = [UIFont systemFontOfSize:24/2];
    self.sourceLabel.textColor = [UIColor grayColor];
    [self.bgView addSubview:self.sourceLabel];
    
    // 评论
    self.commentLabel = [[UILabel alloc]init];
    self.commentLabel.backgroundColor = [UIColor clearColor];
    self.commentLabel.font = [UIFont systemFontOfSize:24/2];
    self.commentLabel.textColor = [UIColor grayColor];
    [self.bgView addSubview:self.commentLabel];
    
    // 点赞
    self.praiseLabel = [[UILabel alloc]init];
    self.praiseLabel.backgroundColor = [UIColor clearColor];
    self.praiseLabel.font = [UIFont systemFontOfSize:24/2];
    self.praiseLabel.textColor = [UIColor grayColor];
    [self.bgView addSubview:self.praiseLabel];
    
    // 查看
    self.lookLabel = [[UILabel alloc]init];
    self.lookLabel.backgroundColor = [UIColor clearColor];
    self.lookLabel.font = [UIFont systemFontOfSize:24/2];
    self.lookLabel.textColor = [UIColor grayColor];
    [self.bgView addSubview:self.lookLabel];
    
    // 点赞button
    self.praiseBtn = [UIButton new];
    self.praiseBtn.backgroundColor = [UIColor clearColor];
    [self.praiseBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.bgView addSubview:self.praiseBtn];
    
    // 膳食
    self.leftBtn = [UIButton new];
    self.leftBtn.backgroundColor = [UIColor clearColor];
    //    [self.leftBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"shape_green"] forState:UIControlStateNormal];
    [self.bgView addSubview:self.leftBtn];
    
    // 健康
    self.rightBtn = [UIButton new];
    self.rightBtn.backgroundColor = [UIColor clearColor];
    //    [self.rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"shape_green"] forState:UIControlStateNormal];
    [self.bgView addSubview:self.rightBtn];
    //
    //    self.bgView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,15);
    //    self.picImage.sd_layout.topSpaceToView(self.bgView,15).rightSpaceToView(self.bgView,15).heightIs(164/2).widthIs(224/2);
    //    self.commentLabel.sd_layout.rightSpaceToView(self.bgView,15).topSpaceToView(self.picImage,20).widthIs(24).heightIs(18);
    //    self.commentImage.sd_layout.topEqualToView(self.commentLabel).widthIs(18).heightIs(18).rightSpaceToView(self.commentLabel,10);
    //    self.praiseLabel.sd_layout.rightSpaceToView(self.commentImage,10).bottomSpaceToView(self.bgView,15).widthIs(24).heightIs(18);
    //    self.praiseBtn.sd_layout.bottomSpaceToView(self.bgView,15).rightSpaceToView(self.praiseLabel,10).widthIs(18).heightIs(18);
    //    self.lookLabel.sd_layout.rightSpaceToView(self.praiseBtn,10).bottomSpaceToView(self.bgView,15).widthIs(24).heightIs(18);
    //    self.lookImage.sd_layout.rightSpaceToView(self.lookLabel,10).bottomSpaceToView(self.bgView,15).heightIs(18).widthIs(18);
    //    self.sourceLabel.sd_layout.leftSpaceToView(self.bgView,15).bottomSpaceToView(self.bgView,15).heightIs(18);
    //    self.titleLabel.sd_layout.topSpaceToView(self.bgView,20).leftSpaceToView(self.bgView,15).rightSpaceToView(self.picImage,10).heightIs(30);
    //    self.TagView.sd_layout.topSpaceToView(self.titleLabel,20).leftEqualToView(self.titleLabel).rightEqualToView(self.titleLabel).heightIs(18);
    //
    //    self.lineImage.sd_layout.heightIs(1).leftSpaceToView(self.bgView,15).rightSpaceToView(self.bgView,15).topEqualToView(self.praiseBtn);
    //    [self.bgView setupAutoHeightWithBottomView:self.lineImage bottomMargin:0];
    //    [self setupAutoHeightWithBottomView:self.bgView bottomMargin:0];
    
    self.bgView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15);
    
    self.picImage.sd_layout.topSpaceToView(self.bgView,15).rightSpaceToView(self.bgView,0).heightIs(164/2).widthIs(224/2);
    
    
    self.titleLabel.sd_layout.topSpaceToView(self.bgView,20).leftSpaceToView(self.bgView,0).rightSpaceToView(self.picImage,10).autoHeightRatio(0);
    
    self.TagView.sd_layout.topSpaceToView(self.titleLabel,20).leftEqualToView(self.titleLabel).rightEqualToView(self.titleLabel).heightIs(18);
    
    self.commentLabel.sd_layout.rightSpaceToView(self.bgView,0).topSpaceToView(self.picImage,20).heightIs(18).widthIs(24);
    
    
    self.commentImage.sd_layout.topEqualToView(self.commentLabel).widthIs(18).heightIs(18).rightSpaceToView(self.commentLabel,10);
    self.praiseLabel.sd_layout.rightSpaceToView(self.commentImage,10).topEqualToView(_commentLabel).heightIs(18).widthIs(24);
    
    
    self.praiseBtn.sd_layout.topEqualToView(_commentImage).rightSpaceToView(self.praiseLabel,10).widthIs(18).heightIs(18);
    
    self.lookLabel.sd_layout.rightSpaceToView(self.praiseBtn,10).topEqualToView(_commentLabel).heightIs(18).widthIs(24);
    
    self.lookImage.sd_layout.rightSpaceToView(self.lookLabel,10).topEqualToView(_commentLabel).heightIs(18).widthIs(18);
    
    self.sourceLabel.sd_layout.leftSpaceToView(self.bgView,0).topEqualToView(_commentLabel).heightIs(18);
    
    self.lineImage.sd_layout.heightIs(1).leftSpaceToView(self.bgView,0).rightSpaceToView(self.bgView,0).topSpaceToView(self.commentLabel,15);
    
    [self.bgView setupAutoHeightWithBottomView:self.lineImage bottomMargin:0];
    
    [self setupAutoHeightWithBottomView:self.bgView bottomMargin:0];
    
    
}
-(void)setTodayRecommend:(TodayRecommend *)todayRecommend
{
    _todayRecommend = todayRecommend;
    [self.picImage sd_setImageWithURL:[NSURL URLWithString:todayRecommend.Photo]];
    self.titleLabel.text = todayRecommend.Title;
    self.sourceLabel.text = todayRecommend.From;
    self.sourceLabel.width = [JMFoundation  calLabelWidth:self.sourceLabel];
    [self.sourceLabel  updateLayout];
    
    //tags
    NSString *tags = todayRecommend.Tags;
    
    NSLog(@"tags is%@()",tags);
    
    //    NSArray *tagArr = [tags componentsSeparatedByString:@" "];
    //    NSLog(@"%@",tagArr.count);
    
    if (tags.length != 0 ) {
        NSArray *tagArr = [tags componentsSeparatedByString:@" "];
        NSLog(@"tags--%lu",(unsigned long)tagArr.count);
        for (int i = 0 ; i<tagArr.count; i++) {
            
            UIView  *tagSSView = [UIView new];
            tagSSView.backgroundColor = [UIColor whiteColor];
            tagSSView.layer.borderWidth= 1;
            tagSSView.layer.cornerRadius = 3.5;
            tagSSView.layer.borderColor = UIColorFromRGB(0xf19ec2).CGColor;
            [self.TagView  addSubview:tagSSView];
            
            UILabel  *tagLb = [UILabel new];
            tagLb.textColor = UIColorFromRGB(0xf19ec2);
            tagLb.textAlignment = NSTextAlignmentCenter;
            tagLb.font = [UIFont  systemFontOfSize:13];
            tagLb.text = tagArr[i];
            [tagSSView  addSubview:tagLb];
            
            tagSSView.sd_layout.topSpaceToView(_TagView,0).leftSpaceToView(_TagView,i*([JMFoundation calLabelWidth:tagLb]+10)).widthIs([JMFoundation calLabelWidth:tagLb]+2).heightIs(18);
            tagLb.sd_layout.centerXEqualToView(tagSSView).centerYEqualToView(tagSSView).widthRatioToView(tagSSView,2).heightIs(12);
            
        }
        
    }
    
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
        [self.praiseBtn  setImage:[UIImage  imageNamed:@"Heart_gray"]  forState:UIControlStateNormal];
    }else{
        //当前用户点过赞
        [self.praiseBtn  setImage:[UIImage  imageNamed:@"hear_red"]  forState:UIControlStateNormal];
    }
    
    self.commentLabel.width = [JMFoundation  calLabelWidth:self.commentLabel];
    
    [self.commentLabel  updateLayout];
    
    self.praiseLabel.width = [JMFoundation  calLabelWidth:self.praiseLabel];
    [self.praiseLabel  updateLayout];
    
    
    self.lookLabel.width = [JMFoundation  calLabelWidth:self.lookLabel];
    [self.lookLabel  updateLayout];
    
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
