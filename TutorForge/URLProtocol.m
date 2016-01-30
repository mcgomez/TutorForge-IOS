//
//  URLProtocol.m
//  TutorForge
//
//  Created by Marisa Gomez on 11/5/15.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import "URLProtocol.h"

@implementation URLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    static NSUInteger requestCount = 0;
    //NSLog(@"Request #%lu: URL = %@", (unsigned long)requestCount++, request);
    
    if ([NSURLProtocol propertyForKey:@"MyURLProtocolHandledKey" inRequest:request]) {
        return NO;
    }
    
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

#pragma mark - NSURLConnectionDelegate Methods

- (void)startLoading {
    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:@"MyURLProtocolHandledKey" inRequest:newRequest];
    
    self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
}

- (void)stopLoading {
    [self.connection cancel];
    self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSURLProtectionSpace *protectionSpace = [challenge protectionSpace];
    
    id<NSURLAuthenticationChallengeSender> sender = [challenge sender];
    
    if ([[protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        SecTrustRef trust = [[challenge protectionSpace] serverTrust];
        
        NSURLCredential *credential = [[NSURLCredential alloc] initWithTrust:trust];
        
        [sender useCredential:credential forAuthenticationChallenge:challenge];
    }
    else
    {
        [sender performDefaultHandlingForAuthenticationChallenge:challenge];
    }
}

@end
