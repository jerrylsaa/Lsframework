//
//  HotDetailInfoTableViewCell.h
//  FamilyPlatForm
//
//  Created by jerry on 16/9/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsultationCommenList.h"
#import "ConsulationReplyList.h"
#import "CircleTableViewCell.h"
//@protocol HotDetailInfoTableViewCellDelegate <NSObject>
//
//-(void)deleButtonWithIndexPath:(UITableViewCell *)indexPath;
//
//@end

@interface HotDetailInfoTableViewCell : UITableViewCell
@property(nullable,nonatomic,retain) ConsulationReplyList * ReplyList;

//@property(nonatomic,weak) id<HotDetailInfoTableViewCellDelegate> delegate;

@property(nullable,nonatomic,weak) id<CircleTableViewCellDelegate> delegate;

@property(nonatomic,strong)UIButton *deleteBtn;


@end
