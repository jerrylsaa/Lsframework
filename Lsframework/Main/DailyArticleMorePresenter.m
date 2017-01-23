//
//  DailyArticleMorePresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/10/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DailyArticleMorePresenter.h"
@interface DailyArticleMorePresenter (){
    NSInteger _page;

}
@end

@implementation DailyArticleMorePresenter

- (instancetype)init{
    if (self = [super init]) {
        _page = 1;
    }
    return self;
}

-(void)GetDailyArticleList{
    
    if(self.dataSource){
        [self.dataSource removeAllObjects];
        self.dataSource = nil;
    }
    _page = 1;

    
    NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId]};
    
    
    
    WS(ws);
    
    [[FPNetwork POST: GET_ARTICLES withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            if (response.data!=nil) {
                ws.dataSource = [DailyFirstArticle mj_objectArrayWithKeyValuesArray:response.data];

            }
    if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetDailyArticleListCompletion:info:)]){
                [ws.delegate GetDailyArticleListCompletion:response.success info:response.message];
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
    }];
    
}


-(void)GetDailyArticleMoreList{
    _page++;
    
    NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId]};
    WS(ws);
    
    [[FPNetwork POST:GET_ARTICLES withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            NSMutableArray* array = [DailyFirstArticle mj_objectArrayWithKeyValuesArray:response.data];
            
            if(array.count != 0){
                NSMutableArray* result = [NSMutableArray arrayWithArray:ws.dataSource];
                [result addObjectsFromArray:array];
                ws.dataSource = nil;
                ws.dataSource = result;
            }else{
                ws.noMoreData = YES;
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetDailyArticleMoreListCompletion:info:)]){
            [ws.delegate GetDailyArticleMoreListCompletion:response.success info:response.message];
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
