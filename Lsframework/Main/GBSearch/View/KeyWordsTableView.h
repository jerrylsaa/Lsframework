//
//  KeyWordsTableView.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyWordsTableViewCell.h"
#import "SearchKeyWordsEntity+CoreDataClass.h"

@protocol KeyWordsTableViewDelegate <NSObject>

- (void)clickKeyWords:(NSString* _Nonnull) keyWord;

@end

@interface KeyWordsTableView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nullable,nonatomic,retain) UITableView* keyWordTable;
@property(nullable,nonatomic,retain) NSMutableArray<NSString*>* dataSource;
@property(nullable,nonatomic,weak) id<KeyWordsTableViewDelegate> delegate;

@property(nullable,nonatomic,copy) void(^ DidEndScrollBlock)();


@end
