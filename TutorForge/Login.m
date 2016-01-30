//
// Login.m
// TutorForge
//
// Created by Marisa Gomez on 01/29/16.
// Copyright © 2015 Learnsmith Solutions. All rights reserved.
//
// Class is used for Main display when user opens app. Also for them
// to login to our services. 

#import "Login.h"
#import "AFNetworking.h"
#import "UIWebView+AFNetworking.h"

@interface Login ()

@end

@implementation Login
@synthesize myWebView;
@synthesize myURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *loggedInStudents = [[NSMutableArray alloc] init];
    NSData *encodedStudentsLoggedIn = [NSKeyedArchiver archivedDataWithRootObject:loggedInStudents];
    [defaults setObject:encodedStudentsLoggedIn forKey:@"loggedInStudents"];
    [defaults synchronize];
    
    //URL To use for WebkitView and make request
//    myURL = @"https://casdev.ad.stetson.edu/cas/login?service=https%3A%2F%2Ftutorme.stetson.edu%2fapi%2fiosauthenticate";
    myURL = @"https://casdev.ad.stetson.edu/cas/login?service=https%3A%2F%2Ftutorme.stetson.edu%2fuser";
    NSURL *myNSURL = [NSURL URLWithString:myURL];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myNSURL];
    
    [myWebView loadRequest:myRequest progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {    } success:^NSString * _Nonnull(NSHTTPURLResponse * _Nonnull response, NSString * _Nonnull HTML) {
        return HTML;
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Failed with error: %@", error);
    }];
}

#pragma mark - UIWebView Delegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    NSLog(@"Request: %@", request.URL);
    
    return YES;
}
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    if ([webView isEqual:myWebView]) {
        NSString *currentURL = myWebView.request.URL.absoluteString;
//        NSLog(@"Current URL: %@", currentURL);
        
//        BOOL loaded = NO;
//        if ([currentURL isEqual:myURL]) {
//            loaded = YES;
//        }
        
        NSArray *sessionIDWithLabel = [currentURL componentsSeparatedByString:@"="];
        NSString *sessionID = [sessionIDWithLabel objectAtIndex:1];
//        NSLog(@"SessionID: %@", sessionID);
        
//        if (loaded) {
            NSHTTPCookieStorage * storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        
//        if (![webView.request.URL isEqual:nil]) {
//            NSArray * cookies = [storage cookiesForURL:webView.request.URL];
//            
//            for (NSHTTPCookie * cookie in cookies)
//            {
//                NSLog(@"%@=%@", cookie.name, cookie.value);
//                
//                NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://tutorme.stetson.edu/user"]];
//                
//                [request setValue:[NSString stringWithFormat:@"%@=%@", cookie.name, cookie.value] forHTTPHeaderField:@"Cookie"];
//                
//                //Setting up for response
//                NSURLResponse *response;
//                NSError *err;
//                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
//                
//                //Printing response
//                id json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: nil];
//                NSLog(@"JSON: %@", json);
//            }
//        }
        
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [cookieJar cookies]) {
            if ([cookie.name isEqualToString:@"connect.sid"]) {
                NSLog(@"Cookie: %@", cookie);
                
                NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://tutorme.stetson.edu/user"]];

                NSArray* cookieArray = [NSArray arrayWithObject:cookie];
                NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
                [request setAllHTTPHeaderFields:headers];
                
                //Setting up for response
                NSURLResponse *response;
                NSError *err;
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
                
                //Printing response
                id json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: nil];
                NSLog(@"JSON: %@", json);
            }
        }
        
//        }
    
//        [self getUserInformation];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}

//- (void)getUserInformation {
//    //Connect to server and database
//    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://tutorme.stetson.edu/student"]];
//    
//    //Setting up for response
//    NSURLResponse *response;
//    NSError *err;
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
//    
//    //Printing response
//    id json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: nil];
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToMainMenu:(UIStoryboardSegue*)sender
{
    UIViewController *sourceViewController = sender.sourceViewController;
    // Pull any data from the view controller which initiated the unwind segue.
}

@end
