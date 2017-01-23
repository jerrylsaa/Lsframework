//
//  MBabyManagerViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MBabyManagerViewController.h"
#import "BabayArchList.h"
#import "BabayCollectionViewCell.h"
#import "MBabyInfoViewController.h"
#import "SidesSliderView.h"
#import "MBabyManagerPresenter.h"
#import "DefaultChildEntity.h"
#import "ArchivesRecordViewController.h"
#import "ArchivesMainViewController.h"
#import <UIImageView+WebCache.h>
#import "MUserNameViewController.h"

#define kColumn 3

@interface MBabyManagerViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MBabyManagerPresenterDelegate>{
    
    UIScrollView* _scroll;
    UIView* _headerbgView;
    UIButton* _choosebt;
    
    UIButton* _editbt;
    
    UIView* _collectbgView;
    
    UICollectionViewFlowLayout* _flowLayout;
    UICollectionView* _collect;
    
    CGFloat _collectHeight ;
    
}

@property(nonatomic,retain) UILabel* currentBaby;

@property(nonatomic,retain) UILabel* currentUser;

@property(nonatomic,retain) MBabyManagerPresenter* presenter;


@end

@implementation MBabyManagerViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initRightBarWithTitle:@"添加"];
    
    self.presenter = [MBabyManagerPresenter new];
    self.presenter.delegate = self;
//    [ProgressUtil show];
//    [self.presenter getAllBaby];
    
    [self registerNotification];


}
#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"我的-宝贝管理页面"];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的-宝贝管理页面"];
    
}

-(void)setupView{
    self.title = @"宝贝管理";
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    _scroll = [UIScrollView new];
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scroll];
    _scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self setupHeaderView];
    [self setupCollectionView];
    
    NSString* currentName = self.currentBabyName;
    if(self.currentBabyName.length == 0){
        currentName = @"无";
    }
    _currentBaby.text = [NSString stringWithFormat:@"当前宝贝：%@",currentName];

}


#pragma mark - 加载子视图

- (void)setupHeaderView{
    _headerbgView = [UIView new];
    _headerbgView.backgroundColor = UIColorFromRGB(0xffffff);
    [_scroll addSubview:_headerbgView];
    
    
    
    //用户昵称
    _currentUser = [UILabel new];
    _currentUser.font = [UIFont systemFontOfSize:18];
    _currentUser.textColor = UIColorFromRGB(0x535353);
    
    _currentUser.text = (_currentUserName.length != 0)? [NSString  stringWithFormat:@"昵称：%@",_currentUserName]: [NSString  stringWithFormat:@"昵称：%@",@""];
    
    [_headerbgView addSubview:_currentUser];

    _editbt = [UIButton new];
    [_editbt setTitle:@"点击编辑" forState:UIControlStateNormal];
    [_editbt setTitleColor:UIColorFromRGB(0x868686) forState:UIControlStateNormal];
    [_editbt addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    [_headerbgView addSubview:_editbt];
  
    
    
    
    UILabel  *lineLb = [UILabel  new];
    lineLb.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [_headerbgView  addSubview:lineLb];

    _currentBaby = [UILabel new];
    _currentBaby.font = [UIFont systemFontOfSize:18];
    _currentBaby.textColor = UIColorFromRGB(0x535353);
//    _currentBaby.text = @"昵称：宝贝";
    [_headerbgView addSubview:_currentBaby];
    
    
    
    _choosebt = [UIButton new];
    [_choosebt setTitle:@"点击切换" forState:UIControlStateNormal];
    [_choosebt setTitleColor:UIColorFromRGB(0x868686) forState:UIControlStateNormal];
    [_choosebt addTarget:self action:@selector(chooseAction) forControlEvents:UIControlEventTouchUpInside];
    [_headerbgView addSubview:_choosebt];
    

    
    
    _currentUser.sd_layout.topSpaceToView(_headerbgView,15).heightIs(20).leftSpaceToView(_headerbgView,20).widthIs(300);
    
    _editbt.sd_layout.centerYEqualToView(_currentUser).heightIs(20).rightSpaceToView(_headerbgView,20).widthIs(100);
    
    lineLb.sd_layout.topSpaceToView(_editbt,15).leftEqualToView(_headerbgView).rightEqualToView(_headerbgView).heightIs(1);
    
    _currentBaby.sd_layout.topSpaceToView(lineLb,15).autoHeightRatio(0).leftSpaceToView(_headerbgView,20).widthIs(300);
    
    _choosebt.sd_layout.centerYEqualToView(_currentBaby).heightIs(20).rightSpaceToView(_headerbgView,20).widthIs(100);
    
    _headerbgView.sd_layout.topEqualToView(_scroll).leftEqualToView(_scroll).rightEqualToView(_scroll);
    [_headerbgView setupAutoHeightWithBottomViewsArray:@[_currentBaby,_choosebt] bottomMargin:15];
    
}

- (void)setupCollectionView{
    _collectbgView = [UIView new];
    _collectbgView.backgroundColor = UIColorFromRGB(0xffffff);
    _collectbgView.hidden = YES;
    [_scroll addSubview:_collectbgView];
    
    UILabel* allBaby = [UILabel new];
    allBaby.font = _currentBaby.font;
    allBaby.textColor = _currentBaby.textColor;
    allBaby.text = @"已添加的宝贝";
    [_collectbgView addSubview:allBaby];
    
    UIView* line = [UIView new];
    line.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [_collectbgView addSubview:line];
    
    //collectionView
    CGFloat width = (kScreenWidth-60-90)/kColumn;
    CGFloat height = width + 20;
    _collectHeight = height;
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
    _flowLayout = layout;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(width, height);
    _collect = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collect.dataSource = self;
    _collect.delegate = self;
    [_collect registerClass:[BabayCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collect.backgroundColor = [UIColor clearColor];
    [_collectbgView addSubview:_collect];
    
    //添加约束
    allBaby.sd_layout.topSpaceToView(_collectbgView,15).leftSpaceToView(_collectbgView,20).autoHeightRatio(0).widthIs(200);
    line.sd_layout.topSpaceToView(allBaby,15).leftEqualToView(_collectbgView).rightEqualToView(_collectbgView).heightIs(1);
    
    CGFloat cHeight = [self getCollectionViewHeight];
    _collect.sd_layout.topSpaceToView(line,0).leftSpaceToView(_collectbgView,0).rightSpaceToView(_collectbgView,0).heightIs(cHeight);
    
    _collectbgView.sd_layout.topSpaceToView(_headerbgView,10).leftEqualToView(_scroll).rightEqualToView(_scroll);
    [_collectbgView setupAutoHeightWithBottomView:_collect bottomMargin:0];
    
    [_scroll setupAutoContentSizeWithBottomView:_collectbgView bottomMargin:0];
    
    _collectbgView.hidden = (self.dataSource.count !=0)?NO:YES;


}

#pragma mark - 代理

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BabayCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    BabayArchList* baby = self.dataSource[indexPath.item];
    
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,baby.childImg]] placeholderImage:[UIImage imageNamed:@"GB_icon"]];
    
    cell.name.text = baby.childName;
    [cell.name updateLayout];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MBabyInfoViewController* babyInfo = [MBabyInfoViewController new];
    babyInfo.baby = self.dataSource[indexPath.item];
    [self.navigationController pushViewController:babyInfo animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 30, 15, 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 44;
}

-(void)onCompletion:(BOOL)success info:(NSString *)info{
    if(success){
        [ProgressUtil dismiss];
        self.dataSource = self.presenter.dataSource;
        CGFloat cHeight = [self getCollectionViewHeight];
        _collect.sd_layout.heightIs(cHeight);
        
        _collectbgView.hidden = (self.dataSource.count !=0)?NO:YES;
        
        [_collect reloadData];
    }else{
        [ProgressUtil showError:info];
    }
}

-(void)setDefaultBabyCompletion:(BOOL)success info:(NSString *)info{
    if(success){
        [ProgressUtil dismiss];
        //刷新我的首页headr宝宝列表
        [kdefaultCenter postNotificationName:Notification_ConvertBaby object:nil userInfo:@{@"name":self.presenter.currentBaby.childName}];
        
        self.currentBaby.text =[NSString stringWithFormat:@"当前宝贝：%@",self.presenter.currentBaby.childName];
        WS(ws);

        kCurrentUser.needToUpdateChildInfo = YES;
        
        DefaultChildEntity* child = [DefaultChildEntity defaultChild];
        [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            DefaultChildEntity* local = [child MR_inContext:localContext];
            local.babyID = [NSNumber numberWithInteger:ws.presenter.currentBaby.childID];
            local.childName = ws.presenter.currentBaby.childName;

        }completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if(contextDidSave){
             //更新医生模块首页家庭医生数据
                [kdefaultCenter postNotificationName:Notification_UpdateFamilyDoctor object:nil userInfo:nil];
            }
        }];
        
        //同步更新首页孩子信息
        kCurrentUser.needToUpdateChildInfo = YES;
        
    }else{
        [ProgressUtil showError:info];
    }
}

-(void)updateListCompletion:(BOOL)success info:(NSString *)info{
    if(success){
        [ProgressUtil dismiss];
        self.dataSource = self.presenter.dataSource;
        CGFloat cHeight = [self getCollectionViewHeight];
        _collect.sd_layout.heightIs(cHeight);
        
        [_collect updateLayout];
        
        _collectbgView.hidden = (self.dataSource.count !=0)?NO:YES;

        [_collect reloadData];
        
        
        //判断宝宝个数，如果是一个，那么当前即为默认宝宝
        if(self.presenter.dataSource.count == 1){
            BabayArchList* baby = [self.presenter.dataSource firstObject];
            self.currentBaby.text = [NSString stringWithFormat:@"当前宝贝：%@",baby.childName];
//            [kdefaultCenter postNotificationName:Notification_ChangeBaby object:nil userInfo:nil];//更新首页宝宝信息
            kCurrentUser.needToUpdateChildInfo = YES;
            
            DefaultChildEntity* child = [DefaultChildEntity MR_createEntity];
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                DefaultChildEntity* localChild = [child MR_inContext:localContext];
                localChild.babyID = [NSNumber numberWithInteger:baby.childID];
                localChild.childName = baby.childName;
            }completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                if(contextDidSave){
                    NSLog(@"添加默认宝宝");
                }
            }];
        }

        
    }else{
        [ProgressUtil showError:info];
    }

}

#pragma mark - 注册通知
- (void)registerNotification{
    //删除管理宝贝
    [kdefaultCenter addObserver:self selector:@selector(updateBabyList:) name:Notification_DeleteLinkBaby object:nil];
    
    //获取所有宝宝列表
    [kdefaultCenter addObserver:self selector:@selector(getAllBabyList) name:Notification_UpdateBabyList object:nil];
    
    //修改宝宝档案，同步更新默认宝宝名字
    [kdefaultCenter addObserver:self selector:@selector(updateDefaultBabyInfo:) name:Notification_UpdateDefaultBabyInfo object:nil];

}

#pragma mark - 通知回调方法
- (void)updateBabyList:(NSNotification*) notice{
    NSDictionary* userInfo = notice.userInfo;
    NSNumber* babyID = userInfo[@"babyID"];
    
    BabayArchList* tempBaby = nil;
    for(BabayArchList* babyList in self.dataSource){
        if(babyList.childID == [babyID integerValue]){
            //移除
            tempBaby = babyList;
            break;
        }
    }
    if(tempBaby){
        NSMutableArray* tempADataSource = [NSMutableArray arrayWithArray:self.dataSource];
        [tempADataSource removeObject:tempBaby];
//        self.dataSource = nil;
        self.dataSource = tempADataSource;
        WSLog(@"====%ld",self.dataSource.count)
        CGFloat cHeight = [self getCollectionViewHeight];
        _collect.sd_layout.heightIs(cHeight);
        
        [_collect updateLayout];
        
        _collectbgView.hidden = (self.dataSource.count !=0)?NO:YES;

        
        [_collect reloadData];
        
//        BabayArchList* baby = ws.dataSource[index];
//        ws.currentBaby.text =[NSString stringWithFormat:@"当前宝贝：%@",baby.childName];
        
        if(self.dataSource.count == 0){
            self.currentBaby.text = @"当前宝贝：无";
        }
        
        //判断移除的孩子是不是当前显示的
        if([[DefaultChildEntity defaultChild].babyID isEqual:babyID]){
            self.currentBaby.text = @"当前宝贝：无";
            
//            [kdefaultCenter postNotificationName:Notification_DeleteCurrentBaby object:nil userInfo:nil];//同步删除 我的 首页宝宝信息
        }

    }else{
        WSLog(@"删除失败")
    }
}
/**
 *  更新默认宝宝信息
 *
 *  @param notice <#notice description#>
 */
- (void)updateDefaultBabyInfo:(NSNotification*) notice{
    
    if(!notice.userInfo){
        //刷新所有宝宝列表
        [self.presenter getAllBaby];
        return ;
    }
    NSDictionary* dic = notice.userInfo;
    NSString* name = dic[@"name"];
    if(name.length == 0){
        self.currentBaby.text = @"当前宝贝：无";
    }else{
        self.currentBaby.text = [NSString stringWithFormat:@"当前宝贝：%@",name];

    }
    
    //刷新所有宝宝列表
    [self.presenter getAllBaby];
    
}
/**
 *  刷新宝宝列表
 */
- (void)getAllBabyList{
    [self.presenter updateAllBabyList];
    
}



#pragma mark - 点击事件
/**
 *  切换宝宝
 */
- (void)chooseAction{
    if(self.dataSource.count == 0){
        [ProgressUtil showInfo:@"请先添加宝贝"];
        return ;
    }
    
    SidesSliderView* sideSlider = [[SidesSliderView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    sideSlider.itemSize = _flowLayout.itemSize;
    sideSlider.dataSource = self.dataSource;
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:sideSlider];
    
    WS(ws);
    [sideSlider showSidesSliderView:^(SidesSliderView *view, NSInteger index) {

        BabayArchList* baby = ws.dataSource[index];

        [ProgressUtil show];
        [ws.presenter setDefaultBaby:baby];

        
        view = nil;
    }];
}

//编辑昵称
-(void)editAction{
MUserNameViewController  *vc = [MUserNameViewController  new];
    vc.currentUserName = _currentUserName;
[self.navigationController  pushViewController:vc animated:YES];
    
    
}



- (void)rightItemAction:(id)sender{
    ArchivesMainViewController * vc = [ArchivesMainViewController new];
    vc.poptoClass = [MBabyManagerViewController class];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - 私有方法

- (CGFloat)getCollectionViewHeight{
    
    CGFloat cHeight = 0;
    if(self.dataSource.count <= kColumn){
        cHeight = 30+5 + _collectHeight;
    }else{
        CGFloat row = self.dataSource.count/kColumn;
        if(self.dataSource.count % kColumn){
            //
            ++row;
        }
        cHeight = 30+5+20*(row-1)+ row*(_collectHeight);
    }

    
    return cHeight;
}

#pragma mark -
- (void)dealloc{
    [kdefaultCenter removeObserver:self name:Notification_DeleteLinkBaby object:nil];
    [kdefaultCenter removeObserver:self name:Notification_UpdateBabyList object:nil];
    [kdefaultCenter removeObserver:self name:Notification_UpdateDefaultBabyInfo object:nil];
}




@end
