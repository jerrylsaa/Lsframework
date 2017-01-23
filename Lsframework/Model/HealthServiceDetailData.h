//
//  HealthServiceDetailData.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/1.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthServiceDetailData : NSObject
@property(nonatomic,retain) NSNumber *ID;
@property(nonatomic,retain) NSString *NAME;
@property(nonatomic,retain) NSString *MAIN_PIC;
@property(nonatomic,retain) NSString *DESCRIPTION;
@property(nonatomic,retain) NSNumber *PRICE;
@property(nonatomic,retain) NSString *DES_PIC;
@property(nonatomic,strong) id Attributes;
@property(nonatomic,strong) id Stocks;
@end
