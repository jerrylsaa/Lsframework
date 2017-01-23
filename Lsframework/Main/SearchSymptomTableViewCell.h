//
//  SearchSymptomTableViewCell.h
//  FamilyPlatForm
//
//  Created by jerry on 16/11/4.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchSymptom.h"

@protocol SearchSymptomTableViewCellDelegate <NSObject>
@optional
/*  点击标题*/
-(void)ClickDiseaTitleUrl:(NSString*)Url;
-(void)ClickDiseaseName1Url:(NSString*)Url;
-(void)ClickDiseaseName2Url:(NSString*)Url;
-(void)ClickDiseaseName3Url:(NSString*)Url;
-(void)ClickDiseaseName4Url:(NSString*)Url;
-(void)ClickDiseaseName5Url:(NSString*)Url;
-(void)ClickDiseaseMoreUrl:(NSString*)Url;


@end

@interface SearchSymptomTableViewCell : UITableViewCell
@property(nullable,nonatomic,weak) id<SearchSymptomTableViewCellDelegate> delegate;
@property(nonatomic,retain) SearchSymptom* searchSymptom;

@end
