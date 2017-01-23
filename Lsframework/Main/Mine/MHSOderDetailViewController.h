//
//  MHSOderDetailViewController.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "MHSOderDetailEntity.h"
#import "MHealthServiceOderListEntity.h"
#import "MHSOderAddressEntity.h"
@interface MHSOderDetailViewController : BaseViewController

@property (nonatomic,strong) MHSOderDetailEntity *myDetailEntity;
@property (nonatomic,strong) MHealthServiceOderListEntity *myOderListEntity;
@property (nonatomic,strong) MHSOderAddressEntity *myAddressEntity;
@property (nonatomic,retain) NSString *mainIVUrl;

@property (nonatomic,retain) NSString *serviceName;

@end
