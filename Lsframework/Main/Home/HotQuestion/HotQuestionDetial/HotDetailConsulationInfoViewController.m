//
//  HotDetailConsulationInfoViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/9/23.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HotDetailConsulationInfoViewController.h"
#import "JMFoundation.h"
#import "ApiMacro.h"
#import "SFPhotoBrowser.h"
#import "HotDetailInfoPresenter.h"
#import "HotDetailInfoTableViewCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>

#import "PublicPostTextView.h"
#import "UIImage+Category.h"
#import "EmotionTextAttachment.h"
#import "ConsulationReplyList.h"

#import "TabbarViewController.h"

#import "HotDetailConsulationViewController.h"

#define kToolBarHeight 48
#define kKeyboardHeight (264 - 40)


#define kScrollViewHeight (270/2.0)

#define kRow 3
#define kColumn 6


#define HaveImageWidth   kScreenWidth-30/2-30-24/2-30/2
#define PhotoSpace  15
#define PhotoWidth  (HaveImageWidth-PhotoSpace*2)/3
#define PhotoHeight (HaveImageWidth-PhotoSpace*2)/3
#define topSpace 7.5

@interface HotDetailConsulationInfoViewController ()<PhotoBrowerDelegate,HotDetailInfoPresenterDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextViewDelegate,CircleTableViewCellDelegate>{

    UIView  *headerView;
    BOOL convertToSystemKeyboard;
    UIView  *ReplyView;
    
    UIButton *smallBtn;
    UIButton *deleteBtn;

}
@property(nonatomic,strong)UIImageView  *HeadImageView;
@property(nonatomic,strong)UILabel  *HeadName;
@property(nonatomic,strong)UILabel  *FloorLb;
@property(nonatomic,strong)UILabel  *CommentContent;
@property(nonatomic,strong)UIImageView  *TimeImageView;
@property(nonatomic,strong)UIImageView  *AnswerCountImageView;
@property(nonatomic,strong)UILabel  *TimeLb;
@property(nonatomic,strong)UILabel  *AnswerLb;
@property(nonatomic,strong)UILabel  *AnswerCountLb;

@property (nonatomic, strong) UIView *haveImageBgView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *midImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *leftImageView1;
@property (nonatomic, strong) UIImageView *midImageView1;
@property (nonatomic, strong) UIImageView *rightImageView1;
@property (nonatomic,retain) NSArray *photoBrowserArr;
@property (nonatomic,retain) NSArray *photoBrowserUrlArr;
@property(nonatomic,strong)HotDetailInfoPresenter  *presenter;
@property(nonatomic,strong)UITableView  *table;

@property(nullable,nonatomic,retain)PublicPostTextView* textView ;

@property(nullable,nonatomic,retain) UIButton* addButton;//添加按钮
@property(nullable,nonatomic,retain) UIButton* faceButton;//表情按钮
@property(nullable,nonatomic,retain) UIButton* sendButton;//发送按钮
@property(nullable,nonatomic,retain) UIView* faceInputView;
@property(nullable,nonatomic,retain) UIButton* defaultImageBt;
@property(nullable,nonatomic,retain) UIButton* selecImageBt;
@property(nullable,nonatomic,retain) UIScrollView* faceScrollView;
@property(nullable,nonatomic,retain) UIPageControl* pageControl;
@property(nullable,nonatomic,retain) NSMutableArray* defaultEmotionArray;//默认表情
@property(nullable,nonatomic,retain) UIScrollView* scroll;




@end

@implementation HotDetailConsulationInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"回复详情";
    
}
-(void)setupView{
    _presenter = [HotDetailInfoPresenter  new];
    _presenter.delegate = self;
    
//[_presenter  GetConsulationReplyByCommentID:_CommenList.uuid];
    
   
    //入口参数请求
    /**
     *  推送、系统消息、上个页面都这样进入
     */
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString  *type =  [user objectForKey:@"AppDelegatePush"];
//        if ([type isEqualToString:@"push"]) {
//        NSLog(@"杀死后推送进入问题回复页");
//        [self  initBackBarWithImage:[UIImage imageNamed:@"GB_LeftDoctorBar"]];
//    }
    [_presenter  GetHotQuestionInfoSingleWithcommentID:_commentID];
   
    
    

    
    UIScrollView* scroll = [UIScrollView new];
    scroll.showsVerticalScrollIndicator = NO;
    scroll.scrollEnabled = NO;
    self.scroll = scroll;
    [self.view addSubview:scroll];
    
   scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    
    [self  setupReplyView];
    
    _table = [UITableView  new];
    _table.delegate = self;
    _table.dataSource = self;
    _table.scrollEnabled = YES;
    _table.userInteractionEnabled = YES;
    [_table registerClass:[HotDetailInfoTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view  addSubview:_table];
    
//    _table.sd_layout.topEqualToView(self.view).leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view,0);
    
    [scroll  addSubview:_table];
    _table.sd_layout.topSpaceToView(scroll,0).leftEqualToView(scroll).rightEqualToView(scroll).bottomSpaceToView(ReplyView,0);

    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    WS(ws);
    _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [_presenter  GetConsulationReplyByCommentID:[_commentID  integerValue]];
    }];
    [_table.mj_header  beginRefreshing];
    _table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.presenter getMoreConsultationReplyList];
    }];
    [ProgressUtil show];
    _table.hidden = YES;
    [self  setupHeadView];
    



}

//-(void)backItemAction:(id)sender{
//    NSLog(@"返回页面");
//    
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString  *type =  [user objectForKey:@"AppDelegatePush"];
//    NSString  *type2 =  [user objectForKey:@"PushHotDetailConsulationinfo"];
//    if (![type2  isEqualToString:@"pushInfo"]) {
//        
//
//    if ([type isEqualToString:@"push"]) {
//        [self presentViewController:[TabbarViewController new] animated:NO completion:nil];
//    }else{
//        
//        [self.navigationController popViewControllerAnimated:YES];
//        
//    }
//    }else{
//      [self.navigationController popViewControllerAnimated:YES];
//    }
//    NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
//    [pushJudge removeObjectForKey:@"AppDelegatePush"];
//    [pushJudge removeObjectForKey:@"PushHotDetailConsulationinfo"];
//    
//}


-(void)setupHeadView{
    
    UIView  *headView  = [UIView new];
    headView.backgroundColor = [UIColor  whiteColor];
    
    UIView  *topView = [UIView  new];
    topView.backgroundColor = [UIColor whiteColor];
    [headView  addSubview:topView];
    
    _HeadImageView = [UIImageView  new];
    
    _HeadImageView.backgroundColor = [UIColor  clearColor];
    [topView  addSubview:_HeadImageView];
    
    
    _HeadName = [UILabel  new];
    _HeadName.backgroundColor = [UIColor  clearColor];
    _HeadName.textColor = UIColorFromRGB(0X333333);
    _HeadName.font = [UIFont  systemFontOfSize:14];
    _HeadName.textAlignment = NSTextAlignmentLeft;
    [topView   addSubview:_HeadName];
    
    
    _FloorLb = [UILabel  new];
    _FloorLb.backgroundColor = [UIColor  clearColor];
    _FloorLb.textColor = UIColorFromRGB(0X999999);
    _FloorLb.font = [UIFont  systemFontOfSize:11];
    _FloorLb.textAlignment = NSTextAlignmentRight;
    [topView   addSubview:_FloorLb];
    
    
    _CommentContent = [UILabel  new];
    _CommentContent.backgroundColor = [UIColor  orangeColor];
    _CommentContent.textColor = UIColorFromRGB(0X666666);
    _CommentContent.font = [UIFont  systemFontOfSize:16];
    _CommentContent.textAlignment = NSTextAlignmentLeft;
    _CommentContent.numberOfLines = 0;
    _CommentContent.backgroundColor = [UIColor clearColor];
    _CommentContent.isAttributedContent = YES;
    [topView   addSubview:_CommentContent];
    
    
    
    //显示图片
    _haveImageBgView =[[UIView alloc]init];
    _haveImageBgView.backgroundColor = [UIColor clearColor];
    [topView addSubview:_haveImageBgView];
    
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
    
    _leftImageView1 = [self newImageWithTag:1004];
    [_haveImageBgView addSubview:_leftImageView1];
    
    _midImageView1 = [self newImageWithTag:1005];
    [_haveImageBgView addSubview:_midImageView1];
    
    _rightImageView1 = [self newImageWithTag:1006];
    [_haveImageBgView addSubview:_rightImageView1];

    //时间
    _TimeImageView = [UIImageView  new];
    _TimeImageView.backgroundColor = [UIColor  clearColor];
    [topView  addSubview:_TimeImageView];
    
    _TimeLb = [UILabel  new];
    _TimeLb.backgroundColor = [UIColor  clearColor];
    _TimeLb.textColor = _FloorLb.textColor;
    _TimeLb.font = [UIFont  systemFontOfSize:11];
    _TimeLb.textAlignment = NSTextAlignmentLeft;
    _TimeLb.numberOfLines = 1;
    [topView   addSubview:_TimeLb];
    
    _AnswerCountImageView = [UIImageView  new];
    _AnswerCountImageView.backgroundColor = [UIColor  clearColor];
    [topView  addSubview:_AnswerCountImageView];
    

    
    UILabel  *lineLb = [UILabel  new];
    lineLb.backgroundColor =UIColorFromRGB(0xf2f2f2);
    [headView   addSubview:lineLb];
    
    
    UIView  *answerView = [UIView  new];
    answerView.backgroundColor = [UIColor  whiteColor];
    [headView  addSubview:answerView];
    _AnswerLb = [UILabel  new];
    _AnswerLb.backgroundColor = [UIColor  clearColor];
    _AnswerLb.textColor = _FloorLb.textColor;
    _AnswerLb.font = [UIFont  systemFontOfSize:15];
    _AnswerLb.textAlignment = NSTextAlignmentLeft;
    _AnswerLb.numberOfLines = 1;
    [answerView   addSubview:_AnswerLb];
    
    _AnswerCountLb = [UILabel  new];
    _AnswerCountLb.backgroundColor = [UIColor  clearColor];
    _AnswerCountLb.textColor = _FloorLb.textColor;
    _AnswerCountLb.font = [UIFont  systemFontOfSize:15];
    _AnswerCountLb.textAlignment = NSTextAlignmentLeft;
    _AnswerCountLb.numberOfLines = 1;
    [answerView   addSubview:_AnswerCountLb];
    
    
    
    //删除button
    deleteBtn = [UIButton new];
    deleteBtn.backgroundColor = [UIColor clearColor];
    [deleteBtn addTarget:self action:@selector(deleteBtnInvationNew) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:deleteBtn];
    
    smallBtn = [UIButton new];
    smallBtn.backgroundColor  = [UIColor clearColor];
    [smallBtn setImage:[UIImage imageNamed:@"Trash"] forState:UIControlStateNormal];
    [smallBtn addTarget:self action:@selector(deleteBtnInvationNew) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:smallBtn];
    
    //
    [_HeadImageView  setImageWithUrl:[ NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.CHILD_IMG] placeholderImage:[UIImage  imageNamed:@"my_answer"]];
    _HeadName.text = _CommenList.NickName;
//    _CommentContent.text = _CommenList.CommentContent;
    _CommentContent.attributedText = [UILabel getAttributeTextWithString:_CommenList.CommentContent];
    
    [_TimeImageView  setImageWithUrl:nil placeholderImage:[UIImage  imageNamed:@"DailyPrise_TimeImage"]];

    _TimeLb.text =_CommenList.CreateTime;
    
    _AnswerCountImageView.image = [UIImage  imageNamed:@"HotAnswerBtnImage"];
//    _FloorLb.text = [NSString  stringWithFormat:@"%d楼",_CommenList.RowID];
    _FloorLb.text = @"1楼";
    _AnswerLb.text = @"相关回复";
    
    

    topView.sd_layout.topSpaceToView(headView,0).leftEqualToView(headView).rightEqualToView(headView);
    
    _HeadImageView.sd_layout.topSpaceToView(topView,30/2).leftSpaceToView(topView,30/2).widthIs(60/2).heightIs(60/2);
    _HeadImageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    _HeadName.sd_layout.topSpaceToView(topView,15+8).leftSpaceToView(_HeadImageView,24/2).heightIs(14).widthIs(kScreenWidth-_HeadImageView.frame.size.width-_FloorLb.frame.size.width-30/2-24/2-30/2);
    
    _FloorLb.sd_layout.topEqualToView(_HeadName).rightSpaceToView(topView,30/2).heightIs(11).minWidthIs(10);
    [_FloorLb setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
    
    _CommentContent.sd_layout.topSpaceToView(_HeadName,30/2).leftEqualToView(_HeadName).widthIs(kScreenWidth-30/2-30-24/2-30/2).autoHeightRatio(0);
    
    
//图片布局
    _haveImageBgView.sd_layout.leftEqualToView(_HeadName).topSpaceToView(_CommentContent,10).widthIs(HaveImageWidth).heightIs(PhotoHeight);
    
    _leftImageView.sd_layout.topSpaceToView(_haveImageBgView,0).leftSpaceToView(_haveImageBgView,0).widthIs(PhotoWidth).heightIs(PhotoHeight);
    _midImageView.sd_layout.topEqualToView(_leftImageView).leftSpaceToView(_haveImageBgView,PhotoWidth+PhotoSpace).widthIs(PhotoWidth).heightIs(PhotoHeight);

    _rightImageView.sd_layout.topEqualToView(_leftImageView).leftSpaceToView(_haveImageBgView,2*PhotoWidth+2*PhotoSpace).widthIs(PhotoWidth).heightIs(PhotoHeight);
    _leftImageView1.sd_layout.topSpaceToView(_haveImageBgView,PhotoHeight+topSpace).leftEqualToView(_leftImageView).widthIs(PhotoWidth).heightIs(PhotoHeight);
    _midImageView1.sd_layout.topEqualToView(_leftImageView1).leftEqualToView(_midImageView).widthIs(PhotoWidth).heightIs(PhotoHeight);
    _rightImageView1.sd_layout.topEqualToView(_leftImageView1).leftEqualToView(_rightImageView).widthIs(PhotoWidth).heightIs(PhotoHeight);
    
        if (_CommenList.Image1!=nil&&_CommenList.Image1.length>4&&(![_CommenList.Image1 isEqualToString:@""])) {
            [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image1]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
            if (_CommenList.Image2!=nil&&_CommenList.Image2.length>4&&(![_CommenList.Image2 isEqualToString:@""])) {
                
                [_midImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image2]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                if (_CommenList.Image3!=nil&&_CommenList.Image3.length>4&&(![_CommenList.Image3 isEqualToString:@""])) {

                    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image3]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                    if (_CommenList.Image4!=nil&&_CommenList.Image4.length>4&&(![_CommenList.Image4 isEqualToString:@""])) {
                        
                        _haveImageBgView.sd_layout.leftEqualToView(_HeadName).topSpaceToView(_CommentContent,10).widthIs(HaveImageWidth).heightIs(PhotoHeight*2+topSpace);
                        
                        [_leftImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image4]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                        
                        if ((_CommenList.Image5!=nil&&_CommenList.Image5.length>4&&(![_CommenList.Image5 isEqualToString:@""]))) {
                            
                            [_midImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image5]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                            
                            if ((_CommenList.Image6!=nil&&_CommenList.Image6.length>4&&(![_CommenList.Image6 isEqualToString:@""]))) {
                                
                                _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1,_midImageView1,_rightImageView1];
                                _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image5],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image6]];
                                
                                [_rightImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image6]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                                
                            }else{
                                // 5
                                _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1,_midImageView1];
                                _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image5]];
                                _rightImageView1.hidden = YES;
                            }
                            
                        }else{
                            // 4
                            _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1];
                            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image4]];
                            
                            _midImageView1.hidden = YES;
                            _rightImageView1.hidden = YES;
                        }
                        
                    }else{
                        // 3
                        _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView];
                        _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image3]];
                        
                        _leftImageView1.hidden = YES;
                        _midImageView1.hidden = YES;
                        _rightImageView1.hidden = YES;
                    }
                    
                }else {
                    //2
                    _photoBrowserArr =@[_leftImageView,_midImageView];
                    _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image2]];
                    _rightImageView.hidden =YES;
                    _leftImageView1.hidden = YES;
                    _midImageView1.hidden = YES;
                    _rightImageView1.hidden = YES;
                }
            }else{
                _photoBrowserArr =@[_leftImageView];
                _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_CommenList.Image1]];
                _midImageView.hidden =YES;
                _rightImageView.hidden =YES;
                _leftImageView1.hidden = YES;
                _midImageView1.hidden = YES;
                _rightImageView1.hidden = YES;
            }
            
        }else{
            _haveImageBgView.sd_layout.widthIs(0).heightIs(0);
            _haveImageBgView.hidden =YES;
        }
        
    if (_haveImageBgView.height == 0) {
        _TimeImageView.sd_layout.topSpaceToView(_CommentContent,30/2).leftEqualToView(_HeadName).widthIs(30/2).heightIs(30/2);
    }else if (_haveImageBgView.height == PhotoHeight){
        _TimeImageView.sd_layout.topSpaceToView(_CommentContent,30/2+PhotoHeight).leftEqualToView(_HeadName).widthIs(30/2).heightIs(30/2);
    }else{
       _TimeImageView.sd_layout.topSpaceToView(_CommentContent,30/2+PhotoHeight*2+topSpace+10).leftEqualToView(_HeadName).widthIs(30/2).heightIs(30/2);
        
    }
//    _TimeImageView.sd_layout.topSpaceToView(_haveImageBgView,30/2).leftEqualToView(_HeadName).widthIs(30/2).heightIs(30/2);
    
//    _AnswerCountImageView.sd_layout.topSpaceToView(_haveImageBgView,30/2).rightEqualToView(_FloorLb).widthIs(30/2).heightIs(30/2);
    
    smallBtn.sd_layout.centerYEqualToView(_TimeImageView).rightEqualToView(_FloorLb).widthIs(15).heightIs(15);
    deleteBtn.sd_layout.centerYEqualToView(_TimeImageView).rightEqualToView(_FloorLb).widthIs(50).heightIs(50);
    
    _TimeLb.sd_layout.topEqualToView(_TimeImageView).leftSpaceToView(_TimeImageView,5).widthIs(100).heightIs(11);
    
    [topView  setupAutoHeightWithBottomView:_TimeImageView bottomMargin:30/2];
    
    //分割线
    lineLb.sd_layout.topSpaceToView(topView,0).leftEqualToView(headView).rightEqualToView(headView).heightIs(1);
    
    //相关回复
    answerView.sd_layout.topSpaceToView(lineLb,0).leftEqualToView(headView).rightEqualToView(headView).heightIs(35);
    
    _AnswerLb.sd_layout.topSpaceToView(answerView,10).leftEqualToView(_HeadImageView).widthIs(70).heightIs(15);
    
    _AnswerCountLb.sd_layout.topEqualToView(_AnswerLb).leftSpaceToView(_AnswerLb,10).minWidthIs(20).heightIs(15);
    
    [_AnswerCountLb setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
[headView  setupAutoHeightWithBottomView:answerView bottomMargin:0];
    
    
    [headView  updateLayout];
    [headView layoutSubviews];
    
    _table.tableHeaderView = headView;
    
    if ((self.userID == kCurrentUser.userId)) {
        
        deleteBtn.hidden = NO;
        smallBtn.hidden = NO;
        
    }else
    {
        deleteBtn.hidden = YES;
        smallBtn.hidden = YES;
    }
    
}


-(void)setupReplyView{
    
    ReplyView = [UIView  new];
    ReplyView.backgroundColor = [UIColor  whiteColor];
    [self.scroll  addSubview:ReplyView];
    
    
    PublicPostTextView* textView = [PublicPostTextView new];
    textView.delegate =  self;
    textView.placeholder = @"我来说两句";
    textView.textColor = [UIColor  blackColor];
    textView.font = [UIFont systemFontOfSize:bigFont];
    textView.placeholderColor = UIColorFromRGB(0xcccccc);
    textView.placeholderFont = [UIFont systemFontOfSize:bigFont];
    textView.layer.borderWidth = 1;
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 8;
    textView.autoAdjustHeight = YES;
    textView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    
    
    [ReplyView addSubview:textView];
    self.textView = textView;
    
    
//    UIButton* addbt = [UIButton new];
//    [addbt setBackgroundImage:[UIImage imageNamed:@"circle_add_sel"] forState:UIControlStateNormal];
//    addbt.tag = 101;
//    addbt.userInteractionEnabled = NO;
//    [addbt addTarget:self action:@selector(clickToolBar:) forControlEvents:UIControlEventTouchUpInside];
//    [ReplyView addSubview:addbt];
//    self.addButton = addbt;
//    
    
    
    UIButton* facebt = [UIButton new];
    [facebt setBackgroundImage:[UIImage imageNamed:@"circle_face_nor"] forState:UIControlStateNormal];
    [facebt setBackgroundImage:[UIImage imageNamed:@"circle_face_heigh"] forState:UIControlStateHighlighted];
    
    facebt.tag = 102;
    [facebt addTarget:self action:@selector(clickToolBar:) forControlEvents:UIControlEventTouchUpInside];
    [ReplyView addSubview:facebt];
    self.faceButton = facebt;
    
    UIButton* sendbt = [UIButton new];
    [sendbt setBackgroundImage:[UIImage imageNamed:@"DailyPrise_NoSendImage"] forState:UIControlStateNormal];
    [sendbt setBackgroundImage:[UIImage imageNamed:@"DailyPrise_SendImage"] forState:UIControlStateSelected];
    sendbt.userInteractionEnabled = NO;
    sendbt.tag = 103;
    [sendbt addTarget:self action:@selector(clickToolBar:) forControlEvents:UIControlEventTouchUpInside];
    //    sendbt.userInteractionEnabled = NO;
    [ReplyView addSubview:sendbt];
    self.sendButton = sendbt;
    
    
    //添加约束
    ReplyView.sd_layout.bottomSpaceToView(self.scroll,0).leftEqualToView(self.scroll).rightEqualToView(self.scroll).heightIs(50);
    
    
//    addbt.sd_layout.centerYEqualToView(ReplyView).leftSpaceToView(ReplyView,5).widthIs(55/2.0).heightEqualToWidth();
    
    
  facebt.sd_layout.centerYEqualToView(ReplyView).leftSpaceToView(ReplyView,5).widthIs(55/2.0).heightEqualToWidth();
    
    sendbt.sd_layout.centerYEqualToView(ReplyView).rightSpaceToView(ReplyView,5).heightIs(76/2).widthIs(100/2);
    ReplyView.sd_layout.bottomSpaceToView(self.scroll,0).leftEqualToView(self.scroll).rightEqualToView(self.scroll).heightIs(50);
    
    
    textView.sd_layout.centerYEqualToView(ReplyView).leftSpaceToView(facebt,5).rightSpaceToView(sendbt,5).heightIs(sendbt.frame.size.height);
    [self.scroll  setupAutoHeightWithBottomView:ReplyView bottomMargin:0];
    
    //    [self setupPhotoNumLabel];
    
    
}

#pragma mark---键盘视图懒加载

-(UIView *)faceInputView{
    if(!_faceInputView){
        _faceInputView = [UIView new];
        _faceInputView.height = kKeyboardHeight;
        _faceInputView.backgroundColor = UIColorFromRGB(0xffffff);
        
        UIScrollView* faceScrollView = [UIScrollView new];
        faceScrollView.showsHorizontalScrollIndicator = NO;
        faceScrollView.pagingEnabled = YES;
        faceScrollView.delegate = self;
        faceScrollView.backgroundColor = UIColorFromRGB(0xfafafa);
        self.faceScrollView = faceScrollView;
        [_faceInputView addSubview:faceScrollView];
        
        UIPageControl* pageControl = [UIPageControl new];
        pageControl.pageIndicatorTintColor = RGB(232, 208, 217);
        pageControl.currentPageIndicatorTintColor = RGB(248, 187, 208);
        self.pageControl = pageControl;
        [_faceInputView addSubview:pageControl];
        
        UIButton* deleteButton = [UIButton new];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"circle_face_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteFaceAction) forControlEvents:UIControlEventTouchUpInside];
        [_faceInputView addSubview:deleteButton];
        
        UIButton* defaultImageButton = [UIButton new];
        defaultImageButton.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [defaultImageButton setImage:[UIImage imageNamed:@"Hotemoij_default"] forState:UIControlStateNormal];
        defaultImageButton.tag = 108;
        [defaultImageButton addTarget:self action:@selector(defaultButton:) forControlEvents:UIControlEventTouchUpInside];
        self.defaultImageBt = defaultImageButton;
        [_faceInputView addSubview:defaultImageButton];
        
        UIButton* defaultSelImageButton = [UIButton new];
        [defaultSelImageButton setImage:[UIImage imageNamed:@"Hotemoij_selec"] forState:UIControlStateNormal];
        defaultSelImageButton.tag = 109;
        [defaultSelImageButton addTarget:self action:@selector(defaultButton:) forControlEvents:UIControlEventTouchUpInside];
        self.selecImageBt = defaultSelImageButton;
        
        
        [_faceInputView addSubview:defaultSelImageButton];
        
        
        CGFloat width = 33;
        CGFloat height = 33;
        CGFloat horizontalMargin = (kScreenWidth - kColumn * width) / (kColumn + 1);
        CGFloat verticalMargin = (kScrollViewHeight - kRow * height) / (kRow + 1);
        
        NSInteger pageTotal = (kColumn * kRow);//当前页表情总个数
        
        NSInteger page = self.defaultEmotionArray.count / pageTotal;
        if(self.defaultEmotionArray.count % pageTotal ){
            page ++ ;
        }
        NSLog(@"====%ld",self.defaultEmotionArray.count);
        faceScrollView.contentSize = CGSizeMake(kScreenWidth * page, kScrollViewHeight);
        pageControl.numberOfPages = page;
        
        NSInteger currentPage = 0;
        for(int i = 0; i < self.defaultEmotionArray.count; i++){
            if(i % pageTotal == 0 ){
                //整数
                currentPage = i / pageTotal;
            }
            NSInteger j = (i - currentPage * pageTotal);
            CGFloat x = currentPage * kScreenWidth + horizontalMargin + (width + horizontalMargin) * (j % kColumn);
            
            //            NSLog(@"---%g",x);
            
            CGFloat y = verticalMargin + (height + verticalMargin) * (j / kColumn);
            //            NSLog(@"---%ld",self.defaultEmotionArray.count);
            UIButton* emotion = [UIButton new];
            emotion.frame = CGRectMake(x, y, width, height);
            //            emotion.backgroundColor = [UIColor redColor];
            NSDictionary* emotionDic = [self.defaultEmotionArray objectAtIndex:i];
            [emotion setBackgroundImage:[UIImage imageNamed:[emotionDic valueForKey:@"png"]] forState:UIControlStateNormal];
            
            emotion.tag = 200 + i;
            [emotion addTarget:self action:@selector(clickEmotionAction:) forControlEvents:UIControlEventTouchUpInside];
            [faceScrollView addSubview:emotion];
        }
        
        
        
        faceScrollView.sd_layout.topSpaceToView(_faceInputView,0).leftSpaceToView(_faceInputView,0).rightSpaceToView(_faceInputView,0).heightIs(kScrollViewHeight);
        pageControl.sd_layout.topSpaceToView(faceScrollView,20).leftSpaceToView(_faceInputView,0).rightSpaceToView(_faceInputView,0).heightIs(8);
        defaultImageButton.sd_layout.leftSpaceToView(_faceInputView,0).bottomSpaceToView(_faceInputView,0).widthIs(104/2.0).heightIs(103/2.0);
        defaultSelImageButton.sd_layout.leftSpaceToView(defaultImageButton,0).bottomSpaceToView(_faceInputView,0).widthIs(104/2.0).heightIs(103/2.0);
        deleteButton.sd_layout.rightSpaceToView(_faceInputView,0).bottomSpaceToView(_faceInputView,0).widthIs(104/2.0).heightIs(103/2.0);
        
    }
    return _faceInputView;
    
}
-(NSMutableArray *)defaultEmotionArray{
    if(!_defaultEmotionArray){
        //        if (isDefaultEmoij == YES) {
        NSString* emotionPath = [[NSBundle mainBundle] pathForResource:@"EmotionPlist" ofType:@"plist"];
        
        _defaultEmotionArray = [NSMutableArray arrayWithContentsOfFile:emotionPath];
        [_defaultEmotionArray removeObjectsInRange:NSMakeRange(30, 6)];
        //        }else{
        //
        //            [_defaultEmotionArray  removeAllObjects];
        //         }
        
        
        //        NSMutableArray *array = [NSMutableArray new];
        //        for (int i=0x1F600; i<=0x1F64F; i++) {
        //            if (i < 0x1F641 || i > 0x1F644) {
        //                int sym = EMOJI_CODE_TO_SYMBOL(i);
        //                NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
        //                [array addObject:emoT];
        //            }
        //        }
        //        _defaultEmotionArray = array;
    }
    return _defaultEmotionArray;
}

#pragma mark---键盘相关点击事件
- (void)clickToolBar:(UIButton*) bt{
    if(self.textView.inputView)self.textView.inputView = nil;
    [self.textView  becomeFirstResponder];
    if(bt.tag == 101){
        NSLog(@"点击添加");
    }else if(bt.tag == 102){
        NSLog(@"点击表情");
        self.addButton.selected = NO;
        
        if(convertToSystemKeyboard){
            convertToSystemKeyboard = NO;
            [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_face_nor"] forState:UIControlStateNormal];
            [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_face_heigh"] forState:UIControlStateHighlighted];
            
        }else{
            convertToSystemKeyboard = YES;
            [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_board_nor"] forState:UIControlStateNormal];
            [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_board_heigh"] forState:UIControlStateHighlighted];
            self.faceInputView = nil;
            self.textView.inputView = self.faceInputView;
            
        }
    }else if(bt.tag == 103){
        
        
        
        
        NSMutableString* mutableStr  = [NSMutableString string];
        [self.textView.attributedText enumerateAttributesInRange:NSMakeRange(0, self.textView.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            EmotionTextAttachment* attach = attrs[@"NSAttachment"];
            if(attach){
                //表情
                [mutableStr appendString:attach.emotionTag];
            }else{
                //拼接文本
                NSAttributedString* temp = [self.textView.attributedText attributedSubstringFromRange:range];
                [mutableStr appendString:temp.string];
            }
        }];
        
        NSString* consultation = mutableStr;
        NSLog(@"%@",consultation);
        

        
        [self.presenter  InsertConsultationByCommentID:_CommenList.uuid  CommentContent:consultation];
        
        [self.textView  endEditing:YES];
        self.textView.text = nil;
        self.textView.placeholder = @"我来说两句";
        self.sendButton.selected = NO;
        self.sendButton.userInteractionEnabled = NO;
        [self.textView   resignFirstResponder];
        [self  textViewDidChange:_textView];
    }
    [self.textView reloadInputViews];
    
    
    
}
- (void)clickEmotionAction:(UIButton*) emotionbt{
    NSInteger index = emotionbt.tag - 200;
    NSDictionary* emotionDic = self.defaultEmotionArray[index];
    NSString  *emotion= [emotionDic valueForKey:@"tag"];
    
    if(!self.textView.text || self.textView.text.length == 0){
        self.textView.text = emotion;
    }else{
        NSMutableString* mutableStr = [NSMutableString stringWithString:self.textView.text];
        [mutableStr appendString:emotion];
        
        self.textView.text = mutableStr;
    }
    if (self.textView.text!=nil&& self.textView.text.length!=0) {
        self.sendButton.userInteractionEnabled = YES;
        self.sendButton.selected = YES;
        
    }else{
        self.sendButton.userInteractionEnabled = NO;
        self.sendButton.selected = NO;
    }
    //文本转换成表情
//    //获取之前写的文本
//    NSAttributedString* str = self.textView.attributedText;
//    //将之前的文本包含进去
//    NSMutableAttributedString* mutableStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
//    //记录当前光标的位置
//    NSInteger currentPosition;
//    EmotionTextAttachment* attach = [EmotionTextAttachment new];
//    attach.bounds = CGRectMake(0, -2.5, self.textView.font.lineHeight - 5, self.textView.font.lineHeight - 5);
//    attach.image = [UIImage imageNamed:[emotionDic valueForKey:@"png"]];
//    attach.emotionTag = [emotionDic valueForKey:@"tag"];
//    NSAttributedString* attr = [NSAttributedString attributedStringWithAttachment:attach];
//    //保存一下当前光标位置
//    currentPosition = self.textView.selectedRange.location;
//    [mutableStr insertAttributedString:attr atIndex:currentPosition];
//    
//    //重写给文本框赋值
//    [mutableStr addAttribute:NSFontAttributeName value:self.textView.font range:NSMakeRange(0, mutableStr.length)];
//    self.textView.attributedText = mutableStr;
//    self.textView.selectedRange = NSMakeRange(currentPosition + 1, 0);
    
}

- (void)deleteFaceAction{
    //    NSRange range = self.textView.selectedRange;
    //    if(range.location >= 2){
    //        NSString* subString = [self.textView.text substringWithRange:NSMakeRange(range.location -2 , 2)];
    //        BOOL isEmotion = NO;
    //        for(NSString* emotion in self.defaultEmotionArray){
    //            if([subString isEqualToString:emotion]){
    //                isEmotion = YES;
    //                break;
    //            }
    //        }
    //
    //        NSMutableString* mutable = [NSMutableString stringWithString:self.textView.text];
    //        if(isEmotion){
    //            //是表情
    //            [mutable deleteCharactersInRange:[self.textView.text rangeOfString:subString]];
    //        }else{
    //            //不是表情
    //            [mutable deleteCharactersInRange:NSMakeRange(self.textView.text.length - 1, 1)];
    //        }
    //        self.textView.text = mutable;
    //    }else{
    //        NSMutableString* mutable = [NSMutableString stringWithString:self.textView.text];
    //        [mutable deleteCharactersInRange:NSMakeRange(self.textView.text.length - 1, 1)];
    //        self.textView.text = mutable;
    //    }
    if (self.textView.text!=nil&& self.textView.text.length!=0) {
        self.sendButton.userInteractionEnabled = YES;
        self.sendButton.selected = YES;
        
    }else{
        self.sendButton.userInteractionEnabled = NO;
        self.sendButton.selected = NO;
    }

    
    [self.textView deleteBackward];
    
}
-(void)defaultButton:(UIButton*)btn{
    if (btn.tag == 108) {
        
        NSLog(@"默认");
        
        if(self.textView.inputView)self.textView.inputView = nil;
        self.faceInputView = nil;
        [_defaultEmotionArray removeAllObjects];
        NSString* emotionPath = [[NSBundle mainBundle] pathForResource:@"EmotionPlist" ofType:@"plist"];
        _defaultEmotionArray = [NSMutableArray arrayWithContentsOfFile:emotionPath];
        [_defaultEmotionArray removeObjectsInRange:NSMakeRange(30, 6)];
        self.textView.inputView = self.faceInputView;
        [self.textView reloadInputViews];
        self.defaultImageBt.backgroundColor = UIColorFromRGB(0XF2F2F2);
        self.selecImageBt.backgroundColor = [UIColor  whiteColor];
        
    }else{
        
        NSLog(@"选中");
        
        if(self.textView.inputView)self.textView.inputView = nil;
        self.faceInputView = nil;
        [_defaultEmotionArray removeAllObjects];
        NSString* emotionPath = [[NSBundle mainBundle] pathForResource:@"EmotionPlist" ofType:@"plist"];
        _defaultEmotionArray = [NSMutableArray arrayWithContentsOfFile:emotionPath];
        [_defaultEmotionArray removeObjectsInRange:NSMakeRange(0, 30)];
        self.textView.inputView = self.faceInputView;
        [self.textView reloadInputViews];
        self.defaultImageBt.backgroundColor = [UIColor  whiteColor];
        self.selecImageBt.backgroundColor =UIColorFromRGB(0XF2F2F2);
        
    }
}
#pragma mark * keyboardWillHide监听
- (void)HotDetailConsulationInfokeyboardWillHide:(NSNotification*)notification{
    
    convertToSystemKeyboard = NO;
    [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_face_nor"] forState:UIControlStateNormal];
    [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_face_heigh"] forState:UIControlStateHighlighted];
    if(self.textView.inputView)self.textView.inputView = nil;
    self.faceInputView = nil;
    self.textView.inputView = nil;
    NSLog(@"隐藏键盘");
    
    
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    
//    if (textView.text != nil||textView.text.length !=0) {
//        self.sendButton.userInteractionEnabled = YES;
//        self.sendButton.selected = YES;
//        
//    }
//    if (textView.text.length == 0) {
//        self.sendButton.userInteractionEnabled = NO;
//       self.sendButton.selected = NO;
// 
//        
//    }
    NSCharacterSet *set=[NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString=[textView.text stringByTrimmingCharactersInSet:set];
    if (trimedString.length==0) {
        self.sendButton.userInteractionEnabled = NO;
        self.sendButton.selected = NO;

    }else{
        
        self.sendButton.userInteractionEnabled = YES;
        self.sendButton.selected = YES;
    }
    
    
    CGFloat height = [JMFoundation calLabelHeight:textView.font andStr:textView.text withWidth:textView.width];
    if (ReplyView.height == 100) {
        if (textView.text.length > 0) {
            return;
        }
    }
    if (height > textView.height) {
        textView.sd_layout.heightIs(textView.height+25);
        ReplyView.sd_layout.heightIs(ReplyView.height+25);
        if (textView.height > 80) {
            textView.height = 80;
            ReplyView.sd_layout.heightIs(100);
        }
    }
    if ([textView.text isEqualToString:@""] || textView.text == nil || [[textView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] || [[textView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"\n"]) {
        self.textView.placeholder = @"我来说两句";
        textView.sd_layout.heightIs(38);
        ReplyView.sd_layout.heightIs(50);
        
    }
    

    
}

#pragma mark - 代理
/**
 *  tableView的数据源代理
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.presenter.DataSource) {
        
        return self.presenter.DataSource.count;
    }else {
        return 0;
    }
    
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HotDetailInfoTableViewCell* cell = [_table dequeueReusableCellWithIdentifier:@"cell"];
    cell.ReplyList = [self.presenter.DataSource objectAtIndex:indexPath.row];
    cell.delegate = self;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = _table;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ConsulationReplyList* replyEntity = [self.presenter.DataSource objectAtIndex:indexPath.row];
    return [_table cellHeightForIndexPath:indexPath model:replyEntity keyPath:@"ReplyList" cellClass:[HotDetailInfoTableViewCell class] contentViewWidth:[self cellContentViewWith]];
}

#pragma mark----网络请求回调
-(void)getConsulationReplyCompletion:(BOOL) success info:(NSString*) messsage{
    _table.userInteractionEnabled = YES;
    [_table.mj_footer resetNoMoreData];
    [_table.mj_header endRefreshing];
    
    if(success){

        [ProgressUtil  dismiss];
        _table.hidden = NO;
        [_table reloadData];
        
        _AnswerCountLb.text =[NSString  stringWithFormat:@"%ld条",(long)_presenter.totalCount];
        [_AnswerCountLb  updateLayout];
        
    }else{
        
    }
}

-(void)GetMoreConsultationReplyCompletion:(BOOL)success info:(NSString*)message{
    _table.userInteractionEnabled = YES;
    self.presenter.noMoreData? [_table.mj_footer endRefreshingWithNoMoreData]: [_table.mj_footer endRefreshing];
    if(success){
        [_table reloadData];
    }else{
        
    }
}
-(void)InsertConsulationOnCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
        [ProgressUtil showInfo:@"评论成功"];
[_presenter  GetConsulationReplyByCommentID:[_commentID  integerValue]];
        [self.table  reloadData];
        //发送通知，刷新问题详情页评论
[kdefaultCenter postNotificationName:Notification_RefreshConsulationList object:nil userInfo:nil];
        
   
    }else{
        
        [ProgressUtil showError:message];
        
    }
}



#pragma mark Action
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if(scrollView.contentOffset.x / kScreenWidth == (int)(scrollView.contentOffset.x / kScreenWidth)){
//        self.pageControl.currentPage = scrollView.contentOffset.x / kScreenWidth;
//    }

 
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [self.textView resignFirstResponder];
        NSLog(@"tableview滑动");
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(HotDetailConsulationInfokeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.textView.inputView){
        self.textView.inputView = nil;
        [self.textView reloadInputViews];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    
}
#pragma mark - 私有方法

- (CGFloat)cellContentViewWith
{
    CGFloat width = kScreenWidth;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
-(void)GetHotQuestionInfoSingleCompletion:(BOOL) success info:(NSString*) messsage{

    if (success) {
        if (_presenter.HotInfoSingleDataSource.count==0) {
            
        }else{
            ConsultationCommenList  *commentList= _presenter.HotInfoSingleDataSource[0];
            _CommenList = commentList;
            [self  setupHeadView];
            _AnswerCountLb.text =[NSString  stringWithFormat:@"%ld条",(long)_presenter.totalCount];
            [_AnswerCountLb  updateLayout];
            [self.table reloadData];

        }
    }else{
        
        [ProgressUtil  showError:messsage];
    }




}
#pragma  mark-- 删除--
-(void)deleteBtnInvationNew
{
    [_presenter deleteAallInvitationWithCommentId:self.commentID];
//    [ProgressUtil show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.RefreshPopViewRow(YES);
        [self.navigationController popViewControllerAnimated:YES];
    });
    
    
}
-(void)deleButtonWithIndexPath:(UITableViewCell *)indexPath
{
    NSIndexPath *index = [_table indexPathForCell:indexPath];
    
    [self tableView:_table commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:index];
    
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ConsulationReplyList* replyEntity = self.presenter.DataSource[indexPath.row];
        
        [self.presenter deleteInvitationWithID:replyEntity.ID];
        
        [self.presenter.DataSource removeObjectAtIndex:indexPath.row];
        //    删除
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [kdefaultCenter postNotificationName:Notification_RefreshConsulationList object:nil userInfo:nil];
        
        [_table.mj_header beginRefreshing];
    }
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
