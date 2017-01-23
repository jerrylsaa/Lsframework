//
//  GBSearchViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GBSearchViewController.h"
#import "LCSearchBarView.h"
#import "SearchKeyWordsEntity+CoreDataClass.h"
#import "KeyWordsTableView.h"
#import "GBSearchPresenter.h"
#import "HExpertAnswerTableViewCell.h"
#import "GBexpertTableViewCell.h"
#import "ExpertAnswerEntity.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "AudioPhotoTableViewCell.h"
#import "CircleTableViewCell.h"
#import "PhotoWallTableViewCell.h"
#import "CircleEntity.h"
#import "HEAInfoViewController.h"
#import "PublicPostDetailViewController.h"
#import "HotDetailConsulationViewController.h"
#import "ChatViewController.h"
#import "SFPhotoBrowser.h"
#import "CirclePresenter.h"
#import "AVRecorderPlayerManager.h"
#import "HotDetailPresenter.h"
#import "HEAParentQuestionEntity.h"
#import "SearchSymptomTableViewCell.h"
#import "SearchSymptom.h"
#import "MSearchSymptomDetailViewController.h"

@interface GBSearchViewController ()<UITextFieldDelegate,KeyWordsTableViewDelegate,UITableViewDelegate,UITableViewDataSource,GBSearchPresenterDelegate,CircleTableViewCellDelegate,PhotoBrowerDelegate,CirclePresenterDelegate,UIActionSheetDelegate,SearchSymptomTableViewCellDelegate>

@property(nullable,nonatomic,retain) LCSearchBarView* searchBarView;
@property(nullable,nonatomic,retain) KeyWordsTableView* keyWordsView;
@property(nullable,nonatomic,retain) GBSearchPresenter* presenter;
@property(nullable,nonatomic,retain) UIView* unresultView;
@property(nullable,nonatomic,retain) UITableView* searchResultTable;
@property(nullable,nonatomic,retain) NSArray* photoWallDataSource;
@property(nullable,nonatomic,retain) NSArray<NSString* >* photoWallURL;
@property(nullable,nonatomic,retain)CirclePresenter* circlePresenter;
@property(nonatomic,retain) NSMutableDictionary* stateDic;//语音按钮状态字典
@property(nullable,nonatomic,retain) NSIndexPath* currentIndexPath;
@property(nullable,nonatomic,retain) NSMutableDictionary* praiseDic;


@end

@implementation GBSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initRightBarWithTitle:@"搜索"];
    
    self.presenter = [GBSearchPresenter new];
    self.presenter.delegate = self;
    
    self.circlePresenter = [CirclePresenter new];
    self.circlePresenter.delegate = self;
    
    //注册通知
//    [kdefaultCenter addObserver:self selector:@selector(refreshSingle:) name:Notification_RefreshCircleSingle object:nil];
    [kdefaultCenter addObserver:self selector:@selector(refreshCircleList) name:Notification_RefreshCircleList object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.isBecomeFirstResponsder){
        self.isBecomeFirstResponsder = NO;
        [self.searchBarView.searchTextField becomeFirstResponder];
    }
    
    if(self.currentIndexPath && [(NSNumber*)[self.stateDic objectForKey:@(self.currentIndexPath.row)] intValue] == 1){
        NSLog(@"停止播放");
        [[AVRecorderPlayerManager sharedManager] pause];
        [self.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
        [self.searchResultTable reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if ([self.searchBarView.searchTextField isFirstResponder]){
        [self.searchBarView.searchTextField resignFirstResponder];
    }

}

#pragma mark - 加载子视图
-(void)setupView{
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    //搜索框
    LCSearchBarView* searchBarView = [LCSearchBarView new];
    searchBarView.frame = CGRectMake(0, 0, 512/2, 60/2);
    searchBarView.searchTextField.delegate = self;
    self.searchBarView = searchBarView;
    self.navigationItem.titleView = searchBarView;

    //关键词
    KeyWordsTableView* keyWordsView = [KeyWordsTableView new];
    keyWordsView.delegate = self;
    self.keyWordsView = keyWordsView;
    [self.view addSubview:keyWordsView];
    WS(ws);
    keyWordsView.DidEndScrollBlock = ^(void){
        if([ws.searchBarView.searchTextField isFirstResponder]){
            [ws.searchBarView.searchTextField resignFirstResponder];
        }
    };
    
    //无搜索结果页面
    [self.view addSubview:self.unresultView];
    
    //搜索结果tableView
    UITableView* searchResultTable = [UITableView new];
    searchResultTable.dataSource = self;
    searchResultTable.delegate = self;
    searchResultTable.hidden = YES;
    searchResultTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:searchResultTable];
    self.searchResultTable = searchResultTable;
    
    [searchResultTable registerClass:[GBexpertTableViewCell class] forCellReuseIdentifier:@"doctorCell"]; //医生
    [searchResultTable registerClass:[AudioPhotoTableViewCell class] forCellReuseIdentifier:@"audioPhoto"];//语音＋图片
    [searchResultTable registerClass:[CircleTableViewCell class] forCellReuseIdentifier:@"circle"];//语音
    [searchResultTable registerClass:[PhotoWallTableViewCell class] forCellReuseIdentifier:@"photo"];//发帖
    
    [searchResultTable registerClass:[SearchSymptomTableViewCell class] forCellReuseIdentifier:@"SymptomCell"];//寻医问药

    
    searchResultTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.presenter laodMoreSearchResult];
    }];
    
    //添加约束
    keyWordsView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.unresultView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    searchResultTable.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

    
}

#pragma mark - 代理
#pragma mark * searchResultTable代理
/**
 *  tableView的数据源代理
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.presenter.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //医生
    GBexpertTableViewCell* doctorCell = [tableView dequeueReusableCellWithIdentifier:@"doctorCell"];
    //语音 ＋ 图片 cell
    AudioPhotoTableViewCell* audioPhotoCell = [tableView dequeueReusableCellWithIdentifier:@"audioPhoto"];
    if(!audioPhotoCell.delegate){
        audioPhotoCell.delegate = self;
    }
    //语音 cell
    CircleTableViewCell* circleCell = [tableView dequeueReusableCellWithIdentifier:@"circle"];
    if(!circleCell.delegate){
        circleCell.delegate = self;
    }
    //文字 + 图片 cell
    PhotoWallTableViewCell* photoCell = [tableView dequeueReusableCellWithIdentifier:@"photo"];
    if(!photoCell.delegate){
        photoCell.delegate = self;
    }
    //寻医问药
    SearchSymptomTableViewCell *SymptomCell = [tableView dequeueReusableCellWithIdentifier:@"SymptomCell"];
    if(!SymptomCell.delegate){
        SymptomCell.delegate = self;
    }
    NSDictionary* dic = self.presenter.dataSource[indexPath.row];
    NSNumber* searchType = [dic valueForKey:@"ConsultationType"];
    NSLog(@"111111111111111%@",dic);
    
    if([searchType isEqual:@1]){
        //语音
        CircleEntity* circleEntity = [CircleEntity mj_objectWithKeyValues:dic];

        NSNumber* isSelect = (NSNumber*)[self.stateDic objectForKey:@(indexPath.row)];
        
        if(circleEntity.isOpenImage && [circleEntity.isOpenImage boolValue]){
            //语音＋图片
            audioPhotoCell.circleEntity = circleEntity;
            if(isSelect) audioPhotoCell.voicebtIsSelect = [isSelect intValue];
            
            audioPhotoCell.sd_indexPath = indexPath;
            audioPhotoCell.sd_tableView = tableView;
            return audioPhotoCell;
        }else{
            //只有语音
            
            circleCell.circleEntity = circleEntity;
            if(isSelect) circleCell.voicebtIsSelect = [isSelect intValue];
            
            circleCell.sd_indexPath = indexPath;
            circleCell.sd_tableView = tableView;
            return circleCell;
        }

    }else if([searchType isEqual:@2]){
        //帖子
        CircleEntity* circleEntity = [CircleEntity mj_objectWithKeyValues:dic];

        
        photoCell.circleEntity = circleEntity;
        
        
        photoCell.sd_indexPath = indexPath;
        photoCell.sd_tableView = tableView;
        return photoCell;

    }else if([searchType isEqual:@3]){
        //医生
        ExpertAnswerEntity* expertAnswer = [ExpertAnswerEntity mj_objectWithKeyValues:dic];
        expertAnswer.doctorID = [dic valueForKey:@"uuid"];//医生ID
        expertAnswer.imageUrl = [dic valueForKey:@"DoctorImageUrl"];//医生头像
        if([[dic valueForKey:@"ExpertPrice"] isKindOfClass:[NSNull class]]){
            expertAnswer.price = 0;
        }else{
            NSNumber* price = (NSNumber*)[dic valueForKey:@"ExpertPrice"];
            expertAnswer.price = [price floatValue];//价格
        }
        //医院ID还没写
        
        doctorCell.expertAnswer = expertAnswer;
        doctorCell.showBottomLine = YES;
        
        doctorCell.sd_indexPath = indexPath;
        doctorCell.sd_tableView = tableView;
        
        return doctorCell;
    }else{
        //寻医问药
        SearchSymptom* searchSymptom = [SearchSymptom mj_objectWithKeyValues:dic];
        SymptomCell.searchSymptom = searchSymptom;
        SymptomCell.sd_indexPath = indexPath;
        SymptomCell.sd_tableView = tableView;
        return SymptomCell;

    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* dic = self.presenter.dataSource[indexPath.row];
    NSNumber* searchType = [dic valueForKey:@"ConsultationType"];
    if([searchType isEqual:@1]){
        //语音
        CircleEntity* circleEntity = [CircleEntity mj_objectWithKeyValues:dic];
        
        HEAParentQuestionEntity* question = [CircleEntity convertCircleEntityToHEAParentQuestionEntity:circleEntity];
        
        HotDetailConsulationViewController  *vc = [HotDetailConsulationViewController  new];
        vc.UUID = [NSNumber  numberWithInteger:question.uuID];
        [self.navigationController pushViewController:vc animated:YES];

        
    }else if([searchType isEqual:@2]){
        //帖子
        CircleEntity* circleEntity = [CircleEntity mj_objectWithKeyValues:dic];
        
        PublicPostDetailViewController* detail = [PublicPostDetailViewController new];
//        detail.circleEntity = circleEntity;
        detail.UUID = circleEntity.uuid;
//        detail.selectNumber = @(indexPath.row);
        
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if([searchType isEqual:@3]){
        //医生
        ExpertAnswerEntity* expertAnswer = [ExpertAnswerEntity mj_objectWithKeyValues:dic];
        expertAnswer.doctorID = [dic valueForKey:@"uuid"];//医生ID
        expertAnswer.imageUrl = [dic valueForKey:@"DoctorImageUrl"];//医生头像
        if([[dic valueForKey:@"ExpertPrice"] isKindOfClass:[NSNull class]]){
            expertAnswer.price = 0;
        }else{
            NSNumber* price = (NSNumber*)[dic valueForKey:@"ExpertPrice"];
            expertAnswer.price = [price floatValue];//价格
        }
        //医院ID还没写
        
        HEAInfoViewController* info = [HEAInfoViewController new];
        info.expertEntity = expertAnswer;
        
        [self.navigationController pushViewController:info animated:YES];
    }else{
    //寻医问药
    SearchSymptom* searchSymptom = [SearchSymptom mj_objectWithKeyValues:dic];
        NSLog(@"寻医问药");
        MSearchSymptomDetailViewController  *vc =[MSearchSymptomDetailViewController  new];
        vc.url = searchSymptom.TitleHref;
        [self.navigationController  pushViewController:vc animated:YES];
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary* dic = self.presenter.dataSource[indexPath.row];
    NSNumber* searchType = [dic valueForKey:@"ConsultationType"];
    
    if([searchType isEqual:@1]){
        //语音
        CircleEntity* circleEntity = [CircleEntity mj_objectWithKeyValues:dic];

        if(circleEntity.isOpenImage && [circleEntity.isOpenImage boolValue]){
            return [tableView cellHeightForIndexPath:indexPath model:circleEntity keyPath:@"circleEntity" cellClass:[AudioPhotoTableViewCell class] contentViewWidth:[self cellContentViewWith]];
        }else{
            return [tableView cellHeightForIndexPath:indexPath model:circleEntity keyPath:@"circleEntity" cellClass:[CircleTableViewCell class] contentViewWidth:[self cellContentViewWith]];
        }
    }else if([searchType isEqual:@2]){
        //帖子
        CircleEntity* circleEntity = [CircleEntity mj_objectWithKeyValues:dic];

        return [tableView cellHeightForIndexPath:indexPath model:circleEntity keyPath:@"circleEntity" cellClass:[PhotoWallTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }else if([searchType isEqual:@3]){
        //医生
        ExpertAnswerEntity* expertAnswer = [ExpertAnswerEntity mj_objectWithKeyValues:dic];
        expertAnswer.doctorID = [dic valueForKey:@"uuid"];//医生ID
        expertAnswer.imageUrl = [dic valueForKey:@"DoctorImageUrl"];//医生头像
        if([[dic valueForKey:@"ExpertPrice"] isKindOfClass:[NSNull class]]){
            expertAnswer.price = 0;
        }else{
            NSNumber* price = (NSNumber*)[dic valueForKey:@"ExpertPrice"];
            expertAnswer.price = [price floatValue];//价格
        }
        //医院ID还没写
        
        return [tableView cellHeightForIndexPath:indexPath model:expertAnswer keyPath:@"expertAnswer" cellClass:[GBexpertTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }else{
    //寻医问药
        SearchSymptom* searchSymptom = [SearchSymptom mj_objectWithKeyValues:dic];
        return [tableView cellHeightForIndexPath:indexPath model:searchSymptom keyPath:@"searchSymptom" cellClass:[SearchSymptomTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }
    
}

#pragma mark * textField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if([textField.text trimming].length != 0){
        //将关键词保存到数据库,判断数据库是不是有这个关键词了如果，没有就保存
        if(![SearchKeyWordsEntity hasKeyWordsEntity:textField.text]){
            [SearchKeyWordsEntity saveToDataBaseWithKeyWords:textField.text];
        }
        
        //走搜索接口
        [ProgressUtil show];
        [self.presenter loadSearchResultWithKeyWords:textField.text];
        
#pragma 打点统计*首页--搜索
        [BasePresenter  EventStatisticalDotTitle:DotHomeSearch Action:DotEventEnter  Remark:textField.text];
    }
    
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    self.keyWordsView.hidden = ![SearchKeyWordsEntity hasKeyWords];
    
    if(!self.unresultView.hidden)self.unresultView.hidden = YES;
    
    //搜索结果table
    if(!self.searchResultTable.hidden)self.searchResultTable.hidden = YES;
    
    
    if([SearchKeyWordsEntity hasKeyWords]){
        //展示关键词
        self.keyWordsView.dataSource = [SearchKeyWordsEntity findAllSerachKeyWords];
        [self.keyWordsView.keyWordTable reloadData];
    }
    

}
#pragma mark * KeyWordTableView代理
-(void)clickKeyWords:(NSString *)keyWord{
    //走搜索接口
    [ProgressUtil show];
    [self.presenter loadSearchResultWithKeyWords:keyWord];
    
#pragma 打点统计*首页--搜索
    [BasePresenter  EventStatisticalDotTitle:DotHomeSearch Action:DotEventEnter  Remark:keyWord];
}
#pragma mark * GBSearchResult代理
-(void)loadSearchResultComplete:(BOOL)success info:(NSString *)message{
    
    if(self.presenter.noMoreData){
        [self.searchResultTable.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.searchResultTable.mj_footer endRefreshing];
    }
    
    self.searchBarView.searchTextField.text = @"";
    
    if(success){
        [ProgressUtil dismiss];
        
        self.keyWordsView.hidden = self.unresultView.hidden = self.presenter.totalCount != 0;
        self.searchResultTable.hidden = !self.unresultView.hidden;

        
        
        [self.searchResultTable reloadData];

        
    }else{
        [ProgressUtil showError:message];
    }
}
#pragma mark * 监听点击cell用户头像
-(void)clickBabyIconWithCircleEntity:(CircleEntity *)circleEntity{
    //    NSLog(@"点击了用户头像－－%ld",(long)circleEntity.userID);
    if ((long)circleEntity.userID == kCurrentUser.userId) {
        [ProgressUtil showError:@"不能与自己私聊"];
        return;
    }
    ChatViewController *vc = [ChatViewController new];
    vc.chatType = ChatTypeSingal;
    vc.ReceiveUserID = circleEntity.userID;
    vc.nickName = circleEntity.nickName;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark * 监听点击了照片墙
-(void)clickPhotoWallWithCircleEntity:(CircleEntity *)circleEntity currentPhoto:(UIImageView *)imageView photoDataSource:(NSArray<UIImageView *> *)photoDataSource photoURLDataSource:(NSArray<NSString *> * _Nonnull)photoURL{
    
    NSInteger photoIndex = imageView.tag - 201;
    
    
    self.photoWallDataSource = photoDataSource;
    self.photoWallURL = photoURL;
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    [SFPhotoBrowser showImageInView:window selectImageIndex:photoIndex delegate:self];
    
}
#pragma mark * 照片墙浏览代理
-(NSUInteger)numberOfPhotosInPhotoBrowser:(SFPhotoBrowser *)photoBrowser{
    return self.photoWallDataSource.count;
}
-(SFPhoto *)photoBrowser:(SFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    SFPhoto* sfPhoto = [SFPhoto new];
    
    //原图
    sfPhoto.srcImageView = self.photoWallDataSource[index];
    
    //缩略图片的url
    NSString *imgUrl = self.photoWallURL[index];
    if(imgUrl && imgUrl.length != 0){
        sfPhoto.url = [NSURL URLWithString:imgUrl];
    }
    
    
    return sfPhoto;
}
#pragma mark * 点击语音按钮代理
-(void)clickAudioButton:(UIButton *)voiceBt circleEntity:(CircleEntity *)circleEntity currentCell:(UITableViewCell *)currentCell{
    NSIndexPath* currentIndexPath = [self.searchResultTable indexPathForCell:currentCell];
    
    self.circlePresenter.circleEntity = circleEntity;
    
    //未回答
    if(!circleEntity.voiceUrl || circleEntity.voiceUrl.length == 0){
        [ProgressUtil showInfo:@"请等待医生回答!"];
        return ;
    }
    
    //限时免费
    if(circleEntity.isFree && [circleEntity.isFree intValue] == 1){
        
        NSArray* result = [circleEntity.voiceUrl componentsSeparatedByString:@"/"];
        if([NSString fileIsExist:[result lastObject]]){
            //音频文件存在，说明之前偷听过了，补血药走接口了，直接播放，这样主要是为了优化体验
            //播放
            NSURL* audioURL = [NSString getAudioURL:[result lastObject]];
            if(!voiceBt.selected){
                [[AVRecorderPlayerManager sharedManager] playerAudio:audioURL completionHandler:^(AVAudioPlayer *player) {
                    NSLog(@"播放完成");
                    [self.stateDic setObject:@0 forKey:@(currentIndexPath.row)];
                    [self.searchResultTable reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    player = nil;
                }];
            }
            
            if(self.currentIndexPath && [self.currentIndexPath isEqual:currentIndexPath]){
                //点击了同一个cell
                NSLog(@"点击同一个cell");
                if(voiceBt.selected){
                    [[AVRecorderPlayerManager sharedManager] pause];
                    [self.stateDic setObject:@0 forKey:@(currentIndexPath.row)];
                }else{
                    [self.stateDic setObject:@1 forKey:@(currentIndexPath.row)];
                }
                [self.searchResultTable reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                //点击了不同cell
                [self.stateDic setObject:@1 forKey:@(currentIndexPath.row)];
                [self.searchResultTable reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                NSLog(@"点击了不同cell");
                if(self.currentIndexPath && [(NSNumber*)[self.stateDic objectForKey:@(self.currentIndexPath.row)] intValue] == 1){
                    //清除上次按钮选中状态，暂停上次播放语音
                    NSLog(@"清除上次按钮选中状态");
                    [self.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
                    [self.searchResultTable reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            self.currentIndexPath = currentIndexPath;
            
            
            
        }else{
            
            if(self.currentIndexPath && [(NSNumber*)[self.stateDic objectForKey:@(self.currentIndexPath.row)] intValue] == 1){
                //清除上次按钮选中状态，暂停上次播放语音
                NSLog(@"清除上次按钮选中状态");
                [self.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
                [self.searchResultTable reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            
            self.currentIndexPath = currentIndexPath;
            
            //判断之前有没有支付成功，但是插入偷听表失败
            NSNumber* consultationUUID = [kDefaultsUser readValueForKey:[NSString stringWithFormat:@"UUID%@",circleEntity.uuid]];
            
            if(consultationUUID && [consultationUUID boolValue]){
                
                NSString* insertListenKeyPath = [NSString stringWithFormat:@"insertListen%@",circleEntity.uuid];
                
                if([kDefaultsUser readValueForKey:insertListenKeyPath]){
                    //处理插入订单表失败
                    NSString* orderID = [kDefaultsUser readValueForKey:insertListenKeyPath];
                    if(orderID && orderID.length != 0){
                        [ProgressUtil show];
                        [self.circlePresenter insertListenQuestion:circleEntity price:0 orderID:orderID];
                    }
                }
            }else{
                //限时免费,走添加偷听表接口
                [ProgressUtil show];
                [self.circlePresenter insertListenQuestion:circleEntity price:0 orderID:@"0"];
            }
            
        }
        
        return ;
    }
    
    //播放音频
    if(circleEntity.isListen && [circleEntity.isListen intValue] == 1){
        NSArray* result = [circleEntity.voiceUrl componentsSeparatedByString:@"/"];
        if([NSString fileIsExist:[result lastObject]]){
            //播放
            NSURL* audioURL = [NSString getAudioURL:[result lastObject]];
            if(!voiceBt.selected){
                [[AVRecorderPlayerManager sharedManager] playerAudio:audioURL completionHandler:^(AVAudioPlayer *player) {
                    NSLog(@"播放完成");
                    [self.stateDic setObject:@0 forKey:@(currentIndexPath.row)];
                    [self.searchResultTable reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    player = nil;
                }];
            }
            
            if(self.currentIndexPath && [self.currentIndexPath isEqual:currentIndexPath]){
                //点击了同一个cell
                NSLog(@"点击同一个cell");
                if(voiceBt.selected){
                    [[AVRecorderPlayerManager sharedManager] pause];
                    [self.stateDic setObject:@0 forKey:@(currentIndexPath.row)];
                }else{
                    [self.stateDic setObject:@1 forKey:@(currentIndexPath.row)];
                }
                [self.searchResultTable reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                //点击了不同cell
                [self.stateDic setObject:@1 forKey:@(currentIndexPath.row)];
                [self.searchResultTable reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                NSLog(@"点击了不同cell");
                if(self.currentIndexPath && [(NSNumber*)[self.stateDic objectForKey:@(self.currentIndexPath.row)] intValue] == 1){
                    //清除上次按钮选中状态，暂停上次播放语音
                    NSLog(@"清除上次按钮选中状态");
                    [self.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
                    [self.searchResultTable reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            self.currentIndexPath = currentIndexPath;
            
        }else{
            //语音文件不存在，下载文件，下载前判断有没有其他语音正在播放，有就停止播放
            NSLog(@"开始下载文件");
            if(self.currentIndexPath && [(NSNumber*)[self.stateDic objectForKey:@(self.currentIndexPath.row)] intValue] == 1){
                [[AVRecorderPlayerManager sharedManager] pause];
                [self.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
                [self.searchResultTable reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            self.currentIndexPath = currentIndexPath;
            [ProgressUtil show];
            [self.circlePresenter downloadAudioFile:circleEntity.voiceUrl];
        }
    }else{
        //一元旁听
        
        if(self.currentIndexPath && [(NSNumber*)[self.stateDic objectForKey:@(self.currentIndexPath.row)] intValue] == 1){
            //清除上次按钮选中状态，暂停上次播放语音
            NSLog(@"清除上次按钮选中状态");
            [self.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
            [self.searchResultTable reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        
        self.currentIndexPath = currentIndexPath;
        //判断之前有没有支付成功，但是插入偷听表失败
        
        NSNumber* consultationUUID = [kDefaultsUser readValueForKey:[NSString stringWithFormat:@"UUID%@",circleEntity.uuid]];
        
        if(consultationUUID && [consultationUUID boolValue]){
            self.circlePresenter.payPrice = 1;//偷听价格
            
            NSString* paySuccessKeyPath = [NSString stringWithFormat:@"paySuccess%@",circleEntity.uuid];
            NSString* insertListenKeyPath = [NSString stringWithFormat:@"insertListen%@",circleEntity.uuid];
            
            if([kDefaultsUser readValueForKey:paySuccessKeyPath]){
                //处理支付成功，但是走订单支付成功接口失败
                NSString* orderID = [kDefaultsUser readValueForKey:paySuccessKeyPath];
                if(orderID && orderID.length != 0){
                    [ProgressUtil show];
                    [self.circlePresenter paySuccessWithOrderID:orderID];
                }
            }else if([kDefaultsUser readValueForKey:insertListenKeyPath]){
                //处理插入订单表失败
                NSString* orderID = [kDefaultsUser readValueForKey:insertListenKeyPath];
                if(orderID && orderID.length != 0){
                    [ProgressUtil show];
                    [self.circlePresenter insertListenQuestion:circleEntity price:self.circlePresenter.payPrice orderID:orderID];
                }
                
            }
        }else{
            //选择支付方式
            UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
            [sheet showInView:self.view];
            
        }
    }
}
#pragma mark * ActionSheet代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        //支付宝
        NSLog(@"支付宝");
        [ProgressUtil show];
        [self.circlePresenter payWithListenPrice:1 payType:@"alipay"];
        
    }else if(buttonIndex == 1){
        //微信
        NSLog(@"微信");
        [ProgressUtil show];
        [self.circlePresenter wxpayWithConsultationID:self.circlePresenter.circleEntity.uuid price:1 type:@"listenBiz"];
        
    }else if(buttonIndex == 2){
        //取消
        NSLog(@"取消");
    }
    
    
}
#pragma mark * 偷听付款完成代理
-(void)payCompleteWithAudioURL:(NSURL *)audioURL{
    
    //支付成功以后，改变按钮的选中状态
    NSDictionary* dic = self.presenter.dataSource[self.currentIndexPath.row];
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [tempDic setObject:@1 forKey:@"IsListen"];
    NSMutableArray* temArray = [NSMutableArray arrayWithArray:self.presenter.dataSource];
    [temArray replaceObjectAtIndex:self.currentIndexPath.row withObject:tempDic];
    self.presenter.dataSource = temArray;
 [self.searchResultTable reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    //    self.circlePresenter.circleEntity.isListen = @1;
//    NSLog(@"11111111111111%@\n",dic);
//    
//    NSLog(@"2222222222222%@\n",temArray[self.currentIndexPath.row]);
//    
//    NSLog(@"33333333333333%@\n",self.presenter.dataSource[self.currentIndexPath.row]);
    
    WS(ws);
    //播放音频
    [[AVRecorderPlayerManager sharedManager] playerAudio:audioURL completionHandler:^(AVAudioPlayer *player) {
        NSLog(@"播放完成");
        [ws.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
        [ws.searchResultTable reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        //        [ws.table reloadData];
        player = nil;
    }];
}
#pragma mark * 赞
- (void)praiseAtIndexPath:(NSIndexPath *)indexPath type:(NSInteger)type{
    
    [self.presenter clickPraiseWith:indexPath type:type];
}
- (void)cancelPraiseAtIndexPath:(NSIndexPath *)indexPath type:(NSInteger)type{
    
    [self.presenter cancelPraiseWith:indexPath type:type];
    
}
#pragma mark * 点赞回调
-(void)praiseOnComplete:(NSIndexPath *)indexPath{
    [self.searchResultTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

}

#pragma mark - 点击事件
-(void)backItemAction:(id)sender{
    if ([self.searchBarView.searchTextField isFirstResponder]){
        [self.searchBarView.searchTextField resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
    

}
-(void)ClickDiseaTitleUrl:(NSString*)Url{
    NSLog(@"点击标题");
    MSearchSymptomDetailViewController  *vc =[MSearchSymptomDetailViewController  new];
    vc.url = Url;
    [self.navigationController  pushViewController:vc animated:YES];
NSLog(@"%@",Url);
}
-(void)ClickDiseaseName1Url:(NSString*)Url{
    NSLog(@"点击可能疾病1");
    NSLog(@"%@",Url);
    MSearchSymptomDetailViewController  *vc =[MSearchSymptomDetailViewController  new];
    vc.url = Url;
    [self.navigationController  pushViewController:vc animated:YES];

}
-(void)ClickDiseaseName2Url:(NSString*)Url{
    NSLog(@"点击可能疾病2");
    NSLog(@"%@",Url);
    MSearchSymptomDetailViewController  *vc =[MSearchSymptomDetailViewController  new];
    vc.url = Url;
    [self.navigationController  pushViewController:vc animated:YES];

}
-(void)ClickDiseaseName3Url:(NSString*)Url{
    NSLog(@"点击可能疾病3");
    NSLog(@"%@",Url);
    MSearchSymptomDetailViewController  *vc =[MSearchSymptomDetailViewController  new];
    vc.url = Url;
    [self.navigationController  pushViewController:vc animated:YES];


}
-(void)ClickDiseaseName4Url:(NSString*)Url{
    NSLog(@"点击可能疾病4");
    NSLog(@"%@",Url);
    MSearchSymptomDetailViewController  *vc =[MSearchSymptomDetailViewController  new];
    vc.url = Url;
    [self.navigationController  pushViewController:vc animated:YES];


}
-(void)ClickDiseaseName5Url:(NSString*)Url{
    NSLog(@"点击可能疾病5");
    NSLog(@"%@",Url);
    MSearchSymptomDetailViewController  *vc =[MSearchSymptomDetailViewController  new];
    vc.url = Url;
    [self.navigationController  pushViewController:vc animated:YES];


}
-(void)ClickDiseaseMoreUrl:(NSString*)Url{
    NSLog(@"点击更多");
    NSLog(@"%@",Url);
    MSearchSymptomDetailViewController  *vc =[MSearchSymptomDetailViewController  new];
    vc.url = Url;
    [self.navigationController  pushViewController:vc animated:YES];


}

#pragma mark * 搜索
-(void)rightItemAction:(id)sender{
    
//    if ([self.searchBarView.searchTextField isFirstResponder]){
//        [self.searchBarView.searchTextField resignFirstResponder];
//    }else{
//    
//        return ;
//    }
//    
//    if(!self.keyWordsView.hidden){
//        self.keyWordsView.hidden = YES;
//    }
//    
//    if([self.searchBarView.searchTextField.text trimming].length != 0){
//        self.searchBarView.searchTextField.text = @"";
//    }
    
//    self.unresultView.hidden = self.presenter.totalCount != 0;
//    self.searchResultTable.hidden = !self.unresultView.hidden;
    
//    self.searchResultTable.hidden = self.presenter.totalCount == 0;
    
    if([self.searchBarView.searchTextField.text trimming].length == 0){
        
        if([self.searchBarView.searchTextField isFirstResponder]){
            [self.searchBarView.searchTextField resignFirstResponder];
        }

        
        return ;
    }
    
    
    if([self.searchBarView.searchTextField isFirstResponder]){
        [self.searchBarView.searchTextField resignFirstResponder];
    }

    
    if([self.searchBarView.searchTextField.text trimming].length != 0){
        //将关键词保存到数据库,判断数据库是不是有这个关键词了如果，没有就保存
        if(![SearchKeyWordsEntity hasKeyWordsEntity:self.searchBarView.searchTextField.text]){
            [SearchKeyWordsEntity saveToDataBaseWithKeyWords:self.searchBarView.searchTextField.text];
        }
        
        //走搜索接口
        [ProgressUtil show];
        [self.presenter loadSearchResultWithKeyWords:self.searchBarView.searchTextField.text];
        
        #pragma 打点统计*首页--搜索
        [BasePresenter  EventStatisticalDotTitle:DotHomeSearch Action:DotEventEnter  Remark:self.searchBarView.searchTextField.text];

    }


}
//#pragma mark - 监听点赞通知
//- (void)refreshSingle:(NSNotification *)notification{
//    NSDictionary *dic = notification.object;
//    if ([dic.allValues.firstObject isEqual:@1]) {
//        //非帖子
//        NSInteger index = [dic.allKeys.firstObject integerValue];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//        
//        NSDictionary* dicDataSource = self.presenter.dataSource[indexPath.row];
//        NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithDictionary:dicDataSource];
//        
//        NSNumber* praiseCount = [dicDataSource valueForKey:@"PraiseCount"];
//        NSNumber* isPraise = [dicDataSource valueForKey:@"isPraise"];
//        
//        if ([isPraise isEqual:@0]) {
//            isPraise = [NSNumber numberWithInteger:1];
//            praiseCount = [NSNumber numberWithInteger:[praiseCount integerValue]+1];
//        }else{
//            isPraise = [NSNumber numberWithInteger:0];
//            praiseCount = [NSNumber numberWithInteger:[praiseCount integerValue]-1];
//        }
//        
//        [tempDic setValue:praiseCount forKey:@"PraiseCount"];
//        [tempDic setValue:isPraise forKey:@"isPraise"];
//        
//        NSMutableArray* tempDataSource = [NSMutableArray arrayWithArray:self.presenter.dataSource];
//        
//        [tempDataSource removeObjectAtIndex:index];
//        [tempDataSource insertObject:tempDic atIndex:index];
//        
//        self.presenter.dataSource = tempDataSource;
//
//        
//        [self.searchResultTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    }else{
//        //帖子
//        NSInteger index = [dic.allKeys.firstObject integerValue];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//        
//        CircleEntity* circleObject = dic.allValues.firstObject;
//
//        
//        NSDictionary* dicDataSource = self.presenter.dataSource[index];
//        
//        NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithDictionary:dicDataSource];
//        
//        [tempDic setValue:circleObject.praiseCount forKey:@"PraiseCount"];
//        [tempDic setValue:circleObject.isPraise forKey:@"isPraise"];
//
//        NSMutableArray* tempDataSource = [NSMutableArray arrayWithArray:self.presenter.dataSource];
//        
//        [tempDataSource removeObjectAtIndex:index];
//        [tempDataSource insertObject:tempDic atIndex:index];
//        
//        self.presenter.dataSource = tempDataSource;
//        
//
//        [self.searchResultTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    }
//}
#pragma mark - 监听点赞通知
-(void)refreshCircleList{
    NSLog(@"上个页面搜索刷新");
    
    [self.presenter  NotificationRefreshSearchResult];
}
#pragma mark - 懒加载
-(UIView *)unresultView{
    if(!_unresultView){
        _unresultView = [UIView  new];
        _unresultView.backgroundColor = [UIColor  whiteColor];
        _unresultView.hidden = YES;
        
        UILabel  *NoSearchLb = [UILabel  new];
        NoSearchLb.text = @"没有搜索到答案呦！~ 快去向专家提问吧";
        NoSearchLb.textAlignment = NSTextAlignmentCenter;
        NoSearchLb.font = [UIFont  systemFontOfSize:17];
        NoSearchLb.textColor = UIColorFromRGB(0x999999);
        NoSearchLb.numberOfLines = 2;
        [_unresultView  addSubview:NoSearchLb];
        
        NoSearchLb.sd_layout.leftSpaceToView(_unresultView,10).rightSpaceToView(_unresultView,10).centerYEqualToView(_unresultView).autoHeightRatio(0);
        
    }
    return _unresultView;
}
-(NSMutableDictionary *)stateDic{
    if(!_stateDic){
        _stateDic = [NSMutableDictionary dictionary];
    }
    return _stateDic;
}

-(NSMutableDictionary *)praiseDic{
    if(!_praiseDic){
        _praiseDic = [NSMutableDictionary dictionary];
    }
    return _praiseDic;
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
#pragma mark - dealloc
-(void)dealloc{
    
    [kdefaultCenter removeObserver:self name:Notification_RefreshCircleList object:nil];
}




@end
