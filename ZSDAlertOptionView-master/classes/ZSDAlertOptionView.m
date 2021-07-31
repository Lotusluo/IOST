//
//  ZSDAlertOptionView.m
//  demo
//
//  Created by zhaoxiao on 15/2/28.
//  Copyright (c) 2015年 zhaoxiao. All rights reserved.
//----------------popup选项列表------------------

#import "ZSDAlertOptionView.h"
#import "OptionCell.h"

#define kRowHeight 45.0f
#define kDefaultLine 6

@interface ZSDAlertOptionView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *optionTable;
}

@end

@implementation ZSDAlertOptionView

-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        
        [self setup];
    }
    
    return self;
}

-(void)setup
{
    if(!optionTable)
    {
        CGRect frect = CGRectZero;
        frect.origin.y = self.bounds.size.height;
        frect.size.width = self.bounds.size.width;
        frect.size.height = kRowHeight * kDefaultLine;
        optionTable = [[UITableView alloc]initWithFrame:frect style:UITableViewStylePlain];
        optionTable.dataSource = self;
        optionTable.delegate = self;
        optionTable.showsVerticalScrollIndicator = NO;
        optionTable.showsHorizontalScrollIndicator = NO;
//        optionTable.bounces = NO;
        optionTable.separatorInset = UIEdgeInsetsMake(0, 16.0f, 0, 16.0f);
        
        [optionTable registerNib:[UINib nibWithNibName:@"OptionCell" bundle:nil] forCellReuseIdentifier:@"OptionCell"];
    }
    
    [self addSubview:optionTable];
}

#pragma mark ---
#pragma mark -UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _optionList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"OptionCell";
    
    OptionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ZSDOptionItem *optionItem = [_optionList objectAtIndex:indexPath.row];
    cell.optionItem = optionItem;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == _selectIndex)
    {
        [cell setSelected:YES];
    }
    else
    {
        [cell setSelected:NO];
    }
}

#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndex = indexPath.row;
    [optionTable reloadData];
    
    if(_delegate && [_delegate respondsToSelector:@selector(optionView:didSelectIndex:)])
    {
        [_delegate optionView:self didSelectIndex:_selectIndex];
    }
    [self hide];
}

-(void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    CGRect frect = self.frame;
    frect.origin.y = self.bounds.size.height - frect.size.height;
//    [UIView animateWithDuration:0.5f animations:^{
//        self.frame = frect;
//    }];
}

-(void)hide
{
    CGRect frect = optionTable.frame;
    frect.origin.y = self.bounds.size.height;
    
    [UIView animateWithDuration:0.5f animations:^{
        optionTable.frame = frect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
