//
//  MyAnswerTableViewCell.m
//  FamilyPlatForm
//
//  Created by jerry on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyAnswerTableViewCell.h"
#import "JMFoundation.h"

@implementation MyAnswerTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
//        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _containerView = [UIView new];
    _containerView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:_containerView];
    
//    _icon = [UIImageView new];
//    _icon.userInteractionEnabled = YES;
//    [_containerView addSubview:_icon];
    
//    _myName = [UILabel new];
//    _myName.textColor = UIColorFromRGB(0x333333);
//    _myName.font = [UIFont systemFontOfSize:16];
//    [_containerView addSubview:_myName];
    
    _watingLable = [UILabel new];
    _watingLable.font = [UIFont systemFontOfSize:15];
    _watingLable.textAlignment = NSTextAlignmentRight;
    [_containerView addSubview:_watingLable];
    
    _questionLabel = [UILabel new];
    _questionLabel.textColor = UIColorFromRGB(0x5D5D5D);
    _questionLabel.font = [UIFont systemFontOfSize:16];
    [_containerView addSubview:_questionLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = UIColorFromRGB(0x999999);
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.numberOfLines = 0;
    [_containerView addSubview:_timeLabel];
    
    _listenLable = [UILabel new];
    _listenLable.textColor = _timeLabel.textColor;
    _listenLable.font = _timeLabel.font;
    _listenLable.textAlignment = NSTextAlignmentRight;
    [_containerView addSubview:_listenLable];
    
    _containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
//    _icon.sd_layout.topSpaceToView(_containerView,10).leftSpaceToView(_containerView,10).widthIs(30).heightEqualToWidth();
//    _myName.sd_layout.topSpaceToView(_containerView,33/2.0).leftSpaceToView(_icon,15).autoHeightRatio(0);
    CGFloat width = [JMFoundation calLabelWidth:_watingLable.font andStr:@"待回答" withHeight:15];
    _watingLable.sd_layout.topSpaceToView(_containerView,33/2.0).rightSpaceToView(_containerView,10).widthIs(width + 5).autoHeightRatio(0);
    _questionLabel.sd_layout.topSpaceToView(_containerView,33/2.0).leftSpaceToView(_containerView,15).autoHeightRatio(0).rightSpaceToView(_watingLable,10);
    _timeLabel.sd_layout.topSpaceToView(_questionLabel,15).leftSpaceToView(_containerView,10).rightEqualToView(_questionLabel).autoHeightRatio(0);
    _listenLable.sd_layout.topSpaceToView(_questionLabel,15).rightSpaceToView(_containerView,10).autoHeightRatio(0);
    [_containerView setupAutoHeightWithBottomView:_listenLable bottomMargin:10];
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:5/2.0];
    
    
}

- (void)setMyAnswer:(MyAnserEntity *)MyAnswer{
    _myAnswer = MyAnswer;
    //用户的照片为空
//    [_icon  sd_setImageWithURL:[NSURL  URLWithString:@""] placeholderImage:[UIImage  imageNamed:@"my_answer"]];
//
////    _myName.text = MyAnswer.userName;
//      _myName.text = @"默默";
    
    if(MyAnswer.consultationStatus == 0){
     _watingLable.textColor = UIColorFromRGB(0x52d8d2);
    _watingLable.text = @"待回答";
        
    }else{
    _watingLable.textColor = UIColorFromRGB(0x999999);
    _watingLable.text = @"已回答";
    
    }
    _questionLabel.text = MyAnswer.consultationContent;
    

    _timeLabel.text = _myAnswer.createTime;
    _listenLable.text =[NSString stringWithFormat:@"听过：%ld",(long)MyAnswer.hearCount];
    
    
}

@end
