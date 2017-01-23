//
//  JMChatViewController.m
//  doctors
//
//  Created by 梁继明 on 16/4/4.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import "JMChatViewController.h"
#import "RCDRCIMDataSource.h"
#import "RCDHttpTool.h"
#import <RongIMKit/RongIMKit.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

#import "JMChatHeaderView.h"

#import "JMChatOnlineHeaderView.h"
#import "FaceAppointMentViewController.h"



@interface JMChatViewController ()

@property(nonatomic,strong)  JMChatHeaderView *header;

//在线咨询专用
@property(nonatomic,strong)  JMChatOnlineHeaderView *onlineHeader;
@end

@implementation JMChatViewController

-(void)dealloc{

    NSLog(@"delloc %@",[[self class] description]);

}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    
//    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    
    [self setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    
   // [self setNavigationBarIsRest:NO];

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
   // [self setNavigationBarIsRest:YES];
        
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   [[IQKeyboardManager sharedManager]setEnable:NO];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

-(void)setNavigationBarIsRest:(BOOL)isRest{

    if (isRest) {
        
        CGRect rect = self . navigationController . navigationBar . frame ;
        
        self . navigationController . navigationBar . frame = CGRectMake ( rect . origin . x , rect . origin . y , rect . size . width , 44 ) ;
        
        [self.header removeFromSuperview];
        
        self.header = nil;
        
    }else{
    
        CGRect rect = self . navigationController . navigationBar . frame ;
        
        self . navigationController . navigationBar . frame = CGRectMake ( rect . origin . x , rect . origin . y , rect . size . width , 139 ) ;
        
        CGRect rect2 =self.conversationMessageCollectionView.frame;
        
        rect2.size.height -= 95;
        
        rect2.origin.y += 95;
        
        self.conversationMessageCollectionView.frame = rect2;
        
        self.header.nameLabel.text =self.strName;
        
        self.header.ageLabel.text = [NSString stringWithFormat:@"%ld",(long)self.age];
        
        NSString *str = [self.sexStr isEqualToString:@"男"]?@"nan-0":@"nv-0";
        
        [self.header.sexImageView setImage:[UIImage imageNamed:str]];
        
        [self.header.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];

        [self.header.patientFileBtn addTarget:self action:@selector(goToFileAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.header.patientPhoneBtn addTarget:self action:@selector(goToPhoneAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.header.patientBookBtn addTarget:self action:@selector(goToBookAction) forControlEvents:UIControlEventTouchUpInside];
        
    }


}

-(void)backAction{

    [self.navigationController popViewControllerAnimated:YES];


}

-(void)goToFileAction{

 //   XJHealthRecordViewController *vc = [[XJHealthRecordViewController alloc] init];
    

}


-(void)goToPhoneAction{
    
    NSLog(@"clik phoneAction");

}

-(void)goToBookAction{

    [self.navigationController pushViewController:[FaceAppointMentViewController new] animated:YES];
     
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    self.conversationMessageCollectionView.backgroundColor = [UIColor whiteColor];
  
    __weak typeof(self) weakSelf = self;

    
    if (self.conversationType == ConversationType_PRIVATE) {
        
        [[RCDRCIMDataSource shareInstance]getUserInfoWithUserId:self.targetId completion:^(RCUserInfo *userInfo) {
            
            self.navigationItem.title = [NSString stringWithFormat:@"%@医生",userInfo.name];
            
            /*
            [[RCDHttpTool shareInstance]updateUserInfo:weakSelf.targetId success:^(RCUserInfo * user) {
                if (![userInfo.name isEqualToString:user.name]) {
                    weakSelf.navigationItem.title = user.name;
                   /* [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:user.userId];
                                        [[NSNotificationCenter defaultCenter]
                                         postNotificationName:@"kRCUpdateUserNameNotification"
                                         object:user];
                
             
                   
                
                }
                
            } failure:^(NSError *err) {
                
            }]; */
        }];
        
    }
 
    
    
}


/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param imageMessageContent 图片消息内容
 */
- (void)presentImagePreviewController:(RCMessageModel *)model;
{
    RCImagePreviewController *_imagePreviewVC =
    [[RCImagePreviewController alloc] init];
    _imagePreviewVC.messageModel = model;
    _imagePreviewVC.title = @"图片预览";
    
    UINavigationController *nav = [[UINavigationController alloc]
                                   initWithRootViewController:_imagePreviewVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view {
    [super didLongTouchMessageCell:model inView:view];
    NSLog(@"%s", __FUNCTION__);
}



#pragma mark override
/**
 *  重写方法实现自定义消息的显示
 *
 *  @param collectionView collectionView
 *  @param indexPath      indexPath
 *
 *  @return RCMessageTemplateCell
 */
- (RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView
                             cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    
    if (!self.displayUserNameInCell) {
        if (model.messageDirection == MessageDirection_RECEIVE) {
            model.isDisplayNickname = NO;
        }
    }
    RCMessageContent *messageContent = model.content;
    RCMessageBaseCell *cell = [super rcConversationCollectionView:collectionView cellForItemAtIndexPath:indexPath];;
    
    return cell;
    
}

#pragma mark override
- (void)didTapMessageCell:(RCMessageModel *)model {
    [super didTapMessageCell:model];
    if ([model.content isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
        [self showRealTimeLocationViewController];
    }
}

- (void)didTapCellPortrait:(NSString *)userId{
    if (self.conversationType == ConversationType_DISCUSSION) {
        [[RCDRCIMDataSource shareInstance]getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
            [[RCDHttpTool shareInstance]updateUserInfo:userId success:^(RCUserInfo * user) {
                if (![userInfo.name isEqualToString:user.name]) {
                    [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:user.userId];
                    
                }
                
            } failure:^(NSError *err) {
                
            }];
        }];
        
    }else{
        
        if (self.conversationType == ConversationType_CUSTOMERSERVICE){
            return;
        }

    }
    
}

#pragma mark override
/**
 *  重写方法实现自定义消息的显示的高度
 *
 *  @param collectionView       collectionView
 *  @param collectionViewLayout collectionViewLayout
 *  @param indexPath            indexPath
 *
 *  @return 显示的高度
 */
- (CGSize)rcConversationCollectionView:(UICollectionView *)collectionView
                                layout:(UICollectionViewLayout *)collectionViewLayout
                sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    if ([messageContent isMemberOfClass:[RCRealTimeLocationStartMessage class]]) {
        if (model.isDisplayMessageTime) {
            return CGSizeMake(collectionView.frame.size.width, 66);
        }
        return CGSizeMake(collectionView.frame.size.width, 66);
    } else {
        return [super rcConversationCollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
}

#pragma mark override
- (void)resendMessage:(RCMessageContent *)messageContent{
    if ([messageContent isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
        [self showRealTimeLocationViewController];
    } else {
        [super resendMessage:messageContent];
    }
}
#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [super pluginBoardView:self.pluginBoardView clickedItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
        }
            break;
        case 1:
        {
            [self showRealTimeLocationViewController];
        }
            break;
    }
}

#pragma mark - RCRealTimeLocationObserver
- (void)onRealTimeLocationStatusChange:(RCRealTimeLocationStatus)status {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateRealTimeLocationStatus];
    });
}

- (void)onReceiveLocation:(CLLocation *)location fromUserId:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateRealTimeLocationStatus];
    });
}

- (void)onParticipantsJoin:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        [self notifyParticipantChange:@"你加入了地理位置共享"];
    } else {
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
            if (userInfo.name.length) {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"%@加入地理位置共享", userInfo.name]];
            } else {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"user<%@>加入地理位置共享", userId]];
            }
        }];
    }
}

- (void)onParticipantsQuit:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        [self notifyParticipantChange:@"你退出地理位置共享"];
    } else {
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
            if (userInfo.name.length) {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"%@退出地理位置共享", userInfo.name]];
            } else {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"user<%@>退出地理位置共享", userId]];
            }
        }];
    }
}

- (void)onRealTimeLocationStartFailed:(long)messageId {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < self.conversationDataRepository.count; i++) {
            RCMessageModel *model =
            [self.conversationDataRepository objectAtIndex:i];
            if (model.messageId == messageId) {
                model.sentStatus = SentStatus_FAILED;
            }
        }
        NSArray *visibleItem = [self.conversationMessageCollectionView indexPathsForVisibleItems];
        for (int i = 0; i < visibleItem.count; i++) {
            NSIndexPath *indexPath = visibleItem[i];
            RCMessageModel *model =
            [self.conversationDataRepository objectAtIndex:indexPath.row];
            if (model.messageId == messageId) {
                [self.conversationMessageCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
        }
    });
}

- (void)notifyParticipantChange:(NSString *)text {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf performSelector:@selector(updateRealTimeLocationStatus) withObject:nil afterDelay:0.5];
    });
}


- (RCMessage *)willAppendAndDisplayMessage:(RCMessage *)message
{
    return message;
}

/*******************实时地理位置共享***************/
- (void)showRealTimeLocationViewController{
}
- (void)updateRealTimeLocationStatus {
    
    
}

- (void)willDisplayConversationTableCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell isKindOfClass:[RCTextMessage class]]) {
        RCTextMessageCell *textCell = (RCTextMessageCell *)cell;
        
        if (textCell.messageDirection == MessageDirection_SEND) {
            
            textCell.textLabel.textColor = [UIColor whiteColor];
        
        }else{
            
            textCell.textLabel.textColor = [UIColor blackColor];
            
        }
        
    }
    
}


-(JMChatOnlineHeaderView *)onlineHeader{

    if (!_onlineHeader) {
        
        _onlineHeader = [[[NSBundle mainBundle] loadNibNamed:@"JMChatOnlineHeaderView" owner:self options:nil] lastObject];
        
        _onlineHeader.frame = CGRectMake(0, 64, kScreenWidth, 80);
        
        
        
        CGRect rect2 =self.conversationMessageCollectionView.frame;
        
        rect2.size.height -= 80;
        
        rect2.origin.y += 80;
        
        self.conversationMessageCollectionView.frame = rect2;
        
        [self.view addSubview:_onlineHeader];
    }
    
    return _onlineHeader;


}


-(JMChatHeaderView *)header{

    if (!_header) {
        
        
        _header = [[[NSBundle mainBundle] loadNibNamed:@"JMChatHeaderView" owner:self options:nil] lastObject];
        
        _header.frame = self.navigationController.navigationBar.bounds;
        
        [self.navigationController.navigationBar addSubview:_header];
        
        _header.backgroundColor = [UIColor clearColor];
        
        [self.navigationItem setHidesBackButton:YES];

    }
    
    return _header;

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
