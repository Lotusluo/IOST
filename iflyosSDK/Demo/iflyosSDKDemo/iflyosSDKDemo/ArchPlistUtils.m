//
//  ArchPlistUtils.m
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2019/7/25.
//  Copyright © 2019 test. All rights reserved.
//

#import "ArchPlistUtils.h"

@implementation ArchPlistUtils
+(NSString *) getPath:(NSString *) fileName{
    //将字典保存到document文件->获取appdocument路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dirPath = [docPath stringByAppendingPathComponent:@"plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL dataIsDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    BOOL dataExisted = [fileManager fileExistsAtPath:dirPath isDirectory:&dataIsDir];
    if ( !(isDir == YES && existed == YES) ) {//如果文件夹不存在
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //要创建的plist文件名 -> 路径
    NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
    return filePath;
}

+(void) save:(NSDictionary *) dict fileName:(NSString *)fileName{
    if (dict && fileName) {
        NSString *path = [ArchPlistUtils getPath:[NSString stringWithFormat:@"%@.plist",fileName]];
        [dict writeToFile:path atomically:YES];
    }
}

+(NSDictionary *) getPlist:(NSString *)fileName{
    NSString *path = [ArchPlistUtils getPath:[NSString stringWithFormat:@"%@.plist",fileName]];
    //反序列化
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    return dict;
}

+(void) remove:(NSString *)fileName{
    NSString *path = [ArchPlistUtils getPath:[NSString stringWithFormat:@"%@.plist",fileName]];
    // 判断要删除的文件是否存在
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if ([fileManage fileExistsAtPath:path]) {
        
        NSLog(@"文件存在");
        
        // 删除
        
        BOOL isSuccess = [fileManage removeItemAtPath:path error:nil];
        
        NSLog(@"%@",isSuccess ? @"删除成功" : @"删除失败");
        
    }else{
        
        NSLog(@"文件不存在");
        
    }
}

+(NSArray *) getAllPilstObject{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dirPath = [docPath stringByAppendingPathComponent:@"plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *myDirectoryEnumerator = [fileManager enumeratorAtPath:dirPath];
    
    BOOL isDir = NO;
    BOOL isExist = NO;
    
    //列举目录内容，可以遍历子目录
    for (NSString *path in myDirectoryEnumerator.allObjects) {
        
        NSLog(@"%@", path);  // 所有路径
        
        isExist = [fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", dirPath, path] isDirectory:&isDir];
        if (isDir) {
            NSLog(@"%@", path);    // 目录路径
        } else {
            NSLog(@"%@", path);    // 文件路径
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", dirPath, path]];
            if (dict) {
                [array addObject:dict];
            }
        }
    }
    return array;
}

@end
