//
//  PosterViewController.m
//  Flix
//
//  Created by Elizabeth Ke on 6/25/21.
//

#import "PosterViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PosterViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end

@implementation PosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // loads posterView - first loads low-resolution image, then followed by a high-resolution image
    NSString *posterURLString = self.movie[@"poster_path"];
    
    NSURL *posterURLLowRes = [NSURL URLWithString:[@"https://image.tmdb.org/t/p/w500" stringByAppendingString:posterURLString]];
    NSURL *posterURLHighRes = [NSURL URLWithString:[@"https://image.tmdb.org/t/p/original" stringByAppendingString:posterURLString]];

    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:posterURLLowRes];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:posterURLHighRes];

    __weak PosterViewController *weakSelf = self;
    [self.posterView setImageWithURLRequest:requestSmall placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
        // smallImageResponse will be nil if the smallImage is already available
        // in cache (might want to do something smarter in that case).
        weakSelf.posterView.alpha = 0.0;
        weakSelf.posterView.image = smallImage;

        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.posterView.alpha = 1.0;
        } completion:^(BOOL finished) {
            // The AFNetworking ImageView Category only allows one request to be sent at a time
            // per ImageView. This code must be in the completion block.
            [weakSelf.posterView setImageWithURLRequest:requestLarge placeholderImage:smallImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                weakSelf.posterView.image = largeImage;
            }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
               // do something for the failure condition of the large image request
               // possibly setting the ImageView's image to a default image
            }];
        }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        // for the failure condition, gets the lower quality photo
        NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
        NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
        NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
        [self.posterView setImageWithURL:posterURL];
    }];
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
