//
//  YFNoteDataManager.h
//  BigShow1949
//
//  Created by big show on 2018/10/16.
//  Copyright © 2018年 BigShowCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFNoteListDataService.h"
@class YFNoteModel;
@interface YFNoteDataManager : NSObject<YFNoteListDataService>
@property (nonatomic, readonly, strong) NSArray<YFNoteModel *> *noteList;
+ (instancetype)sharedInsatnce;
- (void)fetchAllNotesWithCompletion:(void(^)(NSArray *notes))completion;
- (void)storeNote:(YFNoteModel *)note;
- (void)deleteNote:(YFNoteModel *)noteToDelete;
@end
