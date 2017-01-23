//
//  RecommendPresenter.m
//  FamilyPlatForm
//
//  Created by Mac on 16/11/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "RecommendPresenter.h"

@interface RecommendPresenter ()
{
    NSInteger _page;
    
}
@end

@implementation RecommendPresenter

-(instancetype)init
{
    if (self = [super init]) {
        _page = 1;
    }
    return self;
}
-(void)getRecommendList
{
    if (self.reommendSource) {
        [self.reommendSource removeAllObjects];
        self.reommendSource = nil;
    }
    _page = 1;
    
    NSDictionary *params = @{@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId]};
    
    WS(ws);
    [[FPNetwork POST:API_GetDayArticles withParams:params]addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            if (response.data != nil) {
                ws.reommendSource = [TodayRecommend mj_objectArrayWithKeyValuesArray:response.data];
            }
        }
        if (ws.delegate &&[ws.delegate respondsToSelector:@selector(GetRecommendListCompletion:info:)]) {
            [ws.delegate GetRecommendListCompletion:response.success info:response.message];
        }else
        {
            [ProgressUtil showError:@"网络故障"];
        }
    }];
}
-(void)getMoreRecommendList
{
    _page++;
    
    NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId]};
    WS(ws);
    
    [[FPNetwork POST:API_GetDayArticles withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            NSMutableArray* array = [TodayRecommend mj_objectArrayWithKeyValuesArray:response.data];
            
            if(array.count != 0){
                NSMutableArray* result = [NSMutableArray arrayWithArray:ws.reommendSource];
                [result addObjectsFromArray:array];
                ws.reommendSource = nil;
                ws.reommendSource = result;
            }else{
                ws.noMoreData = YES;
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetRecommendMoreListCompletion:info:)]){
            [ws.delegate GetRecommendMoreListCompletion:response.success info:response.message];
        }
        
    }];
}
//文章点赞
-(void)InsertArticlePraiseByArticleID:(NSNumber*)articleID{
    WS(ws);
    NSDictionary* parames = @{@"ArticleID":articleID,@"UserID":@(kCurrentUser.userId)};
    
    [[FPNetwork POST: API_INSERT_ARTICLEPRAISE withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            
            
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(InsertArticlePraiseCommentCompletion:info:)]){
                [ws.delegate InsertArticlePraiseCommentCompletion:response.success info:response.message];
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
    }];
}
//取消点赞
-(void)CancelArticlePraiseByArticleID:(NSNumber*)articleID{
    WS(ws);
    NSDictionary* parames = @{@"ArticleID":articleID,@"UserID":@(kCurrentUser.userId)};
    
    [[FPNetwork POST: API_CANCEL_ARTICLEPRAISE withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            
            
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(CancelArticlePraiseCommentCompletion:info:)]){
                [ws.delegate CancelArticlePraiseCommentCompletion:response.success info:response.message];
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
    }];
    
    
    
}
@end
