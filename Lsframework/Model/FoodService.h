//
//  FoodService.h
//  FamilyPlatForm
//
//  Created by jerry on 16/11/10.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodService : NSObject

@property (nonatomic ,strong) NSNumber *FoodID;
@property (nonatomic ,copy) NSString *Name;
@property (nonatomic ,copy) NSString *CreateTime;
@property (nonatomic ,copy) NSString *ImageUrl;


@end
