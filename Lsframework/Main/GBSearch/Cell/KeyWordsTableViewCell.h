//
//  KeyWordsTableViewCell.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteKeyWords)(UITableViewCell* _Nonnull cell);

@interface KeyWordsTableViewCell : UITableViewCell

@property(nullable,nonatomic,copy) DeleteKeyWords deleteKeyWordBlock;
@end
