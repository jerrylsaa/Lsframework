//
//  GBSearchPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GBSearchPresenter.h"

@interface GBSearchPresenter (){
    NSInteger index;
    NSString* searchKeyWord;
}

@end

@implementation GBSearchPresenter

-(instancetype)init{
    self= [super init];
    if(self){
        index = 1;
    }
    return self;
}


-(void)loadSearchResultWithKeyWords:(NSString *)keyWords{
    index = 1;
    searchKeyWord = keyWords;
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId), @"KeyWord":keyWords, @"PageIndex":@(index), @"PageSize":@(kPageSize)};
    
    WS(ws);
    [[FPNetwork POST:API_Search_Doctor_Article_ConsultationV3 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.success) {
            
//            ws.dataSource = [SearchResultEntity mj_objectArrayWithKeyValuesArray:response.data];
            ws.dataSource = response.data;

            
            ws.totalCount = response.totalCount;
            ws.noMoreData = (response.totalCount <= kPageSize);

        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadSearchResultComplete:info:)]){
            [ws.delegate loadSearchResultComplete:response.success info:response.message];
        }
        
    }];

}

-(void)laodMoreSearchResult{
    index += 1;
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId), @"KeyWord":searchKeyWord, @"PageIndex":@(index), @"PageSize":@(kPageSize)};

    WS(ws);
    [[FPNetwork POST:API_Search_Doctor_Article_ConsultationV3 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.success) {
            
//            NSMutableArray* array = [SearchResultEntity mj_objectArrayWithKeyValuesArray:response.data];
            NSMutableArray* array = response.data;

            if(array.count != 0){
                if(ws.dataSource.count != 0){
                    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:ws.dataSource];
                    [tempArray addObjectsFromArray:array];
                    ws.dataSource = tempArray;
                }else{
                    ws.dataSource = array;
                }

            }else{
                ws.noMoreData = YES;
            }
            
            
            ws.totalCount = response.totalCount;
//            ws.noMoreData = (response.totalCount <= kPageSize);
            
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadSearchResultComplete:info:)]){
            [ws.delegate loadSearchResultComplete:response.success info:response.message];
        }
        
    }];


}

-(void)NotificationRefreshSearchResult{
    
    
    [self  loadSearchResultWithKeyWords:searchKeyWord];
    
}

-(void)clickPraiseWith:(NSIndexPath *)indexPath type:(NSInteger)type{
    
    NSDictionary* dic = self.dataSource[indexPath.row];
    
    
    CircleEntity* circleEntity = [CircleEntity mj_objectWithKeyValues:dic];
    NSString *consultationID = [NSString stringWithFormat:@"%@",circleEntity.uuid];
    
    NSString *consultationType;
    if (type == 0) {
        consultationType = @"1";//语音
    }else{
        consultationType = @"2";//发帖
    }

    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId),@"ConsultationType":consultationType,@"ConsultationID":consultationID};
    
    WS(ws);
    [ProgressUtil show];
    [[FPNetwork POST:INSERT_CONSULTATION_PRAISE withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.success){
            [ProgressUtil showSuccess:@"成功点赞"];
            
            //修改数据源
            
            NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithDictionary:ws.dataSource[indexPath.row]];
            
            
            NSNumber* praiseCount = [tempDic valueForKey:@"PraiseCount"];
            if([praiseCount isKindOfClass:[NSNull class]]){
                praiseCount = @0;
            }
            
            praiseCount = [NSNumber numberWithInteger:[praiseCount integerValue] + 1];
            
            [tempDic setValue:praiseCount forKey:@"PraiseCount"];
            [tempDic setValue:@1 forKey:@"isPraise"];

            NSMutableArray* tempArray = [NSMutableArray arrayWithArray:ws.dataSource];
            [tempArray replaceObjectAtIndex:indexPath.row withObject:tempDic];
            ws.dataSource = tempArray;

            
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(praiseOnComplete:)]){
                [ws.delegate praiseOnComplete:indexPath];
            }
            
        }else{
            [ProgressUtil showError:@"点赞失败"];
        }
        
    }];

    
    
}

-(void)cancelPraiseWith:(NSIndexPath *)indexPath type:(NSInteger)type{
    
    NSDictionary* dic = self.dataSource[indexPath.row];
    
    
    CircleEntity* circleEntity = [CircleEntity mj_objectWithKeyValues:dic];
    NSString *consultationID = [NSString stringWithFormat:@"%@",circleEntity.uuid];
    
    NSString *consultationType;
    if (type == 0) {
        consultationType = @"1";
    }else{
        consultationType = @"2";
    }
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId),@"ConsultationType":consultationType,@"ConsultationID":consultationID};
    
    WS(ws);
    [ProgressUtil show];
    [[FPNetwork POST:CANCEL_CONSULTATION_PRAISE withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.success){
            [ProgressUtil showSuccess:@"取消点赞成功"];
            
            //修改数据源
            
            NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithDictionary:ws.dataSource[indexPath.row]];
            
            
            NSNumber* praiseCount = [tempDic valueForKey:@"PraiseCount"];
            if([praiseCount isKindOfClass:[NSNull class]]){
                praiseCount = @1;
            }
            
            praiseCount = [NSNumber numberWithInteger:[praiseCount integerValue] - 1];
            
            [tempDic setValue:praiseCount forKey:@"PraiseCount"];
            [tempDic setValue:@0 forKey:@"isPraise"];
            
            NSMutableArray* tempArray = [NSMutableArray arrayWithArray:ws.dataSource];
            [tempArray replaceObjectAtIndex:indexPath.row withObject:tempDic];
            ws.dataSource = tempArray;
            
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(praiseOnComplete:)]){
                [ws.delegate praiseOnComplete:indexPath];
            }
            
        }else{
            [ProgressUtil showError:@"取消点赞失败"];
        }
        
    }];

}


@end
