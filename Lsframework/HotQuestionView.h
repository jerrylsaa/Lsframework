//
//  HotQuestionView.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/8/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Height)(CGFloat height);

@interface HotQuestionView : UIView

@property (nonatomic, assign) BOOL isLoad;
@property (nonatomic, assign) CGFloat totalHeight;

- (void)loadData:(Height)block;

@end
