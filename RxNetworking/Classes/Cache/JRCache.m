//
//  JRCache.m
//  NerdWiki
//
//  Created by Jean Raphael Bordet on 24/10/2016.
//  Copyright © 2016 Jean Raphael Bordet. All rights reserved.
//

#import "JRCache.h"
#include <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>

@implementation JRCache

+ (void)resetCacheWithErrorBlock:(void (^)(NSError *))errorBlock {
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[JRCache cacheDirectory]
                                               error:&error];
    if (error) {
        NSLog(@"[JRCache] %@", [error description]);
        errorBlock(error);
    }
}

+ (NSString *)cacheDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    return [cacheDirectory stringByAppendingPathComponent:@"JRCache"];
}

/**
 *  Return an Object by the given key
 *
 *  @param key an NSString
 *
 *  @return an NSData
 */
+ (NSData *)objectForKey:(NSString *)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [self absoluteFilePathWithKey:key];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        return data;
    }
    return nil;
}

/**
 *
 *
 *  @param data       an NSData represents ImageData
 *  @param key        a NSString
 *  @param errorBlock
 *
 *  @return the filename NOT the absolute path
 */
+ (NSString *)setObject:(NSData *)data forKey:(NSString *)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = YES;
    NSError *error;
    
    if (![fileManager fileExistsAtPath:self.cacheDirectory isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    NSString *filePath = [self absoluteFilePathWithKey:key];
    
    [data writeToFile:filePath options:NSDataWritingAtomic error:&error];
    
    if (error) {
        return nil;
    } else {
        return [self fileNameWithKey:key];
    }
}

+ (NSString *)filePathWithName:(NSString *)fileName {
    return [self.cacheDirectory stringByAppendingPathComponent:fileName];
}

/**
 *  Create a filename composed by key_filename_density_extension
 *
 *  @param key an NSString that will be crypted
 *
 *  @return an NSString with the relative filename
 */
+ (NSString *)fileNameWithKey:(NSString *)key {
    NSString *fileName = [[key componentsSeparatedByString:@"/"] lastObject];
    fileName = [[fileName componentsSeparatedByString:@"."] firstObject];
    
    NSString *hashKey =  [self sha1:key];
    
    NSString *extensions = [[key componentsSeparatedByString:@"."] lastObject];
    
    return [NSString stringWithFormat:@"%@%@.%@", hashKey, fileName, extensions];
}

+ (NSString *)absoluteFilePathWithKey:(NSString *)key {
    NSString *fileName = [self fileNameWithKey:key];
    
    return [self filePathWithName:fileName];
}

+ (NSString *)sha1:(NSString *)clear {
    const char *s = [clear cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
    
    CC_SHA1(keyData.bytes, keyData.length, digest);
    
    NSData *out = [NSData dataWithBytes:digest
                                 length:CC_SHA1_DIGEST_LENGTH];
    
    NSString *hash = [out description];
    
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return hash;
}

@end
