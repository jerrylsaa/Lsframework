//
//  DailyArticleDetailTableViewCell.m
//  FamilyPlatForm
//
//  Created by jerry on 16/9/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DailyArticleDetailTableViewCell.h"
#import "JMFoundation.h"
#import "ApiMacro.h"
@implementation DailyArticleDetailTableViewCell

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
    _HeadImageView.layer.masksToBounds = YES;
_HeadImageView.layer.cornerRadius = _HeadImageView.size.height/2;

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
    
    
    _deleteBtn = [UIButton new];
    [_deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:_deleteBtn];
    
    _smallDeleteBtn = [UIButton new];
    [_smallDeleteBtn setImage:[UIImage imageNamed:@"Trash"] forState:UIControlStateNormal];
    [_smallDeleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:_smallDeleteBtn];
    
    
    
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
    
    _FloorLb.text = [NSString  stringWithFormat:@"%ld楼",[_praiseList.RowID integerValue]+1];
    
     NSInteger userid = [praiseList.UserID integerValue];
    
    if (userid == kCurrentUser.userId) {
        
        _smallDeleteBtn.hidden = _deleteBtn.hidden = NO;
        
    }else
    {
        _smallDeleteBtn.hidden= _deleteBtn.hidden = YES;
    }
    
    
    containerView.sd_layout.topSpaceToView(self.contentView,0).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
    
    _HeadImageView.sd_layout.topSpaceToView(containerView,30/2).leftSpaceToView(containerView,30/2).widthIs(60/2).heightIs(60/2);
    _HeadImageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    _HeadName.sd_layout.topSpaceToView(containerView,15+8).leftSpaceToView(_HeadImageView,24/2).heightIs(14).widthIs(kScreenWidth-_HeadImageView.frame.size.width-_FloorLb.frame.size.width-30/2-24/2-30/2);

    _FloorLb.sd_layout.topEqualToView(_HeadName).rightSpaceToView(containerView,30/2).heightIs(11).widthIs(80);
    

    _CommentContent.sd_layout.topSpaceToView(_HeadName,30/2).leftEqualToView(_HeadName).widthIs(kScreenWidth-30/2-30-24/2-30/2).autoHeightRatio(0);

    _TimeImageView.sd_layout.topSpaceToView(_CommentContent,30/2).leftEqualToView(_HeadName).widthIs(30/2).heightIs(30/2);
    
    _TimeLb.sd_layout.topEqualToView(_TimeImageView).leftSpaceToView(_TimeImageView,5).widthIs(100).heightIs(11);
    
    _smallDeleteBtn.sd_layout.centerYEqualToView(_TimeImageView).rightEqualToView(_FloorLb).widthIs(15).heightIs(15);
    _deleteBtn.sd_layout.centerYEqualToView(_TimeImageView).rightEqualToView(_smallDeleteBtn).widthIs(50).heightIs(50);
    
    _lineLb.sd_layout.topSpaceToView(_TimeImageView,30/2).leftEqualToView(containerView).rightEqualToView(containerView).heightIs(1);

    
    [containerView  setupAutoHeightWithBottomView:_lineLb bottomMargin:0];
    [self setupAutoHeightWithBottomView:containerView bottomMargin:0];
    
}

-(void)deleteBtn:(UIButton *)button
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleButtonWithIndexPath:)]) {
        [self.delegate deleButtonWithIndexPath:self];
    }
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
