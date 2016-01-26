//
//  GOTTableViewController.m
//  GameOfThrones
//
//  Created by Brett Tau on 1/26/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

#import "GOTTableViewController.h"
#import "AppDelegate.h"
#import "Character.h"

@interface GOTTableViewController ()

@property NSArray *characters;
@property NSManagedObjectContext *moc;

@end

@implementation GOTTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.moc = appDelegate.managedObjectContext;
    
    [self loadCharacters];
    self.editing = false;
    
    if (self.characters.count == 0) {
    NSArray *tempArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gameofthrones" ofType:@"plist"]];
    
        for (NSDictionary *dict in tempArray) {
            Character *newCharacter = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:self.moc];
            newCharacter.actor = dict[@"actor"];
            newCharacter.character = dict[@"character"];
        }
        [self.moc save:nil];
        [self loadCharacters];
    }
}


-(void)loadCharacters {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Character"];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"character" ascending:YES];
    NSSortDescriptor *sortByHouse = [[NSSortDescriptor alloc] initWithKey:@"house" ascending:YES];
    NSSortDescriptor *sortByAge = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];
    
    request.sortDescriptors = @[sortByName, sortByHouse, sortByAge];
    
    self.characters = [self.moc executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.characters.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    Character *character = [self.characters objectAtIndex:indexPath.row];
    cell.textLabel.text = character.character;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"House: %@ \nAge: %@ \nGender: %@ ", character.house, character.age, character.gender];
    
    cell.detailTextLabel.numberOfLines = 0;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    return 85;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }   
}

- (IBAction)onEditTapped:(UIBarButtonItem *)sender {
    
    if(self.editing)
    {
        self.editing = false;
        [self.tableView setEditing:false animated:true];
        sender.style = UIBarButtonItemStylePlain;
        sender.title = @"Edit";
    }
    else
    {
        self.editing = true;
        [self.tableView setEditing:true animated:true];
        sender.style = UIBarButtonItemStyleDone;
        sender.title = @"Done";
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
