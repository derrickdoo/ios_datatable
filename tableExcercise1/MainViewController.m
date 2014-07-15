//
//  MainViewController.m
//  tableExcercise1
//
//  Created by Derrick Or on 7/10/14.
//  Copyright (c) 2014 derrickor. All rights reserved.
//

#import "MainViewController.h"
#import "UserTableViewCell.h"
#import "PhotoTableViewCell.h"
#import "CommentTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface MainViewController ()
@property (strong, nonatomic) NSArray *people;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *photos;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSURL *instagramUrl = [NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=06a132f82ae744fe9c48ff2258dbaaa8"];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:instagramUrl];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            self.photos = object[@"data"];
            [self.tableView reloadData];
        }];
        
        /*
        self.people = @[
                            @{@"name":@"Yaron", @"hometown":@"Israel"},
                            @{@"name":@"Derrick", @"hometown":@"San Mateo"}
                        ];
        */
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"UserTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"UserTableViewCell"];
    
    UINib *photoViewNib = [UINib nibWithNibName:@"PhotoTableViewCell" bundle:nil];
    [self.tableView registerNib:photoViewNib forCellReuseIdentifier:@"PhotoTableViewCell"];
    
    UINib *commentViewNib = [UINib nibWithNibName:@"CommentTableViewCell" bundle:nil];
    [self.tableView registerNib:commentViewNib forCellReuseIdentifier:@"CommentTableViewCell"];
    
    self.tableView.rowHeight = 320;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.photos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *comments = self.photos[section][@"comments"];
    
    return comments.count+1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *photoInfo = self.photos[section];
    NSString *username = photoInfo[@"user"][@"username"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    headerView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 30)];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor blueColor];
    label.text = username;
    [headerView addSubview:label];
    
    return headerView;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) {
        return 320;
    }
    else {
        /*
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        return size.height + 10;
         */
        
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) {
        PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoTableViewCell"];
    
        NSDictionary *photoInfo = self.photos[indexPath.section];
    
        NSString *url = photoInfo[@"images"][@"standard_resolution"][@"url"];
    
        [cell.photoView setImageWithURL:[NSURL URLWithString:url]];
        
        return cell;
    }
    else {
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
        
        NSDictionary *photosInfo = self.photos[indexPath.section];
        
        NSString *comment = photosInfo[@"comments"][@"data"][indexPath.row][@"text"];
        
        cell.commentLabel.text = comment;
        
        return cell;
    }
    
    /*
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserTableViewCell"];
    
    NSDictionary *person = self.people[indexPath.row];
    cell.nameLabel.text = person[@"name"];
    cell.hometownLabel.text = person[@"hometown"];
    return cell;
    */
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
    (NSIndexPath *)indexPath {
    /*
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *userInfo = self.users[indexPath.row];
    UserViewController *vc = [[UserViewController alloc] init];
    vc.userInfo = userInfo;
    
    [self.navigationController pushViewController:vc animated:YES];
     */
}

@end
