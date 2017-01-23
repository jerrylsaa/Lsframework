//
//  KeyWordsTableView.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "KeyWordsTableView.h"

@implementation KeyWordsTableView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self setupView];
    }
    return self ;
}

-(instancetype)init{
    self= [super init];
    if(self){
        [self setupView];
    }
    return self;
}

-(void)setupView{
    UITableView* table = [UITableView new];
    table.delegate = self;
    table.dataSource = self;
    [self addSubview:table];
    self.keyWordTable = table;
    
    table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [table registerClass:[KeyWordsTableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

#pragma mark - 代理
#pragma mark * tableView代理
/**
 *  tableView的数据源代理
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KeyWordsTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    WS(ws);
    cell.deleteKeyWordBlock = ^(UITableViewCell* cell){
        NSIndexPath* currentIndexPath = [tableView indexPathForCell:cell];
        
        NSString* keyWords = ws.dataSource[currentIndexPath.row];
        WSLog(@"删除关键词 = %@",keyWords);
        
        [ws.dataSource removeObjectAtIndex:currentIndexPath.row];
        [ws.keyWordTable reloadData];
        
        //删除数据库中对应的关键词
        [SearchKeyWordsEntity deleteKeyWords:keyWords];
        
        ws.hidden = ws.dataSource.count == 0;
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickKeyWords:)]){
        [self.delegate clickKeyWords:self.dataSource[indexPath.row]];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"搜索历史";
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setTextColor:UIColorFromRGB(0x999999)];
    footer.textLabel.font = [UIFont  systemFontOfSize:14];
    view.tintColor = UIColorFromRGB(0xf2f2f2);
}
#pragma mark * scrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.DidEndScrollBlock();
}








@end
