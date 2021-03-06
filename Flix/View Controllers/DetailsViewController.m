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
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *unfavoriteButton;

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
    NSString *backdropURLString = self.movie[@"backdrop_path"];

    NSURL *backdropURLLowRes = [NSURL URLWithString:[@"https://image.tmdb.org/t/p/w500" stringByAppendingString:backdropURLString]];
    NSURL *backdropURLHighRes = [NSURL URLWithString:[@"https://image.tmdb.org/t/p/original" stringByAppendingString:backdropURLString]];

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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults arrayForKey:@"favoriteIDs"] containsObject:self.movie[@"id"]]) {
        [self.favoriteButton setHidden:true];
    } else {
        [self.unfavoriteButton setHidden:true];
    }
    [self.synopsisLabel sizeToFit];
}

- (void)favoriteButtonClicked:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favorites = [defaults arrayForKey:@"favoriteIDs"];
    
    if (![favorites containsObject:self.movie[@"id"]]) {
        NSArray *updatedFavorites = [favorites arrayByAddingObject:self.movie[@"id"]];
        [defaults setObject:updatedFavorites forKey:@"favoriteIDs"];
        [defaults synchronize];
        NSLog(@"Added favorite: %@", self.movie[@"id"]);
    }
//    NSLog(@"%@", [defaults arrayForKey:@"favoriteIDs"]);
    [sender setHidden:true];
    [self.unfavoriteButton setHidden:false];
}

- (void)unfavoriteButtonClicked:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favorites = [defaults arrayForKey:@"favoriteIDs"];
    
    if ([favorites containsObject:self.movie[@"id"]]) {
        NSArray *updatedFavorites = [self removeString:self.movie[@"id"] fromArray:favorites];
        [defaults setObject:updatedFavorites forKey:@"favoriteIDs"];
        [defaults synchronize];
        NSLog(@"Removed favorite: %@", self.movie[@"id"]);
    }
//    NSLog(@"%@", [defaults arrayForKey:@"favoriteIDs"]);
    [sender setHidden:true];
    [self.favoriteButton setHidden:false];
}

- (NSArray *)removeString:(NSString *)str fromArray:(NSArray *)arr {
    NSArray *result = [[NSArray alloc] init];
    for (NSString *s in arr) {
        if (s != str) {
            result = [result arrayByAddingObject:s];
        }
    }
    return result;
}


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     TrailerViewController *trailerViewController = [segue destinationViewController];
     trailerViewController.movieID = [NSString stringWithFormat:@"%@", self.movie[@"id"]];
 }


@end
