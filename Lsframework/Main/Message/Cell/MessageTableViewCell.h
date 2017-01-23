//
//  MessageTableViewCell.h
//  PublicHealth
//
//  Created by Tom on 16/3/25.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageEntity.h"

@interface MessageTableViewCell : UITableViewCell

- (void)configCell:(MessageEntity*)messageEntity;

@end
