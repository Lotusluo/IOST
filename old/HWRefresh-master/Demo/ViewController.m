//
//  ViewController.m
//  Demo
//
//  Created by Howe on 16/2/23.
//  Copyright © 2016年 Howe. All rights reserved.
//

#import "ViewController.h"
#import "HWHeadRefresh.h"
#import "HWFooterRefresh.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak)HWHeadRefresh *headrefresh;
@property (nonatomic, weak)HWFooterRefresh *footerrefresh;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightTextColor];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    HWHeadRefresh *headrefresh = HWHeadRefresh.new;
    [self.tableView addSubview:headrefresh];
    self.headrefresh = headrefresh;
    [headrefresh hw_addFooterRefreshWithView:self.tableView hw_footerRefreshBlock:^{
    }];
//
//    HWFooterRefresh *footerrefresh = HWFooterRefresh.new;
//    [self.tableView addSubview:footerrefresh];
//    self.footerrefresh = footerrefresh;
//    [footerrefresh hw_addFooterRefreshWithView:self.tableView hw_footerRefreshBlock:^{
//    }];
//
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0)
//    {
//        [self.headrefresh hw_toRfreshState];
//        return;
//    }
//
//    if (indexPath.row == 1)
//    {
//        [self.headrefresh hw_endRefreshState];
//        return;
//    }
//    if (indexPath.row == 18)
//    {
//        [self.footerrefresh hw_toRfreshState];
//        return;
//    }
//    if (indexPath.row == 19)
//    {
//        [self.footerrefresh hw_endRefreshState];
//        return;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
