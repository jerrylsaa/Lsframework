//
//  ZHProgressView.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#define ZHProgress [[ZHProgressView alloc] init]

#import <UIKit/UIKit.h>
#import "LDProgressView.h"


@interface ZHProgressView : NSObject

@property (nonatomic, weak) id<FinishDelegate> delegate;

@property (nonatomic, assign) CGFloat progressValue;
@property (nonatomic, strong) NSTimer *timer;

@property(nonatomic) CGRect rect;

- (void)show;

- (void)finish;
@end
