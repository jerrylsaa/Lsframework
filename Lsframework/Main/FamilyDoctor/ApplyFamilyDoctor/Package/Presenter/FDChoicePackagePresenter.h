//
//  FDChoicePackagePresenter.h
//  FamilyPlatForm
//
//  Created by tom on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "Package.h"

typedef void(^Complete)(BOOL success ,NSArray *entityArray);

@protocol FDChoicePackagePresenterDelegate <NSObject>

- (void)onCompletion:(BOOL) success info:(NSString*) message;

@end


@interface FDChoicePackagePresenter : BasePresenter

@property (nonatomic ,strong)NSMutableArray *dataSource;


@property(nonatomic,weak) id<FDChoicePackagePresenterDelegate> delegate;
@property(nonatomic,retain) NSArray<Package* > * packageArray;

- (void)getPackage:(NSInteger) doctorID;


- (void)loadPackageByDoctorId:(NSNumber *)doctorId with:(Complete)block;

@end
