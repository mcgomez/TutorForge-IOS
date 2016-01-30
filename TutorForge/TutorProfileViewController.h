//
//  TutorProfileViewController.h
//  TutorForge
//
//  Created by Marisa Gomez on 11/29/15.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tutor.h"

@interface TutorProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *removeTutorBarButton;
@property (strong, nonatomic) Tutor *tutor;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *sundayLabel;
@property (weak, nonatomic) IBOutlet UILabel *mondayLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *wednesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *thursdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *fridayLabel;
@property (weak, nonatomic) IBOutlet UILabel *saturdayLabel;

- (void)removeTutor:(id)sender;

@end
