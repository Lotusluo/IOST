//
//  AntiCppObject.hpp
//  adasdasdasd
//
//  Created by luotao on 2021/7/7.
//

#ifndef AntiCppObject_hpp
#define AntiCppObject_hpp

#include <iostream>
struct delegate;
class AntiCppObject
{
public:
    delegate* dele;
    AntiCppObject();
    ~AntiCppObject();
    void ExampleMethod(const std::string& str);
    // constructor, destructor, other members, etc.
};

#endif /* AntiCppObject_hpp */
