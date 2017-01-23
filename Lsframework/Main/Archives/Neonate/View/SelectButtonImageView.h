//
//  SelectButtonImageView.h
//  FamilyPlatForm
//
//  Created by lichen on 16/3/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBRadioGroup.h"

@protocol SelectButtonDelegate <NSObject>

- (void)showBeiZhuWith:(NSInteger) index;

@end

@interface SelectButtonImageView : UIImageView


@property(nonatomic,retain) NSString* title;

@property(nonatomic,retain) NSArray* listArray;

@property(nonatomic,retain) FBRadioGroup* radioGroup;

@property(nonatomic) NSUInteger currentSelect;

@property(nonatomic,weak) id<SelectButtonDelegate> delegate;

@end
