//
//  SearchQuestionViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/8/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//
#define SearchColor RGB(0, 0, 0)

#import "SearchQuestionViewController.h"
#import "UIImage+Category.h"
#import "HEAParentQuestionTableViewCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "JMFoundation.h"
#import "AliPayUtil.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import "VoiceConverter.h"
#import "AVRecorderPlayerManager.h"
#import "VoiceConvertUtile.h"
#import "CorePhotoPickerVCManager.h"
#import "UIView+ViewController.h"
#import "SearchQuestionPresenter.h"
#import "HotDetailViewController.h"
#import "SearchHistoryTableViewCell.h"
#import "UITableView+FDIndexPathHeightCache.h"
#import "HotDetailConsulationViewController.h"
#import "HotDetailPresenter.h"
#import "HotQuestionViewController.h"


static NSString* const paySuccessKeyPath = @"orderPaySuccess";//付款成功
static NSString* const addConsultationPath = @"addConsultation";//添加咨询
static NSString* const laodConsultationPath = @"laodConsultation";//获取咨询
static NSString* const addListenPath = @"addListen";//添加偷听


@interface SearchQuestionViewController ()<UITableViewDelegate,UITableViewDataSource,SearchQuestionPresenterDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,PraiseDelegate>{
    CGPoint pointAdd;
    CGPoint pointReduce;
    //    UIView* headerView;
    CGFloat  downlbFont;
    UIImageView* _tableHeaderImageView;
    UIView *appraiseView ;
    UIButton *_rightButton;
    UIView    *_NoSearchView;
    NSMutableArray  *_historyArray;
    NSMutableArray  *_hISArray;
}

@property(nonatomic,strong) UITextField *SearchTextField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SearchQuestionPresenter *presenter;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property(nonatomic,retain) NSMutableDictionary* stateDic;//语音按钮状态字典

@property(nonatomic,retain) NSIndexPath* currentIndexPath;
@property(nonatomic,retain) UIButton* currentSelectButton;
@property(nonatomic) CGFloat listenPrice;//偷听价格
@property(nonatomic,retain) HEAParentQuestionEntity* currentQuestion;

@property(nonatomic,retain) UIActivityIndicatorView* indicator;
@property(nonatomic) BOOL isListenType;//偷听
@property(nonatomic) BOOL isReloadAllData;//刷新全部数据
@property(nonatomic,retain) NSIndexPath* saveIndexPath;
@property(nonatomic,retain) UIButton* saveSelectButton;
@property(nonatomic, strong)UIImageView *downImageView;
@property(nonatomic, strong)UIButton *BulletinBtn;
@property(nonatomic, strong)UILabel *downLb;
@property(nonatomic, assign)BOOL   down;

@property(nonatomic,retain) UIView *uploadImageView;
@property(nonatomic,retain) UIView *HaveImageView;

@property(nonatomic,retain) NSMutableArray *uploadImageArr;
@property(nonatomic,retain) UIButton *privateImageBtn;
@property(nonatomic,retain) UIButton *addImageBtn;
@property(nonatomic,retain) NSMutableArray *upImageViewArr;
@property(nonatomic,assign) BOOL isDoctor;

@property (nonatomic, assign) CGFloat price;

@property(nonatomic,retain) UITableView* SearchHostoryTable;

@end

@implementation SearchQuestionViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    _historyArray = [NSMutableArray  new];
    [self  setHeardView];
    [kdefaultCenter addObserver:self selector:@selector(refreshSearhList) name:Notification_HotSearch object:nil];
}
-(void)setHeardView{
    _SearchTextField = [UITextField  new];
    _SearchTextField.frame  = CGRectMake(0, 0, 512/2, 60/2);
    _SearchTextField.font = [UIFont systemFontOfSize:15];
    _SearchTextField.textColor = UIColorFromRGB(0x333333);
    _SearchTextField.placeholder = @"请输入您想了解的问题";
    // 提前在Xcode上设置图片中间拉伸
    _SearchTextField.background = [UIImage imageNamed:@"searchbar_textfield_background"];
    _SearchTextField.returnKeyType = UIReturnKeySearch;
    _SearchTextField.delegate = self;
    
    UIButton *searchIcon = [UIButton  new];
    [searchIcon  setImage:[UIImage  imageNamed:@"searchbar_textfield_search_icon"] forState:UIControlStateNormal];
    searchIcon.contentMode = UIViewContentModeCenter;
    searchIcon.frame = CGRectMake(0, 0, 30, 39/2);
    [searchIcon  setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    _SearchTextField.leftView = searchIcon;
    _SearchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _SearchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.navigationItem.titleView  = _SearchTextField;
   
    _SearchTextField.tintColor= [UIColor lightGrayColor];
    //搜索框
    _rightButton = [UIButton new];
    _rightButton.titleLabel.font = [UIFont  systemFontOfSize:17];
    [_rightButton  setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
    
    [_rightButton setTitle:@"搜索" forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(RightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    _rightButton.frame = CGRectMake(0, 0,[JMFoundation  calLabelWidth:_rightButton.titleLabel] , 17);
    _rightButton.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
  //没有搜索内容view
    _NoSearchView = [UIView  new];
    _NoSearchView.backgroundColor = [UIColor  whiteColor];
    [self.view  addSubview: _NoSearchView];
    
    UILabel  *NoSearchLb = [UILabel  new];
    NoSearchLb.text = @"没有搜索到答案呦！~ 快去向专家提问吧";
    NoSearchLb.textAlignment = NSTextAlignmentCenter;
    NoSearchLb.font = [UIFont  systemFontOfSize:17];
    NoSearchLb.textColor = UIColorFromRGB(0x999999);
    NoSearchLb.numberOfLines = 2;
    [_NoSearchView  addSubview:NoSearchLb];
    
    _NoSearchView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    NoSearchLb.sd_layout.centerXEqualToView(_NoSearchView).centerYEqualToView(_NoSearchView).autoHeightRatio(0).widthIs(kFitWidthScale(375*2));
}
-(void)RightButton
{
    if([_SearchTextField isFirstResponder]){
        [_SearchTextField resignFirstResponder];
    }

    _SearchHostoryTable.hidden = YES;
    _presenter.SearchName =  _SearchTextField.text;
    NSLog(@"搜索：%@", _SearchTextField.text);
    if([_SearchTextField.text  isEqualToString:@""]){
     [ProgressUtil  showInfo:@"请输入您要搜索的内容"];
    
    }else{
        [_historyArray  addObject:_presenter.SearchName];
        
        
        WS(ws);
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        }];
//        [_tableView.mj_header beginRefreshing];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            ws.tableView.userInteractionEnabled = NO;
            [ws.presenter loadMoreSearchQuestion:^(BOOL success, NSString *message) {
                ws.tableView.userInteractionEnabled = YES;
                if (success == YES) {
                    [ws.dataSource addObjectsFromArray:ws.presenter.dataSource];
                    [ws.tableView reloadData];
                    if (ws.presenter.dataSource.count == 0) {
                        [ws.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [ws.tableView.mj_footer endRefreshing];
                    }
                }else{
                    [ProgressUtil showError:message];
                }
            }];
        }];
        
//        [_tableView.mj_header beginRefreshing];
        [self loadData];
        
    }
    
#pragma 打点统计*咨询专家-->搜索
    
    [BasePresenter  EventStatisticalDotTitle:DotExpertConsulationSearch Action:DotEventEnter  Remark:_SearchTextField.text];

    
}

-(void)setupView{
    
    _presenter = [SearchQuestionPresenter new];
    _presenter.delegate = self;
    _dataSource = [NSMutableArray array];
    _price = 1.f;
    
    _tableView = [UITableView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;

    _tableView.tag =1001;
    [self.view addSubview:_tableView];
    


//        _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _tableView.sd_layout.topSpaceToView(self.view,0).leftSpaceToView(self.view ,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    
    
    NSUserDefaults  *user = [NSUserDefaults  standardUserDefaults];

 NSArray *selectArray = [NSArray  arrayWithArray:[user   objectForKey:[NSString stringWithFormat:@"%dRemberrHistory",kCurrentUser.userId]]];
    _hISArray = [NSMutableArray  new];
    if(selectArray.count>=5){
    NSArray  *deleArray =[selectArray subarrayWithRange:NSMakeRange(0, 5)];
        [_hISArray  addObjectsFromArray:deleArray];
    }else{
     [_hISArray  addObjectsFromArray:selectArray];
    }
    NSLog(@"显示的array：%@",_hISArray);
    _SearchHostoryTable = [UITableView new];
    _SearchHostoryTable.dataSource = self;
    _SearchHostoryTable.delegate = self;
    _SearchHostoryTable.backgroundColor = [UIColor clearColor];
    _SearchHostoryTable.tag =1002;
    _SearchHostoryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [ _SearchHostoryTable  setSeparatorColor:[UIColor  blackColor]];
    [self.view addSubview:_SearchHostoryTable];
   _SearchHostoryTable.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1001) {
        return _dataSource.count;
    }else{
    
     return _hISArray.count;
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{
    if (tableView.tag == 1002) {
        return 40;
    }else{
        return 0;
        
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 1002) {
        return @"搜索历史";
    }else{
        return nil;
        
    }
}
//设置透视图字体颜色和背景
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setTextColor:UIColorFromRGB(0x999999)];
    footer.textLabel.font = [UIFont  systemFontOfSize:14];
    view.tintColor = UIColorFromRGB(0xf2f2f2);
}
//设置系统cell的字体颜色和背景
- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath

{
    if(tableView.tag == 1002){
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor  clearColor];
        cell.textLabel.textColor = UIColorFromRGB(0x666666);
        cell.textLabel.font = [UIFont  systemFontOfSize:16];
    }else{
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID0 = @"cell0";
    static NSString *cellID1 = @"cell1";
    static NSString *cellID2 = @"cell2";
    static NSString *cellID3 = @"cell3";
    static NSString *cellID4 = @"cell4";
    static NSString *cellID5 = @"cell5";
    static NSString *cellID6 = @"cell6";
    static NSString *historyID = @"history";
    
   if (tableView.tag == 1001) {
        HEAParentQuestionEntity *preQuestion =[self.dataSource objectAtIndex:indexPath.row];
        HEAParentQuestionTableViewCell* cell;
       /*
        if (![preQuestion.IsOpenImage boolValue]) {
            cell = [_tableView dequeueReusableCellWithIdentifier:cellID0];
            
            if (cell==nil) {
                cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID0];
                
            }
            
            cell.question = [self.dataSource objectAtIndex:indexPath.row];
            
            cell.HaveImageView.sd_layout.widthIs(0).heightIs(0);
            
            
            
        }else{
            if ((preQuestion.Image1==nil)|[preQuestion.Image1 isEqualToString:@""]) {
                
                cell = [_tableView dequeueReusableCellWithIdentifier:cellID0];
                
                if (cell==nil) {
                    cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID0];
                    
                    
                }
                
                cell.question = [self.dataSource objectAtIndex:indexPath.row];
                cell.HaveImageView.sd_layout.widthIs(0).heightIs(0);
                
                
                
                
            }else {
                if ((preQuestion.Image1!=nil&&preQuestion.Image1.length!=0)&&((preQuestion.Image2==nil)|[preQuestion.Image2 isEqualToString:@""])&&((preQuestion.Image3==nil)|[preQuestion.Image3 isEqualToString:@""])) {
                    
                    cell = [_tableView dequeueReusableCellWithIdentifier:cellID1];
                    
                    if (cell==nil) {
                        cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
                        
                    }
                    
                    cell.question = [self.dataSource objectAtIndex:indexPath.row];
                    
                    
                }else if((preQuestion.Image2!=nil&&preQuestion.Image2.length!=0)&&((preQuestion.Image3==nil)|[preQuestion.Image3 isEqualToString:@""])){
                    
                    cell = [_tableView dequeueReusableCellWithIdentifier:cellID2];
                    
                    if (cell==nil) {
                        cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
                        
                    }
                    
                    
                    
                    cell.question = [self.dataSource objectAtIndex:indexPath.row];
                    
                }else {
                    cell = [_tableView dequeueReusableCellWithIdentifier:cellID3];
                    
                    if (cell==nil) {
                        cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3];
                        
                    }
                    
                    cell.question = [self.dataSource objectAtIndex:indexPath.row];
                    
                    
                    
                }
            }}
        */
       
       if (![preQuestion.IsOpenImage boolValue]) {
           cell = [_tableView dequeueReusableCellWithIdentifier:cellID0];
           
           if (cell==nil) {
               cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID0];
               
           }
           
           cell.question = [self.dataSource objectAtIndex:indexPath.row];
           
           cell.HaveImageView.sd_layout.widthIs(0).heightIs(0);
           
           
           
       }else{
           if ((preQuestion.Image1==nil)|[preQuestion.Image1 isEqualToString:@""]) {
               
               cell = [_tableView dequeueReusableCellWithIdentifier:cellID0];
               
               if (cell==nil) {
                   cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID0];
                   
                   
               }
               
               cell.question = [self.dataSource objectAtIndex:indexPath.row];
               cell.HaveImageView.sd_layout.widthIs(0).heightIs(0);
               
               
               
               
           }else {
               
               
               
               
               
               if ((preQuestion.Image1!=nil&&preQuestion.Image1.length!=0)&&((preQuestion.Image2==nil)|[preQuestion.Image2 isEqualToString:@""])&&((preQuestion.Image3==nil)|[preQuestion.Image3 isEqualToString:@""])&&((preQuestion.Image4==nil)|[preQuestion.Image4 isEqualToString:@""])&&((preQuestion.Image5==nil)|[preQuestion.Image5 isEqualToString:@""])&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""])) {
                   //一张图片
                   cell = [_tableView dequeueReusableCellWithIdentifier:cellID1];
                   
                   if (cell==nil) {
                       cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
                       
                   }
                   
                   cell.question = [self.dataSource objectAtIndex:indexPath.row];
                   
                   
               }
               
               else if((preQuestion.Image2!=nil&&preQuestion.Image2.length!=0)&&((preQuestion.Image3==nil)|[preQuestion.Image3 isEqualToString:@""])&&((preQuestion.Image4==nil)|[preQuestion.Image4 isEqualToString:@""])&&((preQuestion.Image5==nil)|[preQuestion.Image5 isEqualToString:@""])&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""])){
                   //2张图片
                   
                   cell = [_tableView dequeueReusableCellWithIdentifier:cellID2];
                   
                   if (cell==nil) {
                       cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
                       
                   }
                   
                   
                   
                   cell.question = [self.dataSource objectAtIndex:indexPath.row];
                   
               }
               
               else if((preQuestion.Image3!=nil&&preQuestion.Image3.length!=0)&&((preQuestion.Image4==nil)|[preQuestion.Image4 isEqualToString:@""])&&((preQuestion.Image5==nil)|[preQuestion.Image5 isEqualToString:@""])&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""])){
                   //3张图片
                   
                   cell = [_tableView dequeueReusableCellWithIdentifier:cellID3];
                   
                   if (cell==nil) {
                       cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3];
                       
                   }
                   
                   
                   
                   cell.question = [self.dataSource objectAtIndex:indexPath.row];
                   
               }
               
               else if((preQuestion.Image4!=nil&&preQuestion.Image4.length!=0)&&((preQuestion.Image5==nil)|[preQuestion.Image5 isEqualToString:@""])&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""])){
                   //4张图片
                   
                   cell = [_tableView dequeueReusableCellWithIdentifier:cellID4];
                   
                   if (cell==nil) {
                       cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID4];
                       
                   }
                   
                   
                   
                   cell.question = [self.dataSource objectAtIndex:indexPath.row];
                   
               }
               
               
               
               else if((preQuestion.Image5!=nil&&preQuestion.Image5.length!=0)&&((preQuestion.Image6==nil)|[preQuestion.Image6 isEqualToString:@""])){
                   //5张图片
                   
                   cell = [_tableView dequeueReusableCellWithIdentifier:cellID5];
                   
                   if (cell==nil) {
                       cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID5];
                       
                   }
                   
                   
                   
                   cell.question = [self.dataSource objectAtIndex:indexPath.row];
                   
               } else {
                   cell = [_tableView dequeueReusableCellWithIdentifier:cellID6];
                   
                   if (cell==nil) {
                       cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID6];
                       
                   }
                   
                   cell.question = [self.dataSource objectAtIndex:indexPath.row];
                   
                   
                   
               }
           }}

       
       
        NSNumber* isSelect = (NSNumber*)[self.stateDic objectForKey:@(indexPath.row)];
        cell.isSelect = [isSelect intValue];
        //            if (self.expertEntity.price==0) {
        //                cell.isFree =YES;
        //
        //            }
        HEAParentQuestionEntity* model = [self.dataSource objectAtIndex:indexPath.row];
        if ([[NSString  stringWithFormat:@"%@",model.IsFree]  isEqualToString:@"1"]) {
            cell.isFreeQusetion =YES;
        }else{
            cell.isFreeQusetion = NO;
        }
        
        WS(ws);
        __weak typeof(cell) weakCell = cell;
        [cell clickAudionButtonOnCompletion:^(UIButton *bt) {
            HEAParentQuestionEntity* question = [ws.dataSource objectAtIndex:indexPath.row];
            NSArray* result = [question.voiceUrl componentsSeparatedByString:@"/"];
            if(question.isListen|cell.isFreeQusetion|self.isDoctor){
                
                //已经偷听过了
                if([NSString fileIsExist:[result lastObject]]){
                    //语音文件存在
                    NSURL* audioURL = [NSString getAudioURL:[result lastObject]];
                    if(!bt.selected){
                        [[AVRecorderPlayerManager sharedManager] playerAudio:audioURL completionHandler:^(AVAudioPlayer *player) {
                            NSLog(@"播放完成");
                            [ws.stateDic setObject:@0 forKey:@(indexPath.row)];
                            [ws.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            player = nil;
                        }];
                    }
                    [ws.stateDic setObject:@1 forKey:@(indexPath.row)];
                    
                    if(ws.currentIndexPath && [ws.currentIndexPath isEqual:indexPath]){
                        //点击了同一个cell,播放／暂停
                        if(bt.selected){
                            NSLog(@"停止");
                            [[AVRecorderPlayerManager sharedManager] pause];
                            [ws.stateDic setObject:@0 forKey:@(indexPath.row)];
                        }
                    }else{
                        //点击不同cell
                        if(ws.currentIndexPath && [(NSNumber*)[ws.stateDic objectForKey:@(ws.currentIndexPath.row)] intValue]){
                            //清除上次按钮选中状态，暂停上次播放语音
                            [ws.stateDic setObject:@0 forKey:@(ws.currentIndexPath.row)];
                        }
                    }
                    ws.currentIndexPath = indexPath;
                    ws.currentSelectButton = bt;
                    [ws.tableView reloadData];
                }else{
                    //语音文件不存在，下载
                    if( ws.currentIndexPath && [(NSNumber*)[ws.stateDic objectForKey:@(ws.currentIndexPath.row)] intValue]){
                        //清除上次按钮选中状态,停止上次播放
                        [[AVRecorderPlayerManager sharedManager] pause];
                        [ws.stateDic setObject:@0 forKey:@(ws.currentIndexPath.row)];
                        [ws.tableView reloadRowsAtIndexPaths:@[ws.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                    
                    [ws.stateDic setObject:@1 forKey:@(indexPath.row)];
                    
                    ws.isReloadAllData = YES;
                    
                    if(ws.saveIndexPath || ws.saveSelectButton){
                        ws.saveIndexPath = nil;
                        ws.saveSelectButton = nil;
                    }
                    
                    ws.saveIndexPath = indexPath;
                    ws.saveSelectButton = bt;
                    ws.indicator = weakCell.activityIndicator;
                    
                    [weakCell.activityIndicator startAnimating];
                    
                    [ws.presenter downloadAudioFile:question.voiceUrl];
                }
                if (cell.isFreeQusetion) {
                    [_presenter  FreeListeningCountWithConsultationID:question.uuID];
                    NSLog(@"打印uuid：%d",question.uuID);
                }
            }else{
                //未偷听，跳到支付页面
                NSLog(@"未偷听，请先支付");
                
                ws.currentIndexPath = indexPath;
                ws.currentSelectButton = bt;
                ws.indicator = weakCell.activityIndicator;
                
                ws.currentQuestion = question;
                ws.isListenType = YES;
                
                if([kDefaultsUser valueForKey:[NSString stringWithFormat:@"%ld",question.uuID]] && [kDefaultsUser valueForkey:@"listenOrderID"]){
                    //处理支付成功，但是走订单支付接口失败
                    NSString *orderID = [kDefaultsUser valueForkey:@"orderID"];
                    
                    [ws.indicator startAnimating];
                    [ws.presenter tradePaySuccessWithOrderID:orderID];
                    
                }else if([kDefaultsUser valueForKey:[NSString stringWithFormat:@"%ld",question.uuID]] && [kDefaultsUser valueForkey:addListenPath]){
                    //处理支付成功，订单支付接口成功，但是添加偷听失败
                    if(ws.listenPrice == 0){
                        //                    ws.listenPrice = ws.expertEntity.price;
                        ws.listenPrice = _price;//test
                    }
                    
                    [ws.indicator startAnimating];
                    [ws.presenter addListenQuestion:ws.currentQuestion withListenPrice:ws.listenPrice];
                    
                }else{
                    //选择支付方式
                    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:ws cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝", nil];
                    sheet.tag = 1001;
                    [sheet showInView:ws.view];
                }
                
            }
        }];
        
        cell.sd_indexPath = indexPath;
        cell.sd_tableView = _tableView;
        cell.searchDelegate = self;
        cell.delegate = self;
        return cell;
       
   }else{
       
       SearchHistoryTableViewCell* historyCell = [tableView dequeueReusableCellWithIdentifier:historyID];
       if (historyCell==nil) {
           historyCell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:historyID];
           
       }
       
       historyCell.textLabel.text =[_hISArray objectAtIndex:indexPath.row];
       UILabel  *lineLb = [UILabel  new];
       lineLb.backgroundColor = UIColorFromRGB(0xf2f2f2);
       [historyCell addSubview:lineLb];
       
    lineLb.sd_layout.topSpaceToView(historyCell.textLabel,0).leftSpaceToView(historyCell,0).widthIs(kScreenWidth).heightIs(1);
       
       //右侧删除按钮
       UIButton  *deletBtn = [UIButton  new];
       deletBtn.frame = CGRectMake(0, 0, 60, 36);
     [deletBtn setImage:[UIImage imageNamed:@"delete_history"] forState:UIControlStateNormal];
       [deletBtn  setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -40)];
       [deletBtn addTarget:self action:@selector(myBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
       historyCell.accessoryView = deletBtn;

       return historyCell;
   }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1001) {
        HEAParentQuestionEntity* question = [self.dataSource objectAtIndex:indexPath.row];
        return [_tableView cellHeightForIndexPath:indexPath model:question keyPath:@"question" cellClass:[HEAParentQuestionTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }else{
    
        return  36;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 1001) {
        [[AVRecorderPlayerManager sharedManager] stop];
        [self.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
//        [tableView reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//        HotDetailViewController *vc = [HotDetailViewController new];
        HotDetailConsulationViewController  *vc = [HotDetailConsulationViewController  new];
        HEAParentQuestionEntity *question = self.dataSource[indexPath.row];
      vc.UUID = [NSNumber  numberWithInteger:question.uuID];
//        vc.row = [NSNumber numberWithInteger:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        _SearchTextField.text =  [_hISArray objectAtIndex:indexPath.row];
        _presenter.SearchName =  _SearchTextField.text;
        _SearchHostoryTable.hidden = YES;
        _tableView.hidden = NO;
         [_historyArray  addObject:_presenter.SearchName];
        WS(ws);
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [ProgressUtil showWithStatus:@"搜索中，请稍等"];
            ws.tableView.userInteractionEnabled = NO;
            [ws.presenter refreshSearchQuestion:^(BOOL success, NSString *message) {
//                [ws.tableView.mj_header endRefreshing];
//                [ws.tableView.mj_footer endRefreshing];
                ws.tableView.userInteractionEnabled = YES;
                if (success == YES) {
                    [ProgressUtil dismiss];
                    [ws.dataSource removeAllObjects];
                    [ws.dataSource addObjectsFromArray:ws.presenter.dataSource];
                    if (ws.dataSource.count == 0) {
                        _tableView.hidden = YES;
                        _NoSearchView.hidden = NO;
                        
                    }else{
                        _tableView.hidden = NO;
                        _NoSearchView.hidden = YES;
                    }
                    [ws.tableView reloadData];
                }else{
                    [ProgressUtil showError:message];
                }
            }];
//        }];
//        [_tableView.mj_header beginRefreshing];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            ws.tableView.userInteractionEnabled = NO;
            [ws.presenter loadMoreSearchQuestion:^(BOOL success, NSString *message) {
                ws.tableView.userInteractionEnabled = YES;
                if (success == YES) {
                    [ws.dataSource addObjectsFromArray:ws.presenter.dataSource];
                    [ws.tableView reloadData];
                    if (ws.presenter.dataSource.count == 0) {
                        [ws.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [ws.tableView.mj_footer endRefreshing];
                    }
                }else{
                    [ProgressUtil showError:message];
                }
            }];
        }];
        
//        [_tableView.mj_header beginRefreshing];
#pragma 打点统计*咨询专家-->搜索
        
[BasePresenter  EventStatisticalDotTitle:DotExpertConsulationSearch Action:DotEventEnter  Remark:_presenter.SearchName];
   
    }

}

-(void)myBtnClick:(id)sender event:(id)event

{
    
    NSSet *touches = [event allTouches];   // 把触摸的事件放到集合里
    UITouch *touch = [touches anyObject];   //把事件放到触摸的对象了
    CGPoint currentTouchPosition = [touch locationInView:_SearchHostoryTable]; //把触发的这个点转成二位坐标
    NSIndexPath *indexPath = [_SearchHostoryTable indexPathForRowAtPoint:currentTouchPosition]; //匹配坐标点
    if(indexPath !=nil){
        
        [self tableView:_SearchHostoryTable accessoryButtonTappedForRowWithIndexPath:indexPath];
        
    }
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //先删数据
    [_hISArray  removeObjectAtIndex:[indexPath row]];
    
    [_SearchHostoryTable  reloadData];
    
    if (_hISArray.count==0) {
        _SearchHostoryTable.hidden = YES;
    }
    
}
#pragma mark---限时免费计数回调
- (void)onFreeListeningCountCompletion:(BOOL) success info:(NSString*) messsage{
             if (success) {
                 NSLog(@"计数成功");
             }else{
                 
                 [ProgressUtil  showError:messsage];
                 
             }
         }

#pragma mark private

- (void)showSheet {
    WS(ws);
    if([[[UIDevice currentDevice] systemVersion] floatValue]  >= 8.0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *uploadPhotos = [UIAlertAction actionWithTitle:@"上传照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"上传照片");
            [ws pickPhoto];
        }];
        
        UIAlertAction *uploadPhotosByCamera = [UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"拍照上传");
            [ws takePhoto];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:uploadPhotos];
        [alert addAction:uploadPhotosByCamera];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"上传照片", @"拍照上传", nil];
        sheet.tag =1009;
        [sheet showInView:self.view];
        
    }
    
}

-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

-(void)pickPhoto{
    WS(ws);
    
    _uploadImageArr =nil;
    
    CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager new];
    
    //设置类型
    manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeMultiPhoto;
    
    //最多可选3张
    manager.maxSelectedPhotoNumber = 3;
    
    //错误处理
    if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
        NSLog(@"设备不可用");
        return;
    }
    
    UIViewController *pickerVC=manager.imagePickerController;
    
    //选取结束
    manager.finishPickingMedia=^(NSArray *medias){
        [ProgressUtil show];
        //        runOnBackground(^{
        //            [medias enumerateObjectsUsingBlock:^(CorePhoto *photo, NSUInteger idx, BOOL *stop) {
        //                //                NSString * path = [photo.editedImage saveToLocal];
        //                //                [ws.urls addObject:path];
        //
        //            }];
        runOnMainThread(^{
            //                [ws resetImageView];
            
            [ProgressUtil dismiss];
            
            //            NSLog(@"%d", medias.count);
            
            for (CorePhoto *photo in medias) {
                
                NSLog(@"%@", photo);
                
                [self.uploadImageArr addObject:photo.editedImage];
                
            }
            //            NSLog(@"%d", _uploadImageArr.count);
            if (_uploadImageArr.count!=0) {
                _uploadImageView.hidden =YES;
                _HaveImageView.hidden =NO;
                
                
                if (_uploadImageArr.count!=3) {
                    
                    for (int i = (int )_uploadImageArr.count; i<3; i++) {
                        if (_upImageViewArr[i]) {
                            UIImageView *photoImagees =(UIImageView *)(_upImageViewArr[i]);
                            photoImagees.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,(_uploadImageArr.count)*70).widthIs(0).heightIs(50);
                        }
                        
                        
                    }
                    for (int i =1; i <_uploadImageArr.count+1; i++) {
                        if (_upImageViewArr[i-1]) {
                            UIImageView *photoImageetsss =(UIImageView *)(_upImageViewArr[i-1]);
                            photoImageetsss.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,(i-1)*70).widthIs(50).heightIs(50);
                        }
                    }
                }else {
                    for (int i =1; i<=_uploadImageArr.count; i++) {
                        if (_upImageViewArr[i-1]) {
                            UIImageView *photoImagee =(UIImageView *)(_upImageViewArr[i-1]);
                            photoImagee.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,(i-1)*70).widthIs(50).heightIs(50);
                        }
                        
                    }
                    
                }
                
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新
                for (int i =0; i<_uploadImageArr.count; i++) {
                    if (_upImageViewArr[i]) {
                        UIImageView *photoImagess =(UIImageView *)(_upImageViewArr[i]);
                        photoImagess.image =_uploadImageArr[i];
                    }
                    
                }
                
                [ws.view updateLayout];
                
                
            });
            
            
        });
        //        });
        
    };
    
    [ws presentViewController:pickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    WS(ws);
    if (_uploadImageArr.count ==3) {
        _uploadImageArr =nil;
    }
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断获取类型：图片
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [self.uploadImageArr addObject:image];
        
    }
    
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        _uploadImageView.hidden =YES;
        _HaveImageView.hidden =NO;
        
        
        if (_uploadImageArr.count!=3) {
            
            for (int i =(int )_uploadImageArr.count; i<3; i++) {
                if (_upImageViewArr[i]) {
                    UIImageView *photoImagees =(UIImageView *)(_upImageViewArr[i]);
                    photoImagees.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,((_uploadImageArr.count)*70)).widthIs(0).heightIs(0);
                }
                
            }
            for (int i =1; i <_uploadImageArr.count+1; i++) {
                if (_upImageViewArr[i-1]) {
                    UIImageView *photoImageesss =(UIImageView *)(_upImageViewArr[i-1]);
                    photoImageesss.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,(i-1)*70).widthIs(50).heightIs(50);
                }
            }
        }else {
            for (int i =1; i<=_uploadImageArr.count; i++) {
                if (_upImageViewArr[i-1]) {
                    UIImageView *photoImagee =(UIImageView *)(_upImageViewArr[i-1]);
                    photoImagee.sd_layout.centerYEqualToView(_HaveImageView).leftSpaceToView(_HaveImageView,(i-1)*70).widthIs(50).heightIs(50);
                }
                
            }
            
        }
        
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //回调或者说是通知主线程刷新
        for (int i =0; i<_uploadImageArr.count; i++) {
            if (_upImageViewArr[i]) {
                UIImageView *photoImageess =(UIImageView *)(_upImageViewArr[i]);
                photoImageess.image =(UIImage *)_uploadImageArr[i];
            }
            
        }
        
        [ws.view updateLayout];
        
        
    });
    NSLog(@"%ld ==",_uploadImageArr.count);
    
    
    //    [self uploadData];
    
}
- (void)loadData{
    WS(ws);
//    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [ProgressUtil showWithStatus:@"搜索中，请稍等"];
    self.tableView.userInteractionEnabled = NO;
    [self.presenter refreshSearchQuestion:^(BOOL success, NSString *message) {
//        [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
        ws.tableView.userInteractionEnabled = YES;
        if (success == YES) {
            [ProgressUtil dismiss];
            [ws.dataSource removeAllObjects];
            [ws.dataSource addObjectsFromArray:ws.presenter.dataSource];
            if (ws.dataSource.count == 0) {
                _tableView.hidden = YES;
                _NoSearchView.hidden = NO;
                
            }else{
                _tableView.hidden = NO;
                _NoSearchView.hidden = YES;
            }
            [ws.tableView reloadData];
        }else{
            [ProgressUtil showError:message];
        }
    }];
}

- (void)openUploadPrivate:(UIButton *)btn{
    btn.selected =!btn.selected;
}

#pragma mark Delegate

-(void)listenOnCompletion:(BOOL)success info:(NSString *)message{
//    if(success){
        NSLog(@"添加偷听成功");
        //添加偷听成功，下载语音开始播放
        HEAParentQuestionEntity* question = self.dataSource[self.currentIndexPath.row];
        question.hearCount ++;
        question.isListen = 1;//已经偷听
        
        [self.stateDic setObject:@1 forKey:@(self.currentIndexPath.row)];
        
        //        [self.indicator startAnimating];
        
        [self.presenter downloadAudioFile:question.voiceUrl];
        
//    }else{
//        if(self.isListenType){
//            self.isListenType = NO;
//            [self.indicator stopAnimating];
//        }
//        
//        [kDefaultsUser saveValue:[NSNumber numberWithBool:YES] withKeyPath:[NSString stringWithFormat:@"%ld",self.currentQuestion.uuID]];
//        [kDefaultsUser saveValue:[NSNumber numberWithBool:YES] withKeyPath:addListenPath];
//        
//        //        [ProgressUtil showError:message];
//    }
}

-(void)tradeIDOnCompletion:(BOOL)success info:(NSString *)message{
    [ProgressUtil dismiss];
    if(success){
        //获取订单号成功
        NSLog(@"订单号==%@",self.presenter.orderID);
        //走支付宝接口
        NSString* orderID = [NSString stringWithFormat:@"%.@",self.presenter.orderID];
        CGFloat price = _price;
        
        NSString* title = @"提问支付";
        if([self.presenter.bussinessType isEqualToString:@"listenBiz"]){
            title = @"偷听支付";
            price = _price;//偷听价格
            self.listenPrice = price;
        }
        //        price = 0.01;//test
        
        WS(ws);
        NSDictionary *parameters = @{@"Expert_ID":@(self.currentQuestion.expertID),@"ConsultationID":@(self.currentQuestion.uuID),@"UserID":@(kCurrentUser.userId),@"Price":[NSString stringWithFormat:@"%.f",1.f],@"OrderID":[NSString stringWithFormat:@"%.@",self.presenter.orderID]};
        [[FPNetwork POST:API_INSERT_LISTEN_QUESTION_RECORDS withParams:parameters] addCompleteHandler:^(FPResponse *response) {
            if (response.success == YES) {
                [ws pay:orderID price:price title:title];
            }else{
                [ProgressUtil showError:response.message];
            }
        }];
    }else{
        [ProgressUtil showError:message];
    }
}

- (void)pay:(NSString *)orderID price:(CGFloat)price title:(NSString *)title{
    WS(ws);
    [AliPayUtil payWithTitle:title withDetail:@"详情" withOrderNum:orderID withPrice:price callback:^(NSDictionary*dict){
        //支付成功调用，订单支付成功接口，并且调用插入咨询表的接口
        NSString* payStatus = dict[@"resultStatus"];
        if([payStatus isEqualToString:@"9000"]){
            NSLog(@"支付成功");
            [ProgressUtil showSuccess:@"付款成功"];
            if(ws.isListenType){
                [ws.indicator startAnimating];
            }
            [ws.presenter tradePaySuccessWithOrderID:ws.presenter.orderID];
            
            
        }else if([payStatus isEqualToString:@"6001"]){
            NSLog(@"用户中途取消支付");
            [ProgressUtil showInfo:@"用户取消支付"];
        }else if([payStatus isEqualToString:@"6002"]){
            NSLog(@"网络连接出错");
            [ProgressUtil showInfo:@"网络连接出错"];
        }else if([payStatus isEqualToString:@"4000"]){
            NSLog(@"订单支付失败");
            [ProgressUtil showInfo:@"订单支付失败"];
        }else{
            NSLog(@"正在处理中");
        }
        
    }];
    
}


-(void)paySuccessOnCompletion:(BOOL)success info:(NSString *)message{
    if(success){
        if([self.presenter.bussinessType isEqualToString:@"questionBiz"]){
            //咨询
            [self.presenter uploadPhoto:_uploadImageArr];
            
            //            [self.presenter addExpertConsultation:_textView.text doctorID:self.expertEntity.doctorID photo:[NSArray array]];
        }else if([self.presenter.bussinessType isEqualToString:@"listenBiz"]){
            //偷听
            [self.presenter addListenQuestion:self.currentQuestion withListenPrice:self.listenPrice];
        }
    }else{
        if(self.isListenType){
            //---偷听－－－－
            self.isListenType = NO;
            [self.indicator stopAnimating];
            
            [kDefaultsUser saveValue:[NSNumber numberWithBool:YES] withKeyPath:[NSString stringWithFormat:@"%ld",self.currentQuestion.uuID]];
            //保存偷听订单号到本地
            [kDefaultsUser saveValue:self.presenter.orderID withKeyPath:@"listenOrderID"];
        }else{
            //－－－－咨询－－－－－
            //保存支付失败状态，下次跳过支付宝/微信支付，直接走支付成功接口
            [kDefaultsUser saveValue:[NSNumber numberWithBool:YES] withKeyPath:paySuccessKeyPath];
            //保存订单号到本地
            [kDefaultsUser saveValue:self.presenter.orderID withKeyPath:@"orderID"];
        }
        
        
        
        [ProgressUtil showError:message];
    }
}

-(void)downloadOnCompletion:(BOOL)success info:(NSString *)message{
    [self.indicator stopAnimating];
    if(success){
        WS(ws);
        //先转码，在播放
        NSString* downloadPath = [NSString getDownloadPath:self.presenter.voiceURL];
        NSArray* result = [self.presenter.voiceURL componentsSeparatedByString:@"/"];
        
        //文件名不带后缀
        NSString* fileName = [NSString getFileName:[result lastObject]];
        
        NSString *convertedPath = [VoiceConvertUtile GetPathByFileName:fileName ofType:@"wav"];
        //amr格式转wav格式
        if([VoiceConverter ConvertAmrToWav:downloadPath wavSavePath:convertedPath]){
            
            NSURL* audioURL = [NSString getAudioURL:[result lastObject]];
            [[AVRecorderPlayerManager sharedManager] playerAudio:audioURL completionHandler:^(AVAudioPlayer *player) {
                NSLog(@"播放完成");
                [ws.stateDic setObject:@0 forKey:@(ws.currentIndexPath.row)];
                [ws.tableView reloadData];
                player = nil;
            }];
            
        }else{
            //转码失败
            
        }
        
        if(self.isReloadAllData){
            self.isReloadAllData = NO;
            [self.tableView reloadData];
            self.currentIndexPath = self.saveIndexPath;
            self.currentSelectButton = self.saveSelectButton;
            
        }else{
            [self.tableView reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        //清除保存的订单id
        if([kDefaultsUser valueForkey:@"listenOrderID"]){
            //处理订单支付接口失败情况
            [kDefaultsUser removeValueWithKey:@"listenOrderID"];
            [kDefaultsUser removeValueWithKey:[NSString stringWithFormat:@"%ld",self.currentQuestion.uuID]];
        }
        if([kDefaultsUser valueForkey:addListenPath]){
            [kDefaultsUser removeValueWithKey:addListenPath];
            [kDefaultsUser removeValueWithKey:[NSString stringWithFormat:@"%ld",self.currentQuestion.uuID]];
        }
        
    }else{
        [ProgressUtil showError:message];
        
    }
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString* bussinessType = nil;
    if(actionSheet.tag == 1000){
        //咨询
        bussinessType = @"questionBiz";
        if(buttonIndex == 0){
            NSLog(@"支付宝支付");
            [ProgressUtil show];
            [self.presenter getTradeID:bussinessType withPrice:_price withPayType:@"alipay"];
            
        }else if (buttonIndex == 1){
            NSLog(@"取消");
        }
    }else if(actionSheet.tag == 1001){
        //偷听
        bussinessType = @"listenBiz";
        
        if(self.currentIndexPath && [(NSNumber*)[self.stateDic objectForKey:@(self.currentIndexPath.row)] intValue]){
            //清除上次按钮选中状态,停止上次播放
            [[AVRecorderPlayerManager sharedManager] pause];
            [self.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
            [self.tableView reloadData];
        }
        if(buttonIndex == 0){
            NSLog(@"支付宝支付");
            [ProgressUtil show];
            [self.presenter getTradeID:bussinessType withPrice:1.f withPayType:@"alipay"];
            
        }else if (buttonIndex == 1){
            NSLog(@"取消");
        }
        
    }else if (actionSheet.tag ==1008){
        
        if(buttonIndex == 0){
            NSLog(@"确定");
            [self.presenter uploadPhoto:_uploadImageArr];
            
            
            //            [self.presenter addExpertConsultation:_textView.text doctorID:self.expertEntity.doctorID photo:[NSArray array]];
        }else if (buttonIndex == 1){
            NSLog(@"取消");
        }
    }else if (actionSheet.tag ==1009){
        
        if (buttonIndex == 0) {
            NSLog(@"上传照片");
            [self pickPhoto];
        }else if (buttonIndex == 1) {
            NSLog(@"拍照上传");
            [self takePhoto];
        }else if (buttonIndex == 2) {
            NSLog(@"取消");
        }
        
    }
    
}
#pragma mark 赞
- (void)praiseAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点赞");
    HotDetailPresenter *presenter = [HotDetailPresenter new];
    NSString *consulationID = [NSString stringWithFormat:@"%ld",(long)((HEAParentQuestionEntity *)self.dataSource[indexPath.row]).uuID];
    WS(ws);
    [presenter praise:consulationID success:^(BOOL success, NSString *message) {
        if (success == YES) {
            ((HEAParentQuestionEntity *)ws.dataSource[indexPath.row]).isPraise = [NSNumber numberWithInteger:1];
            ((HEAParentQuestionEntity *)ws.dataSource[indexPath.row]).praiseCount++;
            [ws.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
              kCurrentUser.hotIsNeedReload = NO;
            //通知咨询页面刷新
            [kdefaultCenter postNotificationName:Notification_RefreshHotQuestion object:nil];
        }else{
            [ProgressUtil showError:@"点赞失败"];
        }
    }];
}
- (void)cancelPraiseAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"取消点赞");
    HotDetailPresenter *presenter = [HotDetailPresenter new];
    NSString *consulationID = [NSString stringWithFormat:@"%ld",(long)((HEAParentQuestionEntity *)self.dataSource[indexPath.row]).uuID];
    WS(ws);
    [presenter cancelPraise:consulationID success:^(BOOL success, NSString *message) {
        if (success == YES) {
            ((HEAParentQuestionEntity *)ws.dataSource[indexPath.row]).isPraise = [NSNumber numberWithInteger:0];
            ((HEAParentQuestionEntity *)ws.dataSource[indexPath.row]).praiseCount--;
            [ws.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            //通知咨询页面刷新
            [kdefaultCenter postNotificationName:Notification_RefreshHotQuestion object:nil];

            kCurrentUser.hotIsNeedReload = NO;
          
        }else{
            [ProgressUtil showError:@"取消点赞失败"];
        }
    }];
}
#pragma mark   refreshSearhList刷新页面通知
- (void)refreshSearhList{
    NSLog(@"刷新搜索页面");
//    [_tableView.mj_header  beginRefreshing];
    WS(ws);

    
    ws.tableView.userInteractionEnabled = NO;
    [ws.presenter refreshSearchQuestion:^(BOOL success, NSString *message) {
        //                [ws.tableView.mj_header endRefreshing];
        //                [ws.tableView.mj_footer endRefreshing];
        ws.tableView.userInteractionEnabled = YES;
        if (success == YES) {
            [ProgressUtil dismiss];
            [ws.dataSource removeAllObjects];
            [ws.dataSource addObjectsFromArray:ws.presenter.dataSource];
            if (ws.dataSource.count == 0) {
                _tableView.hidden = YES;
                _NoSearchView.hidden = NO;
                
            }else{
                _tableView.hidden = NO;
                _NoSearchView.hidden = YES;
            }
            [ws.tableView reloadData];
        }else{
            [ProgressUtil showError:message];
        }
    }];

    
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

#pragma mark - 懒加载

-(NSMutableDictionary *)stateDic{
    if(!_stateDic){
        _stateDic = [NSMutableDictionary dictionary];
    }
    return _stateDic;
}

- (NSMutableArray *)uploadImageArr{
    if (_uploadImageArr ==nil) {
        _uploadImageArr =[NSMutableArray array];
    }
    return _uploadImageArr;
}

- (NSMutableArray *)upImageViewArr{
    if (_upImageViewArr ==nil) {
        _upImageViewArr =[NSMutableArray array];
    }
    return _upImageViewArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"热门咨询搜索页面"];
    if ([_SearchTextField.text  isEqualToString:@""]) {
        [_SearchTextField becomeFirstResponder];
        
        _NoSearchView.hidden = YES;
        _tableView.hidden = YES;
        if (_hISArray.count!=0) {
            _SearchHostoryTable.hidden = NO;
        }else{
            _SearchHostoryTable.hidden = YES;
        }
    }else{
        
        
    }
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"热门咨询搜索页面"];
    if([_SearchTextField isFirstResponder]){
        [_SearchTextField resignFirstResponder];
    }

    //将记录的数据倒序排序
    NSArray* reversedArray = [[_historyArray reverseObjectEnumerator] allObjects];
     NSMutableArray   *resultArray = [NSMutableArray  new];
    if (_hISArray.count !=0) {
        
        [resultArray  addObjectsFromArray:reversedArray];
        [resultArray  addObjectsFromArray:_hISArray];

    }else{
      [resultArray  addObjectsFromArray:reversedArray];
    }
    NSLog(@"所有的数据：%@",resultArray);
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *string in resultArray) {
        if (![result containsObject:string]) {
            [result addObject:string];
        }
    }
    NSLog(@"去重的数据：%@",result);
    
    NSUserDefaults  *user = [NSUserDefaults  standardUserDefaults];
[user  setObject:result forKey:[NSString stringWithFormat:@"%dRemberrHistory",kCurrentUser.userId]];
    
//    
//    [kdefaultCenter removeObserver:self name:Notification_HotSearch object:nil];

}
-(void)dealloc{
    [kdefaultCenter removeObserver:self name:Notification_HotSearch object:nil];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{

  if([_SearchTextField isFirstResponder]){
    [_SearchTextField resignFirstResponder];
    }
        
    if ([_SearchTextField.text  isEqualToString:@""]) {
        [ProgressUtil  showInfo:@"请输入您要搜索的内容"];
    }else{
    _presenter.SearchName =  _SearchTextField.text;
    [_historyArray  addObject:_presenter.SearchName];
    _SearchHostoryTable.hidden = YES;
    _tableView.hidden = NO;
    WS(ws);
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ProgressUtil showWithStatus:@"搜索中，请稍等"];
        ws.tableView.userInteractionEnabled = NO;
        [ws.presenter refreshSearchQuestion:^(BOOL success, NSString *message) {
//            [ws.tableView.mj_header endRefreshing];
//            [ws.tableView.mj_footer endRefreshing];
            ws.tableView.userInteractionEnabled = YES;
            if (success == YES) {
                [ProgressUtil dismiss];
                [ws.dataSource removeAllObjects];
                [ws.dataSource addObjectsFromArray:ws.presenter.dataSource];
                if (ws.dataSource.count == 0) {
                    _tableView.hidden = YES;
                    _NoSearchView.hidden = NO;
                    
                }else{
                    _tableView.hidden = NO;
                    _NoSearchView.hidden = YES;
                }
                [ws.tableView reloadData];
            }else{
                [ProgressUtil showError:message];
            }
        }];
//    }];
//    [_tableView.mj_header beginRefreshing];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ws.tableView.userInteractionEnabled = NO;
        [ws.presenter loadMoreSearchQuestion:^(BOOL success, NSString *message) {
            ws.tableView.userInteractionEnabled = YES;
            if (success == YES) {
                [ws.dataSource addObjectsFromArray:ws.presenter.dataSource];
                [ws.tableView reloadData];
                if (ws.presenter.dataSource.count == 0) {
                    [ws.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [ws.tableView.mj_footer endRefreshing];
                }
            }else{
                [ProgressUtil showError:message];
            }
        }];
    }];
    
//    [_tableView.mj_header beginRefreshing];
    }
    return YES;
    
}

@end
