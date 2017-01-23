//
//  SearchSymptomTableViewCell.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/4.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "SearchSymptomTableViewCell.h"
#import "JMFoundation.h"
@interface   SearchSymptomTableViewCell(){
    /**
     *{
     "RowID": 2,
     "ConsultationType": 0,
     "DiseaseTitle": "麻痹",
     "TitleHref": "http://zzk.xywy.com/2633_gaishu.html",
     "Image": "http://xs3.op.xywy.com/api.iu1.xywy.com/jib/20160509/04c148b4d31fd39fde7db29730342fbd59022.jpg",
     "TitleIntroduce": "广义的麻痹是指机体的细胞、组织和器官的机能衰退，对刺激不发生反应的状态。狭义的麻...",
     "DiseaseName1": "格子状角膜营养不良",
     "DiseaseName2": "颅骨巨细胞瘤",
     "DiseaseName3": "小儿热性惊厥",
     "DiseaseName4": "老年人高钾血症",
     "DiseaseName5": "急性全自主神经失调症",
     "DiseaseIntro1": "格子状角膜营养不良(la...",
     "DiseaseIntro2": "颅骨巨细胞瘤以蝶骨和颞骨...",
     "DiseaseIntro3": "热性惊厥(febrile...",
     "DiseaseIntro4": "高钾血症是指血清钾&gt;...",
     "DiseaseIntro5": "急性全自主神经失调症(a...",
     "DiseaseHref1": "http://3g.jib.xywy.com/il_sii_5691.htm",
     "DiseaseHref2": "http://3g.jib.xywy.com/il_sii_6355.htm",
     "DiseaseHref3": "http://3g.jib.xywy.com/il_sii_7604.htm",
     "DiseaseHref4": "http://3g.jib.xywy.com/il_sii_6149.htm",
     "DiseaseHref5": "http://3g.jib.xywy.com/il_sii_5835.htm",
     "MoreUrl": "http://3g.jib.xywy.com/zzk"

     */
    UIView* _containerView;
    
    UILabel* _DiseaseTitleLb;
    UIImageView  *_DiseaseImageView;
    UILabel* _TitleIntroduceLb;
    UILabel* _PossibleDiseaseLb;
    UILabel* _MoreDiseaseLb;
    UIImageView *_MoreDiseaseImageView;
    UIView  *_LineView;
    
    UILabel *_DiseaseName1Lb;
    UIView  *_LineView1;
    UIImageView  *_DiseaseName1ImageView;
    
    UILabel *_DiseaseName2Lb;
    UIView  *_LineView2;
    UIImageView  *_DiseaseName2ImageView;
    
    UILabel *_DiseaseName3Lb;
    UIView  *_LineView3;
    UIImageView  *_DiseaseName3ImageView;
    
    UILabel *_DiseaseName4Lb;
    UIView  *_LineView4;
    UIImageView  *_DiseaseName4ImageView;
    
    UILabel *_DiseaseName5Lb;
    UIView  *_LineView5;
    UIImageView  *_DiseaseName5ImageView;
    
    UILabel *_DiseaseMoreLb;
    UIImageView *_DiseaseMoreImageView;
    UIView  *_BottomView;
}
@end

@implementation SearchSymptomTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self setupSubviews];
    }
    return self;
}
-(void)setupSubviews{
    
    _containerView = [UIView new];
    _containerView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:_containerView];

    UIView  *TopView = [UIView  new];
    TopView.backgroundColor = [UIColor  clearColor];
    UITapGestureRecognizer *TopViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Toptap)];
    [TopView addGestureRecognizer:TopViewTap];
    [_containerView  addSubview:TopView];
    
    _DiseaseTitleLb = [UILabel  new];
    _DiseaseTitleLb.numberOfLines = 1;
    _DiseaseTitleLb.textAlignment = NSTextAlignmentLeft;
    _DiseaseTitleLb.textColor = UIColorFromRGB(0xe20f00);
    _DiseaseTitleLb.font = [UIFont  systemFontOfSize:18];
    [TopView  addSubview:_DiseaseTitleLb];
    
    _TitleIntroduceLb = [UILabel  new];
    _TitleIntroduceLb.numberOfLines = 0;
    _TitleIntroduceLb.textAlignment = NSTextAlignmentLeft;
    _TitleIntroduceLb.textColor = UIColorFromRGB(0x333333);
    _TitleIntroduceLb.font = [UIFont  systemFontOfSize:16];
    [TopView  addSubview:_TitleIntroduceLb];
    
    _DiseaseImageView = [UIImageView  new];
    _DiseaseImageView.layer.cornerRadius = 5/2;
    _DiseaseImageView.backgroundColor = [UIColor  clearColor];
    [TopView  addSubview:_DiseaseImageView];
    
    
    _PossibleDiseaseLb = [UILabel  new];
    _PossibleDiseaseLb.numberOfLines = 1;
    _PossibleDiseaseLb.textAlignment = NSTextAlignmentLeft;
    _PossibleDiseaseLb.textColor = UIColorFromRGB(0x5ce0f8);
    _PossibleDiseaseLb.font = [UIFont  systemFontOfSize:14];
    [TopView  addSubview:_PossibleDiseaseLb];
    
    _MoreDiseaseLb = [UILabel  new];
    _MoreDiseaseLb.numberOfLines = 1;
    _MoreDiseaseLb.textAlignment = NSTextAlignmentLeft;
    _MoreDiseaseLb.textColor = UIColorFromRGB(0x3324d8);
    _MoreDiseaseLb.font = [UIFont  systemFontOfSize:14];
    [TopView  addSubview:_MoreDiseaseLb];
    
    _MoreDiseaseImageView = [UIImageView  new];
    [TopView  addSubview:_MoreDiseaseImageView];
    
    _LineView = [UIView  new];
    _LineView.backgroundColor = UIColorFromRGB(0XF2F2F2);
    [TopView  addSubview:_LineView];
    
    
    _DiseaseName1Lb = [UILabel  new];
    _DiseaseName1Lb.numberOfLines = 1;
    _DiseaseName1Lb.userInteractionEnabled = YES;
    _DiseaseName1Lb.textAlignment = NSTextAlignmentLeft;
    _DiseaseName1Lb.textColor = UIColorFromRGB(0x3324d8);
    _DiseaseName1Lb.font = [UIFont  systemFontOfSize:16];
    [_containerView  addSubview:_DiseaseName1Lb];
    _LineView1 = [UIView  new];
    _LineView1.backgroundColor = UIColorFromRGB(0XF2F2F2);
    [_containerView  addSubview:_LineView1];
    _DiseaseName1ImageView = [UIImageView  new];
    [_containerView  addSubview:_DiseaseName1ImageView];
    
    _DiseaseName2Lb = [UILabel  new];
    _DiseaseName2Lb.numberOfLines = 1;
    _DiseaseName2Lb.userInteractionEnabled = YES;
    _DiseaseName2Lb.textAlignment = NSTextAlignmentLeft;
    _DiseaseName2Lb.textColor = UIColorFromRGB(0x3324d8);
    _DiseaseName2Lb.font = [UIFont  systemFontOfSize:16];
    [_containerView  addSubview:_DiseaseName2Lb];
    _LineView2 = [UIView  new];
    _LineView2.backgroundColor = UIColorFromRGB(0XF2F2F2);
    [_containerView  addSubview:_LineView2];
    _DiseaseName2ImageView = [UIImageView  new];
    [_containerView  addSubview:_DiseaseName2ImageView];

    
    
    _DiseaseName3Lb = [UILabel  new];
    _DiseaseName3Lb.numberOfLines = 1;
    _DiseaseName3Lb.userInteractionEnabled = YES;
    _DiseaseName3Lb.textAlignment = NSTextAlignmentLeft;
    _DiseaseName3Lb.textColor = UIColorFromRGB(0x3324d8);
    _DiseaseName3Lb.font = [UIFont  systemFontOfSize:16];
    [_containerView  addSubview:_DiseaseName3Lb];
    _LineView3 = [UIView  new];
    _LineView3.backgroundColor = UIColorFromRGB(0XF2F2F2);
    [_containerView  addSubview:_LineView3];
    _DiseaseName3ImageView = [UIImageView  new];
    [_containerView  addSubview:_DiseaseName3ImageView];

    
    
    _DiseaseName4Lb = [UILabel  new];
    _DiseaseName4Lb.numberOfLines = 1;
    _DiseaseName4Lb.userInteractionEnabled = YES;
    _DiseaseName4Lb.textAlignment = NSTextAlignmentLeft;
    _DiseaseName4Lb.textColor = UIColorFromRGB(0x3324d8);
    _DiseaseName4Lb.font = [UIFont  systemFontOfSize:16];
    [_containerView  addSubview:_DiseaseName4Lb];
    _LineView4 = [UIView  new];
    _LineView4.backgroundColor = UIColorFromRGB(0XF2F2F2);
    [_containerView  addSubview:_LineView4];
    _DiseaseName4ImageView = [UIImageView  new];
    [_containerView  addSubview:_DiseaseName4ImageView];

    
    _DiseaseName5Lb = [UILabel  new];
    _DiseaseName5Lb.numberOfLines = 1;
     _DiseaseName5Lb.userInteractionEnabled = YES;
    _DiseaseName5Lb.textAlignment = NSTextAlignmentLeft;
    _DiseaseName5Lb.textColor = UIColorFromRGB(0x3324d8);
    _DiseaseName5Lb.font = [UIFont  systemFontOfSize:16];
    [_containerView  addSubview:_DiseaseName5Lb];
    _LineView5 = [UIView  new];
    _LineView5.backgroundColor = UIColorFromRGB(0XF2F2F2);
    [_containerView  addSubview:_LineView5];
    _DiseaseName5ImageView = [UIImageView  new];
    [_containerView  addSubview:_DiseaseName5ImageView];


    _DiseaseMoreLb = [UILabel  new];
    _DiseaseMoreLb.numberOfLines = 1;
    _DiseaseMoreLb.userInteractionEnabled = YES;
    _DiseaseMoreLb.textAlignment = NSTextAlignmentLeft;
    _DiseaseMoreLb.textColor = UIColorFromRGB(0x767676);
    _DiseaseMoreLb.font = [UIFont  systemFontOfSize:16];
    [_containerView  addSubview:_DiseaseMoreLb];
    
    _DiseaseMoreImageView= [UIImageView  new];
    [_containerView  addSubview:_DiseaseMoreImageView];
    
    _BottomView = [UIView new];
    _BottomView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_containerView  addSubview:_BottomView];
    
//可能疾病1
    UITapGestureRecognizer *DiseaseName1Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickActionDiseaseName1Tap)];
    [_DiseaseName1Lb addGestureRecognizer:DiseaseName1Tap];

//可能疾病2
    UITapGestureRecognizer *DiseaseName2Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickActionDiseaseName2Tap)];
    [_DiseaseName2Lb addGestureRecognizer:DiseaseName2Tap];

//可能疾病3
    UITapGestureRecognizer *DiseaseName3Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickActionDiseaseName3Tap)];
    [_DiseaseName3Lb addGestureRecognizer:DiseaseName3Tap];

//可能疾病4
    UITapGestureRecognizer *DiseaseName4Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickActionDiseaseName4Tap)];
    [_DiseaseName4Lb addGestureRecognizer:DiseaseName4Tap];

//可能疾病5
    UITapGestureRecognizer *DiseaseName5Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickActionDiseaseName5Tap)];
    [_DiseaseName5Lb addGestureRecognizer:DiseaseName5Tap];

//症状库
    UITapGestureRecognizer *DiseaseMoreLbTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickActionDiseaseMoreTap)];
    [_DiseaseMoreLb addGestureRecognizer:DiseaseMoreLbTap];

    
    _containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    TopView.sd_layout.topSpaceToView(_containerView,0).leftSpaceToView(_containerView,0).rightSpaceToView(_containerView,0);
    
    _DiseaseTitleLb.sd_layout.topSpaceToView(TopView,10).leftSpaceToView(TopView,15).heightIs(18).widthIs(kScreenWidth-15*2);
    
    _DiseaseImageView.sd_layout.topSpaceToView(_DiseaseTitleLb,10).leftEqualToView(_DiseaseTitleLb).widthIs(80).heightEqualToWidth();
    
    _TitleIntroduceLb.sd_layout.topEqualToView(_DiseaseImageView).leftSpaceToView(_DiseaseImageView,15).heightIs(80).widthIs(kScreenWidth-_DiseaseImageView.size.width-15*3);
    
    _PossibleDiseaseLb.sd_layout.topSpaceToView(_DiseaseImageView,10).leftEqualToView(_DiseaseTitleLb).widthIs(14*4).heightIs(14);
    
    _MoreDiseaseLb.sd_layout.topEqualToView(_PossibleDiseaseLb).rightSpaceToView(TopView,2+16+15).widthIs(14*2).heightIs(14);
    
   _MoreDiseaseImageView.sd_layout.topEqualToView(_MoreDiseaseLb).rightSpaceToView(TopView,15).widthIs(16).heightEqualToWidth();

    
    _LineView.sd_layout.topSpaceToView(_MoreDiseaseLb,10).leftEqualToView(_DiseaseTitleLb).rightSpaceToView(TopView,15).heightIs(1);
     [TopView setupAutoHeightWithBottomView:_LineView bottomMargin:0];
    
    
    _DiseaseName1Lb.sd_layout.topSpaceToView(TopView,10).leftEqualToView(_DiseaseTitleLb).heightIs(16).widthIs(kScreenWidth-15*2-16);
    _LineView1.sd_layout.topSpaceToView(_DiseaseName1Lb,10).leftEqualToView(_DiseaseTitleLb).rightSpaceToView(_containerView,15).heightIs(1);
    _DiseaseName1ImageView.sd_layout.topEqualToView(_DiseaseName1Lb).rightSpaceToView(_containerView,15).widthIs(16).heightEqualToWidth();

    
    _DiseaseName2Lb.sd_layout.topSpaceToView(_LineView1,10).leftEqualToView(_DiseaseTitleLb).heightIs(16).widthIs(kScreenWidth-15*2-16);
    _LineView2.sd_layout.topSpaceToView(_DiseaseName2Lb,10).leftEqualToView(_DiseaseTitleLb).rightSpaceToView(_containerView,15).heightIs(1);
    _DiseaseName2ImageView.sd_layout.topEqualToView(_DiseaseName2Lb).rightSpaceToView(_containerView,15).widthIs(16).heightEqualToWidth();
    
    
    _DiseaseName3Lb.sd_layout.topSpaceToView(_LineView2,10).leftEqualToView(_DiseaseTitleLb).heightIs(16).widthIs(kScreenWidth-15*2-16);
    _LineView3.sd_layout.topSpaceToView(_DiseaseName3Lb,10).leftEqualToView(_DiseaseTitleLb).rightSpaceToView(_containerView,15).heightIs(1);
    _DiseaseName3ImageView.sd_layout.topEqualToView(_DiseaseName3Lb).rightSpaceToView(_containerView,15).widthIs(16).heightEqualToWidth();
    
    _DiseaseName4Lb.sd_layout.topSpaceToView(_LineView3,10).leftEqualToView(_DiseaseTitleLb).heightIs(16).widthIs(kScreenWidth-15*2-16);
    _LineView4.sd_layout.topSpaceToView(_DiseaseName4Lb,10).leftEqualToView(_DiseaseTitleLb).rightSpaceToView(_containerView,15).heightIs(1);
    _DiseaseName4ImageView.sd_layout.topEqualToView(_DiseaseName4Lb).rightSpaceToView(_containerView,15).widthIs(16).heightEqualToWidth();
    
    _DiseaseName5Lb.sd_layout.topSpaceToView(_LineView4,10).leftEqualToView(_DiseaseTitleLb).heightIs(16).widthIs(kScreenWidth-15*2-16);
    _LineView5.sd_layout.topSpaceToView(_DiseaseName5Lb,10).leftEqualToView(_DiseaseTitleLb).rightSpaceToView(_containerView,15).heightIs(1);
    _DiseaseName5ImageView.sd_layout.topEqualToView(_DiseaseName5Lb).rightSpaceToView(_containerView,15).widthIs(16).heightEqualToWidth();
    
    _DiseaseMoreImageView.sd_layout.topSpaceToView(_LineView5,10).leftSpaceToView(_containerView,15).widthIs(17).heightEqualToWidth();
    
    _DiseaseMoreLb.sd_layout.topSpaceToView(_LineView5,10).leftSpaceToView(_DiseaseMoreImageView,5).heightIs(16).widthIs(kScreenWidth-15*2-17);
    
    _BottomView.sd_layout.topSpaceToView(_DiseaseMoreImageView,10).leftSpaceToView(_containerView,15).rightSpaceToView(_containerView,15).heightIs(1);

    [_containerView setupAutoHeightWithBottomViewsArray:@[_BottomView] bottomMargin:0];

[self setupAutoHeightWithBottomView:_containerView bottomMargin:0];

}
-(void)setSearchSymptom:(SearchSymptom *)searchSymptom{
    _searchSymptom = searchSymptom;
    //疾病标题
    _DiseaseTitleLb.text = [NSString  stringWithFormat:@"%@_症状百科",searchSymptom.DiseaseTitle];
    NSMutableAttributedString *Str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_DiseaseTitleLb.text]];
    [Str1 addAttribute:NSForegroundColorAttributeName
                 value:UIColorFromRGB(0x3324d8)
                 range:NSMakeRange(searchSymptom.DiseaseTitle.length,5)];
    _DiseaseTitleLb.attributedText = Str1;
    //疾病图片
    [_DiseaseImageView sd_setImageWithURL:[NSURL URLWithString:searchSymptom.Image] placeholderImage:[UIImage imageNamed:@"HEADoctorIcon"]];
    //疾病详情
    _TitleIntroduceLb.text = [NSString  stringWithFormat:@"%@%@",searchSymptom.DiseaseTitle,searchSymptom.TitleIntroduce];
    NSMutableAttributedString *Str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_TitleIntroduceLb.text]];
    [Str2 addAttribute:NSForegroundColorAttributeName
                 value:UIColorFromRGB(0xe20f00)
                 range:NSMakeRange(0,searchSymptom.DiseaseTitle.length)];
    _TitleIntroduceLb.attributedText = Str2;
    //可能疾病标题
    _PossibleDiseaseLb.text = @"可能疾病";
    //更多
    _MoreDiseaseLb.text = @"更多";
    _MoreDiseaseImageView.image = [UIImage  imageNamed:@"DiseaseTitle_More"];
    //可能疾病1
    _DiseaseName1Lb.text = [NSString  stringWithFormat:@"%@  %@",searchSymptom.DiseaseName1,searchSymptom.DiseaseIntro1];
    NSMutableAttributedString *Str3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_DiseaseName1Lb.text]];
    [Str3 addAttribute:NSForegroundColorAttributeName
                 value:UIColorFromRGB(0x767676)
                 range:NSMakeRange(searchSymptom.DiseaseName1.length,searchSymptom.DiseaseIntro1.length)];
    _DiseaseName1Lb.attributedText = Str3;
    //可能疾病2
    _DiseaseName2Lb.text = [NSString  stringWithFormat:@"%@  %@",searchSymptom.DiseaseName2,searchSymptom.DiseaseIntro2];
    NSMutableAttributedString *Str4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_DiseaseName2Lb.text]];
    [Str4 addAttribute:NSForegroundColorAttributeName
                 value:UIColorFromRGB(0x767676)
                 range:NSMakeRange(searchSymptom.DiseaseName2.length,searchSymptom.DiseaseIntro2.length)];
    _DiseaseName2Lb.attributedText = Str4;
    
    //可能疾病3
    _DiseaseName3Lb.text = [NSString  stringWithFormat:@"%@  %@",searchSymptom.DiseaseName3,searchSymptom.DiseaseIntro3];
    NSMutableAttributedString *Str5 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_DiseaseName3Lb.text]];
    [Str5 addAttribute:NSForegroundColorAttributeName
                 value:UIColorFromRGB(0x767676)
                 range:NSMakeRange(searchSymptom.DiseaseName3.length,searchSymptom.DiseaseIntro3.length)];
    _DiseaseName3Lb.attributedText = Str5;
    
    //可能疾病4
    _DiseaseName4Lb.text = [NSString  stringWithFormat:@"%@  %@",searchSymptom.DiseaseName4,searchSymptom.DiseaseIntro4];
    NSMutableAttributedString *Str6 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_DiseaseName4Lb.text]];
    [Str6 addAttribute:NSForegroundColorAttributeName
                 value:UIColorFromRGB(0x767676)
                 range:NSMakeRange(searchSymptom.DiseaseName4.length,searchSymptom.DiseaseIntro4.length)];
    _DiseaseName4Lb.attributedText = Str6;
    
    //可能疾病5
    _DiseaseName5Lb.text = [NSString  stringWithFormat:@"%@  %@",searchSymptom.DiseaseName5,searchSymptom.DiseaseIntro5];
    NSMutableAttributedString *Str7 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_DiseaseName5Lb.text]];
    [Str7 addAttribute:NSForegroundColorAttributeName
                 value:UIColorFromRGB(0x767676)
                 range:NSMakeRange(searchSymptom.DiseaseName5.length,searchSymptom.DiseaseIntro5.length)];
    _DiseaseName5Lb.attributedText = Str7;
    
    _DiseaseName1ImageView.image = [UIImage  imageNamed:@"DiseaseName_Right"];
    _DiseaseName2ImageView.image = [UIImage  imageNamed:@"DiseaseName_Right"];
    _DiseaseName3ImageView.image = [UIImage  imageNamed:@"DiseaseName_Right"];
    _DiseaseName4ImageView.image = [UIImage  imageNamed:@"DiseaseName_Right"];
    _DiseaseName5ImageView.image = [UIImage  imageNamed:@"DiseaseName_Right"];
    
    _DiseaseMoreLb.text = @"症状库";
    _DiseaseMoreImageView.image = [UIImage imageNamed:@"DiseaseSymptom"];
}

#pragma mark----点击
 //点击标题
-(void)Toptap{

    if(self.delegate && [self.delegate respondsToSelector:@selector(ClickDiseaTitleUrl:)]){
        [self.delegate ClickDiseaTitleUrl:self.searchSymptom.TitleHref];
    }
}

//点击可能疾病1
-(void)clickActionDiseaseName1Tap{
    if(self.delegate && [self.delegate respondsToSelector:@selector(ClickDiseaseName1Url:)]){
        [self.delegate ClickDiseaseName1Url:self.searchSymptom.DiseaseHref1];
    }


}
//点击可能疾病2
-(void)clickActionDiseaseName2Tap{
    if(self.delegate && [self.delegate respondsToSelector:@selector(ClickDiseaseName2Url:)]){
        [self.delegate ClickDiseaseName2Url:self.searchSymptom.DiseaseHref2];
    }
 
    
}

//点击可能疾病3
-(void)clickActionDiseaseName3Tap{
    if(self.delegate && [self.delegate respondsToSelector:@selector(ClickDiseaseName3Url:)]){
        [self.delegate ClickDiseaseName3Url:self.searchSymptom.DiseaseHref3];
    }

    
}

//点击可能疾病4
-(void)clickActionDiseaseName4Tap{
    if(self.delegate && [self.delegate respondsToSelector:@selector(ClickDiseaseName4Url:)]){
        [self.delegate ClickDiseaseName4Url:self.searchSymptom.DiseaseHref4];
    }
 
    
}

//点击可能疾病5
-(void)clickActionDiseaseName5Tap{
    if(self.delegate && [self.delegate respondsToSelector:@selector(ClickDiseaseName5Url:)]){
        [self.delegate ClickDiseaseName5Url:self.searchSymptom.DiseaseHref5];
    }

    
}

//点击症状库
-(void)clickActionDiseaseMoreTap{
    if(self.delegate && [self.delegate respondsToSelector:@selector(ClickDiseaTitleUrl:)]){
        [self.delegate ClickDiseaseMoreUrl:self.searchSymptom.MoreUrl];
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
