//
//  HealthServiceProductDetailViewController.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/10/31.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "HealthServiceDetailData.h"
#import "HealthServiceDetailAttributes.h"
#import "HealthServiceDetailStocks.h"
@interface HealthServiceProductDetailViewController : BaseViewController

@property(nonatomic,retain) HealthServiceDetailData *serviceData;
@property(nonatomic,retain) NSArray<HealthServiceDetailAttributes* >* attributesDataSource;

@property(nonatomic,retain) NSArray<HealthServiceDetailStocks* >* stocksDataSource;

@end
