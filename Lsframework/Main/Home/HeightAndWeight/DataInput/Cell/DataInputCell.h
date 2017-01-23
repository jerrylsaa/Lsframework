//
//  DataInputCell.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/10/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DataInputCellDelegate <NSObject>

- (void)input:(NSString *)text indexPath:(NSIndexPath *)indexPath;

@end

@interface DataInputCell : UITableViewCell

@property (nonatomic, strong) id<DataInputCellDelegate> delegate;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) CGFloat colHeight;

@property (nonatomic ,copy) NSString *type;

- (void)reloadData;

@end
