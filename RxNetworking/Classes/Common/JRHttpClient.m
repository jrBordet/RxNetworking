//
//  JRHttpClient.m
//  NerdWiki
//
//  Created by Jean Raphael Bordet on 07/08/16.
//  Copyright © 2016 Jean Raphael Bordet. All rights reserved.
//

#import "JRHttpClient.h"
#import "JRCache.h"

@interface JRHttpClient ()

@property (nonatomic) NSURLSession *session;

@end

@implementation JRHttpClient

#pragma mark - private

+ (instancetype)sharedClient {
    static JRHttpClient *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] initPrivate];
    });
    
    return sharedClient;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[HttpClient sharedClient]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:config
                                                     delegate:self
                                                delegateQueue:nil];
    }
    return self;
}

#pragma mark - JRHttpClientProtocol methods

- (void)performRequestWith:(NSString *)sUrl query: (NSDictionary *)q {
    NSURL *url = [self url:sUrl withQuery:q];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonObject = nil;
        if (data) {
            jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                         options:0
                                                           error:nil];
        }
        
        if (self.delegate) {
            [self.delegate downloadCompletedWith:jsonObject];
        }
    }];
    [dataTask resume];
}

- (void)fetchImageFromUrl:(NSURL *)url {
    [self fetchImageFromUrl:url placheholderImage:nil];
}

- (void)fetchImageFromUrl:(NSURL *)url placheholderImage:(UIImageView *)placeholder {
    NSString *key = url.absoluteString;
    NSData *data = [JRCache objectForKey:key];
    
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        if (placeholder) {
            placeholder.image = image;
        }
    } else {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            UIImage *imageFromData = [UIImage imageWithData:data];
            
            [JRCache setObject:UIImagePNGRepresentation(imageFromData)
                        forKey:key];
            
            UIImage *imageToSet = imageFromData;
            
            if (imageToSet) {
                if (self.delegate) {
                    [self.delegate downloadCompletedWithImage:imageToSet];
                }
                
                if (placeholder) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        placeholder.image = imageFromData;
                    });
                }
            }
        });
    }
}

#pragma mark - internals

- (NSURL *)url:(NSString *)sUrl withQuery:(NSDictionary *)q {
    NSMutableString *urlWithQuery = [NSMutableString stringWithFormat:@"%@?", sUrl];
    NSMutableArray *parts = [NSMutableArray array];
    
    for (NSString *params in q) {
        NSString *part = [NSString stringWithFormat: @"%@=%@", params, [q objectForKey:params]];
        [parts addObject: part];
    }
    
    [urlWithQuery appendString:[parts componentsJoinedByString:@"&"]];
    
    return [NSURL URLWithString:urlWithQuery];
}

@end
