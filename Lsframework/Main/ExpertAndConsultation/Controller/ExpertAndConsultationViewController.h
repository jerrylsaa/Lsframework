//
//  ExpertAndConsultationViewController.h
//  FamilyPlatForm
//
//  Created by lichen on 16/9/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, SegmentType) {
    SegmentExpertType,
    SegmentConsulationType
};

@interface ExpertAndConsultationViewController : BaseViewController

@property(nonatomic)SegmentType segmentType ;

@end
