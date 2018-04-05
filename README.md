# RxNetworking

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Code Sample

```objective-c
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
```

## Installation

RxNetworking is not available through [CocoaPods](http://cocoapods.org), so to install
it, simply add the following line to your Podfile:

```ruby
source "https://github.com/jrBordet/RxFramework.podspec.git"

pod 'RxNetworking', '1.0.0'
```

## Author

Jean Raphael Bordet, jr.bordet@gmail.com

## License

RxNetworking is available under the MIT license. See the LICENSE file for more info.

