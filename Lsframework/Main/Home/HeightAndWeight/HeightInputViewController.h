//
//  HeightInputViewController.h
//  FamilyPlatForm
//
//  Created by jerry on 16/11/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"

@protocol HeightInputViewDelegate <NSObject>

-(void)HeightText:(NSString*)text;

@end



@interface HeightInputViewController : BaseViewController

@property (nonatomic, weak) id<HeightInputViewDelegate> delegate;

@property(nonatomic,strong)NSString  *heightTextField;
@end
