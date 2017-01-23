//
//  WeightInputViewController.h
//  FamilyPlatForm
//
//  Created by jerry on 16/11/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"

@protocol WeightInputViewDelegate <NSObject>

-(void)WeightText:(NSString*)text;

@end


@interface WeightInputViewController : BaseViewController
@property (nonatomic, weak) id<WeightInputViewDelegate> delegate;

@property(nonatomic,strong)NSString  *weightTextField;

@end
