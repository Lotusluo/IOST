//
//  PeopleCPP.hpp
//  adasdasdasd
//
//  Created by luotao on 2021/7/14.
//

#ifndef PeopleCPP_hpp
#define PeopleCPP_hpp

#include <stdio.h>
#include "CustomBridge.h"

class PeopleCPP{
private:
    InterfaceBridge iBridge;
    void *target;
public:
    PeopleCPP(void *target,InterfaceBridge iBridge);
    ~PeopleCPP();
    void doSomething(char *params);
};

#endif /* PeopleCPP_hpp */
