//
//  ViewController.m
//  Realm-POC
//
//  Created by Sharon Nathaniel on 10/11/15.
//  Copyright © 2015 Silicus Technologies India Pvt. Ltd. All rights reserved.
//

#import "ViewController.h"

#import <Realm/Realm.h>

#import "DeveloperRealmModal.h"

#import "ProjectRealmModal.h"

#import "ProjectTableViewCell.h"

#import "ApplicationSharedManager.h"

#import "AddNewViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    UIViewController * contributeViewController;
}

// IBOutets
@property (nonatomic, strong) IBOutlet UILabel *developerNameLabel;

@property (nonatomic, strong) IBOutlet UILabel *developerCodeLabel;

@property (nonatomic, strong) IBOutlet UITableView *projectsTableView;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *searchButton;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *refreshButton;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *shareButton;

@property (nonatomic, strong) IBOutlet UIButton *devDetailsButton;


// Private Properties
@property (nonatomic, strong) Developer *currentDeveloper;

@property (nonatomic, strong) RLMArray *projects;

@property (nonatomic, strong) Project *projectToView;

@property (nonatomic, strong) RLMResults<Project *> *filteredprojects;

@property (assign) BOOL isFilterApplied;

// -----------------------------------------------------------------------------

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    // Load developer Profile
    [self fetchDeveloperProfile];
    _projectToView = nil;
}
#pragma mark -

#pragma mark -
#pragma mark Misclenious Functions

// Fetch Developer Profile from Realm Database
-(void)fetchDeveloperProfile
{
    RLMResults<Developer *> *developer = [Developer allObjects];
    NSLog(@"Results Count %lu", (unsigned long)developer.count);
    _currentDeveloper = [developer firstObject];
    [self fillDetailsOfDeveloper:_currentDeveloper];
    [[ApplicationSharedManager sharedManager] setDeveloperModal:_currentDeveloper];
}

// Show Developer Profile
-(void)fillDetailsOfDeveloper:(Developer *)developer
{
    [_developerNameLabel setText:developer.name];
    [_developerCodeLabel setText:developer.code];
    _projects = developer.projects;
    NSLog(@"Projects Count: %@",_projects);
    [_projectsTableView reloadData];
}

-(RLMResults *)searchDatabaseForTheSearchedString:(NSString *)searchedText
{
    
    // Query using an NSPredicate
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name CONTAINS %@",
                         searchedText];
    
    RLMResults<Project *> *projects = [Project objectsWithPredicate:pred];
    
    return projects;
}

#pragma mark -


#pragma mark -
#pragma mark UITableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_isFilterApplied) {
     
        NSLog(@"%lu",(unsigned long)_filteredprojects.count);

        return _filteredprojects.count;
    }
    
    NSLog(@"%lu",(unsigned long)_projects.count);
    
    return _projects.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Projects";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectTableViewCell *cell = (ProjectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ProjectCellIdentifier"];
    
    Project *currentProjectToPopulate;
    
    if (_isFilterApplied)
    {
        currentProjectToPopulate = [_filteredprojects objectAtIndex:indexPath.row];
    }
    else
    {
        currentProjectToPopulate = [_projects objectAtIndex:indexPath.row];
    }
    
    
    [cell.projectNameLabel setText:currentProjectToPopulate.name];
    
    [cell.projectCodeLabel setText:currentProjectToPopulate.code];
    
    if (!currentProjectToPopulate.isActive) {
        [cell.imageView setBackgroundColor:[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.8f]];
    }
    else
    {
        [cell.imageView setBackgroundColor:[UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.8f]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set the Project to View
    if (_isFilterApplied)
    {
        _projectToView = [_filteredprojects objectAtIndex:indexPath.row];
    }
    else
    {
        _projectToView = [_projects objectAtIndex:indexPath.row];

    }
    
    // Navigate to Project Details Screen
    [self performSegueWithIdentifier:@"SegueToDetails" sender:self];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
    {
        // Select from which array to fetch the project that is selected from deletion
        Project *currentProjectToDelete;
        
        if (_isFilterApplied)
        {
            currentProjectToDelete = [_filteredprojects objectAtIndex:indexPath.row];
        }
        else
        {
            currentProjectToDelete = [_projects objectAtIndex:indexPath.row];
        }
        
        // Get Default Realm
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        // Delete an object with a transaction
        [realm beginWriteTransaction];
        [realm deleteObject:currentProjectToDelete];
        [realm commitWriteTransaction];
        
        // Delete row from the UITableView with animation
        [_projectsTableView beginUpdates];
        [_projectsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [_projectsTableView endUpdates];
    }];
    
    deleteAction.backgroundColor = [UIColor redColor];
    
    return @[deleteAction];
}


#pragma mark -

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    AddNewViewController *addNewProjectVC = [segue destinationViewController];
    addNewProjectVC.projectToView = _projectToView;
}
#pragma mark -

#pragma mark - IBActions

-(IBAction)viewDeveloperDetails:(id)sender
{
    
}

-(IBAction)clearSearch:(id)sender
{
    // Remove filter and disable the reload button
    _isFilterApplied = FALSE;
    
    [_projectsTableView reloadData];
    
    [_refreshButton setEnabled:FALSE];
}

-(IBAction)search:(id)sender
{

    // Add Search Bar view
    contributeViewController = [[UIViewController alloc] init];
    
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *beView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    beView.frame = CGRectMake(14.0f, (self.view.frame.size.height/2) - 18, self.view.frame.size.width - 28, 36.0F);
    beView.layer.cornerRadius = 10.0f;
    beView.layer.masksToBounds = TRUE;
    
    contributeViewController.view.frame = CGRectMake(14.0f, (self.view.frame.size.height/2) - 18, self.view.frame.size.width - 28, 36.0F);
    contributeViewController.view.backgroundColor = [UIColor clearColor];
    [contributeViewController.view insertSubview:beView atIndex:1];
    contributeViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    UISearchBar *myTextField = [[UISearchBar alloc] initWithFrame:CGRectMake(10.0f, (self.view.frame.size.height/2) - 28, self.view.frame.size.width - 20, 56.0F)];
    myTextField.placeholder = @"Search for a project";
    myTextField.layer.backgroundColor = [UIColor clearColor].CGColor;
    UIButton *searchbtn = [[UIButton alloc] initWithFrame:CGRectMake(230.0, 35.0, 40.0, 35.0)];
    [myTextField setBackgroundColor:[UIColor clearColor]];
    [searchbtn setBackgroundColor:[UIColor clearColor]];
    myTextField.backgroundColor = [UIColor clearColor];
    myTextField.backgroundImage = [[UIImage alloc]init];
    myTextField.alpha = 0.95f;
    myTextField.delegate = self;
    [contributeViewController.view addSubview:myTextField];
    
    UIBlurEffect * blurEffectBG = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *beViewBG = [[UIVisualEffectView alloc] initWithEffect:blurEffectBG];
    beViewBG.frame = self.view.bounds;
    beViewBG.alpha = 0.6f;
    [contributeViewController.view insertSubview:beViewBG atIndex:0];
    
    [self presentViewController:contributeViewController animated:NO completion:nil];
    
}

#pragma mark -


#pragma mark - UISearchBar Delegates

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"Searched String: %@",searchBar.text);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Search %@",searchBar.text);
    [searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:contributeViewController completion:^{
        
        if (searchBar.text.length == 0)
        {
            _isFilterApplied = FALSE;
        }
        else
        {
            _filteredprojects = [self searchDatabaseForTheSearchedString:searchBar.text];
            _isFilterApplied = TRUE;
        }
        
        [_refreshButton setEnabled:TRUE];
        
        [_projectsTableView reloadData];

    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{}

#pragma mark -

@end
