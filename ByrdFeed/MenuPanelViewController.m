//
//  MenuPanelViewController.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/29/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "MenuPanelViewController.h"
#import "MenuCell.h"
#import "UserBoxView.h"
#import "TwitterClient.h"

@interface MenuPanelViewController ()
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) UserBoxView *userBoxView;

@end

@implementation MenuPanelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    _menuItems = @[@"Profile",
                   @"Timeline",
                   @"Mentions",
                   @"Logout"];
    
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.menuTableView.scrollEnabled = NO;
  [self.menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [self.menuTableView setSeparatorInset:UIEdgeInsetsZero];
  
  UINib *cellNib = [UINib nibWithNibName:@"MenuCell" bundle:nil];
  [self.menuTableView registerNib:cellNib forCellReuseIdentifier:@"MenuCell"];
  
  
  // set up header
  
  // init the header views
  self.userBoxView = [[UserBoxView alloc] init];
  self.userBoxView.user = [[TwitterClient sharedInstance] getCurrentUser];
  
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  self.menuTableView.tableHeaderView = self.userBoxView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *headerView = [[UIView alloc] init];
  headerView.backgroundColor = [UIColor whiteColor];
  
//  [UIView animateWithDuration:1.0f
//                        delay:0.9f
//       usingSpringWithDamping:0.9f
//        initialSpringVelocity:10.0f
//                      options:UIViewAnimationOptionBeginFromCurrentState |
//                              UIViewAnimationCurveEaseInOut
//                   animations:^{
//    headerView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 50.0f);
//  } completion:nil];
  
  headerView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 50.0f);
  
  return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 75.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 32.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
  
  cell.menuTitleLabel.text = [self.menuItems objectAtIndex:indexPath.row];

#warning TODO find a way to remove  the white borders for the unused cells
  
  return cell;
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.delegate menuItemSelected:indexPath.row];
}


@end
