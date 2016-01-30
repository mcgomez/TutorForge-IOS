//
//  URLProtocol.h
//  TutorForge
//
//  Created by Marisa Gomez on 11/5/15.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLProtocol : NSURLProtocol <NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLConnection *connection;

@end
