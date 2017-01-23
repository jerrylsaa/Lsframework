//
//  JMDataPickerView.h
//  
//
//  Created by 梁继明 on 16/4/2.
//
//

#import <UIKit/UIKit.h>
#import "JMDataModel.h"

typedef enum : NSUInteger {
    JM_WEEK,
    JM_DAY,
    
} JMDATA_PICKER_TYPE;

typedef void(^SelectDateBlock)(JMDataModel *model);

@interface JMDataPickerView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *myCollectionView;

@property (nonatomic,strong) NSMutableArray *dateArray;

@property (nonatomic,copy) SelectDateBlock block;


@property (nonatomic,assign) JMDATA_PICKER_TYPE type;

-(void)addForwardDate;

-(void)addBackwardDate;

@end
