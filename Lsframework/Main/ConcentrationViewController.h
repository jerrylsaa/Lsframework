//
//  ConcentrationViewController.h
//  FamilyPlatForm
//
//  Created by Mac on 16/11/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "ConcentrationPresenter.h"

@protocol ConcentrationViewDelegate <NSObject>
- (void)pushToVc:(BaseViewController *)vc;
@end

@interface ConcentrationViewController : BaseViewController
{
    NSInteger  PraiseIndex;
    
}
@property(nonatomic,strong)ConcentrationPresenter *presenter;
@property(nonatomic,strong)UIButton  *starButton;
/** table*/
@property(nonatomic,strong)UITableView*table;
@property (nonatomic, weak) id<ConcentrationViewDelegate> delegate;

-(void)seTupView;
@end
