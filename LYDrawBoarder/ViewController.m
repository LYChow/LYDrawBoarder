//
//  ViewController.m
//  LYDrawBoarder
//
//  Created by lychow on 1/11/16.
//  Copyright © 2016 IOSDeveloper. All rights reserved.
//

#import "ViewController.h"

#import "LYDrawerBoarder.h"

@interface ViewController ()
- (IBAction)popBoarderView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)popBoarderView
{
    LYDrawerBoarder *boarderView =[[LYDrawerBoarder alloc] init];
    [boarderView show];
}
@end
