//
//  PersonFilePresenter.h
//  FamilyPlatForm
//
//  Created by MAC on 16/5/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChildForm.h"

@protocol PersonFilePresenterDelegate <NSObject>

- (void)saveCompletion:(BOOL) success info:(NSString*) info;

@end

typedef void(^CompleteHander)(BOOL success);

@interface PersonFilePresenter : NSObject

@property (nonatomic ,strong) NSArray *dataSource;
@property (nonatomic ,strong) NSMutableArray *textArray;
@property (nonatomic ,strong) NSMutableArray *contentArray;
@property (nonatomic ,strong) ChildForm *child;

@property(nonatomic,weak) id<PersonFilePresenterDelegate> delegate;

- (void)upload;

- (void)loadChildFormBy:(NSInteger)babyId complete:(CompleteHander)block;

- (void)loadMenuData:(CompleteHander)block;

@end
