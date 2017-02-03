//
//  RxClientSpec.m
//  RxNetworking
//
//  Created by Jean Raphael Bordet on 13/12/2016.
//  Copyright 2016 Jean Raphael Bordet. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "JRRxHttpClient.h"

SPEC_BEGIN(RxClientSpec)

describe(@"RxClient", ^{
    describe(@"performRequestWithBaseUrl:query:transform:", ^{
        
        context(@"Server request successful", ^{
            
            it(@"should return an array of 10 elements", ^{
                
                NSDictionary *queryString = @ {
                    @"expand": @"1",
                    @"Category": @"Characters",
                    @"limit": @"10"
                };
                
                NSString *baseUrl = @"http://gameofthrones.wikia.com/api/v1/Articles/Top";
                
                __block NSMutableArray *result = [NSMutableArray new];
                
                [[RxClient performRequestWithBaseUrl:baseUrl query:queryString transform:^id(NSDictionary *jsonResponse) {
                    [[jsonResponse objectForKey:@"items"] enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
                        [result addObject:object];
                    }];
                    
                    return result;
                }] subscribeNext:^(id x) {
                    NSLog(@"%@", result);
                }];
                
                [[expectFutureValue(result) shouldEventually] haveCountOf:10];
            });
        });
    });
});

SPEC_END
