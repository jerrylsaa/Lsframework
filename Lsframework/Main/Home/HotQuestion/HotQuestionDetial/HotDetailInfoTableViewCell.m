//
//  HotDetailInfoTableViewCell.m
//  FamilyPlatForm
//
//  Created by jerry on 16/9/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HotDetailInfoTableViewCell.h"
#import "JMFoundation.h"
#import "ApiMacro.h"

#define HaveImageWidth   kScreenWidth-30/2-30-24/2-30/2
#define PhotoSpace  15
#define PhotoWidth  (HaveImageWidth-PhotoSpace*2)/3
#define PhotoHeight (HaveImageWidth-PhotoSpace*2)/3


@interface HotDetailInfoTableViewCell(){
    UIView *_containerView;
    UIImageView  *_HeadImageView;
    UILabel  *_HeadName;
    UILabel  *_FloorLb;
    UILabel  *_CommentContent;
    UIImageView  *_TimeImageView;
    UILabel  *_TimeLb;
    
    
    UIImageView  *_AnswerImageView;
    UILabel   *_AnswerCount;
    UILabel   *_lineLb;

    UIButton *smallDeleteBtn;


}

@end

@implementation HotDetailInfoTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setConView];
        self.contentView.backgroundColor = [UIColor  whiteColor];
    }
    return self;
}


-(void)setConView{
    
    _containerView  = [UIView new];
    
    _containerView.userInteractionEnabled = YES;
    [self.contentView addSubview:_containerView];
    
    _HeadImageView = [UIImageView  new];
    
    _HeadImageView.backgroundColor = [UIColor  clearColor];
    [_containerView  addSubview:_HeadImageView];
    
    
    _HeadName = [UILabel  new];
    _HeadName.backgroundColor = [UIColor  clearColor];
    _HeadName.textColor = UIColorFromRGB(0X333333);
    _HeadName.font = [UIFont  systemFontOfSize:14];
    _HeadName.textAlignment = NSTextAlignmentLeft;
    [_containerView   addSubview:_HeadName];
    
    
    _FloorLb = [UILabel  new];
    _FloorLb.backgroundColor = [UIColor  clearColor];
    _FloorLb.textColor = UIColorFromRGB(0X999999);
    _FloorLb.font = [UIFont  systemFontOfSize:11];
    _FloorLb.textAlignment = NSTextAlignmentRight;
    [_containerView   addSubview:_FloorLb];
    
    
    _CommentContent = [UILabel  new];
    _CommentContent.backgroundColor = [UIColor  clearColor];
    _CommentContent.textColor = UIColorFromRGB(0X666666);
    _CommentContent.font = [UIFont  systemFontOfSize:16];
    _CommentContent.textAlignment = NSTextAlignmentLeft;
    _CommentContent.isAttributedContent = YES;
    [_containerView   addSubview:_CommentContent];
    
    
    
    _TimeImageView = [UIImageView  new];
    _TimeImageView.backgroundColor = [UIColor  clearColor];
    [_containerView  addSubview:_TimeImageView];
    
    _TimeLb = [UILabel  new];
    _TimeLb.backgroundColor = [UIColor  clearColor];
    _TimeLb.textColor = _FloorLb.textColor;
    _TimeLb.font = [UIFont  systemFontOfSize:11];
    _TimeLb.textAlignment = NSTextAlignmentLeft;
    _TimeLb.numberOfLines = 1;
    [_containerView   addSubview:_TimeLb];
    
    
    _deleteBtn = [UIButton new];
    [_deleteBtn addTarget:self action:@selector(deleteBtns:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_deleteBtn];
    
    smallDeleteBtn = [UIButton new];
    [smallDeleteBtn setImage:[UIImage imageNamed:@"Trash"] forState:UIControlStateNormal];
    [smallDeleteBtn addTarget:self action:@selector(deleteBtns:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:smallDeleteBtn];
    
    
    
    _lineLb= [UILabel  new];
    _lineLb.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_containerView  addSubview:_lineLb];
    
}
-(void)setReplyList:(ConsulationReplyList *)ReplyList{
    
    _ReplyList = ReplyList;
    
    if ((ReplyList.UserID == kCurrentUser.userId)) {
        
        smallDeleteBtn.hidden = _deleteBtn.hidden = NO;
        
    }else
    {
        smallDeleteBtn.hidden= _deleteBtn.hidden = YES;
    }
    
    [_HeadImageView  setImageWithUrl:[ NSString stringWithFormat:@"%@%@",ICON_URL,_ReplyList.UserPic] placeholderImage:[UIImage  imageNamed:@"my_answer"]];
    
    _HeadName.text = _ReplyList.NickName;
    
    
 _CommentContent.attributedText = [UILabel getAttributeTextWithString:_ReplyList.CommentContent];
    
    [_TimeImageView  setImageWithUrl:nil placeholderImage:[UIImage  imageNamed:@"DailyPrise_TimeImage"]];
    
    
//    NSTimeInterval timeInterval = [_ReplyList.CreateTime doubleValue];
//    NSDateFormatter *formatter = [[NSDateFormatter  alloc]init];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSDate *confromTimesp = [NSDate  dateWithTimeIntervalSince1970:timeInterval];
//    NSString*confromTimespStr = [formatter  stringFromDate:confromTimesp];
//    
//    NSString* myAnswerTime = [NSDate getDateCompare:confromTimespStr];
//    _TimeLb.text = myAnswerTime;

//    _TimeLb.text = [NSDate getDateCompare:[_ReplyList.replyTime format2String:@"yyyy-MM-dd HH:mm:ss"]];
    _TimeLb.text = _ReplyList.replyTime;
    
//    _FloorLb.text = [NSString  stringWithFormat:@"%ld楼",_CommenList.RowID];
        _FloorLb.text = [NSString  stringWithFormat:@"%ld楼",_ReplyList.RowID+1];
    
    
    _containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    
    _HeadImageView.sd_layout.topSpaceToView(_containerView,30/2).leftSpaceToView(_containerView,30/2).widthIs(60/2).heightIs(60/2);
    _HeadImageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    
    _HeadName.sd_layout.topSpaceToView(_containerView,15+8).leftSpaceToView(_HeadImageView,24/2).heightIs(14).widthIs(kScreenWidth-_HeadImageView.frame.size.width-_FloorLb.frame.size.width-30/2-24/2-30/2);
    
    _FloorLb.sd_layout.topEqualToView(_HeadName).rightSpaceToView(_containerView,30/2).heightIs(11).widthIs(80);
    
    _CommentContent.sd_layout.topSpaceToView(_HeadName,30/2).leftEqualToView(_HeadName).widthIs(kScreenWidth-30/2-30-24/2-30/2).autoHeightRatio(0);
    
        _TimeImageView.sd_layout.topSpaceToView(_CommentContent,30/2).leftEqualToView(_HeadName).widthIs(30/2).heightIs(30/2);

    _TimeLb.sd_layout.topEqualToView(_TimeImageView).leftSpaceToView(_TimeImageView,5).widthIs(kJMWidth(_TimeLb)).heightIs(11);
    
    smallDeleteBtn.sd_layout.centerYEqualToView(_TimeImageView).rightEqualToView(_FloorLb).widthIs(15).heightIs(15);
    _deleteBtn.sd_layout.centerYEqualToView(_TimeImageView).rightEqualToView(smallDeleteBtn).widthIs(50).heightIs(50);
    
    
    _lineLb.sd_layout.topSpaceToView(_TimeLb,30/2).leftEqualToView(_containerView).rightEqualToView(_containerView).heightIs(1);
    
    [_containerView  setupAutoHeightWithBottomView:_lineLb bottomMargin:0];
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
    
    
}

-(void)deleteBtns:(UIButton *)button
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
