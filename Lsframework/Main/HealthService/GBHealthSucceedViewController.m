//
//  GBHealthSucceedViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GBHealthSucceedViewController.h"
#import "DefaultChildEntity.h"
#import "ApiMacro.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import "GBhomeViewController.h"


@interface GBHealthSucceedViewController ()
//宝宝信息
@property(nonnull,nonatomic,strong)NSString  *childName;
@property(nonnull,nonatomic,strong)NSString  *childPhoto;
@property(nonnull,nonatomic,strong)NSString  *childSex;
@property(nonnull,nonatomic,strong)NSString  *childAge;

//健康宝宝
@property(nonnull,nonatomic,strong)UIImageView  *centerImageView;
@property(nonnull,nonatomic,strong)UIImageView  *medalImageView;
@property(nonnull,nonatomic,strong)UIImageView  *PhotoBGImageView;
@property(nonnull,nonatomic,strong)UIImageView  *PhotoImageView;
@property(nonnull,nonatomic,strong)UILabel  *NameLb;
@property(nonnull,nonatomic,strong)UIImageView  *SexImageView;
@property(nonnull,nonatomic,strong)UIView  *SexLineView;
@property(nonnull,nonatomic,strong)UILabel  *AgeLb;
@property(nonnull,nonatomic,strong)UILabel  *StausLb;
@property(nonnull,nonatomic,strong)UILabel  *ResultLb;
@property(nonnull,nonatomic,strong)UILabel  *ResultLb1;

//不健康宝宝
@property(nonnull,nonatomic,strong)UIImageView  *backImageView;
@end

@implementation GBHealthSucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHideTabbar = YES;
    
}
-(void)setupView{
    _childName = [DefaultChildEntity defaultChild].childName;
    
    _childPhoto = [DefaultChildEntity defaultChild].childImg;
    
    _childSex = [DefaultChildEntity defaultChild].childSex;
    
    _childAge = [DefaultChildEntity defaultChild].nL;
    NSLog(@"姓名：%@-----头像：%@-----性别：%@----年龄：%@----%@",_childName,_childPhoto,_childSex,_childAge,[DefaultChildEntity defaultChild].childImg);
    
    
    [self  initRightBarWithTitle:@"分享"];

    if (_type == GBHealthSucceedTypeFromhealth) {
        //健康
        self.view.backgroundColor =UIColorFromRGB(0xf2f2f2);
        [ self  setupHealthView];
        
    }else if (_type == GBHealthSucceedTypeFromNohealth){
        //不健康
     self.view.backgroundColor = [UIColor yellowColor];
      [ self  setupNoHealthView];
    }
}
-(void)setupHealthView{
    
    

    _centerImageView = [UIImageView  new];
    _centerImageView.backgroundColor = [UIColor clearColor];
    _centerImageView.image = [UIImage  imageNamed:@"Health_centerImageView"];
    [self.view  addSubview:_centerImageView];
    
    
    _medalImageView = [UIImageView  new];
    _medalImageView.backgroundColor = [UIColor clearColor];
    [_centerImageView  addSubview:_medalImageView];
    

    _PhotoBGImageView = [UIImageView  new];
    _PhotoBGImageView.backgroundColor = [UIColor clearColor];
    _PhotoBGImageView.image = [UIImage  imageNamed:@"Health_PhotoBGImageView"];
    [_medalImageView  addSubview:_PhotoBGImageView];
    
    _PhotoImageView = [UIImageView  new];
    _PhotoImageView.layer.masksToBounds = YES;
    _PhotoImageView.layer.borderWidth = 0.8;
    _PhotoImageView.layer.borderColor =  UIColorFromRGB(0x37e0ce).CGColor;
    _PhotoImageView.backgroundColor = [UIColor clearColor];
 [_PhotoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_childPhoto]] placeholderImage:[UIImage imageNamed:@"GB_MineICON"]];
    [_PhotoBGImageView  addSubview:_PhotoImageView];
    
    
    _NameLb = [UILabel new];
    _NameLb.numberOfLines = 1;
    _NameLb.text = _childName;
    _NameLb.lineBreakMode = NSLineBreakByTruncatingTail;
    _NameLb.font = [UIFont boldSystemFontOfSize:34/2];
    _NameLb.textColor = UIColorFromRGB(0xf0324f);
    _NameLb.textAlignment = NSTextAlignmentCenter;
    [_medalImageView  addSubview:_NameLb];
    
    _SexImageView = [UIImageView  new];
    _SexImageView.backgroundColor = [UIColor clearColor];
    [_medalImageView  addSubview:_SexImageView];

    
    _SexLineView = [UIView  new];
    _SexLineView.backgroundColor = UIColorFromRGB(0x61d8d3);
    [_medalImageView  addSubview:_SexLineView];
    
    
    _AgeLb = [UILabel new];
    _AgeLb.numberOfLines = 1;
    _AgeLb.text = _childAge;
    _AgeLb.font = [UIFont boldSystemFontOfSize:26/2];
    _AgeLb.textColor = UIColorFromRGB(0xf0324f);
    _AgeLb.textAlignment = NSTextAlignmentLeft;
    [_medalImageView  addSubview:_AgeLb];

    _StausLb = [UILabel new];
    _StausLb.numberOfLines = 1;
    _StausLb.text = @"特别棒!";
    _StausLb.font = [UIFont boldSystemFontOfSize:35/2];
    _StausLb.textColor = [UIColor  blackColor];
    _StausLb.textAlignment = NSTextAlignmentCenter;
    [_centerImageView  addSubview:_StausLb];
    
    _ResultLb = [UILabel new];
    _ResultLb.numberOfLines = 1;
    _ResultLb.font = _StausLb.font;
    _ResultLb.textColor = [UIColor  blackColor];
    _ResultLb.textAlignment = NSTextAlignmentCenter;
    [_centerImageView  addSubview:_ResultLb];
    
    
    _ResultLb1 = [UILabel new];
    _ResultLb1.numberOfLines = 1;
    _ResultLb1.font = _StausLb.font;
    _ResultLb1.textColor = [UIColor  blackColor];
    _ResultLb1.textAlignment = NSTextAlignmentCenter;
    [_centerImageView  addSubview:_ResultLb1];

    
    NSArray *Array = [NSArray  new];
    Array = [_Result componentsSeparatedByString:@"，"];
    if (Array.count == 1) {
     _ResultLb.text = @"您的孩子很健康";
    _ResultLb1.text = @"颁发一枚健康小王子(小公主)勋章。";
    }else if(Array.count == 2){
        _ResultLb.text = Array[0];
        _ResultLb1.text = Array[1];
    }

    //性别图片、奖章图片
    if ([_childSex  isEqualToString:@"1"]) {
        _medalImageView.image = [UIImage  imageNamed:@"Health_Nan_medalImageView"];
        _SexImageView.image = [UIImage  imageNamed:@"nan"];
        
    }else if ([_childSex  isEqualToString:@"2"]){
        
        _SexImageView.image = [UIImage  imageNamed:@"nv"];
        _medalImageView.image = [UIImage  imageNamed:@"Health_Nv_medalImageView"];
    }
    CGFloat _PhotoBGTop =  -kFitHeightScale(134-50);
    if (kScreenHeight==568) {
        _AgeLb.font = [UIFont boldSystemFontOfSize:22/2];
        _NameLb.font = [UIFont boldSystemFontOfSize:30/2];
        _StausLb.font = [UIFont boldSystemFontOfSize:27/2];
        _ResultLb.font = _StausLb.font;
        _ResultLb1.font = _StausLb.font;
    }else if (kScreenHeight==480) {
        _AgeLb.font = [UIFont boldSystemFontOfSize:22/2];
        _NameLb.font = [UIFont boldSystemFontOfSize:30/2];
        _StausLb.font = [UIFont boldSystemFontOfSize:27/2];
        _ResultLb.font =_StausLb.font;
        _ResultLb1.font = _StausLb.font;
        _PhotoBGTop =  -kFitHeightScale(134);

    }else if (kScreenHeight==667) {
        _StausLb.font = [UIFont boldSystemFontOfSize:30/2];
        _ResultLb.font = _StausLb.font;
        _ResultLb1.font = _StausLb.font;
    }



    
    _centerImageView.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.view).widthIs(kFitWidthScale(560)).heightIs(kFitHeightScale(600));

    _medalImageView.sd_layout.centerXEqualToView(_centerImageView).topSpaceToView(_centerImageView,kFitHeightScale(-50)).widthIs(kFitWidthScale(302)).heightIs(kFitHeightScale(400));
    
    _PhotoBGImageView.sd_layout.topSpaceToView(_medalImageView,_PhotoBGTop).centerXEqualToView(_medalImageView).widthIs(kFitWidthScale(192)).heightEqualToWidth();
    
    _PhotoImageView.sd_layout.centerXEqualToView(_PhotoBGImageView).centerYEqualToView(_PhotoBGImageView).widthIs(kFitWidthScale(170)).heightEqualToWidth();
    _PhotoImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    
    CGFloat  name_Center =  kFitWidthScale(302)/2+2;
    CGFloat  name_Width = 17*5-10;
    CGFloat  name_Height = 17;
    CGFloat  k_ageWidth = [JMFoundation  calLabelWidth:_AgeLb];
    CGFloat   k_xSpace  = (kFitWidthScale(302)-(30/2+10/2+1+10/2+k_ageWidth))/2;
    CGFloat  Result_Width = _centerImageView.size.width;
    CGFloat  Resul_Height =  [JMFoundation  calLabelHeght:_ResultLb];
    CGFloat   SexImageTop = kFitHeightScale(20);
    CGFloat  ResultTop = kFitHeightScale(40);
    
    if (kScreenHeight == 568) {
        //5尺寸
      name_Center = kFitWidthScale(302)/2+4;
      name_Width = 15*5-10;
      name_Height = 15;
      k_xSpace  = (kFitWidthScale(302)-(kFitWidthScale(30)+10/2+1+10/2+k_ageWidth))/2;

    }else if (kScreenHeight==480) {
        //4
        name_Center = kFitWidthScale(302)/2+4;
        name_Width = 15*5-10;
        name_Height = 15;
        k_xSpace  = (kFitWidthScale(302)-(kFitWidthScale(30)+10/2+1+10/2+k_ageWidth))/2;
//        Result_Width = 30/2*13;
        SexImageTop = 3;
        ResultTop = kFitHeightScale(30);

    }
    
    _NameLb.sd_layout.topSpaceToView(_medalImageView,kFitHeightScale(201)).centerXIs(name_Center).widthIs(name_Width).heightIs(name_Height);
    
    _SexImageView.sd_layout.topSpaceToView(_NameLb,SexImageTop).leftSpaceToView(_medalImageView,k_xSpace+3).widthIs(kFitWidthScale(30)).heightEqualToWidth();
    _SexLineView.sd_layout.topEqualToView(_SexImageView).leftSpaceToView(_SexImageView,10/2).widthIs(1).heightRatioToView(_SexImageView,1);
    _AgeLb.sd_layout.topEqualToView(_SexImageView).leftSpaceToView(_SexLineView,10/2).widthIs(k_ageWidth).heightIs(13);
    
    _StausLb.sd_layout.topSpaceToView(_medalImageView,ResultTop).centerXEqualToView(_centerImageView).widthIs([JMFoundation  calLabelWidth:_StausLb]).heightIs(13);
    
    _ResultLb.sd_layout.topSpaceToView(_StausLb,ResultTop).centerXEqualToView(_centerImageView).widthIs(Result_Width).heightIs(Resul_Height);
    _ResultLb1.sd_layout.topSpaceToView(_ResultLb,5).centerXEqualToView(_centerImageView).widthIs(Result_Width).heightIs(Resul_Height);
}

-(void)setupNoHealthView{
    NSLog(@"性别：%@",_childSex);

    _backImageView = [UIImageView  new];
    _backImageView.backgroundColor = [UIColor clearColor];
    _backImageView.image = [UIImage  imageNamed:@"BackImageView"];
    [self.view  addSubview:_backImageView];
    
    _centerImageView = [UIImageView  new];
    _centerImageView.backgroundColor = [UIColor clearColor];
    _centerImageView.image = [UIImage  imageNamed:@"Health_NocenterImageView"];
    [_backImageView  addSubview:_centerImageView];
    
    
    
    _PhotoBGImageView = [UIImageView  new];
    _PhotoBGImageView.backgroundColor = [UIColor clearColor];
    _PhotoBGImageView.image = [UIImage  imageNamed:@"Health_PhotoBGImageView"];
    [_centerImageView  addSubview:_PhotoBGImageView];
    
    _PhotoImageView = [UIImageView  new];
    _PhotoImageView.layer.masksToBounds = YES;
    _PhotoImageView.layer.borderWidth = 0.8;
    _PhotoImageView.layer.borderColor =  UIColorFromRGB(0x37e0ce).CGColor;
    _PhotoImageView.backgroundColor = [UIColor clearColor];
    [_PhotoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_childPhoto]] placeholderImage:[UIImage imageNamed:@"GB_MineICON"]];
    [_PhotoBGImageView  addSubview:_PhotoImageView];
    
    
    _NameLb = [UILabel new];
    _NameLb.numberOfLines = 1;
    _NameLb.text = _childName;
    _NameLb.lineBreakMode = NSLineBreakByTruncatingTail;
    _NameLb.font = [UIFont boldSystemFontOfSize:34/2];
    _NameLb.textColor = UIColorFromRGB(0xfd85c9);
    _NameLb.textAlignment = NSTextAlignmentCenter;
    [_centerImageView  addSubview:_NameLb];
    
    _SexImageView = [UIImageView  new];
    _SexImageView.backgroundColor = [UIColor clearColor];
    [_centerImageView  addSubview:_SexImageView];
    
    
    _SexLineView = [UIView  new];
    _SexLineView.backgroundColor = UIColorFromRGB(0x61d8d3);
    [_centerImageView  addSubview:_SexLineView];
    
    
    _AgeLb = [UILabel new];
    _AgeLb.numberOfLines = 1;
    _AgeLb.text = _childAge;
    _AgeLb.font = [UIFont boldSystemFontOfSize:26/2];
    _AgeLb.textColor = _NameLb.textColor;
    _AgeLb.textAlignment = NSTextAlignmentLeft;
    [_centerImageView  addSubview:_AgeLb];
    
    
    _ResultLb = [UILabel new];
    _ResultLb.backgroundColor = [UIColor clearColor];
    _ResultLb.numberOfLines = 0;
//    _ResultLb.text = @" 您的孩子可能存在多动症，表现为：学习困难，注意力不集中，自控力差。多动症可从幼年延伸至成人，在学龄前男孩中更突出。但是多动症区别于顽皮多动，为了确诊，请您尽快带孩子去做进一步检查哦。谢谢，祝您和您的孩子健康。";
    _ResultLb.text = _Result;
    _ResultLb.font = [UIFont boldSystemFontOfSize:30/2];
    _ResultLb.textColor = [UIColor  blackColor];
    _ResultLb.textAlignment = NSTextAlignmentLeft;
    [_centerImageView  addSubview:_ResultLb];
    
    
    //性别图片、奖章图片
    if ([_childSex  isEqualToString:@"1"]) {

        _SexImageView.image = [UIImage  imageNamed:@"nan"];
        
    }else if ([_childSex  isEqualToString:@"2"]){
        
        _SexImageView.image = [UIImage  imageNamed:@"nv"];
    }

 CGFloat   name_Width = 17*5;
 CGFloat   name_Height = 17;

    if (kScreenHeight == 667) {
        //6尺寸
     _ResultLb.font = [UIFont boldSystemFontOfSize:34/2];
    }else if (kScreenHeight==736) {
        //6  plus
          _NameLb.font = [UIFont boldSystemFontOfSize:40/2];
         _AgeLb.font = [UIFont boldSystemFontOfSize:30/2];
          _ResultLb.font = [UIFont boldSystemFontOfSize:38/2];
        
        name_Width = 20*5;
        name_Height = 20;
    }else  if (kScreenHeight == 480) {
        //4s
        _ResultLb.font = [UIFont boldSystemFontOfSize:26/2];
    }


    _backImageView.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.view).widthIs(kScreenWidth).heightIs(kScreenHeight);
    _centerImageView.sd_layout.centerXEqualToView(_backImageView).centerYEqualToView(_backImageView).widthIs(kFitWidthScale(600)).heightIs(kFitHeightScale(598));
    
    _PhotoBGImageView.sd_layout.topSpaceToView(_centerImageView,-kFitHeightScale(192-70)).centerXEqualToView(_centerImageView).widthIs(kFitWidthScale(192)).heightEqualToWidth();

    _PhotoImageView.sd_layout.centerXEqualToView(_PhotoBGImageView).centerYEqualToView(_PhotoBGImageView).widthIs(kFitWidthScale(170)).heightEqualToWidth();
    _PhotoImageView.sd_cornerRadiusFromWidthRatio = @0.5;
    
    CGFloat  k_ageWidth = [JMFoundation  calLabelWidth:_AgeLb];
    CGFloat   k_xSpace  = (kFitWidthScale(600)-(30/2+10/2+1+10/2+k_ageWidth))/2;
    
    _NameLb.sd_layout.topSpaceToView(_PhotoBGImageView,kFitHeightScale(20)).centerXEqualToView(_centerImageView).widthIs(name_Width).heightIs(name_Height);

    _SexImageView.sd_layout.topSpaceToView(_NameLb,kFitHeightScale(20)).leftSpaceToView(_centerImageView,k_xSpace).widthIs(kFitWidthScale(30)).heightEqualToWidth();
    
    _SexLineView.sd_layout.topEqualToView(_SexImageView).leftSpaceToView(_SexImageView,10/2).widthIs(1).heightRatioToView(_SexImageView,1);
    
    _AgeLb.sd_layout.topEqualToView(_SexImageView).leftSpaceToView(_SexLineView,10/2).widthIs(k_ageWidth).heightRatioToView(_SexImageView,1);

    CGFloat  k_ResultHeight = [JMFoundation  calLabelHeight:_ResultLb.font andStr:_ResultLb.text withWidth:_centerImageView.size.width-40/2*2];
    CGFloat  k_ResultTop = (_centerImageView.size.height-kFitHeightScale(192-70)-kFitHeightScale(20)-17 - kFitHeightScale(20)-kFitWidthScale(30)-k_ResultHeight)/2;

    _ResultLb.sd_layout.topSpaceToView(_SexImageView,k_ResultTop).centerXEqualToView(_centerImageView).widthIs(_centerImageView.size.width-40/2*2).heightIs(k_ResultHeight);
}
#pragma mark--分享事件
-(void)rightItemAction:(id)sender{
    //1、创建分享参数
    //微信朋友圈不能分享Text  微博分享不能分享title，
    NSArray* imageArray = @[[UIImage imageNamed:@"share"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    NSString *urlStr =[NSString stringWithFormat:@"%@%@&ID=%@",URL_SHARE_HEALTHSERVICE,self.EvalName,self.ResultID];
    NSLog(@"健康测评url:%@",urlStr);
    if (imageArray) {
        NSString *text = [NSString stringWithFormat:@"测评结果点击查看:%@",urlStr];
        
        NSString  *title = [NSString  stringWithFormat:@"%@测评结果",self.title];
        if (_IsHealth) {
            NSLog(@"健康");
            if ([_childSex  isEqualToString:@"1"]) {
                
    title = [NSString  stringWithFormat:@"%@《授予小王子勋章一枚》",self.title];
                
            }else if ([_childSex  isEqualToString:@"2"]){
                
    title = [NSString  stringWithFormat:@"%@《授予小公主勋章一枚》",self.title];
                
            }

        }
        
        if (title.length>=124) {
            title = [title  substringToIndex:124];
        }
        
        
NSData * imageData = UIImageJPEGRepresentation(_PhotoImageView.image,1);
NSLog(@"压缩前%@",_PhotoImageView.image);
NSLog(@"压缩前data:%u",[imageData length]/1000);

UIImage  *shareimage =  [JMFoundation  imageCompressForSize:_PhotoImageView.image targetSize:CGSizeMake(120, 180)];
 NSLog(@"压缩后%@",shareimage);
NSData * imageData1 = UIImageJPEGRepresentation(shareimage,1);
NSLog(@"压缩后data:%u",[imageData1 length]/1000);
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];

        [shareParams SSDKSetupShareParamsByText:text               images:shareimage
                                            url:[NSURL URLWithString:urlStr]
                                          title:title                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
    
    
    
}
-(void)backItemAction:(id)sender{
    
    UIViewController* back = nil;
    for(UIViewController* vc in self.navigationController.childViewControllers){
        if([vc isKindOfClass:[GBhomeViewController class]]){
            back = vc;
            break;
        }
    }
    
    if(back){
        [self.navigationController popToViewController:back animated:NO];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_RefreshHealthServiceCount object:nil];
    

    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
