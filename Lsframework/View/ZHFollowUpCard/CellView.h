//
//  CellView.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellFieldDelegate <NSObject>

- (void)endEditingWithText:(NSString *)text forIndexPath:(NSIndexPath *)indexPath;

@end

@interface CellView : UIView

@property (nonatomic ,assign) BOOL isCurrent;
@property (nonatomic ,weak) id<CellFieldDelegate> delegate;
@property (nonatomic ,strong) NSIndexPath *indexPath;

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content unit:(NSString *)unit;
- (void)setupSubview;

@end
