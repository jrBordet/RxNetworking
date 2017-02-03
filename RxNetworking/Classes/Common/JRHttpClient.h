//
//  JRHttpClient.h
//  NerdWiki
//
//  Created by Jean Raphael Bordet on 07/08/16.
//  Copyright © 2016 Jean Raphael Bordet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRHttpClientProtocol.h"
#import "JRHttpClientDelegate.h"

@interface JRHttpClient : NSObject <JRHttpClientProtocol, NSURLSessionDataDelegate>

@property(nonatomic, strong) id<JRHttpClientDelegate> delegate;

@end
