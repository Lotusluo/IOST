//
//  Mall.m
//  10_RunTime
//
//  Created by luotao on 2021/4/14.
//  Copyright © 2021 tengfei. All rights reserved.
//

#import "Mall.h"

@interface Mall()

@property (nonatomic, strong) NSMutableArray<id> *stock;

@end

@implementation Mall

- (instancetype)init {
    self = [super init];
    if (self) {
        _stock = [NSMutableArray array];
    }
    return self;
}

- (void)buy:(id)product {
    [_stock addObject:product];
}

- (id)sell {
    id res = _stock.lastObject;
    [_stock removeLastObject];
    return res;
}

@end
