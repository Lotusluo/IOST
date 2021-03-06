/*
 * This file is part of the JPVideoPlayer package.
 * (c) NewPan <13246884282@163.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * Click https://github.com/newyjp
 * or http://www.jianshu.com/users/e2f2d779c022/latest_articles to contact me.
 */

#import "JPVideoPlayerResourceLoader.h"
#import "JPVideoPlayerCompat.h"
#import "JPVideoPlayerCacheFile.h"
#import "JPVideoPlayerCachePath.h"
#import "JPVideoPlayerManager.h"
#import "JPResourceLoadingRequestTask.h"
#import "JPVideoPlayerSupportUtils.h"
#import <pthread.h>

@interface JPVideoPlayerResourceLoader()<JPResourceLoadingRequestTaskDelegate>

@property (nonatomic, strong)NSMutableArray<AVAssetResourceLoadingRequest *> *loadingRequests;

@property (nonatomic, strong) AVAssetResourceLoadingRequest *runningLoadingRequest;

@property (nonatomic, strong) JPVideoPlayerCacheFile *cacheFile;

@property (nonatomic, strong) NSMutableArray<JPResourceLoadingRequestTask *> *requestTasks;

@property (nonatomic, strong) JPResourceLoadingRequestTask *runningRequestTask;

@property (nonatomic) pthread_mutex_t lock;

@property (nonatomic, strong, nonnull) dispatch_queue_t ioQueue;

@end

@implementation JPVideoPlayerResourceLoader

- (void)dealloc {
    if(self.runningRequestTask){
        [self.runningRequestTask cancel];
        [self removeCurrentRequestTaskAndResetAll];
    }
    self.loadingRequests = nil;
    pthread_mutex_destroy(&_lock);
}

- (instancetype)init {
    NSAssert(NO, @"Please use given initialize method.");
    return [self initWithCustomURL:[NSURL new]];
}

+ (instancetype)resourceLoaderWithCustomURL:(NSURL *)customURL {
    return [[JPVideoPlayerResourceLoader alloc] initWithCustomURL:customURL];
}

- (instancetype)initWithCustomURL:(NSURL *)customURL {
    NSParameterAssert(customURL);
    if(!customURL){
        return nil;
    }

    self = [super init];
    if(self){
        pthread_mutexattr_t mutexattr;
        pthread_mutexattr_init(&mutexattr);
        pthread_mutexattr_settype(&mutexattr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&_lock, &mutexattr);
        _ioQueue = dispatch_queue_create("com.NewPan.jpvideoplayer.resource.loader.www", DISPATCH_QUEUE_SERIAL);
        _customURL = customURL;
        _loadingRequests = [@[] mutableCopy];
        NSString *key = [JPVideoPlayerManager.sharedManager cacheKeyForURL:customURL];
        _cacheFile = [JPVideoPlayerCacheFile cacheFileWithFilePath:[JPVideoPlayerCachePath createVideoFileIfNeedThenFetchItForKey:key]
                                                     indexFilePath:[JPVideoPlayerCachePath createVideoIndexFileIfNeedThenFetchItForKey:key]];
    }
    return self;
}


#pragma mark - AVAssetResourceLoaderDelegate

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader
shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    if (resourceLoader && loadingRequest){
        [self.loadingRequests addObject:loadingRequest];
        JPDebugLog(@"ResourceLoader ?????????????????????, ???????????????: %ld <<<<<<<<<<<<<<", self.loadingRequests.count);
        if(!self.runningLoadingRequest){
            [self findAndStartNextLoadingRequestIfNeed];
        }
    }
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader
didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    if ([self.loadingRequests containsObject:loadingRequest]) {
        if(loadingRequest == self.runningLoadingRequest){
            JPDebugLog(@"????????????????????????????????????");
            if(self.runningLoadingRequest && self.runningRequestTask){
                [self.runningRequestTask cancel];
            }
            if([self.loadingRequests containsObject:self.runningLoadingRequest]){
                [self.loadingRequests removeObject:self.runningLoadingRequest];
            }
            [self removeCurrentRequestTaskAndResetAll];
            [self findAndStartNextLoadingRequestIfNeed];
        }
        else {
            JPDebugLog(@"????????????????????????????????????");
            [self.loadingRequests removeObject:loadingRequest];
        }
    }
    else {
        JPDebugLog(@"?????????????????????????????????");
    }
}


#pragma mark - JPResourceLoadingRequestTaskDelegate

- (void)requestTask:(JPResourceLoadingRequestTask *)requestTask
didCompleteWithError:(NSError *)error {
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    if (![self.requestTasks containsObject:requestTask]) {
        JPDebugLog(@"????????? task ????????????????????? task");
        return;
    }

    if (error) {
        [self finishCurrentRequestWithError:error];
    }
    else {
        [self finishCurrentRequestWithError:nil];
    }
}


#pragma mark - Finish Request

- (void)finishCurrentRequestWithError:(NSError *)error {
    if (error) {
        JPDebugLog(@"ResourceLoader ?????????????????? error: %@", error);
        [self.runningRequestTask.loadingRequest finishLoadingWithError:error];
        [self.loadingRequests removeObject:self.runningLoadingRequest];
        [self removeCurrentRequestTaskAndResetAll];
        [self findAndStartNextLoadingRequestIfNeed];
    }
    else {
        JPDebugLog(@"ResourceLoader ??????????????????, ????????????");
        // ????????????????????????????????????.
        [self.requestTasks removeObject:self.runningRequestTask];
        if(!self.requestTasks.count){ // ????????????.
            [self.runningRequestTask.loadingRequest finishLoading];
            [self.loadingRequests removeObject:self.runningLoadingRequest];
            [self removeCurrentRequestTaskAndResetAll];
            [self findAndStartNextLoadingRequestIfNeed];
        }
        else { // ??????????????????, ????????????.
            [self startNextTaskIfNeed];
        }
    }
}


#pragma mark - Private

- (void)findAndStartNextLoadingRequestIfNeed {
    if(self.runningLoadingRequest || self.runningRequestTask){
        return;
    }
    if (self.loadingRequests.count == 0) {
        return;
    }

    self.runningLoadingRequest = [self.loadingRequests firstObject];
    NSRange dataRange = [self fetchRequestRangeWithRequest:self.runningLoadingRequest];
    if (dataRange.length == NSUIntegerMax) {
        dataRange.length = [self.cacheFile fileLength] - dataRange.location;
    }
    [self startCurrentRequestWithLoadingRequest:self.runningLoadingRequest
                                          range:dataRange];
}

- (void)startCurrentRequestWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
                                        range:(NSRange)dataRange {
    JPDebugLog(@"ResourceLoader ??????????????????, ???????????????: %@", NSStringFromRange(dataRange));
    if (dataRange.length == NSUIntegerMax) {
        [self addTaskWithLoadingRequest:loadingRequest
                                  range:NSMakeRange(dataRange.location, NSUIntegerMax)
                                 cached:NO];
    }
    else {
        NSUInteger start = dataRange.location;
        NSUInteger end = NSMaxRange(dataRange);
        while (start < end) {
            NSRange firstNotCachedRange = [self.cacheFile firstNotCachedRangeFromPosition:start];
            if (!JPValidFileRange(firstNotCachedRange)) {
                [self addTaskWithLoadingRequest:loadingRequest
                                          range:dataRange
                                         cached:self.cacheFile.cachedDataBound > 0];
                start = end;
            }
            else if (firstNotCachedRange.location >= end) {
                [self addTaskWithLoadingRequest:loadingRequest
                                          range:dataRange
                                         cached:YES];
                start = end;
            }
            else if (firstNotCachedRange.location >= start) {
                if (firstNotCachedRange.location > start) {
                    [self addTaskWithLoadingRequest:loadingRequest
                                              range:NSMakeRange(start, firstNotCachedRange.location - start)
                                             cached:YES];
                }
                NSUInteger notCachedEnd = MIN(NSMaxRange(firstNotCachedRange), end);
                [self addTaskWithLoadingRequest:loadingRequest
                                          range:NSMakeRange(firstNotCachedRange.location, notCachedEnd - firstNotCachedRange.location)
                                         cached:NO];
                start = notCachedEnd;
            }
            else {
                [self addTaskWithLoadingRequest:loadingRequest
                                          range:dataRange
                                         cached:YES];
                start = end;
            }
        }
    }

    // ????????????.
    [self startNextTaskIfNeed];
}

- (void)addTaskWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
                            range:(NSRange)range
                           cached:(BOOL)cached {
    JPResourceLoadingRequestTask *task;
    if(cached){
        JPDebugLog(@"ResourceLoader ???????????????????????????");
        task = [JPResourceLoadingRequestLocalTask requestTaskWithLoadingRequest:loadingRequest
                                                                   requestRange:range
                                                                      cacheFile:self.cacheFile
                                                                      customURL:self.customURL
                                                                         cached:cached];
    }
    else {
        task = [JPResourceLoadingRequestWebTask requestTaskWithLoadingRequest:loadingRequest
                                                                 requestRange:range
                                                                    cacheFile:self.cacheFile
                                                                    customURL:self.customURL
                                                                       cached:cached];
        JPDebugLog(@"ResourceLoader ????????????????????????: %@", task);
        if (self.delegate && [self.delegate respondsToSelector:@selector(resourceLoader:didReceiveLoadingRequestTask:)]) {
            [self.delegate resourceLoader:self didReceiveLoadingRequestTask:(JPResourceLoadingRequestWebTask *)task];
        }
    }
    int lock = pthread_mutex_trylock(&_lock);
    task.delegate = self;
    if (!self.requestTasks) {
        self.requestTasks = [@[] mutableCopy];
    }
    [self.requestTasks addObject:task];
    if (!lock) {
        pthread_mutex_unlock(&_lock);
    }
}

- (void)removeCurrentRequestTaskAndResetAll {
    self.runningLoadingRequest = nil;
    self.requestTasks = [@[] mutableCopy];
    self.runningRequestTask = nil;
}

- (void)startNextTaskIfNeed {
    int lock = pthread_mutex_trylock(&_lock);;
    self.runningRequestTask = self.requestTasks.firstObject;
    if ([self.runningRequestTask isKindOfClass:[JPResourceLoadingRequestLocalTask class]]) {
        [self.runningRequestTask startOnQueue:self.ioQueue];
    }
    else {
        [self.runningRequestTask start];
    }
    if (!lock) {
        pthread_mutex_unlock(&_lock);
    }
}

- (NSRange)fetchRequestRangeWithRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    NSUInteger location, length;
    // data range.
    if ([loadingRequest.dataRequest respondsToSelector:@selector(requestsAllDataToEndOfResource)] && loadingRequest.dataRequest.requestsAllDataToEndOfResource) {
        location = (NSUInteger)loadingRequest.dataRequest.requestedOffset;
        length = NSUIntegerMax;
    }
    else {
        location = (NSUInteger)loadingRequest.dataRequest.requestedOffset;
        length = loadingRequest.dataRequest.requestedLength;
    }
    if(loadingRequest.dataRequest.currentOffset > 0){
        location = (NSUInteger)loadingRequest.dataRequest.currentOffset;
    }
    return NSMakeRange(location, length);
}

@end
