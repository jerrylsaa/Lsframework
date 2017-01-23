//
//  HEAParentQuestionTableViewCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HEAParentQuestionTableViewCell.h"
#import "SFPhotoBrowser.h"
#import "ApiMacro.h"
#import "JMFoundation.h"
//#ifdef DEBUG
////开发环境
////测试服务器地址
//#define ICON_URL @"http://121.42.15.43:9020"//头像根路径
//
//#else
////发布环境
////正式服务器地址
//#define ICON_URL @"http://etjk365.dzjk.com:8084"//头像根路径
//
//#endif

#define   kImageXspace     20
#define   kImageTopspace     7.5
#define   kImageWidth   (kScreenWidth-17-2*kImageXspace)/3

@interface HEAParentQuestionTableViewCell()<PhotoBrowerDelegate>{
    
    UIImageView* _userImageView;
    UILabel* _userName;
    UILabel* _priceLabel;
    UILabel* _questionLabel;
    UIImageView* _doctorbgImageView;
    UIImageView* _doctorImageView;
    UIButton* _voicebt;
    UILabel *_voiceTimeLabel;
    
    UILabel* _timeLabel;
    
    UIView* _praisebgView;
    UILabel* _praiseLabel;//点赞
    UIImageView* _praiseImageView;
    UILabel* _hearCount;
    
    ClickAudioButtonBlock _clickbtBlock;
    
    UILabel* commentLabel;
    
    UIImageView* commentImageView;
    
    UILabel *wordContentLabel;
}

@property (nonatomic,retain) NSArray *photoBrowserArr;
@property (nonatomic,retain) NSArray *photoBrowserUrlArr;


@end

@implementation HEAParentQuestionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self!=nil){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupsubView];
    }
    return self;
}

- (void)setupsubView{
    _containerView = [UIView new];
    [self.contentView addSubview:_containerView];
    
    _userImageView = [UIImageView new];
    _userImageView.userInteractionEnabled = YES;
    [_containerView addSubview:_userImageView];
    UITapGestureRecognizer* babyIconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserAction:)];
    [_userImageView addGestureRecognizer:babyIconTap];
    
    
    _userName = [UILabel new];
    _userName.backgroundColor = [UIColor clearColor];
    _userName.textColor = UIColorFromRGB(0x666666);
    _userName.font = [UIFont systemFontOfSize:sbigFont];
    [_containerView addSubview:_userName];
    
    _priceLabel = [UILabel new];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.textColor = UIColorFromRGB(0x61d8d3);
    _priceLabel.font = [UIFont systemFontOfSize:midFont];
    [_containerView addSubview:_priceLabel];
    
    _questionLabel = [UILabel new];
    _questionLabel.textColor = UIColorFromRGB(0x666666);
    _questionLabel.font = [UIFont systemFontOfSize:sbigFont];
    [_containerView addSubview:_questionLabel];
    
    _HaveImageView =[[UIView alloc]init];
    
    [_containerView addSubview:_HaveImageView];

    
    _doctorbgImageView = [UIImageView new];
    _doctorbgImageView.userInteractionEnabled = YES;
    _doctorbgImageView.backgroundColor = UIColorFromRGB(0xffffff);
    _doctorbgImageView.layer.masksToBounds = YES;
    _doctorbgImageView.layer.borderWidth = 1;
    _doctorbgImageView.layer.borderColor = UIColorFromRGB(0x37e0ce).CGColor;
    [_containerView addSubview:_doctorbgImageView];

    _doctorImageView = [UIImageView new];
    _doctorImageView.userInteractionEnabled = YES;
    [_containerView addSubview:_doctorImageView];

    _voicebt = [UIButton buttonWithType:UIButtonTypeCustom];
    [_voicebt setBackgroundImage:[UIImage imageNamed:@"HEAVoice"] forState:UIControlStateNormal];
    _voicebt.titleLabel.font = [UIFont boldSystemFontOfSize:smallFont];
//    _voicebt.hidden = YES;
    [_voicebt addTarget:self action:@selector(clickAudiobt:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_voicebt];
    
    // 文字补充
    wordContentLabel = [UILabel new];
    wordContentLabel.backgroundColor = [UIColor clearColor];
    wordContentLabel.textColor = UIColorFromRGB(0x61d8d3);
    wordContentLabel.font = [UIFont systemFontOfSize:sbigFont];
    [_containerView addSubview:wordContentLabel];
    
    _voiceTimeLabel = [UILabel new];
    _voiceTimeLabel.textColor = UIColorFromRGB(0x999999);
    _voiceTimeLabel.backgroundColor = [UIColor clearColor];
    _voiceTimeLabel.font = [UIFont systemFontOfSize:smallFont];
    [_containerView addSubview:_voiceTimeLabel];
    
    _TraceLabel = [UILabel new];
    _TraceLabel.textColor = UIColorFromRGB(0x37e0ce);
    _TraceLabel.backgroundColor = [UIColor clearColor];
    _TraceLabel.font = [UIFont systemFontOfSize:smallFont];
    _TraceLabel.textAlignment = NSTextAlignmentLeft;
    [_containerView addSubview:_TraceLabel];
    

    
    _activityIndicator = [UIActivityIndicatorView new];
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityIndicator.hidesWhenStopped = YES;
    [_containerView addSubview:_activityIndicator];
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = UIColorFromRGB(0x999999);
    _timeLabel.font = [UIFont systemFontOfSize:midFont];
    [_containerView addSubview:_timeLabel];

    _praisebgView = [UIView new];
    [_containerView addSubview:_praisebgView];
    
    _praiseImageView = [UIImageView new];
    _praiseImageView.userInteractionEnabled = YES;
//    _praiseImageView.image = [UIImage imageNamed:@"HEAPraise"];
    [_praisebgView addSubview:_praiseImageView];
    
    _praiseLabel = [UILabel new];
    _praiseLabel.textColor = _timeLabel.textColor;
    _praiseLabel.font = _timeLabel.font;
    [_praisebgView addSubview:_praiseLabel];

    _hearCount = [UILabel new];
    _hearCount.textAlignment = NSTextAlignmentRight;
    _hearCount.textColor = _timeLabel.textColor;
    _hearCount.font = _timeLabel.font;
    [_containerView addSubview:_hearCount];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction1)];
    [_praisebgView addGestureRecognizer:tap1];
    
    //评论
    commentLabel = [UILabel new];
    commentLabel.textColor = UIColorFromRGB(0x999999);
    commentLabel.font = [UIFont systemFontOfSize:midFont];

    [_containerView addSubview:commentLabel];
    
    //评论图片
    commentImageView = [UIImageView new];
    commentImageView.userInteractionEnabled = YES;
    commentImageView.image = [UIImage imageNamed:@"circle_pl_icon"];
    [_containerView addSubview:commentImageView];

}

-(void)setQuestion:(HEAParentQuestionEntity *)question{
    
    _question = question;
  
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:[NSString  stringWithFormat:@"%@%@",ICON_URL,question.userImageURL]] placeholderImage:[UIImage imageNamed:@"HEAUserIcon"]];
    
    _userName.text = question.nickName.length !=0? question.nickName: @"";
    
    _questionLabel.text = question.consultationContent;
    
    [_doctorImageView sd_setImageWithURL:[NSURL URLWithString:question.imageUrl] placeholderImage:[UIImage imageNamed:@"HEADoctorIcon"]];
    
    //播放语音按钮
    NSString* normalTitle = question.isListen?@"点击播放":@"一元旁听";
    [_voicebt setTitle:normalTitle forState:UIControlStateNormal];
    [_voicebt setBackgroundImage:[UIImage imageNamed:@"HEAVoice"] forState:UIControlStateNormal];
        [_voicebt setTitle:@"暂停播放" forState:UIControlStateSelected];
//    _voicebt.hidden = question.voiceUrl.length ==0;
    
    if(question.voiceUrl.length == 0){
        _voicebt.userInteractionEnabled = NO;
        [_voicebt setTitle:@"未回答" forState:UIControlStateNormal];
    }else {
        _voicebt.userInteractionEnabled = YES;
    }
    if (question.VoiceTime==0) {
        _voiceTimeLabel.text = @"";
    }else {
        _voiceTimeLabel.text =[NSString stringWithFormat:@"%ld''",question.VoiceTime];
    }
    
    wordContentLabel.text = @"文字补充";

    
    _TraceLabel.text = @"追问未回答";
    _TraceLabel.hidden = YES;
    _timeLabel.text = question.createTime;
    
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%g",question.expertPrice];
    [_priceLabel updateLayout];
    
    _hearCount.text = [NSString stringWithFormat:@"听过 %ld",question.hearCount];
    if (question.isPraise) {
        _praiseLabel.text = [NSString stringWithFormat:@"%ld",(long)question.praiseCount];
        if ([question.isPraise integerValue] == 1) {
            _praiseImageView.image = [UIImage imageNamed:@"Heart_red_icon"];
        }else{
            _praiseImageView.image = [UIImage imageNamed:@"Heart_icon"];
        }
    }
//    _hearCount.hidden = (question.hearCount == 0);
    
    //评论
    if([question.commentCount isKindOfClass:[NSNull class]]){
        commentLabel.text = @"0";

    }
    commentLabel.text = [NSString stringWithFormat:@"%@",question.commentCount];
    
    if (![question.IsOpenImage boolValue]) {
    
        _HaveImageView.hidden =YES;
    
        _HaveImageView.sd_layout.topSpaceToView(_questionLabel,0).leftSpaceToView(_containerView,17/2.0).widthIs(0).heightIs(0);
    
        
    }else{
        if (question.Image1==nil|question.Image1.length==0|question.Image1.length<5) {
            
            _HaveImageView.hidden =YES;
            
            _HaveImageView.sd_layout.topSpaceToView(_questionLabel,0).leftSpaceToView(_containerView,17/2.0).widthIs(0).heightIs(0);
            
        }else{
            _HaveImageView.sd_layout.topSpaceToView(_questionLabel,10).leftSpaceToView(_containerView,17/2.0).widthIs(kScreenWidth-17).heightIs(kImageWidth+10);
            if (question.Image1!=nil&&question.Image1.length>4&&(![question.Image1 isEqualToString:@""])) {
                _HaveImageView.hidden =NO;
                
                
                _leftImage =[self viewWithTag:1001];
                if (_leftImage==nil) {
                    
                    _leftImage = [self imageWithTag:1001];
                    
                    [_HaveImageView addSubview:_leftImage];
                    _leftImage.sd_layout.topSpaceToView(_HaveImageView,0).leftSpaceToView(_HaveImageView,0).widthIs(kImageWidth).heightIs(kImageWidth);
                }
                
                    [_leftImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];

                
                if (question.Image2!=nil&&question.Image2.length>4&&(![question.Image2 isEqualToString:@""])) {
                    _midImage =[self viewWithTag:1002];
                    if (_midImage==nil) {
                        
                        _midImage = [self imageWithTag:1002];

                        [_HaveImageView addSubview:_midImage];
                        _midImage.sd_layout.topSpaceToView(_HaveImageView,0).leftSpaceToView(_HaveImageView,kImageWidth+kImageXspace).widthIs(kImageWidth).heightIs(kImageWidth);
                    }
                    
                    [_midImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image2]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                    
                    
                    
                    if (question.Image3!=nil&&(![question.Image3 isEqualToString:@""])&&question.Image3.length>4) {
                        _rightImage =[self viewWithTag:1003];
                        if (_rightImage==nil) {
                            
                            _rightImage = [self imageWithTag:1003];

                            [_HaveImageView addSubview:_rightImage];
                            _rightImage.sd_layout.topSpaceToView(_HaveImageView,0).leftSpaceToView(_HaveImageView,kImageWidth*2+kImageXspace*2).widthIs(kImageWidth).heightIs(kImageWidth);
                        }
                        
                        [_rightImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image3]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                        
                        if (question.Image4!=nil&&(![question.Image4 isEqualToString:@""])&&question.Image4.length>4) {
                            
                            _HaveImageView.sd_layout.topSpaceToView(_questionLabel,10).leftSpaceToView(_containerView,17/2.0).widthIs(kScreenWidth-17).heightIs(kImageWidth*2+kImageTopspace+10);
                            _leftImage1 = [self viewWithTag:1004];
                            if (_leftImage1 == nil) {
                                _leftImage1 = [self imageWithTag:1004];
                                
                            [_HaveImageView addSubview:_leftImage1];
                            _leftImage1.sd_layout.topSpaceToView(_HaveImageView,kImageWidth+kImageTopspace).leftEqualToView(_leftImage).widthIs(kImageWidth).heightEqualToWidth();
                            }
                            [_leftImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image4]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
                            
                            if(question.Image5!=nil&&(![question.Image5 isEqualToString:@""])&&question.Image5.length>4){
                                _midImage1 = [self viewWithTag:1005];
                                if (_midImage1 == nil) {
                                    _midImage1 = [self imageWithTag:1005];
                                    
                            [_HaveImageView addSubview:_midImage1];
                            _midImage1.sd_layout.topEqualToView(_leftImage1).leftEqualToView(_midImage).widthIs(kImageWidth).heightEqualToWidth();
                                }
                                
                            [_midImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image5]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];

                                if (question.Image6!=nil&&(![question.Image6 isEqualToString:@""])&&question.Image6.length>4) {
                                    
                                _rightImage1 = [self viewWithTag:1006];
                                if (_rightImage1 == nil) {
                                    _rightImage1 = [self imageWithTag:1006];
                                    
                                [_HaveImageView addSubview:_rightImage1];
                                _rightImage1.sd_layout.topEqualToView(_leftImage1).leftEqualToView(_rightImage).widthIs(kImageWidth).heightEqualToWidth();
                                    }
                                    
                                [_rightImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image6]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
                                
                            self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image5],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image6]];
                            self.photoBrowserArr =@[_leftImage,_midImage,_rightImage,_leftImage1,_midImage1,_rightImage1];
                                    
                                }else{
                             // 5 张
                            self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image5]];
                            self.photoBrowserArr =@[_leftImage,_midImage,_rightImage,_leftImage1,_midImage1];
                                    _rightImage1.hidden = YES;
                                }
                                
                            }else{
                                // 4 张
                            self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image4]];
                            self.photoBrowserArr =@[_leftImage,_midImage,_rightImage,_leftImage1];
                                _midImage1.hidden = YES;
                                _rightImage1.hidden = YES;
                            }
                            
                        }else{
                        
                       // 上面 3 张图片
                        self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image3]];
                        self.photoBrowserArr =@[_leftImage,_midImage,_rightImage];
                            _leftImage1.hidden = YES;
                            _midImage1.hidden = YES;
                            _rightImage1.hidden = YES;
                        }
                        
                    }else {
                    //只有2张图 1, 2
                        self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image2]];
                        self.photoBrowserArr =@[_leftImage,_midImage];
                        _rightImage.hidden = YES;
                        _leftImage1.hidden = YES;
                        _midImage1.hidden = YES;
                        _rightImage1.hidden = YES;
                    }
                    

                }else{
                   //只有1张图 1
                    
                    self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1]];
                    self.photoBrowserArr =@[_leftImage];
                    _rightImage.hidden = YES;
                    _midImage.hidden = YES;
                    _leftImage1.hidden = YES;
                    _midImage1.hidden = YES;
                    _rightImage1.hidden = YES;
                }
            }
            
        }
    }

    
    
    _containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    _userImageView.sd_layout.topSpaceToView(_containerView,10).leftSpaceToView(_containerView,17/2.0f).heightIs(30).widthIs(30);
    _userImageView.sd_cornerRadius = @15;
    _userName.sd_layout.leftSpaceToView(_userImageView,20).centerYEqualToView(_userImageView).heightIs(15).widthIs(kJMWidth(_userName));
//    [_userName setSingleLineAutoResizeWithMaxWidth:120];
    [_userName updateLayout];
    
    _priceLabel.sd_layout.centerYEqualToView(_userName).autoHeightRatio(0).rightSpaceToView(_containerView,10);
    [_priceLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    

    
    _questionLabel.sd_layout.topSpaceToView(_userImageView,10).leftSpaceToView(_containerView,17/2.0).rightSpaceToView(_containerView,17/2.0).autoHeightRatio(0);
    
    //增加判断，否则_HaveImageView高度为0时造成reloadData后加载不出来，cpu爆炸
    
    if (_HaveImageView.height == 0) {
        _doctorbgImageView.sd_layout.topSpaceToView(_questionLabel,10).leftSpaceToView(_containerView,17/2.0).widthIs(40).heightEqualToWidth();
    }else if(_HaveImageView.height == kImageWidth+10)
    {
        _doctorbgImageView.sd_layout.topSpaceToView(_questionLabel,kImageWidth+20).leftSpaceToView(_containerView,17/2.0).widthIs(40).heightEqualToWidth();
    }else{
        
         _HaveImageView.sd_layout.topSpaceToView(_questionLabel,10).leftSpaceToView(_containerView,17/2.0).widthIs(kScreenWidth-17).heightIs(kImageWidth*2+kImageTopspace+10);
        
        _doctorbgImageView.sd_layout.topSpaceToView(_questionLabel,kImageWidth*2+kImageTopspace+20).leftSpaceToView(_containerView,17/2.0).widthIs(40).heightEqualToWidth();
        
    }


    
    _doctorbgImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    
    _doctorImageView.sd_layout.centerXEqualToView(_doctorbgImageView).centerYEqualToView(_doctorbgImageView).widthIs(35).heightEqualToWidth();
    _doctorImageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
//    _voicebt.sd_layout.topSpaceToView(_HaveImageView,12).leftSpaceToView(_doctorbgImageView,10).widthIs(262/2.0).heightIs(30);
    
    _voicebt.sd_layout.topEqualToView(_doctorImageView).leftSpaceToView(_doctorImageView,10).widthIs(262/2.0).heightIs(30);


CGFloat  voiceTimeWidth = [JMFoundation  calLabelWidth:_voiceTimeLabel.font andStr:_voiceTimeLabel.text withHeight:12];
    
    _voiceTimeLabel.sd_layout.leftSpaceToView(_voicebt,5).centerYEqualToView(_voicebt).heightIs(12).widthIs(voiceTimeWidth);
    

    _TraceLabel.sd_layout.leftSpaceToView(_voiceTimeLabel,10).centerYEqualToView(_voicebt).widthIs([JMFoundation  calLabelWidth:_TraceLabel]).heightIs(12);
    
    _activityIndicator.sd_layout.leftSpaceToView(_voicebt,20).centerYEqualToView(_voicebt).widthIs(25).heightEqualToWidth();
    
    if (question.WordContent.length == 0 || question.WordContent == nil) {

        wordContentLabel.sd_layout.topSpaceToView(_voicebt,8).widthIs(0).heightIs(0);
        
        _timeLabel.sd_layout.topSpaceToView(_doctorbgImageView,10).leftEqualToView(_doctorbgImageView).autoHeightRatio(0).widthIs(kJMWidth(_timeLabel));
    }else if(question.WordContent == nil && _HaveImageView.height !=0){
        
        
        wordContentLabel.sd_layout.topSpaceToView(_voicebt,8).leftSpaceToView(_doctorImageView,14).widthIs(100).heightIs(15);
        
        _timeLabel.sd_layout.topSpaceToView(_doctorImageView,25).leftEqualToView(_doctorbgImageView).autoHeightRatio(0).widthIs(kJMWidth(_timeLabel));
    
    
    }else
    {
        wordContentLabel.sd_layout.topSpaceToView(_voicebt,8).leftSpaceToView(_doctorImageView,14).widthIs(100).heightIs(15);
        
        _timeLabel.sd_layout.topSpaceToView(_doctorImageView,25).leftEqualToView(_doctorbgImageView).autoHeightRatio(0).widthIs(kJMWidth(_timeLabel));
    }
    _hearCount.sd_layout.centerYEqualToView(_timeLabel).heightIs(14).leftSpaceToView(_timeLabel,10).widthIs(150);
    [_hearCount setSingleLineAutoResizeWithMaxWidth:150];
    
    //评论
    commentLabel.sd_layout.centerYEqualToView(_timeLabel).heightIs(18).rightSpaceToView(_containerView,10);
    [commentLabel setSingleLineAutoResizeWithMaxWidth:150];
    commentImageView.sd_layout.centerYEqualToView(_timeLabel).widthIs(16).heightEqualToWidth().rightSpaceToView(commentLabel,7);

    
    
    _praisebgView.sd_layout.centerYEqualToView(_timeLabel).heightIs(18).rightSpaceToView(commentImageView,10);

    
//    _praisebgView.sd_layout.centerYEqualToView(_timeLabel).heightIs(18).rightSpaceToView(_containerView,10);
    _praiseImageView.sd_layout.topSpaceToView(_praisebgView,0).leftSpaceToView(_praisebgView,0).widthIs(36/2.0).heightEqualToWidth();
    _praiseLabel.sd_layout.centerYEqualToView(_praiseImageView).leftSpaceToView(_praiseImageView,10).autoHeightRatio(0);
    [_praiseLabel setSingleLineAutoResizeWithMaxWidth:150];
    [_praisebgView setupAutoWidthWithRightView:_praiseLabel rightMargin:0];
    
    
    [_containerView setupAutoHeightWithBottomViewsArray:@[_timeLabel,_hearCount,_priceLabel] bottomMargin:10];
    
    
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
   
}

-(void)setIsSelect:(int)isSelect{
    _isSelect = isSelect;
    _voicebt.selected = isSelect != 0 ;
//    NSLog(@"-----%d",_voicebt.selected);
}

#pragma mark - 点击事件
- (void)clickAudiobt:(UIButton*) bt{
//    bt.selected = !bt.selected;
    if(_clickbtBlock){
        _clickbtBlock(bt);
    }
    
}

- (void)clickUserAction:(UITapGestureRecognizer*) tapGesture{
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickUserIconWithHEAParentQuestionEntity:)]){
        [self.delegate clickUserIconWithHEAParentQuestionEntity:self.question];
    }
}

#pragma mark - 

-(void)clickAudionButtonOnCompletion:(ClickAudioButtonBlock)block{
    _clickbtBlock = [block copy];
}

- (void)setIsFree:(BOOL)isFree {
    _isFree =isFree;
    runOnMainThread(^{
        if (_isFree){
            NSString* normalTitle =@"免费听";
            [_voicebt setTitle:normalTitle forState:UIControlStateNormal];

            [_voicebt setTitle:@"暂停播放" forState:UIControlStateSelected];
        }
        if(_question.voiceUrl.length == 0){
            _voicebt.userInteractionEnabled = NO;
            [_voicebt setTitle:@"未回答" forState:UIControlStateNormal];
        }else {
            _voicebt.userInteractionEnabled = YES;
        }
    });
}
-(void)setIsFreeQusetion:(BOOL)isFreeQusetion{
    _isFreeQusetion = isFreeQusetion;

    runOnMainThread(^{
        if (_isFreeQusetion){
            NSString* normalTitle =@"限时免费";
        [_voicebt setTitle:normalTitle forState:UIControlStateNormal];
        [_voicebt setBackgroundImage:[UIImage imageNamed:@"HEAVoice_Free"] forState:UIControlStateNormal];
        [_voicebt setTitle:@"暂停播放" forState:UIControlStateSelected];
        }
        if(_question.voiceUrl.length == 0){
            _voicebt.userInteractionEnabled = NO;
        [_voicebt setBackgroundImage:[UIImage imageNamed:@"HEAVoice"] forState:UIControlStateNormal];
            [_voicebt setTitle:@"未回答" forState:UIControlStateNormal];
        }else {
            _voicebt.userInteractionEnabled = YES;
        }
    });

}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    //显示图片浏览器
    [SFPhotoBrowser showImageInView:self.window selectImageIndex:(tap.view.tag-1001) delegate:self];
}

#pragma mark -WXPhotoBrowserDelegate
//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(SFPhotoBrowser *)photoBrowser {
    if (self.photoBrowserArr.count>0) {
        return self.photoBrowserArr.count;
    }else {
        return 0;
    }
}

//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (SFPhoto *)photoBrowser:(SFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    SFPhoto *photo = [[SFPhoto alloc] init];
    //原图
    photo.srcImageView = self.photoBrowserArr[index];
    
    
    
    //缩略图片的url
    NSString *imgUrl = self.photoBrowserUrlArr[index];
    
    photo.url = [NSURL URLWithString:imgUrl];
    
    return photo;
}
- (NSString *)transformTime:(long)second{
    NSString   *time = [NSString  new];
    if(second  >=  3600){
        
        long   minutes = floor(second/60);
        long  sec = floor(second - minutes * 60);
        long  hours1 = floor(second / (60 * 60));
        time = [NSString  stringWithFormat:@"%ld:%02ld:%02ld",hours1,minutes,sec];
        return time;
    }else if (second >= 60){
        long   minutes = floor(second/60);
        long  sec = floor(second - minutes * 60);
        time = [NSString  stringWithFormat:@"%02ld:%02ld",minutes,sec];
        return time;
    }else{
        long  sec = second;
        time = [NSString  stringWithFormat:@"00:%02ld",sec];
        return time;
    }
}

- (void)changeStyle{
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}
- (void)tapAction1{
    if ([self.question.isPraise integerValue] == 0) {
        if (self.delegate) {
            [self.delegate praiseAtIndexPath:self.sd_indexPath];
        }
    }else{
        if (self.delegate) {
            [self.delegate cancelPraiseAtIndexPath:self.sd_indexPath];
        }
    }
}

-(UIImageView *)imageWithTag:(NSInteger)tag
{
    UIImageView *newImages = [UIImageView new];
    newImages.tag = tag;
    newImages.contentMode =UIViewContentModeScaleAspectFill;
    newImages.layer.cornerRadius= 8;
    [newImages.layer setBorderWidth:2];
    [newImages.layer setBorderColor:RGB(80,199, 192).CGColor];
    newImages.clipsToBounds =YES;
    newImages.image =nil;
    newImages.userInteractionEnabled =YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [newImages addGestureRecognizer:tap];
    return newImages;
}
-(void)setDetalIsFreeQuestion:(BOOL)detalIsFreeQuestion
{
    _detalIsFreeQuestion = detalIsFreeQuestion;
    if (_detalIsFreeQuestion == YES) {
        
        runOnMainThread(^{
            if ([[NSString  stringWithFormat:@"%@",self.question.IsFree]  isEqualToString:@"1"]){
                NSString* normalTitle =@"限时免费";
                [_voicebt setTitle:normalTitle forState:UIControlStateNormal];
                [_voicebt setBackgroundImage:[UIImage imageNamed:@"HEAVoice_Free"] forState:UIControlStateNormal];
                [_voicebt setTitle:@"暂停播放" forState:UIControlStateSelected];
            }
            if(_question.voiceUrl.length == 0){
                _voicebt.userInteractionEnabled = NO;
                [_voicebt setBackgroundImage:[UIImage imageNamed:@"HEAVoice"] forState:UIControlStateNormal];
                [_voicebt setTitle:@"未回答" forState:UIControlStateNormal];
            }else {
                _voicebt.userInteractionEnabled = YES;
            }
        });
    }
    
}
@end
