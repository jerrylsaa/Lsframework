//
//  ImageWidget.h
//  Community
//
//  Created by tom on 16/1/12.
//  Copyright © 2016年 Jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageWidget : UIScrollView



@property (nonatomic, copy) NSMutableArray * originalUrls;

@property (weak, nonatomic) UIViewController * viewController;

@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, copy) NSMutableArray * urls;

@property (nonatomic, assign) CGFloat imageHeight;

@end
