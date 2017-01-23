//
//  RelatedAnswerViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/12/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "RelatedAnswerViewController.h"
#import "RelatedAnswerCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "RelatedAnswerPresenter.h"
#import "RelatedAnswerEntity.h"
#import "NSDate+Category.h"
#import "ZHAVRecorder.h"
#import "AVRecorderPlayerManager.h"
#import "SFPhotoBrowser.h"
#import "AwaitAnswerViewController.h"
#import "MyAnserEntity.h"
#import "ApiMacro.h"

#define   kImageXspace     20
#define   kImageTopspace     7.5
#define   kImageWidth   (kScreenWidth-15*2-2*kImageXspace)/3

@interface RelatedAnswerViewController ()<RelatedAnswerPresenterDelegate,UITableViewDelegate, UITableViewDataSource,RelatedAnswerCellDelegate>
@property(nonatomic,strong) RelatedAnswerPresenter *presenter;
@property(nonatomic,strong) UITableView *table;
@property(nonatomic,strong) UIView *headerView;
@property(nonatomic,strong) UIImageView *userIcon;
@property(nonatomic,strong) UILabel *userNameLabel;
@property(nonatomic,strong) UILabel *mainQuestionLabel;
@property(nonatomic,strong) UIImageView *docIcon;
@property(nonatomic,strong) UIButton *mainVoiceBtn;
@property(nonatomic,strong) UILabel *mainVoiceTimeLabel;


@property(nonatomic,strong) UIView *wordBackView;
@property(nonatomic,strong) UIButton *wordContentBtn;
@property(nonatomic,strong) UIView *wordContentView;
@property(nonatomic,strong) UILabel *wordContentMessage;

@property(nonatomic,strong) UILabel *mainDateLabel;
@property(nonatomic,strong) UILabel *mainHeartLabel;
@property(nonatomic,strong)UIView *line;


@property (nonatomic, strong) UIView *haveImageBgView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *midImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *leftImageView1;
@property (nonatomic, strong) UIImageView *midImageView1;
@property (nonatomic, strong) UIImageView *rightImageView1;
@property (nonatomic,retain) NSArray *photoBrowserArr;
@property (nonatomic,retain) NSArray *photoBrowserUrlArr;

@end

@implementation RelatedAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =UIColorFromRGB(0xf2f2f2);
    self.title =@"待回答";
    NSLog(@"12333");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ProgressUtil showWithStatus:@"加载中···"];
    
    [_presenter getdocfullanwerconsultationByUUID:_uuid];
}

- (void)setupView{
    _presenter =[RelatedAnswerPresenter new];
    _presenter.delegate =self;
    
    _table = [UITableView new];
    _table.tag =1001;
    _table.backgroundColor =UIColorFromRGB(0xf2f2f2);
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
//    [_table registerClass:[RelatedAnswerCell class] forCellReuseIdentifier:@"cell"];
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _headerView =[UIView new];
    _headerView.backgroundColor =[UIColor whiteColor];
    
    _userIcon =[UIImageView new];
    _userIcon.layer.masksToBounds = YES;
    _userIcon.layer.cornerRadius = 15;
    [_headerView addSubview:_userIcon];
    
    _userNameLabel =[UILabel new];
    _userNameLabel.font =[UIFont systemFontOfSize:14.0f];
    _userNameLabel.textColor =UIColorFromRGB(0x333333);
    [_headerView addSubview:_userNameLabel];
    
    _mainQuestionLabel =[UILabel new];
    _mainQuestionLabel.font =[UIFont systemFontOfSize:14.0f];
    _mainQuestionLabel.textColor =UIColorFromRGB(0x333333);
    _mainQuestionLabel.numberOfLines =0;
    [_headerView addSubview:_mainQuestionLabel];
    
    _haveImageBgView =[[UIView alloc]init];
    
    [_headerView addSubview:_haveImageBgView];
    
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
    
    _docIcon =[UIImageView new];
    _docIcon.layer.masksToBounds = YES;
    _docIcon.layer.cornerRadius = 25;
    [_headerView addSubview:_docIcon];
    
    _mainVoiceBtn = [UIButton new];
    [_mainVoiceBtn setBackgroundImage:[UIImage imageNamed:@"icon_vioce"] forState:UIControlStateNormal];
    [_mainVoiceBtn setTitle:@"播放" forState:UIControlStateNormal];
    _mainVoiceBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [_headerView addSubview:_mainVoiceBtn];
    [_mainVoiceBtn addTarget:self action:@selector(mainVoiceAction) forControlEvents:UIControlEventTouchUpInside];
    
    _mainVoiceTimeLabel =[UILabel new];
    _mainVoiceTimeLabel.font =[UIFont boldSystemFontOfSize:14.0f];
    _mainVoiceTimeLabel.textColor =UIColorFromRGB(0x666666);
    [_headerView addSubview:_mainVoiceTimeLabel];
    
    _wordBackView = [UIView  new];
    _wordBackView.backgroundColor = [UIColor  clearColor];
    [_headerView  addSubview:_wordBackView];
    
    
    _wordContentBtn = [UIButton  new];
    _wordContentBtn.selected = YES;
    _wordContentBtn.backgroundColor = [UIColor  clearColor];
    [_wordContentBtn setImage:[UIImage  imageNamed:@"WordContent_Close"] forState:UIControlStateNormal];
    
    [_wordContentBtn  setImage:[UIImage  imageNamed:@"WordContent_Open"] forState:UIControlStateSelected];
    
    //
    [_wordContentBtn  addTarget:self action:@selector(WordContentClick:) forControlEvents:UIControlEventAllEvents];
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
    
    _mainDateLabel =[UILabel new];
    _mainDateLabel.font =[UIFont boldSystemFontOfSize:12.0f];
    _mainDateLabel.textColor =UIColorFromRGB(0x999999);
    [_headerView addSubview:_mainDateLabel];
    
    _mainHeartLabel =[UILabel new];
    _mainHeartLabel.font =[UIFont boldSystemFontOfSize:12.0f];
    _mainHeartLabel.textColor =UIColorFromRGB(0x999999);
    [_headerView addSubview:_mainHeartLabel];
    
    _line =[UIView new];
    _line.backgroundColor =UIColorFromRGB(0xf2f2f2);
    [_headerView addSubview:_line];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.presenter.relatedAnswerDataSource.count<2) {
        
        return 0;

    }else{
        return self.presenter.relatedAnswerDataSource.count-1;

    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID0 = @"cell0";
    static NSString *cellID1 = @"cell1";
    static NSString *cellID2 = @"cell2";
    static NSString *cellID3 = @"cell3";
    static NSString *cellID4 = @"cell4";
    static NSString *cellID5 = @"cell5";
    static NSString *cellID6 = @"cell6";
    
//    RelatedAnswerCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    RelatedAnswerCell* cell ;

    RelatedAnswerEntity *preQuestion =[self.presenter.relatedAnswerDataSource objectAtIndex:indexPath.row+1];
    preQuestion.traceNO =indexPath.row+1;
    
    cell.cellEntity =preQuestion;
    
    if (!cell.delegate) {
        cell.delegate =self;
    }
    
    
    if ((preQuestion.Image1==nil)|[preQuestion.Image1 isEqualToString:@""]) {
        
        cell = [_table dequeueReusableCellWithIdentifier:cellID0];
        
        if (cell==nil) {
            cell = [[RelatedAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID0];
            cell.delegate = self;
        }
        
        RelatedAnswerEntity *preQuestion =[self.presenter.relatedAnswerDataSource objectAtIndex:indexPath.row+1];
        preQuestion.traceNO =indexPath.row+1;
        
        cell.cellEntity =preQuestion;
        
        cell.haveImageBgView.sd_layout.widthIs(0).heightIs(0);
        
        
    }else {
        
        if ((preQuestion.Image1!=nil&&preQuestion.Image1.length!=0)&&((preQuestion.Image2==nil)|[preQuestion.Image2 isEqualToString:@""])&&((preQuestion.Image3==nil)|[preQuestion.Image3 isEqualToString:@""])&&((preQuestion.Image4==nil)|[preQuestion.Image4 isEqualToString:@""])&&((preQuestion.Image5==nil)|[preQuestion.Image5 isEqualToString:@""])&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""])) {
            
            cell = [_table dequeueReusableCellWithIdentifier:cellID1];
            cell.delegate = self;
            
            if (cell==nil) {
                cell = [[RelatedAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
                cell.delegate = self;
            }
            RelatedAnswerEntity *preQuestion =[self.presenter.relatedAnswerDataSource objectAtIndex:indexPath.row+1];
            preQuestion.traceNO =indexPath.row+1;
            
            cell.cellEntity =preQuestion;
            
        }else if ((preQuestion.Image2!=nil&&preQuestion.Image2.length!=0)&&((preQuestion.Image3==nil)|[preQuestion.Image3 isEqualToString:@""])&&((preQuestion.Image4==nil)|[preQuestion.Image4 isEqualToString:@""])&&((preQuestion.Image5==nil)|[preQuestion.Image5 isEqualToString:@""])&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""])){
            
            cell = [_table dequeueReusableCellWithIdentifier:cellID2];
            cell.delegate = self;
            
            if (cell==nil) {
                cell = [[RelatedAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
                cell.delegate = self;
            }
            RelatedAnswerEntity *preQuestion =[self.presenter.relatedAnswerDataSource objectAtIndex:indexPath.row+1];
            preQuestion.traceNO =indexPath.row+1;
            
            cell.cellEntity =preQuestion;
        }else if ((preQuestion.Image3!=nil&&preQuestion.Image3.length!=0)&&((preQuestion.Image4==nil)|[preQuestion.Image4 isEqualToString:@""])&&((preQuestion.Image5==nil)|[preQuestion.Image5 isEqualToString:@""])&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""])){
            
            cell = [_table dequeueReusableCellWithIdentifier:cellID3];
            cell.delegate = self;
            
            if (cell==nil) {
                cell = [[RelatedAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3];
                cell.delegate = self;
            }
            RelatedAnswerEntity *preQuestion =[self.presenter.relatedAnswerDataSource objectAtIndex:indexPath.row+1];
            preQuestion.traceNO =indexPath.row+1;
            
            cell.cellEntity =preQuestion;
            
        }else if ((preQuestion.Image4!=nil&&preQuestion.Image4.length!=0)&&((preQuestion.Image5==nil)|[preQuestion.Image5 isEqualToString:@""])&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""])){
            cell = [_table dequeueReusableCellWithIdentifier:cellID4];
            cell.delegate = self;
            
            if (cell==nil) {
                cell = [[RelatedAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID4];
                cell.delegate = self;
            }
            RelatedAnswerEntity *preQuestion =[self.presenter.relatedAnswerDataSource objectAtIndex:indexPath.row+1];
            preQuestion.traceNO =indexPath.row+1;
            
            cell.cellEntity =preQuestion;
            
        }else if ((preQuestion.Image5!=nil&&preQuestion.Image5.length!=0)&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""])){
            
            cell = [_table dequeueReusableCellWithIdentifier:cellID5];
            cell.delegate = self;
            
            if (cell==nil) {
                cell = [[RelatedAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID5];
                cell.delegate = self;
            }
            RelatedAnswerEntity *preQuestion =[self.presenter.relatedAnswerDataSource objectAtIndex:indexPath.row+1];
            preQuestion.traceNO =indexPath.row+1;
            
            cell.cellEntity =preQuestion;
            
        }else{
            cell = [_table dequeueReusableCellWithIdentifier:cellID6];
            cell.delegate = self;
            
            if (cell==nil) {
                cell = [[RelatedAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID6];
                cell.delegate = self;
            }
            RelatedAnswerEntity *preQuestion =[self.presenter.relatedAnswerDataSource objectAtIndex:indexPath.row+1];
            preQuestion.traceNO =indexPath.row+1;
            
            cell.cellEntity =preQuestion;
            
        }

    }
    
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = tableView;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RelatedAnswerEntity *cellEntiy =[self.presenter.relatedAnswerDataSource objectAtIndex:indexPath.row+1];
//    if (!(cellEntiy.Image1!=nil&&cellEntiy.Image1.length>4&&(![cellEntiy.Image1 isEqualToString:@""]))) {
//        
//        return [_table cellHeightForIndexPath:indexPath model:cellEntiy keyPath:@"cellEntity" cellClass:[RelatedAnswerCell class] contentViewWidth:[self cellContentViewWith]];
//        
//    }
    return [_table cellHeightForIndexPath:indexPath model:cellEntiy keyPath:@"cellEntity" cellClass:[RelatedAnswerCell class] contentViewWidth:[self cellContentViewWith]];
    
    
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = kScreenWidth;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (void)getdocfullanwerconsultationSuccess{
    [ProgressUtil dismiss];

    if (_presenter.relatedAnswerDataSource.count==0) {
        return;
    }
    RelatedAnswerEntity *firstEntiy =[_presenter.relatedAnswerDataSource firstObject];
    [_userIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.UserImage]] placeholderImage:[UIImage  imageNamed:@"my_answer"]];
    _userNameLabel.text =firstEntiy.UserName;
    _mainQuestionLabel.text =firstEntiy.ConsultationContent;
   
    
    _haveImageBgView.sd_layout.leftSpaceToView(_headerView,10).topSpaceToView(_mainQuestionLabel,0).widthIs(kScreenWidth - 20).heightIs(kImageWidth+17.5);
    _leftImageView.sd_layout.topSpaceToView(_haveImageBgView,17.5).leftSpaceToView(_haveImageBgView,10).widthIs(kImageWidth).heightIs(kImageWidth);
    _midImageView.sd_layout.topSpaceToView(_haveImageBgView,17.5).leftSpaceToView(_haveImageBgView,kImageWidth+kImageXspace).widthIs(kImageWidth).heightIs(kImageWidth);
    _rightImageView.sd_layout.topSpaceToView(_haveImageBgView,17.5).leftSpaceToView(_haveImageBgView,kImageWidth*2+kImageXspace*2).widthIs(kImageWidth).heightIs(kImageWidth);
    _leftImageView1.sd_layout.leftEqualToView(_leftImageView).topSpaceToView(_haveImageBgView,kImageWidth+17.5+kImageTopspace).widthIs(kImageWidth).heightEqualToWidth();
    _midImageView1.sd_layout.leftEqualToView(_midImageView).topEqualToView(_leftImageView1).widthIs(kImageWidth).heightEqualToWidth();
    _rightImageView1.sd_layout.leftEqualToView(_rightImageView).topEqualToView(_leftImageView1).widthIs(kImageWidth).heightIs(kImageWidth);
    
    
    if (firstEntiy.Image1!=nil&&firstEntiy.Image1.length>4&&(![firstEntiy.Image1 isEqualToString:@""])) {
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image1]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
        if (firstEntiy.Image2!=nil&&firstEntiy.Image2.length>4&&(![firstEntiy.Image2 isEqualToString:@""])) {
            
            [_midImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image2]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
            if (firstEntiy.Image3!=nil&&firstEntiy.Image3.length>4&&(![firstEntiy.Image3 isEqualToString:@""])) {
                
                [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image3]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                if (firstEntiy.Image4!=nil&&firstEntiy.Image4.length>4&&(![firstEntiy.Image4 isEqualToString:@""])) {
                    
                    _haveImageBgView.sd_layout.leftSpaceToView(_headerView,10).topSpaceToView(_mainQuestionLabel,0).widthIs(kScreenWidth - 20).heightIs(kImageWidth+17.5+kImageWidth+kImageTopspace);
                    
                    [_leftImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image4]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                    
                    if ((firstEntiy.Image5!=nil&&firstEntiy.Image5.length>4&&(![firstEntiy.Image5 isEqualToString:@""]))) {
                        
                        [_midImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image5]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                        
                        if ((firstEntiy.Image6!=nil&&firstEntiy.Image6.length>4&&(![firstEntiy.Image6 isEqualToString:@""]))) {
                            
                            _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1,_midImageView1,_rightImageView1];
                            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image5],[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image6]];
                            
                            [_rightImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image6]] placeholderImage:[UIImage imageNamed:@"HEaddimage"] ];
                            
                        }else{
                            // 5
                            _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1,_midImageView1];
                            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image4],[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image5]];
                            _rightImageView1.hidden = YES;
                        }
                        
                    }else{
                        // 4
                        _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView,_leftImageView1];
                        _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image3],[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image4]];
                        _rightImageView1.hidden = YES;
                        _midImageView1.hidden = YES;
                    }
                    
                }else{
                    // 3
                    _photoBrowserArr =@[_leftImageView,_midImageView,_rightImageView];
                    _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image2],[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image3]];
                    _rightImageView1.hidden = YES;
                    _midImageView1.hidden = YES;
                    _leftImageView1.hidden = YES;
                }
                
            }else {
                // 2
                _photoBrowserArr =@[_leftImageView,_midImageView];
                _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image1],[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image2]];
                _rightImageView.hidden =YES;
                _rightImageView1.hidden = YES;
                _midImageView1.hidden = YES;
                _leftImageView1.hidden = YES;
            }
        }else{
            // 1
            _photoBrowserArr =@[_leftImageView];
            _photoBrowserUrlArr =@[[NSString stringWithFormat:@"%@%@",ICON_URL,firstEntiy.Image1]];
            _midImageView.hidden =YES;
            _rightImageView.hidden =YES;
            _rightImageView1.hidden = YES;
            _midImageView1.hidden = YES;
            _leftImageView1.hidden = YES;
        }
        
    }else{
        _haveImageBgView.sd_layout.widthIs(0).heightIs(0);
        _haveImageBgView.hidden =YES;
    }
    
    
    
    _userIcon.sd_layout.topSpaceToView(_headerView,15).leftSpaceToView(_headerView,15).widthIs(30).heightIs(30);
    _userNameLabel.sd_layout.leftSpaceToView(_userIcon,5).centerYEqualToView(_userIcon).heightIs(18).widthIs(200);
    
    _mainQuestionLabel.sd_layout.leftSpaceToView(_headerView,15).topSpaceToView(_userIcon,15).rightSpaceToView(_headerView,15).autoHeightRatio(0);

    if (_haveImageBgView.height == 0) {
        
        _docIcon.sd_layout.leftSpaceToView(_headerView,15).topSpaceToView(_mainQuestionLabel,10).widthIs(50).heightIs(50);
        
    }else if (_haveImageBgView.height ==kImageWidth +17.5 ){
        
        _docIcon.sd_layout.leftSpaceToView(_headerView,15).topSpaceToView(_mainQuestionLabel,10+kImageWidth+17.5).widthIs(50).heightIs(50);
    }else{
        
        _docIcon.sd_layout.leftSpaceToView(_headerView,15).topSpaceToView(_mainQuestionLabel,10+17.5+kImageWidth*2+kImageTopspace).widthIs(50).heightIs(50);
    }
    
    
    _mainVoiceBtn.sd_layout.leftSpaceToView(_docIcon,5).centerYEqualToView(_docIcon).heightIs(30).widthIs(120);
    _mainVoiceTimeLabel.sd_layout.leftSpaceToView(_mainVoiceBtn,5).centerYEqualToView(_mainVoiceBtn).heightIs(18).widthIs(80);
    
    
    _wordBackView.sd_layout.topSpaceToView(_docIcon,30/2).leftSpaceToView(_docIcon,0).rightSpaceToView(_headerView,30/2);
    
    
    _wordContentBtn.sd_layout.topSpaceToView(_wordBackView,0).leftSpaceToView(_wordBackView,5).widthIs(154/2).heightIs(16);
    
    _wordContentView.sd_layout.topSpaceToView(_wordContentBtn,20/2).leftEqualToView(_wordBackView).rightEqualToView(_wordBackView);
    
    _wordContentMessage.sd_layout.topSpaceToView(_wordContentView,20/2).leftSpaceToView(_wordContentView,20/2).rightSpaceToView(_wordContentView,20/2).autoHeightRatio(0);
    
    [_wordContentView setupAutoHeightWithBottomView:_wordContentMessage bottomMargin:20/2];
    
    [_wordBackView  setupAutoHeightWithBottomView:_wordContentBtn bottomMargin:0];
    
    
    _mainDateLabel.sd_layout.leftSpaceToView(_headerView,15).topSpaceToView(_wordBackView,15).heightIs(18).widthIs(80);
    _mainHeartLabel.sd_layout.leftSpaceToView(_mainDateLabel,5).centerYEqualToView(_mainDateLabel).heightIs(18).widthIs(80);
    _line.sd_layout.leftSpaceToView(_headerView,15).rightSpaceToView(_headerView,15).topSpaceToView(_mainDateLabel,5).heightIs(1);
    
    
    
    [_headerView setupAutoHeightWithBottomView:_line bottomMargin:0];
    NSLog(@"image urel -- is %@",firstEntiy.ImageUrl);
    [_docIcon sd_setImageWithURL:[NSURL URLWithString:firstEntiy.ImageUrl] placeholderImage:[UIImage  imageNamed:@"doctor_defaul"]];
    if (firstEntiy.VoiceTime!=nil&&[firstEntiy.VoiceTime stringValue].length!=0&&![[firstEntiy.VoiceTime stringValue] isEqualToString:@"0"]) {
        _mainVoiceTimeLabel.text =[NSString stringWithFormat:@"%@''",firstEntiy.VoiceTime];
    }
    
    _wordContentMessage.text =firstEntiy.WordContent;
    if (firstEntiy.WordContent.length ==0||[firstEntiy.WordContent isEqualToString:@""]||firstEntiy.WordContent==nil) {
        _wordBackView.hidden =YES;
        _mainDateLabel.sd_layout.leftSpaceToView(_headerView,15).topSpaceToView(_docIcon,15).heightIs(18).widthIs(80);
        [_wordBackView  setupAutoHeightWithBottomView:_wordContentBtn bottomMargin:0];
        
    }else{
        _wordBackView.hidden =NO;
        _mainDateLabel.sd_layout.leftSpaceToView(_headerView,15).topSpaceToView(_wordBackView,15).heightIs(18).widthIs(80);
        [_wordBackView  setupAutoHeightWithBottomView:_wordContentView bottomMargin:0];
        
    }
    
    //    _mainDateLabel.text =[NSDate getDateCompare:firstEntiy.CreateTime];
    _mainDateLabel.text = firstEntiy.CreateTime;
    
    if (firstEntiy.HearCount==nil||[firstEntiy.HearCount integerValue]==0) {
        _mainHeartLabel.text =@"听过0";
    }else{
        _mainHeartLabel.text =[NSString stringWithFormat:@"听过%@",firstEntiy.HearCount];
    }
    if (firstEntiy.VoiceUrl.length == 0 || [firstEntiy.VoiceUrl isKindOfClass:[NSNull class]]||[firstEntiy.ConsultationStatus integerValue]==0) {
        [_mainVoiceBtn setTitle:@"去回答" forState:UIControlStateNormal];
    }else{
        [_mainVoiceBtn setTitle:@"播放" forState:UIControlStateNormal];
        
    }
    
    _table.tableHeaderView =_headerView;
    [_headerView updateLayout];
    
    [_headerView layoutSubviews];
    [_table setTableHeaderView:_headerView];
    [_table reloadData];
    
    
}

-(void)WordContentClick:(UIButton*)btn{
    RelatedAnswerEntity *firstEntiy =[_presenter.relatedAnswerDataSource firstObject];
    if (btn.selected == NO) {
        if (firstEntiy.WordContent.length ==0||[firstEntiy.WordContent isEqualToString:@""]||firstEntiy.WordContent==nil) {
            _wordContentView.hidden =YES;
            [_wordBackView  setupAutoHeightWithBottomView:_wordContentBtn bottomMargin:0];
        }else{
            _wordContentView.hidden =NO;
            [_wordBackView  setupAutoHeightWithBottomView:_wordContentView bottomMargin:0];
        }
        
        btn.selected = YES;
        [_headerView layoutSubviews];
        [_table setTableHeaderView:_headerView];

        
    }else{
        _wordContentView.hidden = YES;
        [_wordBackView  setupAutoHeightWithBottomView:_wordContentBtn bottomMargin:0];
        btn.selected = NO;

        [_headerView layoutSubviews];
        [_table setTableHeaderView:_headerView];

    }
    
}

- (void)playVoiceByCell:(RelatedAnswerCell *)cell{
    
    if ([cell.cellEntity.ConsultationStatus integerValue]==0) {
        
        AwaitAnswerViewController *vc = [AwaitAnswerViewController new];
        MyAnserEntity *answer =[MyAnserEntity new];
        answer.consultationContent = cell.cellEntity.ConsultationContent;
        vc.uuid = [cell.cellEntity.uuid integerValue];
        answer.uuid = [cell.cellEntity.uuid stringValue];
        answer.voiceUrl =cell.cellEntity.VoiceUrl;
        answer.hearCount =[cell.cellEntity.HearCount integerValue];
        answer.consultationStatus =[cell.cellEntity.ConsultationStatus integerValue];
        answer.doctorName =cell.cellEntity.DoctorName;
        answer.introduce =cell.cellEntity.Introduce;
        
        answer.imageUrl =cell.cellEntity.ImageUrl;
        answer.createTime =cell.cellEntity.CreateTime;
        answer.userName =cell.cellEntity.UserName;
        answer.Image1 =cell.cellEntity.Image1;
        answer.Image2 =cell.cellEntity.Image2;
        answer.Image3 =cell.cellEntity.Image3;
        answer.Image4 = cell.cellEntity.Image4;
        answer.Image5 = cell.cellEntity.Image5;
        answer.Image6 = cell.cellEntity.Image6;
        answer.IsOpenImage =cell.cellEntity.IsOpenImage;
        answer.answerType =[cell.cellEntity.type integerValue];
        answer.TraceID =[cell.cellEntity.TraceID integerValue];
        vc.MyAnswerEntity =answer;
        vc.WaitAnswer = 1;
        [self.navigationController pushViewController:vc animated:YES];

        
    }else{
    
    
        if (cell.cellEntity.VoiceUrl.length == 0 || [cell.cellEntity.VoiceUrl isKindOfClass:[NSNull class]]) {
            NSLog(@"无语音文件");
            return;
        }
        
        
        
        if (_presenter.isPlaying == NO) {
            _presenter.url =cell.cellEntity.VoiceUrl;
            _presenter.playingType =@"1";
            _presenter.playingCell =cell;
            [_presenter play:^(BOOL success) {
                if (success == YES) {
                    [cell.voiceBtn setTitle:@"正在播放" forState:UIControlStateNormal];
                    _presenter.isPlaying = YES;
                }else{
                    [cell.voiceBtn setTitle:@"播放失败" forState:UIControlStateNormal];
                    _presenter.isPlaying = NO;
                    
                }
            }];
        }else{
            [_presenter stop];
            _presenter.isPlaying = NO;
            if ([_presenter.playingType isEqualToString:@"1"]) {
                [cell.voiceBtn setTitle:@"播放" forState:UIControlStateNormal];
                _presenter.playingCell.voiceTimeLabel.text  =[NSString stringWithFormat:@"%@''",_presenter.playingCell.cellEntity.VoiceTime];
            }else{
                [_mainVoiceBtn setTitle:@"播放" forState:UIControlStateNormal];
                _mainVoiceTimeLabel.text =[NSString stringWithFormat:@"%@''",[_presenter.relatedAnswerDataSource firstObject].VoiceTime];
                _presenter.url =cell.cellEntity.VoiceUrl;
                _presenter.playingType =@"1";
                _presenter.playingCell =cell;
                [_presenter play:^(BOOL success) {
                    if (success == YES) {
                        [cell.voiceBtn setTitle:@"正在播放" forState:UIControlStateNormal];
                        _presenter.isPlaying = YES;
                    }else{
                        [cell.voiceBtn setTitle:@"播放失败" forState:UIControlStateNormal];
                        _presenter.isPlaying = NO;
                        
                    }
                }];
            }
            
            
        }
    }
}

- (void)mainVoiceAction{
    
    RelatedAnswerEntity *firstEntiy =[_presenter.relatedAnswerDataSource firstObject];
    
    if ([firstEntiy.ConsultationStatus integerValue]==0) {
        AwaitAnswerViewController *vc = [AwaitAnswerViewController new];
        MyAnserEntity *answer =[MyAnserEntity new];
        answer.consultationContent = firstEntiy.ConsultationContent;
        vc.uuid = [firstEntiy.uuid integerValue];
        answer.uuid = [firstEntiy.uuid stringValue];
        answer.voiceUrl =firstEntiy.VoiceUrl;
        answer.hearCount =[firstEntiy.HearCount integerValue];
        answer.consultationStatus =[firstEntiy.ConsultationStatus integerValue];
        answer.doctorName =firstEntiy.DoctorName;
        answer.introduce =firstEntiy.Introduce;
        
        answer.imageUrl =firstEntiy.ImageUrl;
        answer.createTime =firstEntiy.CreateTime;
        answer.userName =firstEntiy.UserName;
        answer.Image1 =firstEntiy.Image1;
        answer.Image2 =firstEntiy.Image2;
        answer.Image3 =firstEntiy.Image3;
        answer.Image4 = firstEntiy.Image4;
        answer.Image5 = firstEntiy.Image5;
        answer.Image6 = firstEntiy.Image6;
        answer.IsOpenImage =firstEntiy.IsOpenImage;
        answer.answerType =[firstEntiy.type integerValue];
        answer.TraceID =[firstEntiy.TraceID integerValue];
        vc.MyAnswerEntity =answer;
        vc.WaitAnswer = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
    
    
    
    if (firstEntiy.VoiceUrl.length == 0 || [firstEntiy.VoiceUrl isKindOfClass:[NSNull class]]) {
        NSLog(@"无语音文件");
        return;
    }
    
    
    if (_presenter.isPlaying == NO) {
        _presenter.url =firstEntiy.VoiceUrl;
        _presenter.playingType =@"0";
        [_presenter play:^(BOOL success) {
            if (success == YES) {
                [_mainVoiceBtn setTitle:@"正在播放" forState:UIControlStateNormal];
                _presenter.isPlaying = YES;
            }else{
                [_mainVoiceBtn setTitle:@"播放失败" forState:UIControlStateNormal];
                _presenter.isPlaying = NO;
                
            }
        }];
    }else{
        [_presenter stop];
        _presenter.isPlaying = NO;
        if ([_presenter.playingType isEqualToString:@"1"]) {
            [_presenter.playingCell.voiceBtn setTitle:@"播放" forState:UIControlStateNormal];
            _presenter.playingCell.voiceTimeLabel.text  =[NSString stringWithFormat:@"%@''",_presenter.playingCell.cellEntity.VoiceTime];
            _presenter.url =firstEntiy.VoiceUrl;
            _presenter.playingType =@"0";
            [_presenter play:^(BOOL success) {
                if (success == YES) {
                    [_mainVoiceBtn setTitle:@"正在播放" forState:UIControlStateNormal];
                    _presenter.isPlaying = YES;
                }else{
                    [_mainVoiceBtn setTitle:@"播放失败" forState:UIControlStateNormal];
                    _presenter.isPlaying = NO;
                    
                }
            }];
            
        }else{
            [_mainVoiceBtn setTitle:@"播放" forState:UIControlStateNormal];
            _mainVoiceTimeLabel.text =[NSString stringWithFormat:@"%@''",[_presenter.relatedAnswerDataSource firstObject].VoiceTime];
        }
        
    }
    }
}
//- (void)playFinished{
//    if ([_presenter.playingType isEqualToString:@"1"]) {
//        [_presenter stop];
//        _presenter.isPlaying = NO;
//        [_presenter.playingCell.voiceBtn setTitle:@"播放" forState:UIControlStateNormal];
//        _presenter.playingCell.voiceTimeLabel.text  =[NSString stringWithFormat:@"%@''",_presenter.playingCell.cellEntity.VoiceTime];
//        
//    }else{
//        [_presenter stop];
//        _presenter.isPlaying = NO;
//        [_mainVoiceBtn setTitle:@"播放" forState:UIControlStateNormal];
//        _mainVoiceTimeLabel.text =[NSString stringWithFormat:@"%@''",[_presenter.relatedAnswerDataSource firstObject].VoiceTime];
//    }
//}
- (void)second:(NSString *)second{
    NSLog(@"%@",second);
    if ([_presenter.playingType isEqualToString:@"1"]) {
        if ([second integerValue]>[_presenter.playingCell.cellEntity.VoiceTime integerValue]||second ==nil||[second isEqualToString:@""]||second.length ==0) {
            [_presenter.playingCell.voiceBtn setTitle:@"播放" forState:UIControlStateNormal];
            _presenter.playingCell.voiceTimeLabel.text  =[NSString stringWithFormat:@"%@''",_presenter.playingCell.cellEntity.VoiceTime];
            [_presenter stop];
            _presenter.isPlaying = NO;
            [_presenter.timer invalidate];
            _presenter.timer = nil;
            [_player playerStop];
            _player.delegate = nil;
            
        }else{
            _presenter.playingCell.voiceTimeLabel.text =[NSString stringWithFormat:@"%@''",second];
        }
    }else{
        if ([second integerValue]>[[_presenter.relatedAnswerDataSource firstObject].VoiceTime integerValue]||second ==nil||[second isEqualToString:@""]||second.length ==0) {
            [_mainVoiceBtn setTitle:@"播放" forState:UIControlStateNormal];
            _mainVoiceTimeLabel.text =[NSString stringWithFormat:@"%@''",[_presenter.relatedAnswerDataSource firstObject].VoiceTime];
            [_presenter stop];
            _presenter.isPlaying = NO;
            [_presenter.timer invalidate];
            _presenter.timer = nil;
            [_player playerStop];
            _player.delegate = nil;
        }else{
            _mainVoiceTimeLabel.text = [NSString stringWithFormat:@"%@''",second];
        }
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

-(void)dealloc{
    
    [_player playerStop];
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
