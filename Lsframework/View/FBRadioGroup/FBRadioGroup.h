//
//  FBRadioGroup.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FBRadioGroupType) {
    FBRadioGroupTypeVertical,
    FBRadioGroupTypeHorizontal,
};


typedef void(^FBRadioGroupClickBlock)(NSUInteger index);

IB_DESIGNABLE
@interface FBRadioGroup : UIView

@property (nonatomic, strong) NSMutableArray<UIButton*>* btns;


@property (nonatomic, strong) NSArray * titles;

@property (nonatomic, assign) NSUInteger selection;

@property(nonatomic,retain) UIButton* currentButton;

- (void)setRadioGroupClick:(FBRadioGroupClickBlock)block;

@property (nonatomic) IBInspectable NSUInteger type;

@property (nonatomic, strong) IBInspectable UIImage * normalImage;
@property (nonatomic, strong) IBInspectable UIImage * selectedImage;

@property (nonatomic) IBInspectable BOOL equalWidth;


@end
