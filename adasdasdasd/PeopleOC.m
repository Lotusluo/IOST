//
//  PeopleOC.m
//  adasdasdasd
//
//  Created by luotao on 2021/7/14.
//

#import "PeopleOC.h"

NSString *test = @"a";


@implementation PeopleOC

-(instancetype)init{
    self = [super init];
    if(self){
        NSLog(@"create call");
    }
    return self;
}

-(NSString*)saySomethings:(NSString*)params{
    NSLog(@"PeopleOC:%@",params);
    return [NSString stringWithFormat:@"Tranfer with %@",params];
}

@end
