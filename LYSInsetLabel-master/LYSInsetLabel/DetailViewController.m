//
//  DetailViewController.m
//  LYSInsetLabel
//
//  Created by jk on 2017/3/7.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "DetailViewController.h"
#import "LYSInsetLabel.h"

@interface DetailViewController ()

@property(nonatomic,strong)LYSInsetLabel *label;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

-(LYSInsetLabel*)label{
    if (!_label) {
        _label = [[LYSInsetLabel alloc]init];
        _label.numberOfLines = 0;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor redColor];
        _label.font = [UIFont systemFontOfSize:14];
        _label.edgeInsets = UIEdgeInsetsMake(10, 40, 10, 10);
        _label.layer.borderWidth = 2;
    }
    return _label;
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
    self.label.frame = CGRectMake(10, 120, self.view.frame.size.width - 20, 60);
    [self.view addSubview:self.label];
     self.label.text = @"Do any additional setup after loading the view, typically from a nibDo any additional setup after loading the view, typically from a nibDo any additional setup after loading the view, typically from a nibDo any additional setup after loading the view, typically from a nib";
    [self.label sizeToFit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
