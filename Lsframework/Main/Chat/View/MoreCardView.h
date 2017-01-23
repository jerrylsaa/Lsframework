//
//  MoreCardView.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreCardDelegate <NSObject>

- (void)selectImage:(UIViewController *)vc;

- (void)didSelectImage:(NSArray *)imageArray;

@end

@interface MoreCardView : UIView

@property (nonatomic, weak) id<MoreCardDelegate> delegate;

@end
