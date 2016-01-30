//
//  AdminAddTutorViewController.h
//  TutorForge
//
//  Created by Marisa Gomez on 11/16/15.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tutor.h"

@interface AdminAddTutorViewController : UIViewController
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *addTutor;
@property (weak, nonatomic) IBOutlet UITableView *tutorTable;
@property (strong, nonatomic) NSMutableArray *tutors;
@property (strong, nonatomic) Tutor *tutor;

- (Tutor *)createTutor:(NSString *)fullname :(NSString *)studentID :(NSString *)department;

@end
