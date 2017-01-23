//
//  MHealthServiceCell.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHSOderDetailEntity.h"
#import "MHealthServiceOderListEntity.h"
@protocol MHealthServiceCellDelegate <NSObject>
@optional
- (void)paySuccess;

@end
@interface MHealthServiceCell : UITableViewCell
@property (nonatomic,retain) MHealthServiceOderListEntity *myOderList;
@property (nonatomic,retain) MHSOderDetailEntity *myOderDetail;
@property(nonatomic,weak) id<MHealthServiceCellDelegate> delegate;
@end
