//
//  ZHCardView.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellView.h"

@interface ZHCardView : UIImageView

@property (nonatomic ,assign) BOOL isCurrent;
@property (nonatomic ,assign) NSInteger section;
@property (nonatomic ,weak) id<CellFieldDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title array:(NSArray *)array;

- (void)setupCardView;

@end
