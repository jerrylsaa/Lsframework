//
//  CSystemNoticeCell.m
//  FamilyPlatForm
//
//  Created by Mac on 16/12/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CSystemNoticeCell.h"
#import "ApiMacro.h"
@interface CSystemNoticeCell ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIImageView *chatBackView;
@property (nonatomic, strong) UILabel *chatLabel;
@property (nonatomic, strong) UIImageView *chatImage;
@property (nonatomic, strong) UILabel *timeLabel;


@end
@implementation CSystemNoticeCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpView];
    }
    return  self;
}
-(void)setUpView
{
//    self.contentView.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:0.5];
    
    _icon = [UIImageView new];
    [self.contentView addSubview:_icon];
    
    _chatBackView = [UIImageView new];
    _chatBackView.userInteractionEnabled = YES;
    _chatBackView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_chatBackView];
    
    _chatLabel = [UILabel new];
    _chatLabel.numberOfLines = 0;
    _chatLabel.userInteractionEnabled = YES;
    _chatLabel.isAttributedContent = YES;
    _chatLabel.font = [UIFont systemFontOfSize:14];
    _chatLabel.backgroundColor = [UIColor clearColor];
    [_chatBackView addSubview:_chatLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.backgroundColor = UIColorFromRGB(0xd2d2d2);
    _timeLabel.font = [UIFont systemFontOfSize:10];
    _timeLabel.textColor = [UIColor whiteColor];
    [self addSubview:_timeLabel];
    
    _chatImage = [UIImageView new];
    [_chatBackView addSubview:_chatImage];
    
    
    
}
-(void)setSystemModel:(SystemNotice *)systemModel
{
    if ([systemModel isKindOfClass:[SystemNotice class]]) {
        
        _systemModel = systemModel;
        _icon.image = [UIImage imageNamed:@"smallnotice_icon"];
        _chatLabel.text  = systemModel.Content;
        _timeLabel.text = systemModel.Time;
        
        _icon.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(self.contentView,35).widthIs(50).heightIs(50);
        _icon.sd_cornerRadius = @25;
        _chatBackView.sd_layout.topSpaceToView(self.contentView,30).leftSpaceToView(_icon,5).widthIs(100).heightIs(40);
        _chatLabel.sd_layout.rightSpaceToView(_chatBackView,10).topSpaceToView(_chatBackView,10).leftSpaceToView(_chatBackView,20).heightIs(20);
        
        _timeLabel.sd_layout.topSpaceToView(self,10).widthIs(120).centerXEqualToView(self).heightIs(12);
        _timeLabel.sd_cornerRadius = @2;
        _chatBackView.sd_layout.widthIs(kScreenWidth - 120 );
        _chatLabel.sd_layout.autoHeightRatio(0);
        [_chatBackView setupAutoHeightWithBottomView:_chatLabel bottomMargin:10];
        [self setupAutoHeightWithBottomView:_chatBackView bottomMargin:0];
        
        UIImage *image;
        image = [UIImage imageNamed:@"newchat_gray_shape"];
        _chatBackView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15) resizingMode:UIImageResizingModeStretch];
        [self setupAutoHeightWithBottomView:_chatBackView bottomMargin:20];
        
        
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
