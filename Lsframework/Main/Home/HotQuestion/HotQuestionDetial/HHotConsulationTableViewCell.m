//
//  HHotConsulationTableViewCell.m
//  FamilyPlatForm
//
//  Created by jerry on 16/9/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HHotConsulationTableViewCell.h"
#import "JMFoundation.h"
#import "ApiMacro.h"
#import "SFPhotoBrowser.h"


#define HaveImageWidth   kScreenWidth-30/2-30-24/2-30/2
#define PhotoSpace  15
#define PhotoWidth  (HaveImageWidth-PhotoSpace*2)/3
#define PhotoHeight (HaveImageWidth-PhotoSpace*2)/3
#define topSpace 7.5

@interface HHotConsulationTableViewCell()<PhotoBrowerDelegate>{
    UIView *_containerView;
    UIImageView  *_HeadImageView;
    UILabel  *_HeadName;
    UILabel  *_FloorLb;
    UILabel  *_CommentContent;
    UIImageView  *_TimeImageView;
    UILabel  *_TimeLb;
    
    
    UIImageView  *_AnswerImageView;
    UILabel   *_AnswerCount;
    
    
    UIView* replybgView;
    UIView* replyLine;
    UILabel* reply1Label;
    UILabel* reply2Label;
    
    UIView* grayBarView;

    
}


@property (nonatomic,retain) NSArray *photoBrowserArr;
@property (nonatomic,retain) NSArray *photoBrowserUrlArr;

@end


@implementation HHotConsulationTableViewCell



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
    _HeadImageView.userInteractionEnabled = YES;
    _HeadImageView.backgroundColor = [UIColor  clearColor];
    UITapGestureRecognizer* babyIconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBabyAction:)];
    [_HeadImageView addGestureRecognizer:babyIconTap];
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
    
    
    
    
    _AnswerCountBtn = [UIButton  new];
    _AnswerCountBtn.backgroundColor = [UIColor  clearColor];
    [_AnswerCountBtn  setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    _AnswerCountBtn.titleLabel.font = [UIFont  systemFontOfSize:11];
    [_AnswerCountBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -15)];
    [_AnswerCountBtn  setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -15)];
    [_containerView  addSubview:_AnswerCountBtn];
    
    _HaveImageView =[[UIView alloc]init];
    _HaveImageView.backgroundColor = [UIColor clearColor];
    [_containerView addSubview:_HaveImageView];
    
    
    
    //回复
    replybgView = [UIView new];
    [_containerView addSubview:replybgView];
    replyLine = [UIView new];
    replyLine.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [replybgView addSubview:replyLine];
    reply1Label = [UILabel new];
    reply1Label.font = [UIFont systemFontOfSize:sbigFont];
    reply1Label.textColor = UIColorFromRGB(0x666666);
    reply1Label.isAttributedContent = YES;
    [replybgView addSubview:reply1Label];
    reply2Label = [UILabel new];
    reply2Label.textColor = UIColorFromRGB(0x666666);
    reply2Label.font = [UIFont systemFontOfSize:sbigFont];
    reply2Label.isAttributedContent = YES;
    [replybgView addSubview:reply2Label];
    
    //底部灰色条
    grayBarView = [UIView new];
    grayBarView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_containerView addSubview:grayBarView];
    
    
}
-(void)setCommenList:(ConsultationCommenList *)CommenList{

    _CommenList = CommenList;
    
    [_HeadImageView  setImageWithUrl:[ NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.CHILD_IMG] placeholderImage:[UIImage  imageNamed:@"my_answer"]];
    
    _HeadName.text = _CommenList.NickName;
    
    _CommentContent.attributedText = [UILabel getAttributeTextWithString:_CommenList.CommentContent];
    
    [_TimeImageView  setImageWithUrl:nil placeholderImage:[UIImage  imageNamed:@"DailyPrise_TimeImage"]];
    
    _TimeLb.text = _CommenList.CreateTime;
    
    _FloorLb.text = [NSString  stringWithFormat:@"%d楼",_CommenList.RowID];
   
    
[_AnswerCountBtn  setImage:[UIImage  imageNamed:@"HotAnswerBtnImage"] forState:UIControlStateNormal];
[_AnswerCountBtn  setTitle:[NSString  stringWithFormat:@"%d",_CommenList.ReplyCount] forState:UIControlStateNormal];
    
    _containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    
    _HeadImageView.sd_layout.topSpaceToView(_containerView,30/2).leftSpaceToView(_containerView,30/2).widthIs(60/2).heightIs(60/2);
    _HeadImageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    
    _HeadName.sd_layout.topSpaceToView(_containerView,15+8).leftSpaceToView(_HeadImageView,24/2).heightIs(14).widthIs(kScreenWidth-_HeadImageView.frame.size.width-_FloorLb.frame.size.width-30/2-24/2-30/2);
    
    _FloorLb.sd_layout.topEqualToView(_HeadName).rightSpaceToView(_containerView,30/2).heightIs(11).widthIs(80);
    
    _CommentContent.sd_layout.topSpaceToView(_HeadName,30/2).leftEqualToView(_HeadName).widthIs(HaveImageWidth).autoHeightRatio(0);
    
        if (_CommenList.Image1==nil|_CommenList.Image1.length==0|_CommenList.Image1.length<5) {
            
            _HaveImageView.hidden =YES;
            
            _HaveImageView.sd_layout.topSpaceToView(_CommentContent,0).leftEqualToView(_HeadName).widthIs(0).heightIs(0);
            
        }else{
            _HaveImageView.sd_layout.topSpaceToView(_CommentContent,10).leftEqualToView(_HeadName).widthIs(HaveImageWidth).heightIs(PhotoHeight);
            
            if (_CommenList.Image1!=nil&&_CommenList.Image1.length>4&&(![_CommenList.Image1 isEqualToString:@""])) {
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
                    _leftImage.sd_layout.topSpaceToView(_HaveImageView,0).leftSpaceToView(_HaveImageView,0).widthIs(PhotoWidth).heightIs(PhotoHeight);
                }
                
                [_leftImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image1]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                
                
                if (_CommenList.Image2!=nil&&_CommenList.Image2.length>4&&(![_CommenList.Image2 isEqualToString:@""])) {
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
                        _midImage.sd_layout.topEqualToView(_leftImage).leftSpaceToView(_HaveImageView,PhotoWidth+PhotoSpace).widthIs(PhotoWidth).heightIs(PhotoHeight);
                    }
                    
                    [_midImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image2]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                    
                    
                    if (_CommenList.Image3!=nil&&(![_CommenList.Image3 isEqualToString:@""])&&_CommenList.Image3.length>4) {
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
                            _rightImage.sd_layout.topEqualToView(_leftImage).leftSpaceToView(_HaveImageView,2*PhotoWidth+2*PhotoSpace).widthIs(PhotoWidth).heightIs(PhotoHeight);
                        }
                        
                        [_rightImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image3]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                        
                        if (_CommenList.Image4!=nil&&(![_CommenList.Image4 isEqualToString:@""])&&_CommenList.Image4.length>4) {
                            _HaveImageView.sd_layout.topSpaceToView(_CommentContent,10).leftEqualToView(_HeadName).widthIs(HaveImageWidth).heightIs(PhotoHeight*2+topSpace);
                            _leftImage1 = [self viewWithTag:1004];
                            if (_leftImage1 == nil) {
                                _leftImage1 = [self newImageWithIninter:1004];
                                
                                [_HaveImageView addSubview:_leftImage1];
                                _leftImage1.sd_layout.topSpaceToView(_HaveImageView,PhotoHeight+topSpace+10).leftEqualToView(_leftImage).widthIs(PhotoWidth).heightIs(PhotoHeight);
                            }
                            [_leftImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image4]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                            
                            if (_CommenList.Image5!=nil&&(![_CommenList.Image5 isEqualToString:@""])&&_CommenList.Image5.length>4) {
                        
                                _midImage1 = [self viewWithTag:1005];
                                if (_midImage1 == nil) {
                                    _midImage1 = [self newImageWithIninter:1005];
                                    
                                    [_HaveImageView addSubview:_midImage1];
                                    _midImage1.sd_layout.topEqualToView(_leftImage1).leftEqualToView(_midImage).widthIs(PhotoWidth).heightIs(PhotoHeight);
                                }
                                [_midImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image5]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                                
                                if (_CommenList.Image6!=nil&&(![_CommenList.Image6 isEqualToString:@""])&&_CommenList.Image6.length>4) {
                                    
                                    _rightImage1 = [self viewWithTag:1006];
                                    if (_rightImage1 == nil) {
                                        _rightImage1 = [self newImageWithIninter:1006];
                                        [_HaveImageView addSubview:_rightImage1];
                                        _rightImage1.sd_layout.topEqualToView(_leftImage1).leftEqualToView(_rightImage).widthIs(PhotoWidth).heightIs(PhotoHeight);
                                    }
                                    [_rightImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image6]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
                                    
                                    self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image5],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image6]];
                                    self.photoBrowserArr =@[_leftImage,_midImage,_rightImage,_leftImage1,_midImage1,_rightImage1];
                                    
                                }else{
                                    // 5
                                   
                                    self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image5]];
                                    self.photoBrowserArr =@[_leftImage,_midImage,_rightImage,_leftImage1,_midImage1];
                                    
                                    _rightImage1.hidden = YES;
                                    
                                }
                                
                                
                            }else{
                                // 4
                                self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image4]];
                                self.photoBrowserArr =@[_leftImage,_midImage,_rightImage,_leftImage1];
                                
                                _rightImage1.hidden = YES;
                                _midImage1.hidden = YES;
                            }
                            
                        }else{
                        // 3
                        self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image3]];
                        self.photoBrowserArr =@[_leftImage,_midImage,_rightImage];
                            
                            _rightImage1.hidden = YES;
                            _midImage1.hidden = YES;
                            _leftImage1.hidden = YES;
                        
                        }
                    }else {
                        //只有2张图 1, 2
                        self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image2]];
                        self.photoBrowserArr =@[_leftImage,_midImage];
                        
                        _rightImage.hidden = YES;
                        _rightImage1.hidden = YES;
                        _midImage1.hidden = YES;
                        _leftImage1.hidden = YES;
                    }
                    
                    
                }else{
                    //只有1张图 1
                    
                    self.photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image1]];
                    self.photoBrowserArr =@[_leftImage];
                    _midImage.hidden = YES;
                    _rightImage.hidden = YES;
                    _rightImage1.hidden = YES;
                    _midImage1.hidden = YES;
                    _leftImage1.hidden = YES;
                }
            }
            
        }
    
    

    //增加判断，否则_HaveImageView高度为0时造成reloadData后加载不出来，cpu爆炸
    if (_HaveImageView.height == 0) {
    _TimeImageView.sd_layout.topSpaceToView(_CommentContent,30/2).leftEqualToView(_HeadName).widthIs(30/2).heightIs(30/2);
    _AnswerCountBtn.sd_layout.topSpaceToView(_CommentContent,0).rightSpaceToView(_containerView,0).widthIs(30/2+60).heightIs(90/2);
    }else if (_HaveImageView.height ==PhotoHeight ){
        
    _TimeImageView.sd_layout.topSpaceToView(_CommentContent,30/2+PhotoHeight).leftEqualToView(_HeadName).widthIs(30/2).heightIs(30/2);
    
    _AnswerCountBtn.sd_layout.topSpaceToView(_CommentContent,PhotoHeight).rightSpaceToView(_containerView,0).widthIs(30/2+60).heightIs(90/2);
        
        
    }else{
//    _TimeImageView.sd_layout.topSpaceToView(_CommentContent,30/2+95).leftEqualToView(_HeadName).widthIs(30/2).heightIs(30/2);
//        
//    _AnswerCountBtn.sd_layout.topSpaceToView(_CommentContent,95).rightSpaceToView(_containerView,0).widthIs(30/2+60).heightIs(90/2);
        
    _TimeImageView.sd_layout.topSpaceToView(_CommentContent,30/2+PhotoHeight*2+10 +topSpace).leftEqualToView(_HeadName).widthIs(30/2).heightIs(30/2);
    
    _AnswerCountBtn.sd_layout.topSpaceToView(_CommentContent,PhotoHeight*2+10 +topSpace).rightSpaceToView(_containerView,0).widthIs(30/2+60).heightIs(90/2);

    }


  
_TimeLb.sd_layout.topEqualToView(_TimeImageView).leftSpaceToView(_TimeImageView,5).widthIs(kJMWidth(_TimeLb)).heightIs(11);

//       _lineLb.sd_layout.topSpaceToView(_TimeLb,30/2).leftEqualToView(_containerView).rightEqualToView(_containerView).heightIs(1);
    
    
    //回复
    replybgView.sd_layout.topSpaceToView(_TimeLb,15).leftEqualToView(_CommentContent).rightSpaceToView(_containerView,0);
    replyLine.sd_layout.topSpaceToView(replybgView,0).heightIs(1).leftSpaceToView(replybgView,0).rightSpaceToView(replybgView,0);
    reply1Label.sd_layout.topSpaceToView(replyLine,10).leftEqualToView(replyLine).rightSpaceToView(replybgView,5).autoHeightRatio(0);
    reply2Label.sd_layout.topSpaceToView(reply1Label,10).leftEqualToView(replyLine).rightSpaceToView(replybgView,5).autoHeightRatio(0);
    [replybgView setupAutoHeightWithBottomView:reply2Label bottomMargin:0];
    
    //灰色条
    grayBarView.sd_layout.topSpaceToView(replybgView,15).leftSpaceToView(_containerView,0).rightSpaceToView(_containerView,0).heightIs(1);
    
    [_containerView setupAutoHeightWithBottomView:grayBarView bottomMargin:0];
    
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
    
    //回复
    
    if(_CommenList.ReplyCommentList.count == 0){
        //        NSLog(@"无回复");
        
        replybgView.hidden = YES;
        grayBarView.sd_layout.topSpaceToView(_TimeLb,20).leftSpaceToView(_containerView,0).rightSpaceToView(_containerView,0).heightIs(1);
    }else{
        replybgView.hidden = NO;
        grayBarView.sd_layout.topSpaceToView(replybgView,20).leftSpaceToView(_containerView,0).rightSpaceToView(_containerView,0).heightIs(1);
        
        if(_CommenList.ReplyCommentList.count == 1){
            //            NSLog(@"1回复");
            
            //            [reply1Label sd_resetLayout];
            //            [reply2Label sd_resetLayout];
            //
            //            reply1Label.sd_layout.topSpaceToView(replyLine,10).leftEqualToView(replyLine).rightSpaceToView(replybgView,5).autoHeightRatio(0);
            //            reply2Label.sd_layout.topSpaceToView(reply1Label,10).leftEqualToView(replyLine).rightEqualToView(reply1Label).heightIs(0);
            [replybgView setupAutoHeightWithBottomView:reply1Label bottomMargin:0];
            reply2Label.hidden = YES;
            
            NSString* nickName = [_CommenList.ReplyCommentList firstObject].NickName;
            NSString* comentContent = [_CommenList.ReplyCommentList firstObject].CommentContent;
            
            NSMutableAttributedString* reply1Attribute = [UILabel getAttributeTextWithString:[NSString stringWithFormat:@"%@：%@",nickName,comentContent]];
            [reply1Attribute addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x61d8d3) range:NSMakeRange(0, nickName.length)];
            reply1Label.attributedText = reply1Attribute;
            
        }else if(_CommenList.ReplyCommentList.count == 2){
            //            NSLog(@"2回复");
            
            //            [reply1Label sd_resetLayout];
            //            [reply2Label sd_resetLayout];
            //
            //            reply1Label.sd_layout.topSpaceToView(replyLine,10).leftEqualToView(replyLine).rightSpaceToView(replybgView,5).autoHeightRatio(0);
            //            reply2Label.sd_layout.topSpaceToView(reply1Label,10).leftEqualToView(replyLine).rightEqualToView(reply1Label).autoHeightRatio(0);
            [replybgView setupAutoHeightWithBottomView:reply2Label bottomMargin:0];
            reply2Label.hidden = NO;
            
            NSString* nickName = [_CommenList.ReplyCommentList firstObject].NickName;
            NSString* comentContent = [_CommenList.ReplyCommentList firstObject].CommentContent;
            NSMutableAttributedString* reply1Attribute = [UILabel getAttributeTextWithString:[NSString stringWithFormat:@"%@：%@",nickName,comentContent]];
            [reply1Attribute addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x61d8d3) range:NSMakeRange(0, nickName.length)];
            reply1Label.attributedText = reply1Attribute;
            
            NSString* nickName2 = [_CommenList.ReplyCommentList lastObject].NickName;
            NSString* comentContent2 = [_CommenList.ReplyCommentList lastObject].CommentContent;
            NSMutableAttributedString* reply2Attribute = [UILabel getAttributeTextWithString:[NSString stringWithFormat:@"%@：%@",nickName2,comentContent2]];
            [reply2Attribute addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x61d8d3) range:NSMakeRange(0, nickName2.length)];
            reply2Label.attributedText = reply2Attribute;
            
        }
        [reply1Label updateLayout];
        [reply2Label updateLayout];
        [replybgView updateLayout];
        
    }
    [grayBarView updateLayout];

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

#pragma mark - 手势监听
- (void)clickBabyAction:(UITapGestureRecognizer*) tapGesture{
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickBabyIconWithConsultationCommenList:)]){
        [self.delegate clickBabyIconWithConsultationCommenList:self.CommenList];
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
-(UIImageView *)newImageWithIninter:(NSInteger)tag
{
    UIImageView *newImage =[UIImageView new];
    newImage.tag =tag;
    newImage.contentMode =UIViewContentModeScaleAspectFill;
    newImage.layer.cornerRadius= 8;
    [newImage.layer setBorderWidth:2];
    [newImage.layer setBorderColor:RGB(80,199, 192).CGColor];
    newImage.clipsToBounds =YES;
    newImage.image =nil;
    newImage.userInteractionEnabled =YES;
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [newImage addGestureRecognizer:taps];
    return newImage;
}

@end
