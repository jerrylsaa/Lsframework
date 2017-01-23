//
//  PraisePresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/9/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PraisePresenter.h"

@interface PraisePresenter (){
    NSInteger _page;
    NSNumber* _ArticleID;
    
}

@end

@implementation PraisePresenter


-(instancetype)init{
    self= [super init];
    if(self){
        _page = 1;
        
    }
    return self;
}

-(void)getPraiseListWithArticleID:(NSNumber*)ArticleID{
    if(self.dataSource){
        self.dataSource = nil;
    }
    _page = 1;
    _ArticleID = ArticleID;

    NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"ArticleID":ArticleID,@"UserID":@(kCurrentUser.userId)};
    

    WS(ws);

    [[FPNetwork POST: API_GET_ARTICLECOMMENTLIST withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            if (response.data!=nil) {
                ws.dataSource = [PraiseList mj_objectArrayWithKeyValuesArray:response.data];
                
                 ws.totalCount = response.totalCount;
            }
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetPraiseListCompletion:info:)]){
                [ws.delegate GetPraiseListCompletion:response.success info:response.message];
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
    }];

}


-(void)getMorePraiseList{
    _page++;
    
    NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"ArticleID":_ArticleID,@"UserID":@(kCurrentUser.userId)};
    WS(ws);
    
    [[FPNetwork POST:API_GET_ARTICLECOMMENTLIST withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            NSMutableArray* array = [PraiseList mj_objectArrayWithKeyValuesArray:response.data];
            
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
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetMorePraiseListCompletion:info:)]){
            [ws.delegate GetMorePraiseListCompletion:response.success info:response.message];
        }
        
    }];
}


-(void)insertArticleCommentWithArticleID:(NSNumber*)ArticleID CommentID:(NSNumber*)commentID UserID:(NSNumber*)userid CommentContent:(NSString*)CommentContent{

    WS(ws);
    NSDictionary* parames = @{@"ArticleID":ArticleID,@"CommentID":commentID,@"UserID":userid,@"CommentContent":CommentContent};
    
    [[FPNetwork POST: API_INSERT_ARTICLECOMMENT withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            
            
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(insertArticleCommentCompletion:info:)]){
                [ws.delegate insertArticleCommentCompletion:response.success info:response.message];
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
    }];
}
//获取文章是否点赞
-(void)getArticlePraiseByArticleID:(NSNumber*)articleID{
    WS(ws);
    NSDictionary* parames = @{@"ArticleID":articleID,@"UserID":@(kCurrentUser.userId)};
    
    [[FPNetwork POST: API_GET_ARTICLEPRAISEBYUSERID withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            NSLog(@"点赞1：%@",response.data);
            NSNumber  *praise = response.data;
            NSLog(@"点赞11：%@",praise);
            if ([[NSString  stringWithFormat:@"%@",praise] isEqualToString:@"0"]) {
                ws.ispraise = NO;
            }else{
                ws.ispraise = YES;
            }
            
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetArticlePraiseCompletion:info:)]){
                [ws.delegate GetArticlePraiseCompletion:response.success info:response.message];
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
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
