//
//  Login.h
//  TutorForge
//
//  Created by Marisa Gomez on 01/29/16.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "UIWebView+AFNetworking.h"

@interface Login : UIViewController <UIWebViewDelegate, NSURLConnectionDelegate>

@property(strong,nonatomic) IBOutlet UIWebView *myWebView;
@property (strong, nonatomic) NSString *myURL;
@property (strong, nonatomic) NSMutableData *responseData;

- (void)getUserInformation;

@end

