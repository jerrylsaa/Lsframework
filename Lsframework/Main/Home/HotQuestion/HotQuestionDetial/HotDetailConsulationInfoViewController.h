//
//  HotDetailConsulationInfoViewController.h
//  FamilyPlatForm
//
//  Created by jerry on 16/9/23.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "ConsultationCommenList.h"

@interface HotDetailConsulationInfoViewController : BaseViewController


@property(nonatomic,retain)ConsultationCommenList  *CommenList;

//@property (nonatomic ,assign) BOOL isAnswer;

@property (nonatomic,retain) NSNumber *commentID;

@property(nonatomic,assign)NSInteger userID;

@property(nonatomic,strong)void (^RefreshPopViewRow) (BOOL Disappear);


@end
