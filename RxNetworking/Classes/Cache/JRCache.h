//
//  JRCache.h
//  NerdWiki
//
//  Created by Jean Raphael Bordet on 24/10/2016.
//  Copyright © 2016 Jean Raphael Bordet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRCache : NSObject

+ (void)resetCacheWithErrorBlock:(void(^)(NSError *error))errorBlock;

+ (NSData *) objectForKey:(NSString *)key;
+ (NSString *)setObject:(NSData *)data forKey:(NSString *)key;

+ (NSString *)fileNameWithKey:(NSString *)key;
+ (NSString *)absoluteFilePathWithKey: (NSString *)key;

+ (NSString *)cacheDirectory;

@end
