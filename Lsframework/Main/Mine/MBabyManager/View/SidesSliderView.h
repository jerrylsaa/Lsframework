//
//  SidesSliderView.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabayArchList.h"

@class SidesSliderView;
typedef void (^ CompletionBlock)(SidesSliderView* view, NSInteger index);



@interface SidesSliderView : UIView

@property(nonatomic,assign) CGSize itemSize;
@property(nonatomic,retain) NSArray* dataSource;


- (void)showSidesSliderView:(CompletionBlock) completionBlock;





@end
