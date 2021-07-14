//
//  TrickOC.m
//  adasdasdasd
//
//  Created by luotao on 2021/7/8.
//

#import "TrickOC.h"
#import "TrickInterface.h"

void MyObjectDoSomethingWith(void * obj, void *aParameter){
    [(__bridge id) obj dosthing:aParameter];
}

@implementation TrickOC

-(id)init {
    self = [super init];
    if (self) {
        self.call = MyObjectDoSomethingWith;
    }
    return self;
}

-(int)dosthing:(void *)param{
    char *text = param;
    NSLog(@"OC DO:%@",[[NSString alloc] initWithUTF8String:text]);
    return 0;
}
@end
