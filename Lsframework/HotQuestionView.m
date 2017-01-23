//
//  HotQuestionView.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/8/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HotQuestionView.h"
#import "HEAParentQuestionTableViewCell.h"
#import "HotPresenter.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "LCTextView.h"
#import "JMFoundation.h"
#import "AliPayUtil.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import "VoiceConverter.h"
#import "AVRecorderPlayerManager.h"
#import "VoiceConvertUtile.h"
#import "CorePhotoPickerVCManager.h"
#import "UIView+ViewController.h"
#import "HotQuestionViewController.h"
#import "HotDetailViewController.h"
#import "ExpertAndConsultationViewController.h"
#import "HotDetailConsulationViewController.h"
#import "WXApi.h"
#import "HotDetailPresenter.h"
#import "ChatViewController.h"
#import "GBhomeViewController.h"
static NSString* const paySuccessKeyPath = @"orderPaySuccess";//付款成功
static NSString* const addConsultationPath = @"addConsultation";//添加咨询
static NSString* const laodConsultationPath = @"laodConsultation";//获取咨询
static NSString* const addListenPath = @"addListen";//添加偷听

@interface HotQuestionView ()<UITableViewDelegate,UITableViewDataSource,HEAInfoPresenterDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,WXApiDelegate,PraiseDelegate>{
    CGPoint pointAdd;
    CGPoint pointReduce;
    UIView* headerView;
    CGFloat  downlbFont;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HotPresenter *presenter;
@property (nonatomic,strong) UIImageView *hotquestuinIV;
@property(nonatomic,retain) UIImageView* iconbgImageView;
@property(nonatomic,retain) UIImageView* doctorIcon;
@property(nonatomic,retain) UILabel* doctorName;
@property(nonatomic,retain) UIView* lineView;
@property(nonatomic,retain) UILabel* doctorTitle;
@property(nonatomic,retain) UILabel* doctorIntroduce;
@property(nonatomic,retain) UILabel* doctorField;
@property(nonatomic,retain) UILabel* questionTimes;
@property(nonatomic,retain) LCTextView* textView;
@property(nonatomic,retain) UILabel* moneyTips;
@property(nonatomic,retain) UILabel* pricenLabel;
@property(nonatomic,retain) UIButton* commitbt;
@property(nonatomic,retain) UIView* headerTitlebgView;
@property(nonatomic,retain) UILabel* titleTips;

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

@end

@implementation HotQuestionView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _presenter = [HotPresenter new];
        _presenter.delegate = self;
        _price = 1;
//        [kdefaultCenter addObserver:self selector:@selector(homeRefreshAction) name:Notification_HotIsLoad object:nil];
        

        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
//    _hotquestuinIV =[UIImageView new];
//    _hotquestuinIV.image =[UIImage imageNamed:@"hotquestionicon"];
//    [self addSubview:_hotquestuinIV];
//     _hotquestuinIV.sd_layout.leftSpaceToView(self,10).topSpaceToView(self,6).widthIs(27).heightIs(27);
    
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"热门咨询";
    _titleLabel.textColor = UIColorFromRGB(0x2dcbc4);
    [self addSubview:_titleLabel];
    _titleLabel.sd_layout.leftSpaceToView(self,15).topSpaceToView(self,12.5f).widthIs(80).heightIs(16);
    
    _moreButton = [UIButton new];
    [_moreButton setBackgroundImage:[UIImage imageNamed:@"Expert_MORE"] forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreButton];
    _moreButton.sd_layout.rightSpaceToView(self,15).heightIs(16).widthIs(62).centerYEqualToView(_titleLabel);
    
    _tableView = [UITableView new];
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    _tableView.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).topSpaceToView(_titleLabel,11.5f);
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _presenter.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID0 = @"cell0";
    static NSString *cellID1 = @"cell1";
    static NSString *cellID2 = @"cell2";
    static NSString *cellID3 = @"cell3";
    
    
    HEAParentQuestionEntity *preQuestion =[self.presenter.dataSource objectAtIndex:indexPath.row];
    
    HEAParentQuestionTableViewCell* cell;
    
    
    
    if (![preQuestion.IsOpenImage boolValue]) {
        cell = [_tableView dequeueReusableCellWithIdentifier:cellID0];
        
        if (cell==nil) {
            cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID0];
            
        }
        
        cell.question = [self.presenter.dataSource objectAtIndex:indexPath.row];
        
        cell.HaveImageView.sd_layout.widthIs(0).heightIs(0);
        
        
        
    }else{
        if ((preQuestion.Image1==nil)|[preQuestion.Image1 isEqualToString:@""]) {
            
            cell = [_tableView dequeueReusableCellWithIdentifier:cellID0];
            
            if (cell==nil) {
                cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID0];
                
                
            }
            
            
            cell.question = [self.presenter.dataSource objectAtIndex:indexPath.row];
            cell.HaveImageView.sd_layout.widthIs(0).heightIs(0);
            
            
            
            
        }else {
            if ((preQuestion.Image1!=nil&&preQuestion.Image1.length!=0)&&((preQuestion.Image2==nil)|[preQuestion.Image2 isEqualToString:@""])&&((preQuestion.Image3==nil)|[preQuestion.Image3 isEqualToString:@""])) {
                
                cell = [_tableView dequeueReusableCellWithIdentifier:cellID1];
                
                if (cell==nil) {
                    cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
                    
                }
                
                cell.question = [self.presenter.dataSource objectAtIndex:indexPath.row];
                
                
            }else if((preQuestion.Image2!=nil&&preQuestion.Image2.length!=0)&&((preQuestion.Image3==nil)|[preQuestion.Image3 isEqualToString:@""])){
                
                cell = [_tableView dequeueReusableCellWithIdentifier:cellID2];
                
                if (cell==nil) {
                    cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
                    
                }
                
                
                
                cell.question = [self.presenter.dataSource objectAtIndex:indexPath.row];
                
            }else {
                cell = [_tableView dequeueReusableCellWithIdentifier:cellID3];
                
                if (cell==nil) {
                    cell = [[HEAParentQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3];
                    
                }
                
                cell.question = [self.presenter.dataSource objectAtIndex:indexPath.row];
                
                
                
            }
        }}
    
    
    NSNumber* isSelect = (NSNumber*)[self.stateDic objectForKey:@(indexPath.row)];
    cell.isSelect = [isSelect intValue];
//    if (self.expertEntity.price==0) {
//        cell.isFree =YES;
//        
//    }
    
    HEAParentQuestionEntity* model = [self.presenter.dataSource objectAtIndex:indexPath.row];
    
    if ([[NSString  stringWithFormat:@"%@",model.IsFree]  isEqualToString:@"1"]) {
        cell.isFreeQusetion =YES;
    }else{
        cell.isFreeQusetion = NO;
    }

    WS(ws);
    __weak typeof(cell) weakCell = cell;
    [cell clickAudionButtonOnCompletion:^(UIButton *bt) {
        HEAParentQuestionEntity* question = [ws.presenter.dataSource objectAtIndex:indexPath.row];
        NSArray* result = [question.voiceUrl componentsSeparatedByString:@"/"];
        if(question.isListen|cell.isFree|cell.isFreeQusetion|self.isDoctor){
            
            if (cell.isFree) {
                [self.presenter addListenQuestion:question withListenPrice:0];
            }
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
            
            if (cell.isFreeQusetion&&!bt.selected) {
                [_presenter  FreeListeningCountWithConsultationID:question.uuID];
                NSLog(@"打印uuid：%ld",question.uuID);
                
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
                UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:ws cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
                sheet.tag = 1001;
                [sheet showInView:ws];
            }
            
        }
    }];
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = _tableView;
    cell.delegate = self;
    [cell changeStyle];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HEAParentQuestionEntity* question = [self.presenter.dataSource objectAtIndex:indexPath.row];
    return [_tableView cellHeightForIndexPath:indexPath model:question keyPath:@"question" cellClass:[HEAParentQuestionTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[AVRecorderPlayerManager sharedManager] stop];
    [self.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HEAParentQuestionEntity* question = [self.presenter.dataSource objectAtIndex:indexPath.row];
    HotDetailConsulationViewController  *vc = [HotDetailConsulationViewController  new];
   vc.UUID = [NSNumber  numberWithInteger:question.uuID];
//    vc.row = [NSNumber numberWithInteger:indexPath.row];
    [self.ViewController.navigationController pushViewController:vc animated:YES];
}

//加载数据
- (void)loadData:(Height)block{
    WS(ws);
    [_presenter loadHotQuestion:^(BOOL success, NSString *message) {
        if (success == YES) {
            //计算总高度
            CGFloat height = [ws totalHeight:ws.presenter.dataSource];
            ws.tableView.sd_layout.heightIs(height);
            [ws.tableView updateLayout];
            block(height);
            [ws.tableView reloadData];
        }else{
            [ProgressUtil showError:message];
            //无数据状态下
            CGFloat height = 37;
            ws.tableView.sd_layout.heightIs(height);
            [ws.tableView updateLayout];
            block(height);
            [ws.tableView reloadData];
        }
    }];
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
        [self.ViewController presentViewController:alert animated:YES completion:nil];
    }else {
        
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"上传照片", @"拍照上传", nil];
        sheet.tag =1009;
        [sheet showInView:self];
        
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
        [self.ViewController presentViewController:picker animated:YES completion:nil];
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
            
            NSLog(@"%d", medias.count);
            
            for (CorePhoto *photo in medias) {
                
                NSLog(@"%@", photo);
                
                [self.uploadImageArr addObject:photo.editedImage];
                
            }
            NSLog(@"%d", _uploadImageArr.count);
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
                
                [ws updateLayout];
                
                
            });
            
            
        });
        //        });
        
    };
    
    [ws.ViewController presentViewController:pickerVC animated:YES completion:nil];
    
    
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
        
        [ws updateLayout];
        
        
    });
    NSLog(@"%ld ==",_uploadImageArr.count);
    
    
    //    [self uploadData];
    
}


- (void)openUploadPrivate:(UIButton *)btn{
    btn.selected =!btn.selected;
}

#pragma mark Delegate

-(void)listenOnCompletion:(BOOL)success info:(NSString *)message{
//    if(success){
    
        //通知首页刷新
//        [self homeRefreshAction];
        
        NSLog(@"添加偷听成功");
        //添加偷听成功，下载语音开始播放
        HEAParentQuestionEntity* question = self.presenter.dataSource[self.currentIndexPath.row];
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
            [ProgressUtil show];
            
            NSLog(@"微信支付");
            [self.presenter weixinPayWithListenId:self.currentQuestion.uuID];
        }else if (buttonIndex == 2){
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


- (void)onCheckWXPayResultWithOderCompletion:(BOOL) success info:(NSString*) message Url:(NSString *)url{
    if (success) {
        //偷听
        self.currentQuestion.isListen = 1;//已经偷听
        
        [self.stateDic setObject:@1 forKey:@(self.currentIndexPath.row)];
        
        //        [self.indicator startAnimating];
        
        [self.presenter downloadAudioFile:url];
        
    }else{
        [ProgressUtil showInfo:message];
    }
    
}
#pragma mark 赞
- (void)praiseAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点赞");
    HotDetailPresenter *presenter = [HotDetailPresenter new];
    NSString *consulationID = [NSString stringWithFormat:@"%ld",(long)((HEAParentQuestionEntity *)self.presenter.dataSource[indexPath.row]).uuID];
    WS(ws);
    [presenter praise:consulationID success:^(BOOL success, NSString *message) {
        if (success == YES) {
            ((HEAParentQuestionEntity *)ws.presenter.dataSource[indexPath.row]).isPraise = [NSNumber numberWithInteger:1];
            ((HEAParentQuestionEntity *)ws.presenter.dataSource[indexPath.row]).praiseCount++;
            [ws.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            //圈子首页刷新
            [kdefaultCenter postNotificationName:Notification_RefreshCircleList object:nil userInfo:nil];

        }else{
            [ProgressUtil showError:@"点赞失败"];
        }
    }];
}
- (void)cancelPraiseAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"取消点赞");
    HotDetailPresenter *presenter = [HotDetailPresenter new];
    NSString *consulationID = [NSString stringWithFormat:@"%ld",(long)((HEAParentQuestionEntity *)self.presenter.dataSource[indexPath.row]).uuID];
    WS(ws);
    [presenter cancelPraise:consulationID success:^(BOOL success, NSString *message) {
        if (success == YES) {
            ((HEAParentQuestionEntity *)ws.presenter.dataSource[indexPath.row]).isPraise = [NSNumber numberWithInteger:0];
            ((HEAParentQuestionEntity *)ws.presenter.dataSource[indexPath.row]).praiseCount--;
            [ws.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            //圈子首页刷新
            [kdefaultCenter postNotificationName:Notification_RefreshCircleList object:nil userInfo:nil];

        }else{
            [ProgressUtil showError:@"取消点赞失败"];
        }
    }];
}

- (void)clickUserIconWithHEAParentQuestionEntity:(HEAParentQuestionEntity* ) heaParentQuestionEntity{
    if ((long)heaParentQuestionEntity.userID == kCurrentUser.userId) {
        [ProgressUtil showError:@"不能与自己私聊"];
        return;
    }
    ChatViewController *vc = [ChatViewController new];
    vc.chatType = ChatTypeSingal;
    vc.ReceiveUserID = heaParentQuestionEntity.userID;
    vc.nickName = heaParentQuestionEntity.nickName;
    
    GBhomeViewController *currentVC =[self getCurrentViewController];
    
    [currentVC.navigationController pushViewController:vc animated:YES];
}

/** 获取当前View的控制器对象 */
-(GBhomeViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[GBhomeViewController class]]) {
            return (GBhomeViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
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
- (CGFloat)totalHeight:(NSArray *)array{
    CGFloat height = 0.f;
    for (int i = 0; i < self.presenter.dataSource.count; i ++) {
        HEAParentQuestionEntity* question = self.presenter.dataSource[i];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        height += [_tableView cellHeightForIndexPath:indexPath model:question keyPath:@"question" cellClass:[HEAParentQuestionTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }
    return height+37;
}
- (void)moreAction{
//    [self.ViewController.navigationController pushViewController:[HotQuestionViewController new] animated:YES];
    
    ExpertAndConsultationViewController* expert = [ExpertAndConsultationViewController new];
    expert.segmentType = SegmentConsulationType;
    
    [self.ViewController.navigationController pushViewController:expert animated:YES];

}
//- (void)homeRefreshAction{
//    self.isLoad = NO;
//}



#pragma mark - 懒加载
-(UIImageView*)downImageView{
    if (!_downImageView) {
        _downImageView = [UIImageView new];
        [_downImageView  setImage:[UIImage  imageNamed:@"Baby_selec"]];
        _down = NO;
        UITapGestureRecognizer *tapRecognizerRadar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRadar:)];
        
        [_downImageView addGestureRecognizer:tapRecognizerRadar];
        _downImageView.userInteractionEnabled = YES;
        
    }
    
    return _downImageView;
}

-(UILabel*)downLb{
    if (!_downLb) {
        downlbFont = 16;
        if (kScreenWidth == 320) {
            downlbFont = 13;
        }
        if (kScreenWidth == 375) {
            downlbFont = 15;
        }
        
        _downLb = [UILabel new];
//        _downLb.text = self.expertEntity.Notice;
        _downLb.backgroundColor = [UIColor clearColor];
        _downLb.textColor = UIColorFromRGB(0xffffff);
        _downLb.font = [UIFont  systemFontOfSize:downlbFont];
        _downLb.textAlignment = NSTextAlignmentCenter;
        _downLb.numberOfLines = 0;
    }
    
    
    
    return  _downLb;
}

-(UIButton*)BulletinBtn{
    if(!_BulletinBtn){
        _BulletinBtn = [UIButton new];
        [_BulletinBtn  setImage:[UIImage  imageNamed:@"BulletinBoard"] forState:UIControlStateNormal];
        
        [_BulletinBtn  addTarget:self action:@selector(BulletinClick) forControlEvents:UIControlEventTouchUpInside];
        _BulletinBtn.userInteractionEnabled = YES;
        
    }
    return _BulletinBtn;
}

-(UIImageView *)iconbgImageView{
    if(!_iconbgImageView){
        _iconbgImageView = [UIImageView new];
        _iconbgImageView.userInteractionEnabled = YES;
        _iconbgImageView.backgroundColor = UIColorFromRGB(0xffffff);
        _iconbgImageView.layer.masksToBounds = YES;
        _iconbgImageView.layer.borderWidth = 1;
        _iconbgImageView.layer.borderColor = UIColorFromRGB(0x37e0ce).CGColor;
    }
    return _iconbgImageView;
}

-(UIImageView *)doctorIcon{
    if(!_doctorIcon){
        _doctorIcon = [UIImageView new];
        _doctorIcon.userInteractionEnabled = YES;
    }
    return _doctorIcon;
}
-(UILabel *)doctorName{
    if(!_doctorName){
        _doctorName = [UILabel new];
        _doctorName.textAlignment = NSTextAlignmentCenter;
        _doctorName.textColor = UIColorFromRGB(0x333333);
        _doctorName.font = [UIFont systemFontOfSize:bigFont];
    }
    return _doctorName;
}
-(UIView *)lineView{
    if(!_lineView){
        _lineView = [UIView new];
        _lineView.backgroundColor = UIColorFromRGB(0x999999);
    }
    return _lineView;
}
-(UILabel *)doctorTitle{
    if(!_doctorTitle){
        _doctorTitle = [UILabel new];
        _doctorTitle.textColor = UIColorFromRGB(0x999999);
        _doctorTitle.font = [UIFont systemFontOfSize:midFont];
    }
    return _doctorTitle;
}
-(UILabel *)doctorIntroduce{
    if(!_doctorIntroduce){
        _doctorIntroduce = [UILabel new];
        _doctorIntroduce.numberOfLines = 0;
        //        _doctorIntroduce.textAlignment = NSTextAlignmentCenter;
        _doctorIntroduce.textColor = self.doctorName.textColor;
        _doctorIntroduce.font = [UIFont systemFontOfSize:sbigFont];
    }
    return _doctorIntroduce;
}

-(UILabel *)doctorField{
    if(!_doctorField){
        _doctorField = [UILabel new];
        _doctorField.numberOfLines = 0;
        _doctorField.textColor = self.doctorTitle.textColor;
        _doctorField.font = self.doctorIntroduce.font;
    }
    return _doctorField;
}

-(UILabel *)questionTimes{
    if(!_questionTimes){
        _questionTimes = [UILabel new];
        _questionTimes.textAlignment = NSTextAlignmentRight;
        _questionTimes.textColor = self.doctorTitle.textColor;
        _questionTimes.font = [UIFont systemFontOfSize:smallFont];
    }
    return _questionTimes;
}

-(LCTextView *)textView{
    if(!_textView){
        
        _textView = [LCTextView new];
        _textView.backgroundColor = UIColorFromRGB(0xfbffff);
        _textView.placeholderColor = UIColorFromRGB(0x999999);
        _textView.font = [UIFont systemFontOfSize:midFont];
        _textView.placeholderFont = [UIFont systemFontOfSize:smallFont];
        _textView.showTextLength = YES;
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 5;
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = UIColorFromRGB(0x5bc4be).CGColor;
    }
    return _textView;
}

-(UILabel *)moneyTips{
    if(!_moneyTips){
        _moneyTips = [UILabel new];
        _moneyTips.textColor = self.doctorTitle.textColor;
        _moneyTips.font = [UIFont systemFontOfSize:smallFont];
        
        NSString* tips = @"*公开提问，答案每被偷听1次，你从中分成¥0.5";
        
        NSMutableAttributedString* attributeStr = [[NSMutableAttributedString alloc] initWithString:tips];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:midFont] range:NSMakeRange(0, 1)];
        
        [attributeStr addAttribute:NSForegroundColorAttributeName value:self.doctorTitle.textColor range:NSMakeRange(1, tips.length-1)];
        
        
        
        _moneyTips.attributedText = attributeStr;
    }
    return _moneyTips;
}

-(UILabel *)pricenLabel{
    if(!_pricenLabel){
        _pricenLabel = [UILabel new];
        _pricenLabel.textAlignment = NSTextAlignmentCenter;
        _pricenLabel.textColor = UIColorFromRGB(0xd50000);
        _pricenLabel.font = self.doctorName.font;
    }
    return _pricenLabel;
}

-(UIButton *)commitbt{
    if(!_commitbt){
        _commitbt = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitbt.backgroundColor = RGB(80,199, 192);
        [_commitbt setTitle:@"写好了" forState:UIControlStateNormal];
        _commitbt.layer.masksToBounds = YES;
        _commitbt.layer.cornerRadius = 5;
//        [_commitbt addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitbt;
}
-(UIView *)headerTitlebgView{
    if(!_headerTitlebgView){
        _headerTitlebgView = [UIView new];
        _headerTitlebgView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    }
    return _headerTitlebgView ;
}

-(UILabel *)titleTips{
    if(!_titleTips){
        _titleTips = [UILabel new];
        _titleTips.textColor = UIColorFromRGB(0x666666);
        _titleTips.font = self.doctorName.font;
        
    }
    return _titleTips;
}

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


- (void)dealloc{
//    [kdefaultCenter removeObserver:self name:Notification_HotIsLoad object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:Notification_HotWeXinPayResult object:nil];

}


@end
