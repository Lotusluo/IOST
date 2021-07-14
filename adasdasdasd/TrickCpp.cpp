//
//  TrickCpp.cpp
//  adasdasdasd
//
//  Created by luotao on 2021/7/8.
//

#include "TrickCpp.hpp"
#include "TrickInterface.h"
TrickCpp::TrickCpp(void* oc,interface call){
    myoc = oc;
    mycall = call;
}
TrickCpp::~TrickCpp(){
    
}
void TrickCpp::function(){
    const char *words = "function";
    mycall(myoc,(void *)words);
}
