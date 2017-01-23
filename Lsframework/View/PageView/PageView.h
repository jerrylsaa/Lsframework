//
//  PageView.h
//  Community
//
//  Created by Tom on 16/1/10.
//  Copyright © 2016年 Jia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PageType) {
    PageTypeNormal,
    PageTypeSubTitle
};

@protocol PageViewDelegate <NSObject>

-(void)onPageViewTabChange:(NSInteger)index;

@end

@interface PageView : UIView

@property (nonatomic, copy) NSArray * titles;

@property (nonatomic, copy) UIColor * backgroundColor;

@property (nonatomic, copy) UIColor * bottomLineColor;

@property (nonatomic, assign) CGFloat bottomLineHeight;

@property (nonatomic, copy) UIColor * titleNormalColor;

@property (nonatomic, copy) UIColor * titleHightLightColor;

@property (nonatomic, copy) UIColor * separatorColor;

@property (nonatomic, assign) CGFloat tabHeight;

@property (nonatomic, strong) NSArray<UIViewController*> * viewControllers;

@property (nonatomic, assign) NSInteger selection;

@property (nonatomic, weak) id<PageViewDelegate> delegate;

@property (nonatomic ,assign)PageType pageType;
@end
