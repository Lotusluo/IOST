//
//  JADataModel.h
//  JATableCellNestTableDemo
//
//  Created by JasoneIo on 16/6/27.
//  Copyright © 2016年 littleBoy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface picurls : NSObject

@property (nonatomic,copy) NSString *img; //图片链接

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)picUrlWithDict:(NSDictionary *)dict;
@end

@interface dayjourney : NSObject

@property (nonatomic,copy) NSString *theme; //主题
@property (nonatomic,copy) NSString *content;//内容
@property (nonatomic,copy) NSString *type; //iocn 显示类型
@property (nonatomic,assign,getter=isLastRow) BOOL lastRow;

@property (nonatomic,strong) NSMutableArray <NSString *> *journeyrange;//行程细项
@property (nonatomic,strong) NSMutableArray <picurls *> *picurls;//图片

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)dayJourneyWithDict:(NSDictionary *)dict;
@end

@interface JADataModel : NSObject

@property (nonatomic,copy) NSString *outday;//天
@property (nonatomic,copy) NSString *title; //标题
@property (nonatomic,strong) NSMutableArray <dayjourney *> *dayjourney;
@property (nonatomic,assign,getter=isHideTopLine) BOOL hideTopLine;
@property (nonatomic,assign,getter=isLastSection) BOOL lastSetion;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)dataModelWithDict:(NSDictionary *)dict;

+ (NSArray *)fetchDataModelList;
@end
