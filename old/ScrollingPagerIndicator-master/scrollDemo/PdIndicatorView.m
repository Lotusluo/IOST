//
//  PdIndicatorView.m
//  scrollDemo
//
//  Created by light_bo on 2018/11/20.
//  Copyright © 2018年 light_bo. All rights reserved.
//

#import "PdIndicatorView.h"
#import "PdDotCell.h"
#import "PdIndicatorView.h"

#define PdDotCellId @"PdDotCellId"

@interface PdIndicatorView ()
<UITableViewDelegate,UITableViewDataSource>
{
    
    NSInteger _selectIndex;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,assign)NSInteger totalCount;
@end

@implementation PdIndicatorView

- (void)initDataWithCount:(NSInteger)count {
    self.totalCount = count;
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
        if (self.totalCount <=4) {
            for (int i = 0; i<self.totalCount; i++) {
                [_dataArr addObject:@"small"];
            }
        }
        else if (self.totalCount >= 5) {
            
            for (int i = 0; i<self.totalCount; i++) {
                if (i<=2) {
                    _dataArr[i] = @"small";
                }
                [_dataArr addObject:@"smallest"];
            }
        }
        
    }
    _selectIndex = 0 ;
    [self initTableView];
    [self scrollAction:0 isLeft:YES]
    ;}

- (void)initTableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(100, 50, 20, 100) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor yellowColor];
        _tableView.delegate = self;
        _tableView.dataSource    = self;
        _tableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        _tableView.showsVerticalScrollIndicator=NO;
        [self addSubview:_tableView];
        [self.tableView registerClass:[PdDotCell class] forCellReuseIdentifier:PdDotCellId];
        
    }
}

- (void)scrollAction:(NSInteger )index isLeft:(BOOL)isLeft {
    _selectIndex = index;
    [self updateWithSelectIndex:index scrollLeft:isLeft];

    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    NSLog(@"currentSelectIndex:%d",_selectIndex);
    [self.tableView reloadData];

}

-(void)updateWithSelectIndex:(NSInteger)index scrollLeft:(BOOL)isLeft {//往左滚动
    if (self.totalCount <= 4) {
        return;
    }
    
    if (self.totalCount >= 5) {
        if (isLeft) {
            
            for (int i = 0; i<self.totalCount; i++) {
                _dataArr[i] = @"smallest";
            }
            
            if (index >= 2) {
                _dataArr[index] = @"small";
                _dataArr[index-1] = @"small";
                _dataArr[index-2] = @"small";
            }
            else {
                _dataArr[0] = @"small";
                _dataArr[1] = @"small";
                _dataArr[2] = @"small";
            }
        }
        else {
            
            for (int i = 0; i<self.totalCount; i++) {
                _dataArr[i] = @"smallest";
            }
            
            if (index <= self.totalCount-3) {
                _dataArr[index] = @"small";
                _dataArr[index+1] = @"small";
                _dataArr[index+2] = @"small";
            }
            else {
                _dataArr[self.totalCount-3] = @"small";
                _dataArr[self.totalCount-2] = @"small";
                _dataArr[self.totalCount-1] = @"small";
            }
            
        }
        
    }
    
    
}

#pragma mark -- tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.totalCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PdDotCell *cell = [tableView dequeueReusableCellWithIdentifier:PdDotCellId forIndexPath:indexPath];
    cell.imageName = [NSString stringWithFormat:@"indicator_dot_%@",_dataArr[indexPath.row]]; //;
    cell.imageSelected = (_selectIndex == indexPath.row) ? (YES):(NO);
    return cell;
}


@end
