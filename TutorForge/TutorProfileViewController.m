//
//  TutorProfileViewController.m
//  TutorForge
//
//  Created by Marisa Gomez on 11/29/15.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import "TutorProfileViewController.h"
#import "Tutor.h"

@interface TutorProfileViewController ()

@end

@implementation TutorProfileViewController
@synthesize tutor;
@synthesize removeTutorBarButton;
@synthesize fullNameLabel;
@synthesize studentIDLabel;
@synthesize departmentLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    removeTutorBarButton.action = @selector(removeTutor:);
    
    fullNameLabel.text = tutor.fullname;
    studentIDLabel.text = tutor.studentID;
    departmentLabel.text = tutor.department;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeTutor:(id)sender {
    UIAlertController *confirmation=   [UIAlertController
                                          alertControllerWithTitle:@"Confirmation"
                                            message:[NSString stringWithFormat:@"Are you sure you want to remove tutor:\n%@: %@", tutor.studentID, tutor.fullname]
                                          preferredStyle:UIAlertControllerStyleAlert];
        
    UIAlertAction *yesConfirmation = [UIAlertAction
                                       actionWithTitle:@"YES"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [confirmation dismissViewControllerAnimated:YES completion:nil];
                                           
                                           //Remove tutor
                                           //Connect to server and database
                                           NSMutableURLRequest *removeTutorRequest =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://tutorme.stetson.edu/api/administrator/removeTutor"]]];
                                           [removeTutorRequest setHTTPMethod:@"POST"];
                                           
                                           NSString *postBodyStr = [NSString stringWithFormat:@"ID=%@", tutor.studentID];
                                           
                                           NSData *encodedPostBody = [postBodyStr dataUsingEncoding:NSASCIIStringEncoding];
                                           [removeTutorRequest setHTTPBody:encodedPostBody];
                                           [removeTutorRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                                           
                                           //Setting up for response
                                           NSURLResponse *requestTutorResponse;
                                           NSError *requestTutorError;
                                           NSData *requestTutorData = [NSURLConnection sendSynchronousRequest:removeTutorRequest returningResponse:&requestTutorResponse error:&requestTutorError];
                                           
                                           //Get response
                                           id json = [NSJSONSerialization JSONObjectWithData:requestTutorData options:NSJSONReadingMutableContainers error: nil];
                                           bool responseJSON = [json objectForKey:@"success"];
//                                           bool responseBool = responseJSON[0];
                                           
                                           if (responseJSON) {
                                               [self performSegueWithIdentifier:@"unwindToTutors" sender:self];
                                           } else {
                                               UIAlertController *error=   [UIAlertController
                                                                                   alertControllerWithTitle:@"Error"
                                                                                   message:[NSString stringWithFormat:@"Error removing tutor:\n%@: %@\nTry again later.", tutor.studentID, tutor.fullname]
                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                                               
                                               UIAlertAction *confirmation = [UIAlertAction
                                                                                actionWithTitle:@"OK"
                                                                                style:UIAlertActionStyleDefault
                                                                                handler:^(UIAlertAction * action)
                                                                                {
                                                                                    [error dismissViewControllerAnimated:YES completion:nil];
                                                                                }];
                                               [error addAction:confirmation];
                                               [self presentViewController:error animated:YES completion:nil];
                                           }
                                       }];
    UIAlertAction *noConfirmation = [UIAlertAction
                                          actionWithTitle:@"NO"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                                          {
                                              [confirmation dismissViewControllerAnimated:YES completion:nil];
                                          }];
        
    [confirmation addAction:noConfirmation];
    [confirmation addAction:yesConfirmation];
    [self presentViewController:confirmation animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
