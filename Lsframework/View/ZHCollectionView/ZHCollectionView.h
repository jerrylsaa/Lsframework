//
//  ZHCollectionView.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildEntity.h"

@interface ZHCollectionView : UIView

@property (nonatomic ,strong)NSArray *babyArray;

@property (nonatomic ,strong)NSMutableArray *selectBabyArray;

@property(nonatomic,retain) ChildEntity* currentChild;

@property(nonatomic) Class popToClass;


- (void)reloadData;

@end
