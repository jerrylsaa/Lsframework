//
//  MoreAskCell.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 2016/10/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MoreAskCell.h"
#import "SFPhotoBrowser.h"
#import "ApiMacro.h"
#import "JMFoundation.h"


#define leftXspace   10
#define leftYspace   10

#define QuestionImageXspace   20
#define QuestionImageYspace    5

#define QuestionImageWidtn   kScreenWidth -leftXspace*2

#define QuestionImageSingleWidtn  (kScreenWidth -leftXspace*2 - QuestionImageXspace*2)/3

#define QuestionImageHeight1   QuestionImageSingleWidtn+leftYspace*2

#define QuestionImageHeight2   leftYspace + QuestionImageSingleWidtn + QuestionImageYspace + QuestionImageSingleWidtn +leftYspace


#define QuestionImageYspace2  leftYspace+QuestionImageSingleWidtn+QuestionImageYspace


@interface MoreAskCell ()<PhotoBrowerDelegate>{

    
    UILabel* _questionLabel;
    UIImageView* _doctorbgImageView;
    UIImageView* _doctorImageView;
    
    ClickAudioButtonBlock _clickbtBlock;
    ClickWordContentBlock _clickWordContentBlock;
    
    //追问
    UILabel *_TraceLabel;
}
@property (nonatomic,retain) NSArray *photoBrowserArr;
@property (nonatomic,retain) NSArray *photoBrowserUrlArr;

@end

@implementation MoreAskCell

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
    
    _priceLabel = [UILabel new];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.textColor = UIColorFromRGB(0x61d8d3);
    _priceLabel.font = [UIFont systemFontOfSize:midFont];
    [_containerView addSubview:_priceLabel];
    
    //追问
    _TraceLabel = [UILabel new];
    _TraceLabel.backgroundColor = [UIColor clearColor];
    _TraceLabel.textColor = UIColorFromRGB(0x61d8d3);
    _TraceLabel.font = [UIFont systemFontOfSize:sbigFont];
    [_containerView addSubview:_TraceLabel];
    
    _questionLabel = [UILabel new];
    _questionLabel.backgroundColor = [UIColor clearColor];
    _questionLabel.numberOfLines = 0;
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
    
//    @property (nonatomic, strong) UIView *WordBackView;
//    @property (nonatomic, strong) UIButton *WordContentBtn;
//    @property (nonatomic, strong) UIView *WordContentView;
//    @property (nonatomic, strong) UILabel  *WordContentMessage;
    //文字补充回答
    _WordBackView = [UIView  new];
    _WordBackView.userInteractionEnabled = YES;
    _WordBackView.backgroundColor = [UIColor clearColor];
    [_containerView  addSubview:_WordBackView];
    
    _WordContentBtn = [UIButton  new];
    _WordContentBtn.backgroundColor = [UIColor  clearColor];
    [_WordContentBtn addTarget:self action:@selector(clickWordContentbt:) forControlEvents:UIControlEventTouchUpInside];
   _WordContentBtn.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//    [_WordContentBtn addGestureRecognizer:tap1];

    [_WordContentBtn setImage:[UIImage  imageNamed:@"WordContent_Close"] forState:UIControlStateNormal];
    [_WordContentBtn  setImage:[UIImage  imageNamed:@"WordContent_Open"] forState:UIControlStateSelected];
  
    [_WordBackView  addSubview:_WordContentBtn];

    _WordContentView  = [UIView  new];
    _WordContentView.backgroundColor = [UIColor  whiteColor];
    _WordContentView.layer.masksToBounds = YES;
    _WordContentView.layer.cornerRadius = 10/2;
    _WordContentView.layer.borderWidth = 1;
   _WordContentView.layer.borderColor = UIColorFromRGB(0x61d8d3).CGColor;
    [_WordBackView addSubview:_WordContentView];
    
    _WordContentMessage = [UILabel  new];
    _WordContentMessage.backgroundColor = [UIColor  clearColor];
    _WordContentMessage.font = [UIFont  systemFontOfSize:15];
    _WordContentMessage.numberOfLines = 0;
    _WordContentMessage.textColor = UIColorFromRGB(0x333333);
    _WordContentMessage.textAlignment = NSTextAlignmentLeft;
    [_WordContentView  addSubview:_WordContentMessage];


    
    _voicebt = [UIButton buttonWithType:UIButtonTypeCustom];
    [_voicebt setBackgroundImage:[UIImage imageNamed:@"HEAVoice"] forState:UIControlStateNormal];
    _voicebt.titleLabel.font = [UIFont boldSystemFontOfSize:smallFont];
    //    _voicebt.hidden = YES;
    [_voicebt addTarget:self action:@selector(clickAudiobt:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_voicebt];
    
    _voiceTimeLabel = [UILabel new];
    _voiceTimeLabel.textColor = UIColorFromRGB(0x999999);
    _voiceTimeLabel.font = [UIFont systemFontOfSize:smallFont];
    [_containerView addSubview:_voiceTimeLabel];
    
    _activityIndicator = [UIActivityIndicatorView new];
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityIndicator.hidesWhenStopped = YES;
    [_containerView addSubview:_activityIndicator];
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = UIColorFromRGB(0x999999);
    _timeLabel.font = [UIFont systemFontOfSize:smallFont];
    [_containerView addSubview:_timeLabel];
    
    
    _hearCount = [UILabel new];
    _hearCount.textAlignment = NSTextAlignmentRight;
    _hearCount.textColor = _timeLabel.textColor;
    _hearCount.font = [UIFont systemFontOfSize:smallFont];
    [_containerView addSubview:_hearCount];
    
}

-(void)setQuestion:(HEAParentQuestionEntity *)question{
    
    _question = question;
   
    _questionLabel.text = question.consultationContent;

    [_doctorImageView sd_setImageWithURL:[NSURL URLWithString:question.imageUrl] placeholderImage:[UIImage imageNamed:@"HEADoctorIcon"]];
    
    //播放语音按钮
    NSString* normalTitle = question.isListen?@"点击播放":@"一元旁听";
    [_voicebt setTitle:normalTitle forState:UIControlStateNormal];
    [_voicebt setBackgroundImage:[UIImage imageNamed:@"HEAVoice"] forState:UIControlStateNormal];
    [_voicebt setTitle:@"暂停播放" forState:UIControlStateSelected];

    _WordContentMessage.text = question.WordContent;
    NSLog(@"追问文字补充回答：%@",question.WordContent);
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
    
    
    _timeLabel.text = question.questionTime ? question.questionTime:question.createTime;
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%g",question.expertPrice];
    
    _hearCount.text = [NSString stringWithFormat:@"听过 %ld",question.hearCount];
    
    
    _TraceLabel.text = [NSString stringWithFormat:@"追问%@:",question.RowID];
    //    _hearCount.hidden = (question.hearCount == 0);
    /*
    if ([question.IsOpenImage boolValue] == NO) {
        
        _HaveImageView.hidden =YES;
        
        _HaveImageView.sd_layout.topSpaceToView(_questionLabel,0).leftSpaceToView(_containerView,17/2.0).widthIs(0).heightIs(0);
        
        
    }else{
        if (question.Image1==nil|question.Image1.length==0|question.Image1.length<5) {
            
            _HaveImageView.hidden =YES;
            
            _HaveImageView.sd_layout.topSpaceToView(_questionLabel,0).leftSpaceToView(_containerView,17/2.0).widthIs(0).heightIs(0);
            
        }else{
            _HaveImageView.sd_layout.topSpaceToView(_questionLabel,10).leftSpaceToView(_containerView,17/2.0).widthIs(280).heightIs(95.0);
            if (question.Image1!=nil&&question.Image1.length>4&&(![question.Image1 isEqualToString:@""])) {
                _HaveImageView.hidden =NO;
                
                
                _leftImage =[self viewWithTag:1001];
                if (_leftImage==nil) {
                    _leftImage =[[UIImageView alloc]init];
                    _leftImage.tag =1001;
                    _leftImage.contentMode =UIViewContentModeScaleAspectFill;
                    _leftImage.layer.cornerRadius= 8;
                    [_leftImage.layer setBorderWidth:2];
                    [_leftImage.layer setBorderColor:RGB(80,199, 192).CGColor];
                    _leftImage.clipsToBounds =YES;
                    _leftImage.image =nil;
                    _leftImage.userInteractionEnabled =YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                    [_leftImage addGestureRecognizer:tap];
                    
                    [_HaveImageView addSubview:_leftImage];
                    _leftImage.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,0).widthIs(80).heightIs(80);
                }
                
                [_leftImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                
                
                if (question.Image2!=nil&&question.Image2.length>4&&(![question.Image2 isEqualToString:@""])) {
                    _midImage =[self viewWithTag:1002];
                    if (_midImage==nil) {
                        _midImage =[[UIImageView alloc]init];
                        _midImage.tag =1002;
                        _midImage.contentMode =UIViewContentModeScaleAspectFill;
                        _midImage.layer.cornerRadius= 8;
                        [_midImage.layer setBorderWidth:2];
                        [_midImage.layer setBorderColor:RGB(80,199, 192).CGColor];
                        _midImage.clipsToBounds =YES;
                        _midImage.image =nil;
                        _midImage.userInteractionEnabled =YES;
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                        [_midImage addGestureRecognizer:tap];
                        
                        
                        
                        [_HaveImageView addSubview:_midImage];
                        _midImage.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,100).widthIs(80).heightIs(80);
                    }
                    
                    [_midImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image2]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                    
                    
                    
                    if (question.Image3!=nil&&(![question.Image3 isEqualToString:@""])&&question.Image3.length>4) {
                        _rightImage =[self viewWithTag:1003];
                        if (_rightImage==nil) {
                            _rightImage =[[UIImageView alloc]init];
                            _rightImage.tag =1003;
                            _rightImage.contentMode =UIViewContentModeScaleAspectFill;
                            _rightImage.layer.cornerRadius= 8;
                            [_rightImage.layer setBorderWidth:2];
                            [_rightImage.layer setBorderColor:RGB(80,199, 192).CGColor];
                            _rightImage.clipsToBounds =YES;
                            _rightImage.image =nil;
                            _rightImage.userInteractionEnabled =YES;
                            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                            [_rightImage addGestureRecognizer:tap];
                            
                            [_HaveImageView addSubview:_rightImage];
                            _rightImage.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,200).widthIs(80).heightIs(80);
                        }
                        
                        [_rightImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image3]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                        
                        self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image3]];
                        self.photoBrowserArr =@[_leftImage,_midImage,_rightImage];
                        
                        
                    }else {
                        //只有2张图 1, 2
                        self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image2]];
                        self.photoBrowserArr =@[_leftImage,_midImage];
                        
                    }
                    
                    
                }else{
                    //只有1张图 1
                    
                    self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1]];
                    self.photoBrowserArr =@[_leftImage];
                }
            }
            
        }
    }
    */
    NSLog(@"isopenimage is-- %@",question.IsOpenImage);
    
    if ([question.IsOpenImage boolValue] == NO) {

        _HaveImageView.hidden =YES;
        
        _HaveImageView.sd_layout.topEqualToView(_questionLabel).leftEqualToView(_questionLabel).widthIs(0).heightIs(0);
        
        
    }else{
        if (question.Image1==nil|question.Image1.length==0|question.Image1.length<5) {
            
            _HaveImageView.hidden =YES;
            
            _HaveImageView.sd_layout.topEqualToView(_questionLabel).leftEqualToView(_questionLabel).widthIs(0).heightIs(0);
            
        }else{
            if (question.Image4==nil|question.Image4.length==0|question.Image4.length<5 ) {
                //1行图片
                
                _HaveImageView.sd_layout.topSpaceToView(_questionLabel,0).leftEqualToView(_questionLabel).widthIs(QuestionImageWidtn).heightIs(QuestionImageHeight1);
                
                if (question.Image1!=nil&&question.Image1.length>4&&(![question.Image1 isEqualToString:@""])) {
                    _HaveImageView.hidden =NO;
                    
                    _QuestionImageView1 =[self viewWithTag:1001];
                    if (_QuestionImageView1==nil) {
                        _QuestionImageView1 =[[UIImageView alloc]init];
                        _QuestionImageView1.tag =1001;
                        _QuestionImageView1.contentMode =UIViewContentModeScaleAspectFill;
                        _QuestionImageView1.layer.cornerRadius= 8;
                        [_QuestionImageView1.layer setBorderWidth:2];
                        [_QuestionImageView1.layer setBorderColor:UIColorFromRGB(0x1fcfdb).CGColor];
                        _QuestionImageView1.clipsToBounds =YES;
                        _QuestionImageView1.image =nil;
                        _QuestionImageView1.userInteractionEnabled =YES;
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                        [_QuestionImageView1 addGestureRecognizer:tap];
                        
                        [_HaveImageView addSubview:_QuestionImageView1];
                        _QuestionImageView1.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,0).widthIs(QuestionImageSingleWidtn).heightEqualToWidth();
                    }
                    
                    [_QuestionImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                    
                    
                    if (question.Image2!=nil&&question.Image2.length>4&&(![question.Image2 isEqualToString:@""])) {
                        _QuestionImageView2 =[self viewWithTag:1002];
                        if (_QuestionImageView2==nil) {
                            _QuestionImageView2 =[[UIImageView alloc]init];
                            _QuestionImageView2.tag =1002;
                            _QuestionImageView2.contentMode =UIViewContentModeScaleAspectFill;
                            _QuestionImageView2.layer.cornerRadius= 8;
                            [_QuestionImageView2.layer setBorderWidth:2];
                            [_QuestionImageView2.layer setBorderColor:UIColorFromRGB(0x1fcfdb).CGColor];
                            _QuestionImageView2.clipsToBounds =YES;
                            _QuestionImageView2.image =nil;
                            _QuestionImageView2.userInteractionEnabled =YES;
                            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                            [_QuestionImageView2 addGestureRecognizer:tap];
                            
                            [_HaveImageView addSubview:_QuestionImageView2];
                            _QuestionImageView2.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,QuestionImageSingleWidtn+QuestionImageXspace).widthIs(QuestionImageSingleWidtn).heightEqualToWidth();                        }
                        
                        [_QuestionImageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image2]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                        
                        
                        
                        if (question.Image3!=nil&&(![question.Image3 isEqualToString:@""])&&question.Image3.length>4) {
                            _QuestionImageView3 =[self viewWithTag:1003];
                            if (_QuestionImageView3==nil) {
                                _QuestionImageView3 =[[UIImageView alloc]init];
                                _QuestionImageView3.tag =1003;
                                _QuestionImageView3.contentMode =UIViewContentModeScaleAspectFill;
                                _QuestionImageView3.layer.cornerRadius= 8;
                                [_QuestionImageView3.layer setBorderWidth:2];
                                [_QuestionImageView3.layer setBorderColor:UIColorFromRGB(0x1fcfdb).CGColor];
                                _QuestionImageView3.clipsToBounds =YES;
                                _QuestionImageView3.image =nil;
                                _QuestionImageView3.userInteractionEnabled =YES;
                                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                                [_QuestionImageView3 addGestureRecognizer:tap];
                                
                                [_HaveImageView addSubview:_QuestionImageView3];
                                _QuestionImageView3.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,2*QuestionImageSingleWidtn+2*QuestionImageXspace).widthIs(QuestionImageSingleWidtn).heightEqualToWidth();
                            }
                            
                            [_QuestionImageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image3]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                            
                            self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image3]];
                            self.photoBrowserArr =@[_QuestionImageView1,_QuestionImageView2,_QuestionImageView3];
                            
                            
                            
                        }else {
                            //只有2张图 1, 2
                            self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image2]];
                            self.photoBrowserArr =@[_QuestionImageView1,_QuestionImageView2];
                            
                        }
                        
                        
                    }else{
                        //只有1张图 1
                        
                        self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1]];
                        self.photoBrowserArr =@[_QuestionImageView1];
                    }
                }
                
            }else{
                //2行图片
                
                _HaveImageView.sd_layout.topSpaceToView(_questionLabel,0).leftEqualToView(_questionLabel).widthIs(QuestionImageWidtn).heightIs(QuestionImageHeight2);
                _HaveImageView.hidden =NO;
                
                _QuestionImageView1 =[self viewWithTag:1001];
                if (_QuestionImageView1==nil) {
                    _QuestionImageView1 =[[UIImageView alloc]init];
                    _QuestionImageView1.tag =1001;
                    _QuestionImageView1.contentMode =UIViewContentModeScaleAspectFill;
                    _QuestionImageView1.layer.cornerRadius= 8;
                    [_QuestionImageView1.layer setBorderWidth:2];
                    [_QuestionImageView1.layer setBorderColor:UIColorFromRGB(0x1fcfdb).CGColor];
                    _QuestionImageView1.clipsToBounds =YES;
                    _QuestionImageView1.image =nil;
                    _QuestionImageView1.userInteractionEnabled =YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                    [_QuestionImageView1 addGestureRecognizer:tap];
                    
                    [_HaveImageView addSubview:_QuestionImageView1];
                    _QuestionImageView1.sd_layout.topSpaceToView(_HaveImageView,leftYspace).leftSpaceToView(_HaveImageView,0).widthIs(QuestionImageSingleWidtn).heightEqualToWidth();
                }
                
                [_QuestionImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                
                
                _QuestionImageView2 =[self viewWithTag:1002];
                if (_QuestionImageView2==nil) {
                    _QuestionImageView2 =[[UIImageView alloc]init];
                    _QuestionImageView2.tag =1002;
                    _QuestionImageView2.contentMode =UIViewContentModeScaleAspectFill;
                    _QuestionImageView2.layer.cornerRadius= 8;
                    [_QuestionImageView2.layer setBorderWidth:2];
                    [_QuestionImageView2.layer setBorderColor:UIColorFromRGB(0x1fcfdb).CGColor];
                    _QuestionImageView2.clipsToBounds =YES;
                    _QuestionImageView2.image =nil;
                    _QuestionImageView2.userInteractionEnabled =YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                    [_QuestionImageView2 addGestureRecognizer:tap];
                    
                    [_HaveImageView addSubview:_QuestionImageView2];
                    _QuestionImageView2.sd_layout.topSpaceToView(_HaveImageView,leftYspace).leftSpaceToView(_HaveImageView,QuestionImageSingleWidtn+QuestionImageXspace).widthIs(QuestionImageSingleWidtn).heightEqualToWidth();                        }
                
                [_QuestionImageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image2]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                
                
                _QuestionImageView3 =[self viewWithTag:1003];
                if (_QuestionImageView3==nil) {
                    _QuestionImageView3 =[[UIImageView alloc]init];
                    _QuestionImageView3.tag =1003;
                    _QuestionImageView3.contentMode =UIViewContentModeScaleAspectFill;
                    _QuestionImageView3.layer.cornerRadius= 8;
                    [_QuestionImageView3.layer setBorderWidth:2];
                    [_QuestionImageView3.layer setBorderColor:UIColorFromRGB(0x1fcfdb).CGColor];
                    _QuestionImageView3.clipsToBounds =YES;
                    _QuestionImageView3.image =nil;
                    _QuestionImageView3.userInteractionEnabled =YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                    [_QuestionImageView3 addGestureRecognizer:tap];
                    
                    [_HaveImageView addSubview:_QuestionImageView3];
                    _QuestionImageView3.sd_layout.topSpaceToView(_HaveImageView,leftYspace).leftSpaceToView(_HaveImageView,2*QuestionImageSingleWidtn+2*QuestionImageXspace).widthIs(QuestionImageSingleWidtn).heightEqualToWidth();
                }
                
                [_QuestionImageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image3]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                
                self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image3]];
                self.photoBrowserArr =@[_QuestionImageView1,_QuestionImageView2,_QuestionImageView3];
                
                
                
                if (question.Image4!=nil&&question.Image4.length>4&&(![question.Image4 isEqualToString:@""])) {
                    
                    _QuestionImageView4 =[self viewWithTag:1004];
                    if (_QuestionImageView4==nil) {
                        _QuestionImageView4 =[[UIImageView alloc]init];
                        _QuestionImageView4.tag =1004;
                        _QuestionImageView4.contentMode =UIViewContentModeScaleAspectFill;
                        _QuestionImageView4.layer.cornerRadius= 8;
                        [_QuestionImageView4.layer setBorderWidth:2];
                        [_QuestionImageView4.layer setBorderColor:UIColorFromRGB(0x1fcfdb).CGColor];
                        _QuestionImageView4.clipsToBounds =YES;
                        _QuestionImageView4.image =nil;
                        _QuestionImageView4.userInteractionEnabled =YES;
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                        [_QuestionImageView4 addGestureRecognizer:tap];
                        
                        [_HaveImageView addSubview:_QuestionImageView4];
                        _QuestionImageView4.sd_layout.topSpaceToView(_HaveImageView,QuestionImageYspace2).leftSpaceToView(_HaveImageView,0).widthIs(QuestionImageSingleWidtn).heightEqualToWidth();
                    }
                    
                    [_QuestionImageView4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image4]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                    
                    
                    if (question.Image5!=nil&&question.Image5.length>4&&(![question.Image5 isEqualToString:@""])) {
                        _QuestionImageView5 =[self viewWithTag:1005];
                        if (_QuestionImageView5==nil) {
                            _QuestionImageView5 =[[UIImageView alloc]init];
                            _QuestionImageView5.tag =1005;
                            _QuestionImageView5.contentMode =UIViewContentModeScaleAspectFill;
                            _QuestionImageView5.layer.cornerRadius= 8;
                            [_QuestionImageView5.layer setBorderWidth:2];
                            [_QuestionImageView5.layer setBorderColor:UIColorFromRGB(0x1fcfdb).CGColor];
                            _QuestionImageView5.clipsToBounds =YES;
                            _QuestionImageView5.image =nil;
                            _QuestionImageView5.userInteractionEnabled =YES;
                            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                            [_QuestionImageView5 addGestureRecognizer:tap];
                            
                            [_HaveImageView addSubview:_QuestionImageView5];
                            _QuestionImageView5.sd_layout.topSpaceToView(_HaveImageView,QuestionImageYspace2).leftSpaceToView(_HaveImageView,QuestionImageSingleWidtn+QuestionImageXspace).widthIs(QuestionImageSingleWidtn).heightEqualToWidth();
                        }
                        
                        
                        [_QuestionImageView5 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image5]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                        
                        
                        if (question.Image6!=nil&&question.Image6.length>4&&(![question.Image6 isEqualToString:@""])) {
                            _QuestionImageView6 =[self viewWithTag:1006];
                            if (_QuestionImageView6==nil) {
                                _QuestionImageView6 =[[UIImageView alloc]init];
                                _QuestionImageView6.tag =1006;
                                _QuestionImageView6.contentMode =UIViewContentModeScaleAspectFill;
                                _QuestionImageView6.layer.cornerRadius= 8;
                                [_QuestionImageView6.layer setBorderWidth:2];
                                [_QuestionImageView6.layer setBorderColor:UIColorFromRGB(0x1fcfdb).CGColor];
                                _QuestionImageView6.clipsToBounds =YES;
                                _QuestionImageView6.image =nil;
                                _QuestionImageView6.userInteractionEnabled =YES;
                                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                                [_QuestionImageView6 addGestureRecognizer:tap];
                                
                                [_HaveImageView addSubview:_QuestionImageView6];
                                _QuestionImageView6.sd_layout.topSpaceToView(_HaveImageView,QuestionImageYspace2).leftSpaceToView(_HaveImageView,2*QuestionImageSingleWidtn+2*QuestionImageXspace).widthIs(QuestionImageSingleWidtn).heightEqualToWidth();                        }
                            
                            [_QuestionImageView6 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image6]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                            
                            //只有6张图
                            
                            self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image5],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image6]];
                            self.photoBrowserArr =@[_QuestionImageView1,_QuestionImageView2,_QuestionImageView3,_QuestionImageView4,_QuestionImageView5,_QuestionImageView6];
                            
                        }else{
                            
                            //只有5张图
                            
                            self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image5]];
                            self.photoBrowserArr =@[_QuestionImageView1,_QuestionImageView2,_QuestionImageView3,_QuestionImageView4,_QuestionImageView5];
                            
                            
                        }//6
                    }else{
                        //只有4张图
                        
                        self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,question.Image4]];
                        self.photoBrowserArr =@[_QuestionImageView1,_QuestionImageView2,_QuestionImageView3,_QuestionImageView4];
                    }   // 5
                }  //4
                
                
            }  //2张图片
            
        }
        
        
    }
    
    
    _containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);

    _TraceLabel.sd_layout.leftSpaceToView(_containerView,17/2.0).topSpaceToView(_containerView,10).rightSpaceToView(_containerView,17/2.0).autoHeightRatio(0);
    
    _questionLabel.sd_layout.topSpaceToView(_TraceLabel,10).leftSpaceToView(_containerView,17/2.0).rightSpaceToView(_containerView,17/2.0).autoHeightRatio(0);
    
    //增加判断，否则_HaveImageView高度为0时造成reloadData后加载不出来，cpu爆炸
    
    if (_HaveImageView.height == 0) {
        _doctorbgImageView.sd_layout.topSpaceToView(_questionLabel,10).leftSpaceToView(_containerView,17/2.0).widthIs(40).heightEqualToWidth();
        
    }else if(_HaveImageView.height == QuestionImageHeight1){
        //一行
        
    _doctorbgImageView.sd_layout.topSpaceToView(_questionLabel,QuestionImageHeight1).leftSpaceToView(_containerView,17/2.0).widthIs(40).heightEqualToWidth();
        
        
    }else {
        //二行
        _doctorbgImageView.sd_layout.topSpaceToView(_questionLabel,QuestionImageHeight2).leftSpaceToView(_containerView,17/2.0).widthIs(40).heightEqualToWidth();
    }
    
    _doctorbgImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    
    _doctorImageView.sd_layout.centerXEqualToView(_doctorbgImageView).centerYEqualToView(_doctorbgImageView).widthIs(35).heightEqualToWidth();
    _doctorImageView.sd_cornerRadiusFromWidthRatio = @(0.5);

    
    _voicebt.sd_layout.centerYEqualToView(_doctorbgImageView).leftSpaceToView(_doctorbgImageView,10).widthIs(262/2.0).heightIs(30);
    
    _WordBackView.sd_layout.topSpaceToView(_doctorbgImageView,30/2).leftEqualToView(_voicebt).rightSpaceToView(_containerView,30/2);
    _WordContentBtn.sd_layout.topSpaceToView(_WordBackView,0).leftSpaceToView(_WordBackView,0).widthIs(154/2).heightIs(16);
    _WordContentView.sd_layout.topSpaceToView(_WordContentBtn,20/2).leftEqualToView(_WordContentBtn).rightEqualToView(_WordBackView);
//    CGFloat   _WordContentMessageHeight = [JMFoundation calLabelHeight:_WordContentMessage.font andStr:_WordContentMessage.text withWidth:(kScreenWidth - 50)];
    _WordContentMessage.sd_layout.topSpaceToView(_WordContentView,20/2).leftSpaceToView(_WordContentView,20/2).rightSpaceToView(_WordContentView,20/2).autoHeightRatio(0);
    [_WordContentView setupAutoHeightWithBottomView:_WordContentMessage bottomMargin:20/2];
    [_WordBackView  setupAutoHeightWithBottomView:_WordContentView bottomMargin:0];
    NSLog(@"是否偷听%ld",question.isListen);
    if (_WordContentMessage.text.length==0 ||_WordContentMessage.text == nil ) {
        _WordBackView.hidden = YES;
        _WordBackView.height = 0;
    _voiceTimeLabel.sd_layout.leftSpaceToView(_voicebt,20).centerYEqualToView(_voicebt).widthIs(50).heightEqualToWidth();
        
        
    _activityIndicator.sd_layout.leftSpaceToView(_voicebt,20).centerYEqualToView(_voicebt).widthIs(25).heightEqualToWidth();
        
    _timeLabel.sd_layout.topSpaceToView(_doctorbgImageView,10).leftEqualToView(_doctorbgImageView).autoHeightRatio(0).widthIs([JMFoundation  calLabelWidth:_timeLabel]);

    }else{
        if (question.isListen == 0) {
            _WordBackView.hidden = YES;
            _WordBackView.height = 0;
            _voiceTimeLabel.sd_layout.leftSpaceToView(_voicebt,20).centerYEqualToView(_voicebt).widthIs(50).heightEqualToWidth();
            
            
            _activityIndicator.sd_layout.leftSpaceToView(_voicebt,20).centerYEqualToView(_voicebt).widthIs(25).heightEqualToWidth();
            
            _timeLabel.sd_layout.topSpaceToView(_doctorbgImageView,10).leftEqualToView(_doctorbgImageView).autoHeightRatio(0).widthIs([JMFoundation calLabelWidth:_timeLabel]);

        }else{
        _WordBackView.hidden = NO;
        _WordContentBtn.selected = YES;
        if (_WordContentBtn.selected ==NO) {
            _WordContentView.hidden = YES;
            [_WordBackView  setupAutoHeightWithBottomView:_WordContentBtn bottomMargin:0];
        }else{
            _WordContentView.hidden = NO;
            [_WordBackView  setupAutoHeightWithBottomView:_WordContentView bottomMargin:0];
        }
        _voiceTimeLabel.sd_layout.leftSpaceToView(_voicebt,20).centerYEqualToView(_voicebt).widthIs(50).heightEqualToWidth();
        _activityIndicator.sd_layout.leftSpaceToView(_voicebt,20).centerYEqualToView(_voicebt).widthIs(25).heightEqualToWidth();

        _timeLabel.sd_layout.topSpaceToView(_WordBackView,10).leftEqualToView(_doctorbgImageView).autoHeightRatio(0).widthIs([JMFoundation calLabelWidth:_timeLabel]);
        
       }
    }
    
    _priceLabel.sd_layout.centerYEqualToView(_TraceLabel).autoHeightRatio(0).rightSpaceToView(_containerView,10);
    [_priceLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _hearCount.sd_layout.centerYEqualToView(_timeLabel).autoHeightRatio(0).leftSpaceToView(_timeLabel,10);
    [_hearCount setSingleLineAutoResizeWithMaxWidth:120];
    
    [_containerView setupAutoHeightWithBottomViewsArray:@[_timeLabel,_hearCount] bottomMargin:10];
    
    
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

#pragma mark -

-(void)clickAudionButtonOnCompletion:(ClickAudioButtonBlock)block{
    _clickbtBlock = [block copy];
}

//-(void)setIsWordContentSelect:(int)isWordContentSelect{
//    _isWordContentSelect = isWordContentSelect;
//    _WordContentBtn.selected = isWordContentSelect !=0;
//  
//}

#pragma mark - 点击事件
- (void)clickWordContentbt:(UIButton*) bt{
//    bt.selected = !bt.selected;
//    if(_clickWordContentBlock){
//        _clickWordContentBlock(bt);
//    }
//    NSLog(@"是否选中%ld",bt.selected);
//    
//    if (bt.selected) {
//        _WordContentView.hidden = NO;
//        [_WordBackView  setupAutoHeightWithBottomView:_WordContentView bottomMargin:0];
//       
//        [_timeLabel  updateLayout];
//        [_priceLabel  updateLayout];
//        [_hearCount  updateLayout];
//        [_timeLabel  updateLayout];
//        
//        [_containerView setupAutoHeightWithBottomViewsArray:@[_timeLabel,_hearCount,_priceLabel] bottomMargin:10];
//        
//        
//        [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
//        
//        self.height += 46+30;
//        
//        [self  updateLayout];
//        [self  updateConstraints];
//        
//    }else{
//    
//        _WordContentView.hidden = YES;
//        [_WordBackView  setupAutoHeightWithBottomView:_WordContentBtn bottomMargin:0];
//        
//        [_timeLabel  updateLayout];
//        [_priceLabel  updateLayout];
//        [_hearCount  updateLayout];
//        [_timeLabel  updateLayout];
//        
//        [_containerView setupAutoHeightWithBottomViewsArray:@[_timeLabel,_hearCount,_priceLabel] bottomMargin:10];
//
//        [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
//        self.height -= 46+30;
//        
//        [self  updateLayout];
//        [self  updateConstraints];
//
//    }

}

#pragma mark -

-(void)clickWordContentButtonOnCompletion:(ClickWordContentBlock)block{
    _clickWordContentBlock = [block copy];
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
-(void)setIsMainFreeQusetion:(BOOL)isMainFreeQusetion{
    _isMainFreeQusetion = isMainFreeQusetion;
    runOnMainThread(^{
        if (_isMainFreeQusetion){

            [_voicebt setBackgroundImage:[UIImage imageNamed:@"HEAVoice_Free"] forState:UIControlStateNormal];
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
//-(void)tapAction{
//    if (self.delegate) {
////        [self.delegate WordContentClickAtIndexPath:self.sd_indexPath];
//    }
//}
@end
