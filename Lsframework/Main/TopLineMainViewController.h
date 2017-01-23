//
//  TopLineMainViewController.h
//  FamilyPlatForm
//
//  Created by jerry on 16/11/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, SegmentType) {
    SegmentRecommendType,
    SegmentConcentrationType,
    SegmentRankingType,
};
@interface TopLineMainViewController : BaseViewController

@property(nonatomic)SegmentType segmentType ;


@end
