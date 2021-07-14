//
//  PeopleCPP.cpp
//  adasdasdasd
//
//  Created by luotao on 2021/7/14.
//

#include "PeopleCPP.hpp"

PeopleCPP::PeopleCPP(void *target,InterfaceBridge iBridge){
    this->target = target;
    this->iBridge = iBridge;
    printf("PeopleCPP create\n");
}

PeopleCPP::~PeopleCPP(){
    printf("PeopleCPP delloc\n");
}

void PeopleCPP::doSomething(char *params){
    iBridge(target,params);
}
