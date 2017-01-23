//
//  CommentDetailViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CommentDetailViewController.h"
#import "LCChatToolBarView.h"
#import "CommentDetailHeaderCell.h"
#import "ReplyCell.h"
#import "CommentDetailPresenter.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "ConsulationReplyList.h"
#import "SFPhotoBrowser.h"
#import "TabbarViewController.h"

#import "PatientCaseDetailController.h"


#define HaveImageWidth   kScreenWidth-30/2-30-24/2-30/2
#define PhotoSpace  15
#define PhotoWidth  (HaveImageWidth-PhotoSpace*2)/3
#define PhotoHeight (HaveImageWidth-PhotoSpace*2)/3
#define topHeight 7.5


@interface CommentDetailViewController ()<LCChatToolBarViewDelegate,UITableViewDelegate,UITableViewDataSource,CommentDetailPresenterDelegate,PhotoBrowerDelegate,CircleTableViewCellDelegate>

@property(nullable,nonatomic,retain) UIScrollView* scroll;
@property(nullable,nonatomic,retain) LCChatToolBarView* toolBarView;//聊天工具条
@property(nullable,nonatomic,retain) UITableView* table;
@property(nullable,nonatomic,retain) CommentDetailPresenter* presenter;


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

@property(nonatomic,strong)UIButton *deletedBtn;
@property(nonatomic,strong)UIButton *smallBtn;



@end

@implementation CommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - 加载视图
-(void)setupView{
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    self.title = @"回复详情";
    
    UIScrollView* scroll = [UIScrollView new];
    scroll.showsVerticalScrollIndicator = NO;
    scroll.scrollEnabled = NO;
    [self.view addSubview:scroll];
    self.scroll = scroll;
    scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self setupTableView];
    [self setupToobarView];

}

- (void)setupTableView{
    UITableView* table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.dataSource = self;
    table.delegate = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scroll addSubview:table];
    self.table = table;
    table.sd_layout.topSpaceToView(self.scroll,0).leftSpaceToView(self.scroll,0).rightSpaceToView(self.scroll,0).bottomSpaceToView(self.scroll,50);
    
//    [table registerClass:[CommentDetailHeaderCell class] forCellReuseIdentifier:@"header"];
    [table registerClass:[ReplyCell class] forCellReuseIdentifier:@"cell"];
    [ProgressUtil  show];
    table.hidden = YES;
    WS(ws);
    //下拉刷新
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        ws.table.userInteractionEnabled = NO;
        [ws.presenter getPostReplyListByCommentID:[ws.commentID  integerValue]];
    }];
    [table.mj_header beginRefreshing];
    //上拉加载
    table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        ws.table.userInteractionEnabled = NO;
        [ws.presenter getMorePostReplyListCommentID:[ws.commentID  integerValue]];
    }];
    
    [self  setupHeadView];

}

- (void)setupToobarView{
    [self.scroll addSubview:self.toolBarView];
    self.toolBarView.sd_layout.leftSpaceToView(self.scroll,0).rightSpaceToView(self.scroll,0).bottomSpaceToView(self.scroll,0).heightIs(50);
    [self.scroll  setupAutoHeightWithBottomView:self.toolBarView bottomMargin:0];

}

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
    _CommentContent.backgroundColor = [UIColor  clearColor];
    _CommentContent.textColor = UIColorFromRGB(0X666666);
    _CommentContent.font = [UIFont  systemFontOfSize:16];
    _CommentContent.textAlignment = NSTextAlignmentLeft;
    _CommentContent.numberOfLines = 0;
    _CommentContent.isAttributedContent = YES;
    [topView   addSubview:_CommentContent];
    
    _deletedBtn = [UIButton new];
    [_deletedBtn addTarget:self action:@selector(deleteContent) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_deletedBtn];
    
    _smallBtn = [UIButton new];
    [_smallBtn setImage:[UIImage imageNamed:@"Trash"] forState:UIControlStateNormal];
    [_smallBtn addTarget:self action:@selector(deleteContent) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_smallBtn];
    
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
    
    _leftImageView1 = [self imageVIiewWithTag:1004];
    _leftImageView1.backgroundColor = [UIColor clearColor];
    [_haveImageBgView addSubview:_leftImageView1];
    
    _midImageView1 = [self imageVIiewWithTag:1005];
    _midImageView1.backgroundColor = [UIColor clearColor];
    [_haveImageBgView addSubview:_midImageView1];
    
    _rightImageView1 = [self imageVIiewWithTag:1006];
    
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
    
    
    
    
    //
    [_HeadImageView  setImageWithUrl:[ NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.CHILD_IMG] placeholderImage:[UIImage  imageNamed:@"my_answer"]];
    _HeadName.text = _commentEntity.NickName;
    //    _CommentContent.text = _CommenList.CommentContent;
    _CommentContent.attributedText = [UILabel getAttributeTextWithString:_commentEntity.CommentContent];
    
    [_TimeImageView  setImageWithUrl:nil placeholderImage:[UIImage  imageNamed:@"DailyPrise_TimeImage"]];

    
    _TimeLb.text =  _commentEntity.CreateTime;
    _AnswerCountImageView.image = [UIImage  imageNamed:@"HotAnswerBtnImage"];
    //    _FloorLb.text = [NSString  stringWithFormat:@"%d楼",_CommenList.RowID];
    _FloorLb.text = @"1楼";
    _AnswerLb.text = @"相关回复";
    
    
    
    topView.sd_layout.topSpaceToView(headView,0).leftEqualToView(headView).rightEqualToView(headView);
    
    _HeadImageView.sd_layout.topSpaceToView(topView,30/2).leftSpaceToView(topView,30/2).widthIs(60/2).heightIs(60/2);
    _HeadImageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    _HeadName.sd_layout.topSpaceToView(topView,15+8).leftSpaceToView(_HeadImageView,24/2).heightIs(14).widthIs(kScreenWidth-_HeadImageView.frame.size.width-_FloorLb.frame.size.width-30/2-24/2-30/2);
//    _HeadName.sd_layout.topSpaceToView(topView,15+8).leftSpaceToView(_HeadImageView,24/2).heightIs(14).widthIs(150);
    _FloorLb.sd_layout.topEqualToView(_HeadName).rightSpaceToView(topView,30/2).heightIs(11).minWidthIs(10);
    [_FloorLb setSingleLineAutoResizeWithMaxWidth:kScreenWidth];

    _CommentContent.sd_layout.topSpaceToView(_HeadName,30/2).leftEqualToView(_HeadName).widthIs(kScreenWidth-30/2-30-24/2-30/2).autoHeightRatio(0);
    
    
    //图片布局
//    _haveImageBgView.sd_layout.leftEqualToView(_HeadName).topSpaceToView(_CommentContent,0).widthIs(HaveImageWidth).heightIs(PhotoHeight+10);
//    
//    _leftImageView.sd_layout.topSpaceToView(_haveImageBgView,10).leftSpaceToView(_haveImageBgView,0).widthIs(PhotoWidth).heightIs(PhotoHeight);
//    _midImageView.sd_layout.topEqualToView(_leftImageView).leftSpaceToView(_haveImageBgView,PhotoWidth+PhotoSpace).widthIs(PhotoWidth).heightIs(PhotoHeight);
//    
//    _rightImageView.sd_layout.topEqualToView(_leftImageView).leftSpaceToView(_haveImageBgView,2*PhotoWidth+2*PhotoSpace).widthIs(PhotoWidth).heightIs(PhotoHeight);
//    _leftImageView1.sd_layout.topSpaceToView(_haveImageBgView,PhotoHeight+topHeight+10).leftEqualToView(_leftImageView).widthIs(PhotoWidth).heightIs(PhotoHeight);
//    
//    _midImageView1.sd_layout.topSpaceToView(_haveImageBgView,PhotoHeight+topHeight+10).leftSpaceToView(_leftImageView1,PhotoWidth+PhotoSpace).heightIs(PhotoHeight).widthIs(PhotoWidth);
//    
//    _rightImageView1.sd_layout.topEqualToView(_leftImageView1).leftEqualToView(_rightImageView).widthIs(PhotoWidth).heightIs(PhotoHeight);
//    
//    if (_commentEntity.Image1!=nil&&_commentEntity.Image1.length>4&&(![_commentEntity.Image1 isEqualToString:@""])) {
//        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image1]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
//        if (_commentEntity.Image2!=nil&&_commentEntity.Image2.length>4&&(![_commentEntity.Image2 isEqualToString:@""])) {
//            
//            [_midImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image2]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
//            if (_commentEntity.Image3!=nil&&_commentEntity.Image3.length>4&&(![_commentEntity.Image3 isEqualToString:@""])) {
//                
//                [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image3]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
//                
//                if (_commentEntity.Image4!=nil&&_commentEntity.Image4.length>4&&(![_commentEntity.Image4 isEqualToString:@""])) {
////                    [_haveImageBgView addSubview:_leftImageView1];
//                    _haveImageBgView.sd_layout.leftEqualToView(_HeadName).topSpaceToView(_CommentContent,0).widthIs(HaveImageWidth).heightIs(2*PhotoHeight+10+topHeight);
//                    
//                     [_leftImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image4]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
//                    
//                    if (_commentEntity.Image5!=nil&&_commentEntity.Image5.length>4&&(![_commentEntity.Image5 isEqualToString:@""])) {
//                        _midImageView1.hidden = NO;
//                        
//                       [_midImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image5]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
//                        
//                        if (_commentEntity.Image6!=nil&&_commentEntity.Image6.length>4&&(![_commentEntity.Image6 isEqualToString:@""])) {
//                            
//                            _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1,_midImageView1,_rightImageView1];
//                            
//                            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image5],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image6]];
//                            
//                            [_rightImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image6]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
//                            
//                        }else{
//                            // 5
//                            _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1,_midImageView1];
//                            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image5]];
////                            _midImageView1.hidden = YES;
//                            _rightImageView1.hidden = YES;
//                        }
//                        
//                    }else{
//                    // 4
////                    _haveImageBgView.sd_layout.leftEqualToView(_HeadName).topSpaceToView(_CommentContent,0).widthIs(HaveImageWidth).heightIs(2*PhotoHeight+10+topHeight);
//                        
//                    _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1];
//                    _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image4]];
//                    }
//                    _midImageView1.hidden = YES;
//                    _rightImageView1.hidden = YES;
//
//                    
//                }else{
////                    _haveImageBgView.sd_layout.leftEqualToView(_HeadName).topSpaceToView(_CommentContent,0).widthIs(HaveImageWidth).heightIs(PhotoHeight+10);
//                    // 3 张
//                    _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView];
//                    _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image3]];
//                    
////                    _rightImageView.hidden =YES;
//                    _leftImageView1.hidden = YES;
//                    _midImageView1.hidden = YES;
//                    _rightImageView1.hidden = YES;
//
//                }
//                    
//                
//            }else {
//                // 2 张
//                _photoBrowserArr =@[_leftImageView,_midImageView];
//                _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image2]];
//                _rightImageView.hidden =YES;
//                _leftImageView1.hidden = YES;
//                _midImageView1.hidden = YES;
//                _rightImageView1.hidden = YES;
//
//            }
//        }else{
//            _photoBrowserArr =@[_leftImageView];
//            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image1]];
//            _midImageView.hidden =YES;
//            _rightImageView.hidden =YES;
//            _leftImageView1.hidden = YES;
//            _midImageView1.hidden = YES;
//            _rightImageView1.hidden = YES;
//            
//        }
//        
//    }else{
//        _haveImageBgView.sd_layout.widthIs(0).heightIs(0);
//        _haveImageBgView.hidden =YES;
//    }
//    
//    if (_haveImageBgView.height == 0) {
//         _TimeImageView.sd_layout.topSpaceToView(_CommentContent,30/2).leftEqualToView(_HeadName).widthIs(30/2).heightIs(30/2);
//    }else if (_haveImageBgView.height == PhotoHeight+10){
//        _TimeImageView.sd_layout.topSpaceToView(_CommentContent,30/2+PhotoHeight).leftEqualToView(_HeadName).widthIs(30/2).heightIs(30/2);
//    }else{
//       _TimeImageView.sd_layout.topSpaceToView(_CommentContent,30/2+2*PhotoHeight+topHeight).leftEqualToView(_HeadName).widthIs(30/2).heightIs(30/2);
//        
//    }
    
    _haveImageBgView.sd_layout.leftEqualToView(_HeadName).topSpaceToView(_CommentContent,10).widthIs(HaveImageWidth).heightIs(PhotoHeight);
    
    _leftImageView.sd_layout.topSpaceToView(_haveImageBgView,0).leftSpaceToView(_haveImageBgView,0).widthIs(PhotoWidth).heightIs(PhotoHeight);
    _midImageView.sd_layout.topEqualToView(_leftImageView).leftSpaceToView(_haveImageBgView,PhotoWidth+PhotoSpace).widthIs(PhotoWidth).heightIs(PhotoHeight);
    
    _rightImageView.sd_layout.topEqualToView(_leftImageView).leftSpaceToView(_haveImageBgView,2*PhotoWidth+2*PhotoSpace).widthIs(PhotoWidth).heightIs(PhotoHeight);
    _leftImageView1.sd_layout.topSpaceToView(_haveImageBgView,PhotoHeight+topHeight).leftEqualToView(_leftImageView).widthIs(PhotoWidth).heightIs(PhotoHeight);
    _midImageView1.sd_layout.topEqualToView(_leftImageView1).leftEqualToView(_midImageView).widthIs(PhotoWidth).heightIs(PhotoHeight);
    _rightImageView1.sd_layout.topEqualToView(_leftImageView1).leftEqualToView(_rightImageView).widthIs(PhotoWidth).heightIs(PhotoHeight);
    
    if (_commentEntity.Image1!=nil&&_commentEntity.Image1.length>4&&(![_commentEntity.Image1 isEqualToString:@""])) {
        _haveImageBgView.sd_layout.leftEqualToView(_HeadName).topSpaceToView(_CommentContent,10).widthIs(HaveImageWidth).heightIs(PhotoHeight);
        
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image1]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
        if (_commentEntity.Image2!=nil&&_commentEntity.Image2.length>4&&(![_commentEntity.Image2 isEqualToString:@""])) {
            
            [_midImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image2]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
            if (_commentEntity.Image3!=nil&&_commentEntity.Image3.length>4&&(![_commentEntity.Image3 isEqualToString:@""])) {
                
                [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image3]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                if (_commentEntity.Image4!=nil&&_commentEntity.Image4.length>4&&(![_commentEntity.Image4 isEqualToString:@""])) {
                    
                    _haveImageBgView.sd_layout.leftEqualToView(_HeadName).topSpaceToView(_CommentContent,10).widthIs(HaveImageWidth).heightIs(PhotoHeight*2+topHeight);
                    
                    [_leftImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image4]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                    
                    if ((_commentEntity.Image5!=nil&&_commentEntity.Image5.length>4&&(![_commentEntity.Image5 isEqualToString:@""]))) {
                        
                        [_midImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image5]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                        
                        if ((_commentEntity.Image6!=nil&&_commentEntity.Image6.length>4&&(![_commentEntity.Image6 isEqualToString:@""]))) {
                            
                            _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1,_midImageView1,_rightImageView1];
                            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image5],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image6]];
                            
                            [_rightImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image6]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                            
                        }else{
                            // 5
                            _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1,_midImageView1];
                            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image5]];
                            _rightImageView1.hidden = YES;
                        }
                        
                    }else{
                        // 4
                        _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1];
                        _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image4]];
                        
                        _midImageView1.hidden = YES;
                        _rightImageView1.hidden = YES;
                    }
                    
                }else{
                    // 3
                    _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView];
                    _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image3]];
                    
                    _leftImageView1.hidden = YES;
                    _midImageView1.hidden = YES;
                    _rightImageView1.hidden = YES;
                }
                
            }else {
                //2
                _photoBrowserArr =@[_leftImageView,_midImageView];
                _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image2]];
                _rightImageView.hidden =YES;
                _leftImageView1.hidden = YES;
                _midImageView1.hidden = YES;
                _rightImageView1.hidden = YES;
            }
        }else{
            _photoBrowserArr =@[_leftImageView];
            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,_commentEntity.Image1]];
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
        _TimeImageView.sd_layout.topSpaceToView(_CommentContent,30/2+PhotoHeight*2+topHeight).leftEqualToView(_HeadName).widthIs(30/2).heightIs(30/2);
        
    }

    
    _smallBtn.sd_layout.centerYEqualToView(_TimeImageView).rightEqualToView(_FloorLb).heightIs(15).widthIs(15);
    
    _deletedBtn.sd_layout.centerYEqualToView(_TimeImageView).rightEqualToView(_FloorLb).heightIs(50).widthIs(50);
    
    _TimeLb.sd_layout.topEqualToView(_TimeImageView).leftSpaceToView(_TimeImageView,5).widthIs(kJMWidth(_TimeLb)).heightIs(11);
    
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
    
    if ((self.commentEntity.UserID == kCurrentUser.userId)) {
        
        _deletedBtn.hidden = NO;
        _smallBtn.hidden = NO;
        
    }else
    {
        _deletedBtn.hidden = YES;
        _smallBtn.hidden = YES;
    }
}


#pragma mark - 代理
#pragma mark * tableView代理

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if(section == 0){
//        return 1;
//    }else{
        return self.presenter.dataSource.count;
//    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReplyCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
//    CommentDetailHeaderCell* headerCell = [tableView dequeueReusableCellWithIdentifier:@"header"];
//    
//    if(indexPath.section == 0){
//        headerCell.commentEntity = self.commentEntity;
//        
//        headerCell.sd_indexPath = indexPath;
//        headerCell.sd_tableView = tableView;
//        
//        return headerCell;
//    }else{
        if(indexPath.row >= self.presenter.dataSource.count){
            cell.replyList = [self.presenter.dataSource lastObject];
        }else{
            ConsulationReplyList* replyEntity = self.presenter.dataSource[indexPath.row];
            replyEntity.RowID = (self.commentEntity.RowID + indexPath.row + 1);
            cell.replyList = replyEntity;
        }
    
        cell.delegate = self;
    
        cell.sd_indexPath = indexPath;
        cell.sd_tableView = tableView;
        
        return cell;
        
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if(indexPath.section == 0){
//        return [_table cellHeightForIndexPath:indexPath model:self.commentEntity keyPath:@"commentEntity" cellClass:[CommentDetailHeaderCell class] contentViewWidth:[self cellContentViewWith]];
//        
//    }else{
        ConsulationReplyList* replyEntity = [self.presenter.dataSource objectAtIndex:indexPath.row];
        return [_table cellHeightForIndexPath:indexPath model:replyEntity keyPath:@"replyList" cellClass:[ReplyCell class] contentViewWidth:[self cellContentViewWith]];
        
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark * scrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if([scrollView isEqual:self.table]){
        if([self.toolBarView.textView isFirstResponder]){
            [self.toolBarView.textView resignFirstResponder];
        }
        
        if([self.toolBarView.unUsedTextView isFirstResponder]){
            [self.toolBarView.unUsedTextView resignFirstResponder];
        }

    }
}


#pragma mark * 发送评论代理
-(void)sendCommitPostWith:(BOOL)isNeedUploadPImage content:(NSString *)consultation imageDataSource:(NSMutableArray * _Nonnull)imageDataSource{
    if(isNeedUploadPImage){
        //先上传图片
    }else{
        //直接走发送评论接口
        [ProgressUtil show];
        [self.presenter commitPostReplyWithConsultationID:self.commentEntity.uuid CommentContent:consultation];
    }
}
#pragma mark * 回复列表代理
-(void)replyCommentComplete:(BOOL)success info:(NSString *)message{
    [_table.mj_footer resetNoMoreData];
    [_table.mj_header endRefreshing];
//    _table.userInteractionEnabled = YES;
    
    if(success){
        [ProgressUtil dismiss];
        _table.hidden = NO;
//        self.commentEntity.ReplyCount = self.presenter.totalCount;
        if(self.presenter.dataSource.count == 0){
            [_table.mj_footer endRefreshingWithNoMoreData];
        }
        
        if(self.toolBarView.textView.text.length != 0){
            self.toolBarView.textView.text = nil;;
        }
        
        self.toolBarView.sendButton.selected = NO;


        [_table reloadData];
        _AnswerCountLb.text =[NSString  stringWithFormat:@"%d条",_presenter.totalCount];
        [_AnswerCountLb  updateLayout];
    }else{
        [ProgressUtil showError:message];
    }

}
-(void)moreReplyCommentComplete:(BOOL)success info:(NSString *)message{
    self.presenter.noMoreData? [self.table.mj_footer endRefreshingWithNoMoreData]: [self.table.mj_footer endRefreshing];
//    self.table.userInteractionEnabled = YES;
    
    if(success){
        [self.table reloadData];
    }else{
        [ProgressUtil showError:message];
    }

}

-(void)GetCircleQuestionInfoSingleCompletion:(BOOL) success info:(NSString*) messsage{
    
    if (success) {
        if (_presenter.CircleInfoSingleDataSource.count==0) {
            
        }else{
            
            ConsultationCommenList  *commentList= _presenter.CircleInfoSingleDataSource[0];
            _commentEntity = commentList;
            [self  setupHeadView];
            
            
            if (self.isPatinetCase == YES) {
                
                self.RefreshRow(YES);
                
            }else
            {
//            
            }
            
        }
    }else{
        
        [ProgressUtil  showError:messsage];
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

#pragma mark--删除--
-(void)deleteContent
{
    NSLog(@"self.commentID is- %@ self.isPation is- %hhd",self.commentID,self.isPatinetCase);
    
        [_presenter deleteAallInvitationWithCommentId:self.commentID];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            if (self.isPatinetCase == YES) {
              
                self.deleteRow(YES);
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else
            {
//                self.deletePubPostDetailRow(YES);
                [kdefaultCenter postNotificationName:@"refreshPopViewnew" object:nil userInfo:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
           
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
        
       ConsulationReplyList* replyEntity = self.presenter.dataSource[indexPath.row];
        
        
        if (self.isPatinetCase == YES) {
            
            [self.presenter deleteInvitationWithID:replyEntity.uuid];
            
            [self.presenter.dataSource removeObjectAtIndex:indexPath.row];
            //    删除
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            self.RefreshRow(YES);
            
            [_table.mj_header beginRefreshing];
            
            
            
            
        }else
        {
            [self.presenter deleteInvitationWithID:replyEntity.ID];
            
            [self.presenter.dataSource removeObjectAtIndex:indexPath.row];
            //    删除
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [_table.mj_header beginRefreshing];
            
            [kdefaultCenter postNotificationName:@"refreshPopViewnew" object:nil userInfo:nil];
            
        }
        
        
    }
}

#pragma mark - 懒加载
-(LCChatToolBarView *)toolBarView{
    if(!_toolBarView){
        _toolBarView = [LCChatToolBarView new];
        _toolBarView.backgroundColor = UIColorFromRGB(0xffffff);
        _toolBarView.emotionRow = 3;//3行
        _toolBarView.emotionColumn = 6;//6列
        _toolBarView.delegate = self;
        _toolBarView.hiddenAddButton = YES;
    }
    
    return _toolBarView;
}
-(CommentDetailPresenter *)presenter{
    if(!_presenter){
        _presenter = [CommentDetailPresenter new];
        _presenter.delegate = self;

        //入口参数请求
        /**
         *  推送、系统消息、上个页面都这样进入
         */
        _presenter.isPatinetCase = self.isPatinetCase;
        NSLog(@"11111:%d",self.isPatinetCase);

[_presenter  GetCircleQuestionInfoSingleWithcommentID:_commentID];
    }
    return _presenter;
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

-(UIImageView *)imageVIiewWithTag:(NSInteger)tag
{
    UIImageView *newImage =[[UIImageView alloc]init];
    
    newImage.contentMode =UIViewContentModeScaleAspectFill;
    newImage.tag =tag;
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
