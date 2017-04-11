//
//  ViewController.h
//  IMAGE DB
//
//  Created by Apple on 4/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

- (IBAction)btnSave:(id)sender;

- (IBAction)btnBack:(id)sender;


@end

