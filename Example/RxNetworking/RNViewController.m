//
//  RNViewController.m
//  RxNetworking
//
//  Created by Jean Raphael Bordet on 12/12/2016.
//  Copyright (c) 2016 Jean Raphael Bordet. All rights reserved.
//

#import "RNViewController.h"
#import "JRRxHttpClient.h"

@interface RNViewController ()

@end

@implementation RNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
