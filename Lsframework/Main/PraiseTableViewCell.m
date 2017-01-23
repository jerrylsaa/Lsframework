//
//  PraiseTableViewCell.m
//  FamilyPlatForm
//
//  Created by jerry on 16/9/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PraiseTableViewCell.h"
#import "JMFoundation.h"
#import "ApiMacro.h"
@implementation PraiseTableViewCell

//
//@property(nonatomic,strong)UIImageView  *HeadImageView;
//@property(nonatomic,strong)UILabel  *HeadName;
//@property(nonatomic,strong)UILabel  *FloorLb;
//@property(nonatomic,strong)UILabel  *CommentContent;
//@property(nonatomic,strong)UIImageView  *TimeImageView;
//@property(nonatomic,strong)UILabel  *TimeLb;
//@property(nonatomic,strong) UIButton * AnswerBtn;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupSubviews];
        self.contentView.backgroundColor = [UIColor  whiteColor];
    }
    return self;
}
-(void)setupSubviews{
    
    containerView  = [UIView new];
    containerView.backgroundColor = [UIColor  whiteColor];
    containerView.userInteractionEnabled = YES;
    [self.contentView addSubview:containerView];

    _HeadImageView = [UIImageView  new];

    _HeadImageView.backgroundColor = [UIColor  clearColor];
    [containerView  addSubview:_HeadImageView];
    
    
    _HeadName = [UILabel  new];
    _HeadName.backgroundColor = [UIColor  clearColor];
    _HeadName.textColor = UIColorFromRGB(0X333333);
    _HeadName.font = [UIFont  systemFontOfSize:14];
    _HeadName.textAlignment = NSTextAlignmentLeft;
    [containerView   addSubview:_HeadName];
    
    
    _FloorLb = [UILabel  new];
    _FloorLb.backgroundColor = [UIColor  clearColor];
    _FloorLb.textColor = UIColorFromRGB(0X999999);
    _FloorLb.font = [UIFont  systemFontOfSize:11];
    _FloorLb.textAlignment = NSTextAlignmentRight;
    [containerView   addSubview:_FloorLb];

   
    _CommentContent = [UILabel  new];
    _CommentContent.backgroundColor = [UIColor  clearColor];
    _CommentContent.textColor = UIColorFromRGB(0X666666);
    _CommentContent.font = [UIFont  systemFontOfSize:16];
    _CommentContent.textAlignment = NSTextAlignmentLeft;
    _CommentContent.numberOfLines = 0;
    [containerView   addSubview:_CommentContent];
    
    

    _AnswerImageView = [UIImageView  new];
    _AnswerImageView.backgroundColor = [UIColor  clearColor];
    [_AnswerImageView  setImageWithUrl:nil placeholderImage:[UIImage  imageNamed:@"DailyAnswerImageView"]];
    [containerView  addSubview:_AnswerImageView];
    
    
    _AnswerName = [UILabel  new];
    _AnswerName.backgroundColor = [UIColor  clearColor];
    _AnswerName.textColor = UIColorFromRGB(0x5ed7d3) ;
    _AnswerName.font = [UIFont  systemFontOfSize:12];
    _AnswerName.textAlignment = NSTextAlignmentLeft;
    _AnswerName.numberOfLines = 1;
    [_AnswerImageView   addSubview:_AnswerName];
    
    
    
    _AnswerfloorLb = [UILabel  new];
    _AnswerfloorLb.backgroundColor = [UIColor  clearColor];
    _AnswerfloorLb.textColor = UIColorFromRGB(0X999999);
    _AnswerfloorLb.font = [UIFont  systemFontOfSize:10];
    _AnswerfloorLb.textAlignment = NSTextAlignmentLeft;
    _AnswerfloorLb.numberOfLines = 1;
    [_AnswerImageView   addSubview:_AnswerfloorLb];

    
    _AnswerComment = [UILabel  new];
    _AnswerComment.backgroundColor = [UIColor  clearColor];
    _AnswerComment.textColor = UIColorFromRGB(0X666666);
    _AnswerComment.font = [UIFont  systemFontOfSize:12];
    _AnswerComment.textAlignment = NSTextAlignmentLeft;
    _AnswerComment.numberOfLines =0;
    _AnswerComment.lineBreakMode = NSLineBreakByTruncatingTail;
    [_AnswerImageView   addSubview:_AnswerComment];
 
    
    _TimeImageView = [UIImageView  new];
    _TimeImageView.backgroundColor = [UIColor  clearColor];
    [containerView  addSubview:_TimeImageView];

    _TimeLb = [UILabel  new];
    _TimeLb.backgroundColor = [UIColor  clearColor];
    _TimeLb.textColor = _FloorLb.textColor;
    _TimeLb.font = [UIFont  systemFontOfSize:11];
    _TimeLb.textAlignment = NSTextAlignmentLeft;
    _TimeLb.numberOfLines = 1;
    [containerView   addSubview:_TimeLb];

    _AnswerBtn = [UIButton new];
    _AnswerBtn.backgroundColor = [UIColor  clearColor];
    [containerView   addSubview:  _AnswerBtn];
    
    _lineLb= [UILabel  new];
    _lineLb.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [containerView  addSubview:_lineLb];
    
    


}
-(void)setPraiseList:(PraiseList *)praiseList{
    _praiseList = praiseList;
    
    [_HeadImageView  setImageWithUrl:[ NSString stringWithFormat:@"%@%@",ICON_URL,_praiseList.CHILD_IMG] placeholderImage:[UIImage  imageNamed:@"my_answer"]];

    _HeadName.text = _praiseList.NickName;


    _CommentContent.text = _praiseList.CommentContent;
    
    [_TimeImageView  setImageWithUrl:nil placeholderImage:[UIImage  imageNamed:@"DailyPrise_TimeImage"]];
    
    
    NSTimeInterval timeInterval = [_praiseList.CreateTime doubleValue];
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter  alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate  dateWithTimeIntervalSince1970:timeInterval];
    NSString*confromTimespStr = [formatter  stringFromDate:confromTimesp];

    NSString* myAnswerTime = [NSDate getDateCompare:confromTimespStr];
    _TimeLb.text = myAnswerTime;
    
    _FloorLb.text = [NSString  stringWithFormat:@"%@楼",_praiseList.RowID];
    
    
    [_AnswerBtn  setTitle:@"回复" forState:UIControlStateNormal];
    [_AnswerBtn  setTitleEdgeInsets:UIEdgeInsetsMake(-8, 0, 0, -50)];
    
    [_AnswerBtn  setTitleColor:UIColorFromRGB(0x5ed7d3) forState:UIControlStateNormal];
    _AnswerBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    _AnswerBtn.titleLabel.font = [UIFont  systemFontOfSize:11];
    
    
    
    containerView.sd_layout.topSpaceToView(self.contentView,0).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
    
    _HeadImageView.sd_layout.topSpaceToView(containerView,30/2).leftSpaceToView(containerView,30/2).widthIs(60/2).heightIs(60/2);
    _HeadImageView.sd_cornerRadiusFromWidthRatio = @(0.5);

    
    _HeadName.sd_layout.topSpaceToView(containerView,15+8).leftSpaceToView(_HeadImageView,24/2).heightIs(14).widthIs(kScreenWidth-_HeadImageView.frame.size.width-_FloorLb.frame.size.width-30/2-24/2-30/2);
    
    _FloorLb.sd_layout.topEqualToView(_HeadName).rightSpaceToView(containerView,30/2).heightIs(11).widthIs(80);
    
    _CommentContent.sd_layout.topSpaceToView(_HeadName,30/2).leftEqualToView(_HeadName).widthIs(kScreenWidth-30/2-30-24/2-30/2).autoHeightRatio(0);
    
    if ([[NSString  stringWithFormat:@"%@",_praiseList.CommentID ]  isEqualToString:@"0"]) {
        
        _AnswerImageView.hidden = YES;
        _TimeImageView.sd_layout.topSpaceToView(_CommentContent,30/2).leftEqualToView(_HeadName).widthIs(30/2).heightIs(30/2);
        _lineLb.sd_layout.topSpaceToView(_TimeImageView,30/2).leftEqualToView(containerView).rightEqualToView(containerView).heightIs(1);
        
    }else{
        _AnswerImageView.hidden = NO;
        _AnswerImageView.sd_layout.topSpaceToView(_CommentContent,30/2).leftEqualToView(_CommentContent).widthIs(kFitWidthScale(586)).heightIs(kFitHeightScale(206));
        
//        _AnswerImageView.sd_layout.topSpaceToView(_CommentContent,30/2).leftEqualToView(_CommentContent).widthIs(kFitWidthScale(586)).heightIs(kFitHeightScale(106));
        
        _AnswerName.sd_layout.topSpaceToView(_AnswerImageView,10).leftSpaceToView(_AnswerImageView,10).heightIs(12).minWidthIs(10);
         [_AnswerName setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
       
        _AnswerfloorLb.sd_layout.topEqualToView(_AnswerName).leftSpaceToView(_AnswerName,10).heightIs(10).minWidthIs(30);
         [_AnswerfloorLb setSingleLineAutoResizeWithMaxWidth:kScreenWidth];

        
        _AnswerComment.sd_layout.topSpaceToView(_AnswerName,10).leftSpaceToView(_AnswerImageView,10).rightSpaceToView(_AnswerImageView,20).heightIs(kFitHeightScale(206)-40);
        
        _TimeImageView.sd_layout.topSpaceToView(_AnswerImageView,30/2).leftEqualToView(_HeadName).widthIs(30/2).heightIs(30/2);
        [_TimeImageView   updateLayout];
        
        _lineLb.sd_layout.topSpaceToView(_TimeImageView,30/2).leftEqualToView(containerView).rightEqualToView(containerView).heightIs(1);

        
        
    }
    
    
    _TimeLb.sd_layout.topEqualToView(_TimeImageView).leftSpaceToView(_TimeImageView,5).widthIs(100).heightIs(11);
    
    _AnswerBtn.sd_layout.topEqualToView(_TimeImageView).rightEqualToView(containerView).widthIs(100).heightIs(20);
    

    
    [containerView  setupAutoHeightWithBottomViewsArray:@[_lineLb] bottomMargin:0];
    
[self setupAutoHeightWithBottomView:containerView bottomMargin:0];

}
-(void)layoutSubviews{
    _AnswerComment.numberOfLines = 3;
    _AnswerComment.lineBreakMode = NSLineBreakByTruncatingTail;
    [_AnswerComment sizeToFit];
    
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
