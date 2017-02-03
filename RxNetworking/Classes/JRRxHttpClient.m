//
//  JRRxHttpClient.m
//  NerdWiki
//
//  Created by Jean Raphael Bordet on 20/09/16.
//  Copyright © 2016 Jean Raphael Bordet. All rights reserved.
//

#import "JRRxHttpClient.h"
#import "JRHttpClient.h"

@implementation JRRxHttpClient

#pragma mark - private

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason: [NSString stringWithFormat:@"Use +[%@ sharedClient]", self]
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        [[JRHttpClient sharedClient] setDelegate:self];
    }
    return self;
}

#pragma mark - Protocol Methods

+ (instancetype)sharedClient {
    static JRRxHttpClient *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] initPrivate];
    });
    
    return sharedClient;
}

#pragma mark - Interface

- (RACSignal *)performRequestWithBaseUrl:(NSString *)baseUrl query:(NSDictionary *)query transform:(id (^)(NSDictionary *jsonResponse))response {
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        RACSignal *successSignal = [self rac_signalForSelector:@selector(downloadCompletedWith:)
                                                  fromProtocol:@protocol(JRHttpClientDelegate)];
        
        [[[successSignal map:^id(RACTuple *value) {
            return value.first;
        }] map:response]
         subscribeNext:^(id x) {
             [subscriber sendNext:x];
             [subscriber sendCompleted];
         }];
        
        [[JRHttpClient sharedClient] performRequestWith:baseUrl
                                                  query:query];
        
        return [RACDisposable disposableWithBlock:^{
        }];
    }];
}

- (RACSignal *)fetchImageFromUrl:(NSURL *)url placheholderImage:(UIImageView *)placeholderImage {
    @weakify(self)
    return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       @strongify(self)
        
        RACSignal *successSignal = [self rac_signalForSelector:@selector(downloadCompletedWithImage:)
                                                  fromProtocol:@protocol(JRHttpClientDelegate)];
        
        [[successSignal map:^id(RACTuple *value) {
            return value.first;
        }]
         subscribeNext:^(id x) {
             [subscriber sendNext:x];
             [subscriber sendCompleted];
         }];
        
        [[JRHttpClient sharedClient] fetchImageFromUrl:url
                                     placheholderImage:placeholderImage];
        
        return [RACDisposable disposableWithBlock:^{
        }];
    }];
}

@end
