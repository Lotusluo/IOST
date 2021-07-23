//
//  PeopleOC.h
//  adasdasdasd
//
//  Created by luotao on 2021/7/14.
//

#import <Foundation/Foundation.h>
#import "CustomBridge.h"



NS_ASSUME_NONNULL_BEGIN
extern NSString *test;

static NSString *test1;

@interface PeopleOC : NSObject

@property(nonatomic,strong)NSString *testParams;

@property(nonatomic)InterfaceBridge call;

-(NSString*)saySomethings:(NSString*)params;

+(void)saySomethings:(NSString*)params;

@end

NS_ASSUME_NONNULL_END
