//
//  ZHImageTitleLabel.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHImageTitleLabel : UIView

@property(nonatomic,copy) NSString* imageName;

@property(nonatomic,copy) NSString* title;

@property(nonatomic,copy) NSString* content;

@property(nonatomic,copy) NSString* unit;

@property(nonatomic,retain)UILabel* titleLabel;
;

@end
