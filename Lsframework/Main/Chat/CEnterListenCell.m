//
//  CEnterListenCell.m
//  FamilyPlatForm
//
//  Created by Mac on 16/12/16.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CEnterListenCell.h"
#import "ApiMacro.h"

@interface CEnterListenCell ()

@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *describleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIView *messageView;
@property(nonatomic,strong)UILabel *messageLabel;



@end

@implementation CEnterListenCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpView];
    }
    return self;
}
-(void)setUpView
{
    _icon = [UIImageView new];
    _icon.image = [UIImage imageNamed:@"smallnotice_icon"];
    [self.contentView addSubview:_icon];
    
    _nameLabel = [UILabel new];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    // 描述
    _describleLabel = [[UILabel alloc]init];
    _describleLabel.backgroundColor = [UIColor clearColor];
    _describleLabel.font = [UIFont systemFontOfSize:14];
    _describleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _describleLabel.textColor = UIColorFromRGB(0x2dcbc4);
    [self.contentView addSubview:_describleLabel];
    
    // 时间
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont systemFontOfSize:22/2];
    _timeLabel.textColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:_timeLabel];
    
    // 内容
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.font = [UIFont systemFontOfSize:28/2];
    _contentLabel.textColor = UIColorFromRGB(0x33333);
    _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_contentLabel];
    
    _messageView = [UIView new];
    _messageView.layer.borderWidth = 1;
    _messageView.layer.borderColor = UIColorFromRGB(0x61d8d3).CGColor;
    _messageView.layer.masksToBounds = YES;
    _messageView.layer.cornerRadius = 5;
    _messageView.backgroundColor = UIColorFromRGB(0xfbffff);
    [self.contentView addSubview:_messageView];
    
    // 回答内容
    _messageLabel = [[UILabel alloc]init];
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.font = [UIFont systemFontOfSize:26/2];
    _messageLabel.textColor = UIColorFromRGB(0x666666);
    _messageLabel.isAttributedContent = YES;
    [_messageView addSubview:_messageLabel];
    
}

-(void)setListen:(CConsultationBeListen *)listen
{
    
    if ([listen isKindOfClass:[CConsultationBeListen class]]) {
        
        _listen = listen;
        NSString *imagePath = [NSString stringWithFormat:@"%@%@",ICON_URL,listen.CHILD_IMG];
        [_icon sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        _timeLabel.text = listen.Time;
        _describleLabel.text = listen.Message;
        _nameLabel.text = listen.NickName;
        _messageLabel.attributedText = [UILabel getAttributeTextWithString:[NSString  stringWithFormat:@"%@",listen.Content]];
        _messageLabel.width = [JMFoundation calLabelHeght:_messageLabel];
        [_messageLabel updateLayout];
        
        CGFloat width = kScreenWidth - 30;
        _icon.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(self.contentView,15).widthIs(50).heightIs(50);
        _icon.sd_cornerRadius = @25;
        _nameLabel.sd_layout.leftSpaceToView(_icon,15).topSpaceToView(self.contentView,25).widthIs([JMFoundation calLabelWidth:_nameLabel]).heightIs(15);
        CGFloat describleWidth = kScreenWidth-30-_icon.width-_nameLabel.width-30;
        _describleLabel.sd_layout.leftSpaceToView(_nameLabel,15).topEqualToView(_nameLabel).widthIs(describleWidth).heightIs(15);
        _timeLabel.sd_layout.leftEqualToView(_nameLabel).topSpaceToView(_nameLabel,8).autoHeightRatio(0);
        [_timeLabel setSingleLineAutoResizeWithMaxWidth:150];
        _messageView.sd_layout.topSpaceToView(_icon,10).widthIs(width).leftEqualToView(_icon);
        CGFloat margin = 8;
        _messageLabel.sd_layout.leftSpaceToView(_messageView,margin).topSpaceToView(_messageView,margin).autoHeightRatio(0).widthIs(width -2*margin);
        [_messageLabel setSingleLineAutoResizeWithMaxWidth:width- 2*margin];
        [_messageView setupAutoHeightWithBottomView:_messageLabel bottomMargin:margin];
        [self setupAutoHeightWithBottomView:_messageView bottomMargin:0];
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