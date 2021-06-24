//
//  TrailerViewController.m
//  Flix
//
//  Created by Elizabeth Ke on 6/24/21.
//

#import "TrailerViewController.h"

@interface TrailerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tempLabel.text = self.movieID;
    
    [self fetchTrailer];
    
    
}

-(void) fetchTrailer {
    NSString *urlString = [[@"https://api.themoviedb.org/3/movie/" stringByAppendingString:self.movieID] stringByAppendingString:@"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);

               // creates network error alert
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The Internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];

               UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                   [self fetchTrailer];
               }];
               [alert addAction:tryAgainAction];

               [self presentViewController:alert animated:YES completion:nil];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSArray *trailers = dataDictionary[@"results"];

               NSString *youtubeKey = trailers[1][@"key"];
               NSString *youtubeLink = [@"https://www.youtube.com/watch?v=" stringByAppendingString:youtubeKey];
               NSLog(youtubeLink);
           }
       }];
    [task resume];
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
