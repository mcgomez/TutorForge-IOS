//
//  AdminAddTutorViewController.m
//  TutorForge
//
//  Created by Marisa Gomez on 11/16/15.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import "AdminAddTutorViewController.h"
#import "TutorProfileViewController.h"
#import "Tutor.h"

@interface AdminAddTutorViewController ()

@end

@implementation AdminAddTutorViewController
@synthesize tutorTable;
@synthesize tutors;
@synthesize tutor;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    tutors = [[NSMutableArray alloc] init];
    
    //Get all tutors in database
    //Connect to server and database
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://tutorme.stetson.edu/api/tutors/getAll"]]];
    
    //Setting up for response
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    //Get response
    id json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: nil];
    NSArray *responseJSON = [json objectForKey:@"result"];
    
    for (int i = 0; i < responseJSON.count; i++) {
        Tutor *tutorObject = [self createTutor:[responseJSON[i] objectForKey:@"FullName"] :[NSString stringWithFormat:@"%@", [responseJSON[i] objectForKey:@"ID"]] :[responseJSON[i] objectForKey:@"Subject"]];
        [tutors addObject:tutorObject];
    }
    [tutorTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (Tutor *)createTutor:(NSString *)fullname :(NSString *)studentID :(NSString *)department{
    Tutor *tutorObject = [[Tutor alloc] init];
    
    tutorObject.fullname = fullname;
    tutorObject.studentID = studentID;
    tutorObject.department = department;
    
    return tutorObject;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tutors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tutorsIdentifier = @"tutorsIdentifier";
    
    //Create each table cell with the student logged in
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:tutorsIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tutorsIdentifier];
        Tutor *tutorToAdd = tutors[indexPath.row];
        cell.textLabel.text = tutorToAdd.fullname;
    }
    
    cell.backgroundColor = [UIColor colorWithRed:(74.0/255.0) green:(184.0/255.0) blue:(175.0/255.0) alpha:1];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    tutor = tutors[indexPath.row];
    [self performSegueWithIdentifier:@"showTutorProfile" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showTutorProfile"]) {
        TutorProfileViewController *profile = segue.destinationViewController;
        profile.tutor = self.tutor;
    }
}

- (IBAction)unwindToTutors:(UIStoryboardSegue *)unwindSegue {
    [tutorTable reloadData];
}


@end
