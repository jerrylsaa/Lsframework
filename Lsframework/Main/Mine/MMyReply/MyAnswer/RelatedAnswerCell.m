//
//  RelatedAnswerCell.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/12/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "RelatedAnswerCell.h"
#import "NSDate+Category.h"
#import "ApiMacro.h"
#import "SFPhotoBrowser.h"

#define   kImageXspace     20
#define   kImageTopspace     7.5
#define   kImageWidth   (kScreenWidth-10*2-2*kImageXspace)/3

#define topSpace 17.5

@interface RelatedAnswerCell (){
    UIView *_containerView;
    UILabel *_titleNOLabel;
    UILabel *_contentLabel;
    UIImageView *_doctorIcon;
    
    UILabel *_dateLabel;
    UILabel *_heartLabel;
    
    UIView *line;
    
    UILabel *_taskDescribeLabel;
}

@property(nonatomic,strong) UIView *wordBackView;
@property(nonatomic,strong) UIButton *wordContentBtn;
@property(nonatomic,strong) UIView *wordContentView;
@property(nonatomic,strong) UILabel *wordContentMessage;


@property (nonatomic,retain) NSArray *photoBrowserArr;
@property (nonatomic,retain) NSArray *photoBrowserUrlArr;

@end
@implementation RelatedAnswerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.contentView.backgroundColor =[UIColor whiteColor];
    
    _containerView = [UIView new];
    _containerView.backgroundColor =[UIColor whiteColor];
    [self.contentView addSubview:_containerView];
    
    _titleNOLabel =[UILabel new];
    _titleNOLabel.textColor =UIColorFromRGB(0x61d8d3);
    _titleNOLabel.font =[UIFont systemFontOfSize:14.0f];
    [_containerView addSubview:_titleNOLabel];
    
    _contentLabel =[UILabel new];
    _contentLabel.numberOfLines =0;
    _contentLabel.textColor =UIColorFromRGB(0x333333);
    _contentLabel.font =[UIFont systemFontOfSize:14.0f];
    [_containerView addSubview:_contentLabel];
    
    if ([_containerView viewWithTag:9999]) {
        _haveImageBgView =[_containerView viewWithTag:9999];
    }else{
        _haveImageBgView =[[UIView alloc]init];
        _haveImageBgView.tag =9999;
        [_containerView addSubview:_haveImageBgView];
    }
    if ([_haveImageBgView viewWithTag:1001]) {
        _leftImageView =[_haveImageBgView viewWithTag:1001];
    }else{
        _leftImageView =[[UIImageView alloc]init];
        
        _leftImageView.contentMode =UIViewContentModeScaleAspectFill;
        _leftImageView.tag =1001;
        _leftImageView.layer.cornerRadius= 8;
        [_leftImageView.layer setBorderWidth:2];
        [_leftImageView.layer setBorderColor:RGB(80,199, 192).CGColor];
        _leftImageView.clipsToBounds =YES;
        _leftImageView.userInteractionEnabled =YES;
        UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_leftImageView addGestureRecognizer:leftTap];
        [_haveImageBgView addSubview:_leftImageView];
    }
    
    if ([_haveImageBgView viewWithTag:1002]) {
        _midImageView =[_haveImageBgView viewWithTag:1002];
    }else{
        _midImageView =[[UIImageView alloc]init];
        _midImageView.tag =1002;
        _midImageView.contentMode =UIViewContentModeScaleAspectFill;
        _midImageView.layer.cornerRadius= 8;
        [_midImageView.layer setBorderWidth:2];
        [_midImageView.layer setBorderColor:RGB(80,199, 192).CGColor];
        _midImageView.clipsToBounds =YES;
        _midImageView.userInteractionEnabled =YES;
        UITapGestureRecognizer *midTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_midImageView addGestureRecognizer:midTap];
        [_haveImageBgView addSubview:_midImageView];
    }
    if ([_haveImageBgView viewWithTag:1003]) {
        _rightImageView =[_haveImageBgView viewWithTag:1003];
    }else{
        _rightImageView =[[UIImageView alloc]init];
        _rightImageView.tag =1003;
        _rightImageView.contentMode =UIViewContentModeScaleAspectFill;
        _rightImageView.layer.cornerRadius= 8;
        [_rightImageView.layer setBorderWidth:2];
        [_rightImageView.layer setBorderColor:RGB(80,199, 192).CGColor];
        _rightImageView.clipsToBounds =YES;
        _rightImageView.userInteractionEnabled =YES;
        UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_rightImageView addGestureRecognizer:rightTap];
        [_haveImageBgView addSubview:_rightImageView];
    }
    
    _leftImageView1 = [self newImageWithTag:1004];
    [_haveImageBgView addSubview:_leftImageView1];
    
    _midImageView2 = [self newImageWithTag:1005];
    [_haveImageBgView addSubview:_midImageView2];
    
    _rightImageView3 = [self newImageWithTag:1006];
    [_haveImageBgView addSubview:_rightImageView3];
    
    
    _doctorIcon =[UIImageView new];
    _doctorIcon.layer.masksToBounds = YES;
    _doctorIcon.layer.cornerRadius = 25;
    [_containerView addSubview:_doctorIcon];
    
    _voiceBtn = [UIButton new];
    [_voiceBtn setBackgroundImage:[UIImage imageNamed:@"icon_vioce"] forState:UIControlStateNormal];
    [_voiceBtn setTitle:@"播放" forState:UIControlStateNormal];
    _voiceBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [_containerView addSubview:_voiceBtn];
    [_voiceBtn addTarget:self action:@selector(voiceAction) forControlEvents:UIControlEventTouchUpInside];
    
    _voiceTimeLabel =[UILabel new];
    _voiceTimeLabel.font =[UIFont boldSystemFontOfSize:14.0f];
    _voiceTimeLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_voiceTimeLabel];
    
    _wordBackView = [UIView  new];
    _wordBackView.backgroundColor = [UIColor  clearColor];
    [_containerView  addSubview:_wordBackView];
    
    
    _wordContentBtn = [UIButton  new];
    _wordContentBtn.selected = YES;
    _wordContentBtn.backgroundColor = [UIColor  clearColor];
    [_wordContentBtn setImage:[UIImage  imageNamed:@"WordContent_Close"] forState:UIControlStateNormal];
    
    [_wordContentBtn  setImage:[UIImage  imageNamed:@"WordContent_Open"] forState:UIControlStateSelected];
    
    //
//    [_wordContentBtn  addTarget:self action:@selector(WordContentClick:) forControlEvents:UIControlEventAllEvents];
    [_wordBackView  addSubview:_wordContentBtn];
    
    
    _wordContentView  = [UIView  new];
    _wordContentView.backgroundColor = [UIColor  whiteColor];
    _wordContentView.layer.masksToBounds = YES;
    _wordContentView.layer.cornerRadius = 10/2;
    _wordContentView.layer.borderWidth = 1;
    _wordContentView.layer.borderColor = UIColorFromRGB(0x61d8d3).CGColor;
    [_wordBackView addSubview:_wordContentView];
    
    _wordContentMessage = [UILabel  new];
    _wordContentMessage.backgroundColor = [UIColor  clearColor];
    _wordContentMessage.font = [UIFont  systemFontOfSize:15];
    _wordContentMessage.numberOfLines = 0;
    //    _wordContentMessage.text=self.presenter.question.WordContent;
    _wordContentMessage.textColor = UIColorFromRGB(0x333333);
    _wordContentMessage.textAlignment = NSTextAlignmentLeft;
    [_wordContentView  addSubview:_wordContentMessage];
    
    _dateLabel =[UILabel new];
    _dateLabel.font =[UIFont boldSystemFontOfSize:12.0f];
    _dateLabel.textColor =UIColorFromRGB(0x999999);
    [_containerView addSubview:_dateLabel];
    
    _heartLabel =[UILabel new];
    _heartLabel.font =[UIFont boldSystemFontOfSize:12.0f];
    _heartLabel.textColor =UIColorFromRGB(0x999999);
    [_containerView addSubview:_heartLabel];
    
    line =[UIView new];
    line.backgroundColor =UIColorFromRGB(0xf2f2f2);
    [_containerView addSubview:line];
    
}

- (void)setCellEntity:(RelatedAnswerEntity *)cellEntity{
    _cellEntity =cellEntity;
    _titleNOLabel.text =[NSString stringWithFormat:@"追问:%ld",(long)cellEntity.traceNO];
    _contentLabel.text =cellEntity.ConsultationContent;
    
    
    
    
    
    _haveImageBgView.sd_layout.leftSpaceToView(_containerView,10).topSpaceToView(_contentLabel,0).widthIs(kScreenWidth -20).heightIs(kImageWidth+topSpace);
    _leftImageView.sd_layout.topSpaceToView(_haveImageBgView,topSpace).leftSpaceToView(_haveImageBgView,0).widthIs(kImageWidth).heightIs(kImageWidth);
    _midImageView.sd_layout.topEqualToView(_leftImageView).leftSpaceToView(_haveImageBgView,kImageWidth +kImageXspace).widthIs(kImageWidth).heightIs(kImageWidth);
    _rightImageView.sd_layout.topEqualToView(_leftImageView).leftSpaceToView(_haveImageBgView,kImageWidth*2+2*kImageXspace).widthIs(kImageWidth).heightIs(kImageWidth);
    _leftImageView1.sd_layout.leftEqualToView(_leftImageView).topSpaceToView(_haveImageBgView,kImageWidth+kImageTopspace+topSpace).widthIs(kImageWidth).heightEqualToWidth();
    _midImageView2.sd_layout.leftEqualToView(_midImageView).topEqualToView(_leftImageView1).widthIs(kImageWidth).heightEqualToWidth();
    _rightImageView3.sd_layout.leftEqualToView(_rightImageView).topEqualToView(_leftImageView1).widthIs(kImageWidth).heightEqualToWidth();
    
    if (cellEntity.Image1!=nil&&cellEntity.Image1.length>4&&(![cellEntity.Image1 isEqualToString:@""])) {
        _haveImageBgView.hidden =NO;
        
        _haveImageBgView.sd_layout.leftSpaceToView(_containerView,10).topSpaceToView(_contentLabel,0).widthIs(kScreenWidth -20).heightIs(kImageWidth+topSpace);
        
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image1]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
        if (cellEntity.Image2!=nil&&cellEntity.Image2.length>4&&(![cellEntity.Image2 isEqualToString:@""])) {
            
            [_midImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image2]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
            if (cellEntity.Image3!=nil&&cellEntity.Image3.length>4&&(![cellEntity.Image3 isEqualToString:@""])) {
                
                [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image3]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                if (cellEntity.Image4!=nil&&cellEntity.Image4.length>4&&(![cellEntity.Image4 isEqualToString:@""])) {
                    
                    _haveImageBgView.sd_layout.leftSpaceToView(_containerView,10).topSpaceToView(_contentLabel,0).widthIs(kScreenWidth -20).heightIs(kImageWidth*2+topSpace+kImageTopspace);
                    
                    [_leftImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image4]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                    
                    if ((cellEntity.Image5!=nil&&cellEntity.Image5.length>4&&(![cellEntity.Image5 isEqualToString:@""]))) {
                        
                        _midImageView2.sd_layout.leftEqualToView(_midImageView).topEqualToView(_leftImageView1).widthIs(kImageWidth).heightEqualToWidth();
                        
                        [_midImageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image5]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                        
                        if ((cellEntity.Image6!=nil&&cellEntity.Image6.length>4&&(![cellEntity.Image6 isEqualToString:@""]))) {
                            
                            _rightImageView3.sd_layout.leftEqualToView(_rightImageView).topEqualToView(_leftImageView1).widthIs(kImageWidth).heightEqualToWidth();
                            
                            _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1,_midImageView2,_rightImageView3];
                            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image5],[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image6]];
                            
                            [_rightImageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image6]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                            
                        }else{
                            // 5
                            _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1,_midImageView2];
                            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image5]];
                            _rightImageView3.hidden = YES;
                        }
                        
                    }else{
                        // 4
                        _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1];
                        _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image4]];
                        _rightImageView3.hidden = YES;
                        _midImageView2.hidden = YES;
                    }
                    
                }else{
                    // 3
                    _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView];
                    _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image3]];
                    _rightImageView3.hidden = YES;
                    _midImageView2.hidden = YES;
                    _leftImageView1.hidden = YES;
                }
                
            }else {
                _photoBrowserArr =@[_leftImageView,_midImageView];
                _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image2]];
                _rightImageView.hidden =YES;
                _rightImageView3.hidden = YES;
                _midImageView2.hidden = YES;
                _leftImageView1.hidden = YES;
            }
        }else{
            _photoBrowserArr =@[_leftImageView];
            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,cellEntity.Image1]];
            _midImageView.hidden =YES;
            _rightImageView.hidden =YES;
            _rightImageView3.hidden = YES;
            _midImageView2.hidden = YES;
            _leftImageView1.hidden = YES;
        }
        
    }else{
        _haveImageBgView.sd_layout.leftSpaceToView(_containerView,10).topSpaceToView(_contentLabel,0).widthIs(280).heightIs(0);
        _haveImageBgView.hidden =YES;
    }
    [_haveImageBgView layoutSubviews];
    [_haveImageBgView updateLayout];
    
    
    
    
    _containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    
    _titleNOLabel.sd_layout.topSpaceToView(_containerView,15).leftSpaceToView(_containerView,15).widthIs(80).heightIs(20);
    _contentLabel.sd_layout.topSpaceToView(_titleNOLabel,10).leftSpaceToView(_containerView,15).rightSpaceToView(_containerView,15).autoHeightRatio(0);
    
    if (_haveImageBgView.height == 0) {
        
        _doctorIcon.sd_layout.topSpaceToView(_contentLabel,15).leftSpaceToView(_containerView,15).heightIs(50).widthIs(50);
        
    }else if (_haveImageBgView.height ==kImageWidth+topSpace ){
        
        _doctorIcon.sd_layout.topSpaceToView(_contentLabel,15+kImageWidth+topSpace).leftSpaceToView(_containerView,15).heightIs(50).widthIs(50);
        
    }else{
        
        _doctorIcon.sd_layout.topSpaceToView(_contentLabel,15+kImageWidth*2+topSpace+kImageTopspace).leftSpaceToView(_containerView,15).heightIs(50).widthIs(50);
    }
    
    _voiceBtn.sd_layout.leftSpaceToView(_doctorIcon,5).centerYEqualToView(_doctorIcon).heightIs(30).widthIs(120);
    _voiceTimeLabel.sd_layout.leftSpaceToView(_voiceBtn,5).centerYEqualToView(_voiceBtn).heightIs(18).widthIs(80);
    
    _wordBackView.sd_layout.topSpaceToView(_doctorIcon,30/2).leftSpaceToView(_doctorIcon,0).rightSpaceToView(_containerView,30/2);
    
    
    _wordContentBtn.sd_layout.topSpaceToView(_wordBackView,0).leftSpaceToView(_wordBackView,5).widthIs(154/2).heightIs(16);
    
    _wordContentView.sd_layout.topSpaceToView(_wordContentBtn,20/2).leftEqualToView(_wordBackView).rightEqualToView(_wordBackView);
    
    _wordContentMessage.sd_layout.topSpaceToView(_wordContentView,20/2).leftSpaceToView(_wordContentView,20/2).rightSpaceToView(_wordContentView,20/2).autoHeightRatio(0);
    
    [_wordContentView setupAutoHeightWithBottomView:_wordContentMessage bottomMargin:20/2];
    
    [_wordBackView  setupAutoHeightWithBottomView:_wordContentView bottomMargin:0];
    
    _dateLabel.sd_layout.leftSpaceToView(_containerView,15).topSpaceToView(_wordBackView,15).heightIs(18).widthIs(80);
    _heartLabel.sd_layout.leftSpaceToView(_dateLabel,5).centerYEqualToView(_dateLabel).heightIs(18).widthIs(80);
    line.sd_layout.leftSpaceToView(_containerView,15).topSpaceToView(_dateLabel,10).rightSpaceToView(_containerView,15).heightIs(1);
    
    
    [_containerView setupAutoHeightWithBottomView:line bottomMargin:0];
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
    
    [_doctorIcon sd_setImageWithURL:[NSURL URLWithString:cellEntity.ImageUrl] placeholderImage:[UIImage  imageNamed:@"doctor_defaul"]];
    if (cellEntity.VoiceTime!=nil&&[cellEntity.VoiceTime stringValue].length!=0&&![[cellEntity.VoiceTime stringValue] isEqualToString:@"0"]) {
        _voiceTimeLabel.text =[NSString stringWithFormat:@"%@''",cellEntity.VoiceTime?cellEntity.VoiceTime:@"0"];
    }
    if (cellEntity.VoiceUrl.length == 0 || [cellEntity.VoiceUrl isKindOfClass:[NSNull class]]||[cellEntity.ConsultationStatus integerValue]==0) {
        [_voiceBtn setTitle:@"去回答" forState:UIControlStateNormal];
    }else{
        [_voiceBtn setTitle:@"播放" forState:UIControlStateNormal];
    }
    
    _wordContentMessage.text =cellEntity.WordContent;
    if (_wordContentMessage.text.length ==0||[_wordContentMessage.text isEqualToString:@""]||_wordContentMessage.text==nil) {
        _wordBackView.hidden =YES;
        _dateLabel.sd_layout.leftSpaceToView(_containerView,15).topSpaceToView(_doctorIcon,15).heightIs(18).widthIs(80);
        
        
    }else{
        _wordBackView.hidden =NO;
        _dateLabel.sd_layout.leftSpaceToView(_containerView,15).topSpaceToView(_wordBackView,15).heightIs(18).widthIs(80);
        
    }
    
    //    _dateLabel.text =[NSDate getDateCompare:cellEntity.CreateTime];
    _dateLabel.text = cellEntity.CreateTime;
    _heartLabel.text =[NSString stringWithFormat:@"听过%@",cellEntity.HearCount];

    
}

- (void)voiceAction{
    WS(ws);
    if (ws.delegate && [ws.delegate respondsToSelector:@selector(playVoiceByCell:)]) {
        [ws.delegate playVoiceByCell:ws];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    //显示图片浏览器
    [SFPhotoBrowser showImageInView:[UIApplication sharedApplication].keyWindow selectImageIndex:(tap.view.tag-1001) delegate:self];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(UIImageView *)newImageWithTag:(NSInteger)tag
{
    UIImageView *newImage =[[UIImageView alloc]init];
    newImage.tag =tag;
    newImage.contentMode =UIViewContentModeScaleAspectFill;
    newImage.layer.cornerRadius= 8;
    [newImage.layer setBorderWidth:2];
    [newImage.layer setBorderColor:RGB(80,199, 192).CGColor];
    newImage.clipsToBounds =YES;
    newImage.userInteractionEnabled =YES;
    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [newImage addGestureRecognizer:Tap];
    
    return newImage;
}

@end
