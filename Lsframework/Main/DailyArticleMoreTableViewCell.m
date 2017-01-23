//
//  DailyArticleMoreTableViewCell.m
//  FamilyPlatForm
//
//  Created by jerry on 16/10/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DailyArticleMoreTableViewCell.h"
@interface DailyArticleMoreTableViewCell(){
  UIView* containerView;
  UIImageView  *_DailyImageView;
  UILabel     *_DailyContentlb;
  UIButton     *_DailyCommonCountBt;
//  UIButton     *_DailyPraiseCountBt;
  UILabel      *_DailyCommonLb;
//  UILabel      *_DailyPraiseLb;
  UIView   *grayBarView;
 UIButton     *_DailyLookCountBt;
 UILabel  *_DailyLookLb;
    
    
}

@end

@implementation DailyArticleMoreTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self setupView];
    }
    return self;
}

-(void)setupView{

    containerView = [UIView new];
    [self.contentView addSubview:containerView];
//必读图片
    _DailyImageView = [UIImageView   new];
    _DailyImageView.backgroundColor = [UIColor  clearColor];
    _DailyImageView.layer.cornerRadius = 5/2;
    [containerView  addSubview:_DailyImageView];
    

 //必读标题
    _DailyContentlb = [UILabel  new];
    _DailyContentlb.backgroundColor = [UIColor  clearColor];
    _DailyContentlb.font = [UIFont  systemFontOfSize:16];
    _DailyContentlb.textAlignment = NSTextAlignmentLeft;
    _DailyContentlb.textColor =UIColorFromRGB(0x333333);
    _DailyContentlb.numberOfLines = 0;
    [containerView  addSubview:_DailyContentlb];
  
    
    
    _DailyLookCountBt = [UIButton  new];
    _DailyLookCountBt.backgroundColor = [UIColor  clearColor];
    [ _DailyLookCountBt  setImage:[UIImage  imageNamed:@"LookImage"]  forState:UIControlStateNormal];
//    [_DailyLookCountBt  setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [containerView  addSubview:_DailyLookCountBt];
    
    

    //必读点赞
    _DailyPraiseCountBt = [UIButton  new];
    _DailyPraiseCountBt.backgroundColor = [UIColor  clearColor];
    [ _DailyPraiseCountBt  setImage:[UIImage  imageNamed:@"DailyArticleMore_praise"]  forState:UIControlStateNormal];
//    [_DailyPraiseCountBt  setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [containerView  addSubview:_DailyPraiseCountBt];
    
 //必读评论
    _DailyCommonCountBt = [UIButton  new];
    _DailyCommonCountBt.backgroundColor = [UIColor  clearColor];
    [ _DailyCommonCountBt  setImage:[UIImage  imageNamed:@"DailyArticleMore_comment"] forState:UIControlStateNormal];
    [containerView  addSubview:_DailyCommonCountBt];
    
    
    _DailyPraiseLb = [UILabel  new];
    _DailyPraiseLb.backgroundColor = [UIColor  clearColor];
    _DailyPraiseLb.font = [UIFont  systemFontOfSize:24/2];
    _DailyPraiseLb.textAlignment = NSTextAlignmentLeft;
    _DailyPraiseLb.textColor =UIColorFromRGB(0x767676);
    _DailyPraiseLb.numberOfLines = 1;
    [containerView  addSubview:_DailyPraiseLb];

    
    _DailyCommonLb = [UILabel  new];
    _DailyCommonLb.backgroundColor = [UIColor  clearColor];
    _DailyCommonLb.font = [UIFont  systemFontOfSize:24/2];
    _DailyCommonLb.textAlignment = NSTextAlignmentLeft;
    _DailyCommonLb.textColor =UIColorFromRGB(0x767676);
    _DailyCommonLb.numberOfLines = 1;
    [containerView  addSubview:_DailyCommonLb];
    
    
    
    _DailyLookLb = [UILabel  new];
    _DailyLookLb.backgroundColor = [UIColor  clearColor];
    _DailyLookLb.font = [UIFont  systemFontOfSize:24/2];
    _DailyLookLb.textAlignment = NSTextAlignmentLeft;
    _DailyLookLb.textColor =UIColorFromRGB(0x767676);
    _DailyLookLb.numberOfLines = 1;
    [containerView  addSubview:_DailyLookLb];

    //底部灰色条
    grayBarView = [UIView new];
//    grayBarView.backgroundColor = UIColorFromRGB(0xd9d9d9);
    grayBarView.backgroundColor = UIColorFromRGB(0xe6e6e6);
    [containerView addSubview:grayBarView];

    
    
}


-(void)setDailyArticle:(DailyFirstArticle *)DailyArticle{
    _DailyArticle = DailyArticle;
    
    [_DailyImageView  setImageWithUrl:DailyArticle.Photo placeholderImage:nil];
    _DailyContentlb.text = DailyArticle.Title;
    if ([DailyArticle.PraiseCount integerValue] >=100) {
        _DailyPraiseLb.text = @"99+";
    }else{
        _DailyPraiseLb.text =[NSString  stringWithFormat:@"%@",DailyArticle.PraiseCount];

    }
    if([DailyArticle.IsPraise integerValue] == 0){
        //当前用户没有点过赞
        [_DailyPraiseCountBt  setImage:[UIImage  imageNamed:@"DailyArticleMore_praise"]  forState:UIControlStateNormal];
    }else{
        //当前用户点过赞
        [_DailyPraiseCountBt  setImage:[UIImage  imageNamed:@"Heart_red_icon"]  forState:UIControlStateNormal];
    }

    
    
    if ([DailyArticle.CommentCount integerValue] >= 100) {
    _DailyCommonLb.text = @"99+";
    }else{
    _DailyCommonLb.text = [NSString  stringWithFormat:@"%@",DailyArticle.CommentCount];
    }
    
    if ([DailyArticle.Clicks integerValue] >= 100) {
        _DailyLookLb.text = @"99+";
    }else{
        _DailyLookLb.text = [NSString  stringWithFormat:@"%@",DailyArticle.Clicks];
    }
    
    //添加约束
    containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    
    
    _DailyImageView.sd_layout.topSpaceToView(containerView,20/2).leftSpaceToView(containerView,20/2).heightIs(80).widthIs(80);
    
    _DailyContentlb.sd_layout.topSpaceToView(containerView,34/2).leftSpaceToView(_DailyImageView,30/2).rightSpaceToView(containerView,30/2).heightIs(80-7-36/2);
    
    
    _DailyCommonLb.sd_layout.bottomSpaceToView(containerView,20/2).rightSpaceToView(containerView,30/2).heightIs(36/2).widthIs(12*2);
//    [_DailyCommonLb setSingleLineAutoResizeWithMaxWidth:50];
    
    
    _DailyCommonCountBt.sd_layout.bottomSpaceToView(containerView,20/2).rightSpaceToView(_DailyCommonLb,20/2).widthIs(36/2).heightIs(36/2);
    
    
//    _DailyPraiseLb.sd_layout.bottomSpaceToView(containerView,20/2).rightSpaceToView(_DailyCommonCountBt,40/2).heightIs(36/2).minWidthIs(12);
    //  [_DailyPraiseLb setSingleLineAutoResizeWithMaxWidth:50];
    _DailyPraiseLb.sd_layout.bottomSpaceToView(containerView,20/2).rightSpaceToView(_DailyCommonCountBt,20/2).heightIs(36/2).widthIs(12*2);

    _DailyPraiseCountBt.sd_layout.topEqualToView(_DailyCommonCountBt).rightSpaceToView(_DailyPraiseLb,20/2).widthIs(18).heightIs(18);
    
 _DailyLookLb.sd_layout.bottomSpaceToView(containerView,20/2).rightSpaceToView(_DailyPraiseCountBt,20/2).heightIs(36/2).widthIs(12*2);
    
 _DailyLookCountBt.sd_layout.topEqualToView(_DailyCommonCountBt).rightSpaceToView(_DailyLookLb,20/2).widthIs(18).heightIs(18);
    
    grayBarView.sd_layout.topSpaceToView(_DailyImageView,20/2).leftEqualToView(_DailyImageView).rightEqualToView(_DailyContentlb).heightIs(0.5);
    
    [containerView setupAutoHeightWithBottomView:grayBarView bottomMargin:0];
    
    [self setupAutoHeightWithBottomView:containerView bottomMargin:0];

    
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
