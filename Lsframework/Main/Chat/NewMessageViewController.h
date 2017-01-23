//
//  NewMessageViewController.h
//  FamilyPlatForm
//
//  Created by Mac on 16/12/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, SegmentTypes) {
    SegmentNoticeType,
    SegmentChatListType
};
@interface NewMessageViewController : BaseViewController

@property(nonatomic)SegmentTypes segmentType ;


@end
