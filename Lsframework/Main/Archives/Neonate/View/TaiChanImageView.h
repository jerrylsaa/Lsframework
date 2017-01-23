//
//  TaiChanImageView.h
//  FamilyPlatForm
//
//  Created by lichen on 16/3/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTextField.h"

@interface TaiChanImageView : UIImageView

@property(nonatomic,copy) NSString* title;

@property(nonatomic,retain) NTextField* taitf;
@property(nonatomic,retain) NTextField* chantf;

@end
