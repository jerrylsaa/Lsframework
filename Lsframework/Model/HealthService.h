//
//  HealthService.h
//  FamilyPlatForm
//
//  Created by jerry on 16/7/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthService : NSObject

@property (nonatomic ,strong) NSNumber *TID;
@property (nonatomic ,copy) NSString *Name;
@property (nonatomic ,copy) NSString *Remark;
@property (nonatomic ,copy) NSString *ImageUrl;


/***/
@property(nullable,nonatomic,copy) NSString* imageUrl;


@end
