//
//  FavoritesViewController.m
//  Flix
//
//  Created by Elizabeth Ke on 6/25/21.
//

#import "FavoritesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"

@interface FavoritesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *movieIDs;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.movieIDs = [defaults arrayForKey:@"favoriteIDs"];
    
    [self.tableView reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
//    return self.movieIDs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MovieCell *cell = [[MovieCell alloc] init];
    cell.titleLabel.text = @"temp title label";
    return cell;
    
    
//    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
//
//    NSString *movieID = self.movieIDs[indexPath.row];
//
//    NSString *requestURL = [[@"https://api.themoviedb.org/3/movie/" stringByAppendingFormat:@"%@", movieID] stringByAppendingFormat:@"?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US"];
//
//    NSURL *url = [NSURL URLWithString:requestURL];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//           if (error != nil) {
//               NSLog(@"%@", [error localizedDescription]);
//           }
//           else {
//               NSDictionary *movie = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//
//               cell.titleLabel.text = movie[@"title"];
//               cell.synopsisLabel.text = movie[@"overview"];
//
//               NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
//               NSString *posterURLString = movie[@"poster_path"];
//               NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
//
//               NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
//               NSURLRequest *request = [NSURLRequest requestWithURL:posterURL];
//
//               // fades in image if loaded from network, just update otherwise
//               __weak MovieCell *weakSelf = cell;
//               [cell.posterView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
//                   // imageResponse will be nil if the image is cached
//                   if (imageResponse) { // Image was NOT cached, fade in image
//                       weakSelf.posterView.alpha = 0.0;
//                       weakSelf.posterView.image = image;
//
//                       //Animate UIImageView back to alpha 1 over 0.3sec
//                       [UIView animateWithDuration:0.3 animations:^{
//                           weakSelf.posterView.alpha = 1.0;
//                       }];
//                   }
//                   else { // Image was cached so just update the image
//                       weakSelf.posterView.image = image;
//                   }
//               }
//               failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
//                   // do nothing for the failure condition
//               }];
//           }
//       }];
//    return cell;
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
