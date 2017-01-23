//
//  SystemNotiecPresenter.m
//  FamilyPlatForm
//
//  Created by Mac on 16/12/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "SystemNotiecPresenter.h"

@interface SystemNotiecPresenter ()
{
    NSInteger _page;
    
}
@end

@implementation SystemNotiecPresenter


-(instancetype)init
{
    if (self = [super init]) {
        _page = 1;
    }
    return self;
}

-(void)isReadNoticeWithUuid:(NSNumber *)uuid sysBlock:(SystemNoticeBlock)block
{
    
    NSDictionary *params = @{@"UUID":uuid,@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId]};
    [[FPNetwork POST:API_setmessageread withParams:params]addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
             NSLog(@"setmessageread 红点 is--  %@",response.data);
            BOOL success;
            if ([response.data integerValue] == 1) {
                NSLog(@"adfsa");
                success =YES;
            }else{
                
                success = NO;
            }
            
            block(success);
        }
        
     }];
    
}
-(void)loadSystemNotice:(NSString *)url
{
    if (self.dataSource) {
        [self.dataSource removeAllObjects];
        self.dataSource = nil;
    }
    _page = 1;
    
    WS(ws);
        NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId]};
        [[FPNetwork POST:url withParams:parames]addCompleteHandler:^(FPResponse *response) {
            if (response.success) {
                
                ws.dataSource = [SystemNotice mj_objectArrayWithKeyValuesArray:response.data];
            }
            if (ws.delegate &&[ws.delegate respondsToSelector:@selector(GetSystemNoticeCompletion:info:)]) {
                [ws.delegate GetSystemNoticeCompletion:response.success info:response.message];
            }else{
                [ProgressUtil showError:@"网络故障"];
            }
        }];
    
    
    
}
-(void)loadSystemMoreNotiec:(NSString *)url 
{
        _page++;

        NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId]};
        WS(ws);
        
        [[FPNetwork POST:url withParams:parames] addCompleteHandler:^(FPResponse *response) {
            if (response.success) {
                NSMutableArray* array = [SystemNotice mj_objectArrayWithKeyValuesArray:response.data];
                
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
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetSystemNoticeMoreListCompletion:info:)]){
                [ws.delegate GetSystemNoticeMoreListCompletion:response.success info:response.data];
            }
        }];
    
    
}
-(void)loadSystemNotice:(NSString *)url ModelType:(SegmentNoticeType)type
{
    NSString *userid = [NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId];
//    NSString *userid = @"48";
    
    WS(ws);
    switch (type) {
        case SegmentSystemType:
        {
            if (self.dataSource) {
                [self.dataSource removeAllObjects];
                self.dataSource = nil;
            }
            _page = 1;
            NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"UserID":userid};
            [[FPNetwork POST:url withParams:parames]addCompleteHandler:^(FPResponse *response) {
                if (response.success) {
                    
                    ws.dataSource = [SystemNotice mj_objectArrayWithKeyValuesArray:response.data];
                }
                if (ws.delegate &&[ws.delegate respondsToSelector:@selector(GetSystemNoticeCompletion:info:)]) {
                    [ws.delegate GetSystemNoticeCompletion:response.success info:response.message];
                }else{
                    [ProgressUtil showError:@"网络故障"];
                }
            }];
            
        }
            break;
        case SegmentCommentType:
        {
            if (self.commentSource) {
                [self.commentSource removeAllObjects];
                self.commentSource = nil;
            }
            _page = 1;
            NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"UserID":userid};
            [[FPNetwork POST:url withParams:parames]addCompleteHandler:^(FPResponse *response) {
                if (response.success) {

                    ws.commentSource = [CMyComment mj_objectArrayWithKeyValuesArray:response.data];
                }
                if (ws.delegate &&[ws.delegate respondsToSelector:@selector(GetSystemNoticeCompletion:info:)]) {
                    [ws.delegate GetSystemNoticeCompletion:response.success info:response.message];
                }else{
                    [ProgressUtil showError:@"网络故障"];
                }
            }];
            
        }
            break;
        case SegmentFavouriteType:
        {
            if (self.favoriteSource) {
                [self.favoriteSource removeAllObjects];
                self.favoriteSource = nil;
            }
            _page = 1;

            NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"UserID":userid};
            [[FPNetwork POST:url withParams:parames]addCompleteHandler:^(FPResponse *response) {
                if (response.success) {
                    ws.favoriteSource = [MyFavorite mj_objectArrayWithKeyValuesArray:response.data];
                }
                if (ws.delegate &&[ws.delegate respondsToSelector:@selector(GetSystemNoticeCompletion:info:)]) {
                    [ws.delegate GetSystemNoticeCompletion:response.success info:response.message];
                }else{
                    [ProgressUtil showError:@"网络故障"];
                }
            }];
            
        }
            break;
            
        case SegmentListenType:
        {

            if (self.ListenSource) {
                [self.ListenSource removeAllObjects];
                self.ListenSource = nil;
            }
            _page = 1;

            NSDictionary *parames = [NSDictionary dictionaryWithObjectsAndKeys:@(_page),@"PageIndex",@(kPageSize),@"PageSize",userid,@"UserID", nil];
            [[FPNetwork POST:url withParams:parames]addCompleteHandler:^(FPResponse *response) {
                if (response.success) {
                    
                    ws.ListenSource = [CConsultationBeListen mj_objectArrayWithKeyValuesArray:response.data];

                }
                if (ws.delegate &&[ws.delegate respondsToSelector:@selector(GetSystemNoticeCompletion:info:)]) {
                    [ws.delegate GetSystemNoticeCompletion:response.success info:response.message];
                }else{
                    [ProgressUtil showError:@"网络故障"];
                }
            }];
            
        }
            break;
            
        default:
            break;
    }
    
}
-(void)loadSystemMoreNotiec:(NSString *)url ModelType:(SegmentNoticeType)type
{
    switch (type) {
        case SegmentSystemType:
        {
            _page++;
            
            NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId]};
            WS(ws);
            
            [[FPNetwork POST:url withParams:parames] addCompleteHandler:^(FPResponse *response) {
                if (response.success) {
                    NSMutableArray* array = [SystemNotice mj_objectArrayWithKeyValuesArray:response.data];
                    
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
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetSystemNoticeMoreListCompletion:info:)]){
                    [ws.delegate GetSystemNoticeMoreListCompletion:response.success info:response.data];
                }
            }];
            
        }
            break;
        case SegmentCommentType:
        {
            _page++;
            
            NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId]};
            WS(ws);
            
            [[FPNetwork POST:url withParams:parames] addCompleteHandler:^(FPResponse *response) {
                if (response.success) {
                    NSMutableArray* array = [CMyComment mj_objectArrayWithKeyValuesArray:response.data];
                    
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
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetSystemNoticeMoreListCompletion:info:)]){
                    [ws.delegate GetSystemNoticeMoreListCompletion:response.success info:response.data];
                }
            }];
            
        }
            break;
        case SegmentFavouriteType:
        {
            _page++;
            
            NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId]};
            WS(ws);
            
            [[FPNetwork POST:url withParams:parames] addCompleteHandler:^(FPResponse *response) {
                if (response.success) {
                    NSMutableArray* array = [MyFavorite mj_objectArrayWithKeyValuesArray:response.data];
                    
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
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetSystemNoticeMoreListCompletion:info:)]){
                    [ws.delegate GetSystemNoticeMoreListCompletion:response.success info:response.data];
                }
            }];
            
        }
            break;
            
        case SegmentListenType:
        {
            _page++;
            
            NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId]};
            WS(ws);
            
            [[FPNetwork POST:url withParams:parames] addCompleteHandler:^(FPResponse *response) {
                if (response.success) {
                    NSMutableArray* array = [CConsultationBeListen mj_objectArrayWithKeyValuesArray:response.data];
                    
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
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetSystemNoticeMoreListCompletion:info:)]){
                    [ws.delegate GetSystemNoticeMoreListCompletion:response.success info:response.data];
                }
            }];
            
        }
            break;
            
        default:
            break;
    }
    
}

@end
