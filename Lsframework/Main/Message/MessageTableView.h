//
//  MessageTableView.h
//  doctors
//
//  Created by 梁继明 on 16/3/29.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableView.h"
#import "MessageTableViewCell.h"
#import "MessagePresenter.h"

typedef enum : NSUInteger {
    MSG_NEW_PATIENT = 2,
    MSG_UN_READ = 0,
    MSG_ALL = 3,
    MSG_OTHER = 1,//签约患者
} MSG_TYPE;

@interface MessageTableView : BaseTableView<MessagePresnterDelegate>

@property (nonatomic,assign) MSG_TYPE type;
@property (nonatomic, strong) MessagePresenter * presenter;

@end
