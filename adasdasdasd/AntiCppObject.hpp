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
typedef struct delegate *delegate1;
typedef struct delegate delegate2;
class AntiCppObject
{
public:
    delegate1 dele;
    delegate2 *dele2;
    AntiCppObject();
    ~AntiCppObject();
    void ExampleMethod(const std::string& str);
    // constructor, destructor, other members, etc.
};

#endif /* AntiCppObject_hpp */
