//
//  AntiCppObject.cpp
//  adasdasdasd
//
//  Created by luotao on 2021/7/7.
//

#include "AntiCppObject.hpp"
#import "TestView.h"

struct delegate{
    TestView* oc;
};

AntiCppObject::AntiCppObject(){
    dele2 = new delegate;
    dele2 -> oc = [TestView new];
    printf("AntiCppObject 初始化\n");
}

AntiCppObject::~AntiCppObject(){
    delete dele;
    printf("AntiCppObject 销毁\n");
}

void AntiCppObject::ExampleMethod(const std::string& str){
    const char *cString = str.c_str();
    NSString * cocoaString = [[NSString alloc] initWithCString:cString encoding:NSUTF8StringEncoding];
    [dele->oc say:cocoaString];
}



