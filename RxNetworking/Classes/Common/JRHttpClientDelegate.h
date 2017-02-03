//
//  JRHttpClientDelegate.h
//  NerdWiki
//
//  Created by Jean Raphael Bordet on 07/08/16.
//  Copyright © 2016 Jean Raphael Bordet. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JRHttpClientDelegate <NSObject>

@optional
- (void)downloadCompletedWith:(NSDictionary *)data;

- (void)downloadCompletedWithImage:(UIImage *)image;

@end
