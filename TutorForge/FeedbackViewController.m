//
//  FeedbackViewController.m
//  TutorForge
//
//  Created by Marisa Gomez on 01/29/16.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Populate dummy data
    _tableData = [[NSMutableArray alloc]initWithObjects:@"Ashley @ 2:00pm", @"Jacob @ 3:00pm", @"John @ 4:00pm", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate Methods
/*
 * Method is used to determine how many cells will be in the table based off tableData count.
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData count];
}

/*
 * Method used to assign each cell in the table with values from tableData array.
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myTableIdentifier = @"TableItem";
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    
    if(myCell == nil)
    {
        myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
    }
    
    myCell.textLabel.text = [_tableData objectAtIndex:indexPath.row];
    
    //    myCell.imageView.image = [UIImage imageNamed:@""]; if we want to use a image with each cell
    return myCell;
}
/*
 * Method tableview delegate is used when user selects a row in the table view.
 * Displays an alert with request sent & with option to accept or decline the request.
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Request" message:[NSString stringWithFormat:@"%@", [_tableData objectAtIndex:indexPath.row]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *resendRequest = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                    {
                                        //DISPLAY REQUEST ABLE TO ACCEPT IT OR DECLINE IT
                                        UIAlertController *sentAlert = [UIAlertController alertControllerWithTitle:nil message:@"Request Accepted!" preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
                                        [sentAlert addAction:okAction];
                                        [self presentViewController:sentAlert animated:YES completion:nil];
                                    }];
    UIAlertAction *decline = [UIAlertAction actionWithTitle:@"Decline" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        //DECLINE IT IN DATABASE
        UIAlertController *sentAlert = [UIAlertController alertControllerWithTitle:nil message:@"Request Declined!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        [sentAlert addAction:okAction];
        [self presentViewController:sentAlert animated:YES completion:nil];
    }];
    
    [myAlert addAction:resendRequest];
    [myAlert addAction:decline];
    [self presentViewController:myAlert animated:YES completion:nil];
    
}

@end
