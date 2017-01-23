//
//  MDoctoreWalletPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MDoctoreWalletPresenter.h"

@interface MDoctoreWalletPresenter ()<UIAlertViewDelegate>{
    NSInteger _page;
}


@end

@implementation MDoctoreWalletPresenter

-(instancetype)init{
    self= [super init];
    if(self){
        _page = 1;
        
    }
    return self;
}

-(void)loadWalletBalance{
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",kCurrentUser.userId]};
    WS(ws);
    [[FPNetwork POST:API_GETMYWALLETMONEY withParams:params] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            if (response.data!=nil) {
                NSArray *dataArr =(NSArray *)response.data;
                if (dataArr.count!=0&&(dataArr[0]!=nil)) {
                    NSDictionary *dataDict =[NSDictionary dictionaryWithDictionary:dataArr[0]];
                    NSString *money =[dataDict objectForKey:@"Money"];
                    
                    [ws.delegate onBalanceCompletion:YES info:money];
                }else{
                    [ws.delegate onBalanceCompletion:YES info:@"0"];
                }
                
            }else{
                [ws.delegate onBalanceCompletion:YES info:@"0"];
            }
            

//            NSLog(@"%@",ws.dataSource[0].balance);
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
    }];
}

- (void)loadWalletConsumption{
    
    _page = 1;
    
    if(self.dataSource){
        self.dataSource = nil;
    }
    
    NSDictionary* parames = @{@"userid":[NSString stringWithFormat:@"%ld",kCurrentUser.userId],@"PageIndex":@(_page),@"PageSize":@(kPageSize)};
    WS(ws);
    [[FPNetwork POST:API_GETMYCONSUMPTION withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        
        if(response.success&&response.data!=nil){
            NSLog(@"%@",response.data);
            [MWallet mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"money" : @"Money",
                         @"date"  : @"CreateTime",
                         @"remarks" : @"Remarks"
                         };
            }];
            ws.dataSource = [MWallet mj_objectArrayWithKeyValuesArray:response.data];
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
            [ws.delegate onCompletion:response.success info:response.message];
        }
        
    }];
    
}

-(void)loadMoreWalletConsumption{
    _page++;
    
    NSDictionary* parames = @{@"userid":[NSString stringWithFormat:@"%ld",kCurrentUser.userId],@"PageIndex":@(_page),@"PageSize":@(kPageSize)};
    WS(ws);
    [[FPNetwork POST:API_GETMYCONSUMPTION withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            if (response.data!=nil) {
                [MWallet mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"money" : @"Money",
                             @"date"  : @"CreateTime",
                             @"remarks" : @"Remarks"
                             };
                }];
                NSMutableArray* array = [MWallet mj_objectArrayWithKeyValuesArray:response.data];
                
                if(array.count != 0){
                    NSMutableArray* result = [NSMutableArray arrayWithArray:ws.dataSource];
                    [result addObjectsFromArray:array];
                    ws.dataSource = nil;
                    ws.dataSource = result;
                }else{
                    ws.noMoreData = YES;
                }

                        }
                    }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(MoreOnCompletion:info:)]){
            [ws.delegate MoreOnCompletion:response.success info:response.message];
        }
        
    }];

}


- (void)checkWalletAccount{
    
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",kCurrentUser.userId]};
    WS(ws);
    [[FPNetwork POST:API_HAVEMYWALLETPASS withParams:params] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            NSLog(@"%@",response.data);
            if ([response.data boolValue]==NO) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"要使用钱包功能,请先设置支付密码"] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag =1001;
                [alertView show];

            }
            
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
    }];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        if (self.delegate && [self.delegate respondsToSelector:@selector(popVC)]) {
            [self.delegate popVC];
        }
    
    }else if (buttonIndex==1){
        if (self.delegate && [self.delegate respondsToSelector:@selector(pushSetUpPass)]) {
            [self.delegate pushSetUpPass];
        }
    }
}

- (void)submitWalletPwd:(NSString *)password{
    WS(ws);
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",kCurrentUser.userId],@"pass":password};
    [[FPNetwork POST:API_SETPASSBYMYWALLET withParams:params] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            NSLog(@"%@",response);
            [((UIViewController *)ws.delegate).navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
    }];

}

@end
