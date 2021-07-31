//
//  ArchPlistUtils.h
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2019/7/25.
//  Copyright © 2019 test. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArchPlistUtils : NSObject
+(void) save:(NSDictionary *) dict fileName:(NSString *)fileName;
+(NSDictionary *) getPlist:(NSString *)fileName;
+(void) remove:(NSString *)fileName;
+(NSArray *) getAllPilstObject;
@end

NS_ASSUME_NONNULL_END
