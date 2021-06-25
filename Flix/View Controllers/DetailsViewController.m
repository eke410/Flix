//
//  DetailsViewController.m
//  Flix
//
//  Created by Elizabeth Ke on 6/23/21.
//

#import "DetailsViewController.h"
#import "TrailerViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Cosmos-Swift.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet CosmosView *cosmosView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // loads posterView
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterView setImageWithURL:posterURL];
    
    // loads backdropView - first loads low-resolution image, then followed by a high-resolution image
    NSString *baseURLStringLowRes = @"https://image.tmdb.org/t/p/w500";
    NSString *baseURLStringHighRes = @"https://image.tmdb.org/t/p/original";
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    
    NSString *fullBackdropURLStringLowRes = [baseURLStringLowRes stringByAppendingString:backdropURLString];
    NSString *fullBackdropURLStringHighRes = [baseURLStringHighRes stringByAppendingString:backdropURLString];

    NSURL *backdropURLLowRes = [NSURL URLWithString:fullBackdropURLStringLowRes];
    NSURL *backdropURLHighRes = [NSURL URLWithString:fullBackdropURLStringHighRes];

    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:backdropURLLowRes];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:backdropURLHighRes];

    __weak DetailsViewController *weakSelf = self;
    [self.backdropView setImageWithURLRequest:requestSmall placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
        // smallImageResponse will be nil if the smallImage is already available
        // in cache (might want to do something smarter in that case).
        weakSelf.backdropView.alpha = 0.0;
        weakSelf.backdropView.image = smallImage;

        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.backdropView.alpha = 1.0;
        } completion:^(BOOL finished) {
            // The AFNetworking ImageView Category only allows one request to be sent at a time
            // per ImageView. This code must be in the completion block.
            [weakSelf.backdropView setImageWithURLRequest:requestLarge placeholderImage:smallImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                weakSelf.backdropView.image = largeImage;
            }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
               // do something for the failure condition of the large image request
               // possibly setting the ImageView's image to a default image
            }];
        }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        // do something for the failure condition
        // possibly try to get the large image
        NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
        NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
        [self.backdropView setImageWithURL:backdropURL];
    }];
    
    // sets label values
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    self.releaseDateLabel.text = self.movie[@"release_date"];
    
    NSString *ratingString = [NSString stringWithFormat:@"%@", self.movie[@"vote_average"]];
    self.cosmosView.rating = ratingString.floatValue / 2;
    
    [self.synopsisLabel sizeToFit];
}


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     TrailerViewController *trailerViewController = [segue destinationViewController];
     trailerViewController.movieID = [NSString stringWithFormat:@"%@", self.movie[@"id"]];
 }


@end
