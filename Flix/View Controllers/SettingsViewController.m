//
//  SettingsViewController.m
//  Flix
//
//  Created by Elizabeth Ke on 6/25/21.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *darkModeSwitch;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)stateChanged:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (sender.on) {
        [defaults setBool:true forKey:@"dark_mode"];
        [defaults synchronize];
    } else {
        [defaults setBool:false forKey:@"dark_mode"];
        [defaults synchronize];
    }
}

//- (void)stateChanged:(UISwitch *)switchState {
//    if (switchState.on) {
//        NSLog(@"The Switch is On");
//    } else {
//        NSLog(@"The Switch is Off");
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
