//
//  PeopleOC.m
//  adasdasdasd
//
//  Created by luotao on 2021/7/14.
//

#import "PeopleOC.h"
#import <objc/runtime.h>

NSString *test = @"a";


@implementation PeopleOC{
    NSString *str;
}

-(instancetype)init{
    self = [super init];
    if(self){
        str = @"a";
        NSLog(@"create call");
    }
    return self;
}

-(NSString*)saySomethings:(NSString*)params{
    NSLog(@"-PeopleOC:%@",params);
    return [NSString stringWithFormat:@"Tranfer with %@",params];
}

+(void)saySomethings:(NSString*)params{
    NSLog(@"+PeopleOC:%@",params);
}

+(BOOL)resolveInstanceMethod:(SEL)sel{
    if(sel == @selector(saySomethingsNew:)){
//        Method method = class_getInstanceMethod(self.class, @selector(eatOC:));
//        class_addMethod(
//                        self,
//                        sel,
//                        method_getImplementation(method),
//                        method_getTypeEncoding(method));
        
        class_addMethod(
                        self,
                        sel,
                        (IMP)eat,
                        "v@:*");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

void eat(id self,SEL _cmd,char* msg){
    void *t = (__bridge_retained void*)self;
    if(t){
        printf("a\n");
    }
    free(t);
//    printf("%s", msg);
}

-(void)eatOC:(NSString*) _msg{
    
}

-(void)ritl_borderlayoutsubViews{
}
@end
