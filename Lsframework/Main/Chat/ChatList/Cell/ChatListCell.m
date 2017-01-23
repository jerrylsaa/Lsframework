//
//  ChatListCell.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ChatListCell.h"
#import "ApiMacro.h"

@interface ChatListCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *unReadLabel;

@property(nonatomic,strong)UIImageView *redDotImg;

@end

@implementation ChatListCell

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
    [self setupHeadImageView];
    [self setupNameLabel];
    [self setupTimeLabel];
    [self setupContentLabel];
    [self setupUnreadLabel];
}
- (void)setupHeadImageView{
    _headImageView = [UIImageView new];
    _headImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_headImageView];
    _headImageView.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(self.contentView,10).bottomSpaceToView(self.contentView,10).widthEqualToHeight(1);
    _headImageView.sd_cornerRadius = @20;
    
    _redDotImg = [UIImageView new];
    _redDotImg.image = [UIImage imageNamed:@"redDot"];
    [self.contentView addSubview:_redDotImg];
    
    _redDotImg.sd_layout.leftSpaceToView(_headImageView,-8).topSpaceToView(self.contentView,15).widthIs(8).heightIs(8);
    _redDotImg.sd_cornerRadiusFromWidthRatio = @(0.5);
}
- (void)setupNameLabel{
    _nameLabel = [UILabel new];
    _nameLabel.userInteractionEnabled = YES;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _nameLabel.textColor = UIColorFromRGB(0x666666);
    _nameLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.sd_layout.leftSpaceToView(_headImageView,10).topSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,100).heightIs(15);
}
- (void)setupTimeLabel{
    _timeLabel = [UILabel new];
    _timeLabel.userInteractionEnabled = YES;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = UIColorFromRGB(0x989898);
    [self.contentView addSubview:_timeLabel];
    _timeLabel.sd_layout.leftSpaceToView(_nameLabel,5).rightSpaceToView(self.contentView,10).topSpaceToView(self.contentView,20).heightIs(10);
}
- (void)setupContentLabel{
    _contentLabel = [UILabel new];
    _contentLabel.isAttributedContent = YES;
    _contentLabel.userInteractionEnabled = YES;
    _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.textColor = _timeLabel.textColor;
    [self.contentView addSubview:_contentLabel];
    _contentLabel.sd_layout.leftEqualToView(_nameLabel).topSpaceToView(_nameLabel,5).rightSpaceToView(self.contentView,50).heightIs(20);
}
- (void)setupUnreadLabel{
    _unReadLabel = [UILabel new];
    _unReadLabel.userInteractionEnabled = YES;
    _unReadLabel.textAlignment = NSTextAlignmentCenter;
    _unReadLabel.font = [UIFont systemFontOfSize:12];
    _unReadLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_unReadLabel];
    _unReadLabel.sd_layout.rightSpaceToView(self.contentView,10).bottomSpaceToView(self.contentView,10).widthIs(30).heightIs(15);
    _unReadLabel.sd_cornerRadius = @7.5;
    
    UIView *sepView = [UIView new];
    sepView.backgroundColor = UIColorFromRGB(0xefefef);
    [self.contentView addSubview:sepView];
    sepView.sd_layout.leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).bottomSpaceToView(self.contentView,0).heightIs(1);
}

- (void)setConversation:(Conversation *)conversation{
    
    _conversation = conversation;
    NSString *imagePath = [NSString stringWithFormat:@"%@%@",ICON_URL,_conversation.UserImg];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    if (conversation.IsRead == YES) {
        _redDotImg.hidden = YES;
    }else{
        _redDotImg.hidden = NO;
    }
        
    
    _nameLabel.text = _conversation.NickName;
//    NSString *dateString;
//    if (_conversation.ModifyDate) {
//        dateString = _conversation.ModifyDate;
//    }else{
//        dateString = _conversation.CreateDate;
//    }
//    _timeLabel.text = [self dateToStringFrom:dateString];
    _timeLabel.text = _conversation.CreateDate;
    _contentLabel.attributedText = [UILabel getAttributeTextWithString:_conversation.NewContent];
//    NSInteger count = [_conversation.UnreadCount integerValue];
//    
    NSString *unReadText;
//    if (count == 0) {
//        _unReadLabel.sd_layout.heightIs(0);
//        _unReadLabel.backgroundColor = [UIColor clearColor];
//    }else{
//        _unReadLabel.sd_layout.heightIs(15);
//        _unReadLabel.backgroundColor = [UIColor redColor];
//        if (count > 99) {
//            unReadText = @"99+";
//        }else{
//            unReadText = [NSString stringWithFormat:@"%ld",(long)count];
//        }
//    }
    _unReadLabel.text = unReadText;
    [_unReadLabel updateLayout];
}
- (NSString *)dateToStringFrom:(NSString *)time{
    if (time == nil || [time isEqualToString:@""]) {
        return @"";
    }
    NSTimeInterval timeInterval = [time longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    //判断
    NSDateFormatter *formatter = [NSDateFormatter new];
    //年
    [formatter setDateFormat:@"yyyy"];
    long timeValue = [[formatter stringFromDate:date] longLongValue];
    long timeToday = [[formatter stringFromDate:[NSDate date]] longLongValue];
    if (timeToday > timeValue) {
        if (timeToday - timeValue < 5) {
            return [NSString stringWithFormat:@"%ld年前",timeToday - timeValue];
        }else{
            return [NSString stringWithFormat:@"%@年",[formatter stringFromDate:date]];
        }
    }
    //月
    [formatter setDateFormat:@"MM"];
    timeValue = [[formatter stringFromDate:date] longLongValue];
    timeToday = [[formatter stringFromDate:[NSDate date]] longLongValue];
    if (timeToday > timeValue) {
        if (timeToday - timeValue == 1) {
            return @"上个月";
        }else{
            [formatter setDateFormat:@"MM-dd"];
            return [formatter stringFromDate:date];
        }
    }
    //日
    [formatter setDateFormat:@"dd"];
    timeValue = [[formatter stringFromDate:date] longLongValue];
    timeToday = [[formatter stringFromDate:[NSDate date]] longLongValue];
    NSInteger day = timeToday - timeValue;
    if (day == 1) {
        return @"昨天";
    }else if (day == 2){
        return @"前天";
    }else if (day > 2){
        [formatter setDateFormat:@"MM-dd hh:mm"];
        return [formatter stringFromDate:date];
    }else if(day == 0){
        [formatter setDateFormat:@"hh:mm:ss"];
        return [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    }
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}



@end
