//
//  JMChatViewController.h
//  doctors
//
//  Created by 梁继明 on 16/4/4.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>





@interface JMChatViewController : RCConversationViewController

/**
 *  会话数据模型
 */
@property (strong,nonatomic) RCConversationModel *conversation;


//当且仅当在线聊天时能用

@property (nonatomic,strong) id model;

@property (nonatomic,copy) NSString * strName;

@property (nonatomic,copy) NSString * contentStr;

@property (nonatomic,assign) NSInteger age;

@property (nonatomic,copy) NSString * sexStr;


@end
