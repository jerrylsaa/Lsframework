//
//  ChatCell.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ChatCell.h"
#import "JMFoundation.h"
#import "ApiMacro.h"


@interface ChatCell ()<UIAlertViewDelegate>



@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIImageView *chatBackView;
@property (nonatomic, strong) UILabel *chatLabel;
@property (nonatomic, strong) UIImageView *chatImage;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
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
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressAction:)];
    [_chatBackView addGestureRecognizer:press];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapAction)];
    [_chatBackView addGestureRecognizer:tap];

    
    
}
- (void)setTalkType:(TalkType )talkType{
    _talkType = talkType;
}
- (void)setIsTime:(BOOL)isTime{
    _isTime = isTime;
    if (_isTime == YES) {
        _timeLabel.hidden = NO;
    }else{
        _timeLabel.hidden = YES;
    }
}
- (void)setChat:(ChatEntity *)chat{
    _chat = chat;
    //这段应该在baseCell里用来继承
    if (_talkType == TalkTypeSend) {
        _icon.sd_layout.rightSpaceToView(self.contentView,15).topSpaceToView(self.contentView,35).widthIs(40).heightIs(40);
        _icon.sd_cornerRadius = @20;
        _chatBackView.sd_layout.topSpaceToView(self.contentView,30).rightSpaceToView(_icon,5).widthIs(100).heightIs(40);
        _chatLabel.sd_layout.leftSpaceToView(_chatBackView,10).topSpaceToView(_chatBackView,10).rightSpaceToView(_chatBackView,20).heightIs(20);
        
    }else{
        _icon.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(self.contentView,35).widthIs(40).heightIs(40);
        _icon.sd_cornerRadius = @20;
        _chatBackView.sd_layout.topSpaceToView(self.contentView,30).leftSpaceToView(_icon,5).widthIs(100).heightIs(40);
        _chatLabel.sd_layout.rightSpaceToView(_chatBackView,10).topSpaceToView(_chatBackView,10).leftSpaceToView(_chatBackView,20).heightIs(20);
    }
    
    NSURL *imageUrl;
    if (_talkType == TalkTypeSend) {
        imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,chat.SendUserImg]];
    }else{
        imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,chat.SendUserImg]];
    }
    
    [_icon sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _chatLabel.attributedText = [UILabel getAttributeTextWithString:_chat.Content];
    _timeLabel.text = [self time:_chat.CreateDate];
    _timeLabel.sd_layout.topSpaceToView(self,10).widthIs(120).centerXEqualToView(self).heightIs(12);
    _timeLabel.sd_cornerRadius = @2;
    _chatBackView.sd_layout.widthIs(kScreenWidth - 120 );
    _chatLabel.sd_layout.autoHeightRatio(0);
    [_chatBackView setupAutoHeightWithBottomView:_chatLabel bottomMargin:10];
    [self setupAutoHeightWithBottomView:_chatBackView bottomMargin:0];

    UIImage *image;
    if (self.talkType == TalkTypeSend) {
        image = [UIImage imageNamed:@"chat_right"];
    }else{
        image = [UIImage imageNamed:@"chat_left"];
    }
    //图片展示
    if (self.displayType == DisplayTypeImage) {
        _chatLabel.hidden = YES;
        if (!_image) {
            _image = [UIImage imageNamed:@"chat_default"];
        }
        if (_image) {
//            CGSize size = _image.size;
            //根据图片大小布局
            CGFloat height = _image.size.height;
            CGFloat width = _image.size.width;
            CGFloat scole = _image.size.width/_image.size.height;
            if (width > kScreenWidth - 120) {
                width = kScreenWidth-120;
            }
            
            height = width/scole+20;
            
            _chatImage.image = _image;
            if (_talkType == TalkTypeSend) {
                _chatImage.sd_layout.leftSpaceToView(_chatBackView,5).rightSpaceToView(_chatBackView,15).topSpaceToView(_chatBackView,10).heightIs(height-20);
            }else{
                _chatImage.sd_layout.leftSpaceToView(_chatBackView,15).rightSpaceToView(_chatBackView,5).topSpaceToView(_chatBackView,10).heightIs(height-20);
            }
            _chatBackView.sd_layout.heightIs(height).widthIs(width+20);
            [_chatBackView setupAutoHeightWithBottomView:_chatImage bottomMargin:10];
        }else{
            
        }
    }else{
        _chatLabel.hidden = NO;
    }
    _chatBackView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15) resizingMode:UIImageResizingModeStretch];
    [self setupAutoHeightWithBottomView:_chatBackView bottomMargin:20];
}

- (void)pressAction:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIAlertView *tipsView = [[UIAlertView alloc] initWithTitle:nil message:@"是否删除此条记录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"是",@"否", nil];
        [tipsView show];
  
    }else {
      
    }
}
-(void)TapAction{
    if (self.delegate) {
        [self.delegate enterCellForIndexPath:self.indexPath];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (self.delegate) {
            [self.delegate cancelCellForIndexPath:self.indexPath];
        }
    }
}
@end
