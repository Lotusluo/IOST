//
//  TrickCpp.hpp
//  adasdasdasd
//
//  Created by luotao on 2021/7/8.
//

#ifndef TrickCpp_hpp
#define TrickCpp_hpp

#include <stdio.h>
#include <iostream>
#include "TrickInterface.h"
class TrickCpp
{
void* myoc;
    interface mycall;
public:
    TrickCpp();
    TrickCpp(void* oc,interface call);
    ~TrickCpp();
    void function();
    // constructor, destructor, other members, etc.
};


#endif /* TrickCpp_hpp */
