//
//  ChatBaseCell.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TalkType){
    TalkTypeSend,
    TalkTypeRecive,
};
typedef NS_ENUM(NSInteger, DisplayType){
    DisplayTypeDefault,
    DisplayTypeImage,
};
@protocol CellImageDelegate <NSObject>

- (void)cellHeight:(CGFloat )height needReload:(BOOL )need indexPath:(NSIndexPath *)indexPath;
- (void)cancelCellForIndexPath:(NSIndexPath *)indexPath;
- (void)enterCellForIndexPath:(NSIndexPath *)indexPath;

@end
@interface ChatBaseCell : UITableViewCell


- (NSString *)time:(NSNumber *)time;

@end
