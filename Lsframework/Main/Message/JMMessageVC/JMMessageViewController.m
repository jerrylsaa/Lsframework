//
//  JMMessageViewController.m
//  FamilyPlatForm
//
//  Created by 梁继明 on 16/6/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "JMMessageViewController.h"
#import "JMChatViewController.h"
#import "JMMessageCell.h"
#import "RCDRCIMDataSource.h"


@interface JMMessageViewController ()

@end

@implementation JMMessageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_CUSTOMERSERVICE)]];
    
    self.navigationItem.title = @"消息";
    
    self.emptyConversationView = [UIView new];
 
    self.emptyConversationView =[UIView new];
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
//插入自定义会话model
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
{
    
    for (int i=0; i<dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        //筛选请求添加好友的系统消息，用于生成自定义会话类型的cell
        
        model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        
    }
    /*
    RCUserInfo *userInfor = [[RCUserInfo alloc] initWithUserId:@"" name:@"联系医助" portrait:@""];
    
    RCConversation * con = [[RCConversation alloc] init];
    
    con.targetId = PUBLIC_SERVICE_KEY;
    
    con.conversationType = ConversationType_CUSTOMERSERVICE;
    
    con.isTop = YES;
    
    RCConversationModel *model = [[RCConversationModel alloc] init:RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION conversation:con extend:nil];
    
    model.conversationType = ConversationType_CUSTOMERSERVICE;
    
    model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
    
    model.conversationTitle = @"联系医助";
    
    
    
    
    model.isTop = YES;
    
    [dataSource insertObject:model atIndex:0];
    
    
    NSLog(@"get object %ld",dataSource.count);
    */
   
    
    return dataSource;
}


//高度
-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78.0f;
}


-(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JMMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JMMessageCell" owner:self options:nil] lastObject];
    }
    

    RCConversationModel *model = [self.conversationListDataSource objectAtIndex:indexPath.row];
    
    
    
    if (model.conversationType == ConversationType_CUSTOMERSERVICE) {
        
      //  RCMessageContent * contentModel = model.lastestMessage;
        
        RCTextMessage *testMsg = (RCTextMessage *)model.lastestMessage;
        
        NSLog(@"%@",model.objectName);
        
        if ([model.objectName isEqualToString:@"RC:TxtMsg"]) {
            
            
            
                 cell.docMsgLabel.text = testMsg.content;
        }
        
        
        cell.docNameLabel.text = @"医助小帮手";
        
        cell.docDateLabel.text =[self ConvertMessageTime:model.sentTime/1000 ];
        
   
        
        
        return cell;
    }
    
    

    
    [RCDDataSource getUserInfoWithUserId:model.targetId completion:^(RCUserInfo *userInfo) {
        
        
        cell.docNameLabel.text = [NSString stringWithFormat:@"%@医生",userInfo.name];
      
        cell.docDateLabel.text =[self ConvertMessageTime:model.sentTime / 1000];
        
        
        
        if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
            
            RCTextMessage *testMsg = (RCTextMessage *)model.lastestMessage;
            
            cell.docMsgLabel.text =testMsg.content;
            
        }
        
        if (model.unreadMessageCount > 0) {
            
            cell.docBadgeView.text = @"未读消息";
            
            cell.docBadgeView.hidden = NO;
        }else{
        
              cell.docBadgeView.hidden = YES;
        
        }
        
        
        
        
    }];
    
    
    return cell;
    
    
}



-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    
    
    JMChatViewController *conversationVC = [[JMChatViewController alloc]init];
    
    conversationVC.conversationType =model.conversationType;
    
    conversationVC.targetId = model.targetId;
    
    
    // [conversationVC setMessageAvatarStyle:RCUserAvatarCycle];
    [self.navigationController pushViewController:conversationVC animated:YES];
    
    
    
}

-(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    RCConversationModel *model = [self.conversationListDataSource objectAtIndex:indexPath.row];
    
    cell.model = model;
    
    
    NSLog(@"will display %@",model.objectName);
    
}

-(void)didDeleteConversationCell:(RCConversationModel *)model{

    [self.conversationListDataSource removeObject:model];
   
    [self.conversationListTableView reloadData];


}


#pragma mark - private
- (NSString *)ConvertMessageTime:(long long)secs {
    NSString *timeText = nil;
    
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:secs];
    
    //    DebugLog(@"messageDate==>%@",messageDate);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strMsgDay = [formatter stringFromDate:messageDate];
    
    NSDate *now = [NSDate date];
    NSString *strToday = [formatter stringFromDate:now];
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-(24 * 60 * 60)];
    NSString *strYesterday = [formatter stringFromDate:yesterday];
    
    NSString *_yesterday = nil;
    if ([strMsgDay isEqualToString:strToday]) {
        [formatter setDateFormat:@"HH':'mm"];
    } else if ([strMsgDay isEqualToString:strYesterday]) {
        _yesterday = NSLocalizedStringFromTable(@"Yesterday", @"RongCloudKit", nil);
        //[formatter setDateFormat:@"HH:mm"];
    }
    
    if (nil != _yesterday) {
        timeText = _yesterday; //[_yesterday stringByAppendingFormat:@" %@", timeText];
    } else {
        timeText = [formatter stringFromDate:messageDate];
    }
    
    return timeText;
}


@end
