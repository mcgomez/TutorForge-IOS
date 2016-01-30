//
//  AdminAddTutorScheduleViewController.h
//  TutorForge
//
//  Created by Marisa Gomez on 11/28/15.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tutor.h"

@interface AdminAddTutorScheduleViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *sundayLabel;
@property (weak, nonatomic) IBOutlet UILabel *mondayLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *wednesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *thursdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *fridayLabel;
@property (weak, nonatomic) IBOutlet UILabel *saturdayLabel;
@property (weak, nonatomic) IBOutlet UIView *timeSlotInformationView;
@property (weak, nonatomic) IBOutlet UIPickerView *dayPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *timeSlotPicker;
@property (weak, nonatomic) IBOutlet UILabel *selectATutorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeSlotLabel;
@property (strong, nonatomic) NSArray *days;
@property (strong, nonatomic) NSArray *times;
@property (strong, nonatomic) NSString *dayChosen;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;
@property (strong, nonatomic) Tutor *tutor;

-(IBAction)addTimeSlotInformation:(id)sender;
-(IBAction)addSlotInformation:(id)sender;
-(IBAction)saveSchedule:(id)sender;

@end
