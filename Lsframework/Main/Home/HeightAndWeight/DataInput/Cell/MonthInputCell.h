//
//  MonthInputCell.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/10/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataValue.h"

@protocol MonthCellDelegate <NSObject>

- (void)inputText:(NSString *)text index:(NSInteger )index;

@end

@interface MonthInputCell : UICollectionViewCell

@property (nonatomic, weak) id<MonthCellDelegate> delegate;
@property (nonatomic, strong) DataValue *value;
@property (nonatomic ,copy) NSString *type;
@property (nonatomic, assign) BOOL editEnable;

@end
