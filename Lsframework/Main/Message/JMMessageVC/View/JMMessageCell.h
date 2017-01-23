//
//  JMMessageCell.h
//  FamilyPlatForm
//
//  Created by 梁继明 on 16/6/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RCConversationBaseCell.h>

@interface JMMessageCell : RCConversationBaseCell
@property (weak, nonatomic) IBOutlet UILabel *docNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *docMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *docDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *docDepLabel;
@property (weak, nonatomic) IBOutlet UILabel *docBadgeView;

@end
