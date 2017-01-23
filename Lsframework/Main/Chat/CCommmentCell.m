//
//  CCommmentCell.m
//  FamilyPlatForm
//
//  Created by Mac on 16/12/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CCommmentCell.h"
#import "ApiMacro.h"
@interface CCommmentCell ()

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UILabel *contentLb;
@property(nonatomic,strong)UILabel *timeLb;
@property(nonatomic,strong)UILabel *describeLb;
@property(nonatomic,strong)UIImageView *picImg;
@property(nonatomic,strong)UIImageView *lineImg;

@property(nonatomic,strong) UILabel *unreadLabel;
@end
@implementation CCommmentCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpView];
    }
    return self;
}
-(void)setUpView
{
    // 背景
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_bgView];
    
    // 图片
    _picImg = [UIImageView new];
    _picImg.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_picImg];
    
    
    
    // 线
    _lineImg = [UIImageView new];
    _lineImg.backgroundColor = [UIColor clearColor];
    _lineImg.image = [UIImage imageNamed:@"line_short"];
    [_bgView addSubview:_lineImg];
    
    // 标题
    _titleLb = [[UILabel alloc]init];
    _titleLb.backgroundColor = [UIColor clearColor];
    _titleLb.font = [UIFont systemFontOfSize:28/2];
    _titleLb.textColor = UIColorFromRGB(0x333333);
    [_bgView addSubview:_titleLb];
    
    // 描述
    _describeLb = [[UILabel alloc]init];
    _describeLb.backgroundColor = [UIColor clearColor];
    _describeLb.font = [UIFont systemFontOfSize:28/2];
    _describeLb.textColor = UIColorFromRGB(0x2dcbc4);
    _describeLb.lineBreakMode = NSLineBreakByTruncatingTail;
    [_bgView addSubview:_describeLb];
    
    // 内容
    _contentLb = [[UILabel alloc]init];
    _contentLb.backgroundColor = [UIColor clearColor];
    _contentLb.font = [UIFont systemFontOfSize:24/2];
    _contentLb.textColor = UIColorFromRGB(0x989898);
    _contentLb.numberOfLines = 1;
    _contentLb.isAttributedContent = YES;
    _contentLb.lineBreakMode= NSLineBreakByTruncatingTail;
    [_bgView addSubview:_contentLb];
    
    // 时间
    _timeLb = [[UILabel alloc]init];
    _timeLb.backgroundColor = [UIColor clearColor];
    _timeLb.font = [UIFont systemFontOfSize:22/2];
    _timeLb.textColor = UIColorFromRGB(0x999999);
    [_bgView addSubview:_timeLb];
    
    //
    _redDotImg = [UIImageView new];
    _redDotImg.image = [UIImage imageNamed:@"redDot"];
    [_bgView addSubview:_redDotImg];
    
    _bgView.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    _picImg.sd_layout.leftSpaceToView(_bgView,15).topSpaceToView(_bgView,15).widthIs(kFitWidthScale(100)).heightIs(kFitHeightScale(100));
    _picImg.sd_cornerRadiusFromWidthRatio =@0.5;
    
    _redDotImg.sd_layout.leftSpaceToView(_picImg,-8).topSpaceToView(_bgView,15).widthIs(8).heightIs(8);
    _redDotImg.sd_cornerRadiusFromWidthRatio = @(0.5);
    _titleLb.sd_layout.topSpaceToView(_bgView,23).leftSpaceToView(_picImg,15).widthIs(28).heightIs(15);
    _describeLb.sd_layout.topEqualToView(_titleLb).leftSpaceToView(_titleLb,7).widthIs(60).heightIs(15);
    _contentLb.sd_layout.topSpaceToView(_titleLb,7).leftEqualToView(_titleLb).rightSpaceToView(_bgView,15).heightIs(18);
    
    _timeLb.sd_layout.topSpaceToView(_contentLb,12/2).rightSpaceToView(_bgView,15).widthIs(22).heightIs(11);
    
    _lineImg.sd_layout.leftEqualToView(_titleLb).topSpaceToView(_timeLb,5).heightIs(1).rightSpaceToView(_bgView,0);
    [_bgView setupAutoHeightWithBottomView:_lineImg bottomMargin:0];
    [self setupAutoHeightWithBottomView:_bgView bottomMargin:0];
}
-(void)setComment:(CMyComment *)comment
{
    if ([comment isKindOfClass:[CMyComment class]]) {
        
        _comment = comment;
        NSString *imagePath = [NSString stringWithFormat:@"%@%@",ICON_URL,comment.CHILD_IMG];
        
        [_picImg sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        _describeLb.text = comment.Message;
//        _contentLb.text = comment.Content;
        _contentLb.attributedText = [UILabel getAttributeTextWithString:[NSString  stringWithFormat:@"%@",comment.Content]];
        _timeLb.text = comment.Time;
        _titleLb.text = comment.NickName;
        
        if (comment.IsRead == YES) {
            _redDotImg.hidden = YES;
        }else{
            _redDotImg.hidden = NO;
        }
        
        _titleLb.width = [JMFoundation calLabelWidth:_titleLb];
        [_titleLb updateLayout];
        
        
        _contentLb.width = [JMFoundation calLabelWidth:_contentLb];
        [_contentLb updateLayout];
        
        _timeLb.width = [JMFoundation calLabelWidth:_timeLb];
        [_timeLb updateLayout];
        
        _describeLb.width = [JMFoundation calLabelWidth:_describeLb];
        [_describeLb updateLayout];
        
        
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
