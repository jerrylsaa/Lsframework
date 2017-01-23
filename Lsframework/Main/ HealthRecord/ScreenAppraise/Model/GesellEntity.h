//
//  GesellEntity.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GesellEntity : NSObject
@property (nonatomic,assign) NSInteger DIAG_ID;
@property (nonatomic,assign) NSInteger BEHAVIOR_ID;
@property (nonatomic,assign) float DA;
@property (nonatomic,assign) float DQ;
@property (nonatomic,retain) NSString *JUDGEMENT;
@property (nonatomic,retain) NSString *DIAGNOSIS;
@property (nonatomic,retain) NSString *BEHAVIOR_OBSERV;
@property (nonatomic,retain) NSString *UserName;
@property (nonatomic,retain) NSString *HName;

@end
