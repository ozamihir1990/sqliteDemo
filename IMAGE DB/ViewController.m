//
//  ViewController.m
//  IMAGE DB
//
//  Created by Apple on 4/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"
#import "imageTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize imgView;

- (void)viewDidLoad {
    [super viewDidLoad];
    DBManager * dbmClass = [[DBManager alloc]init];
    [dbmClass database];
    
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadOrCapture)];
    [singleTap setNumberOfTapsRequired:1];
    [imgView addGestureRecognizer:singleTap];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)btnSave:(id)sender {
    DBManager*dbmClass = [[DBManager alloc]init];
    NSData *imageInData = UIImagePNGRepresentation(imgView.image);
    [dbmClass SaveImagesToSql:imageInData];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)uploadOrCapture
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"CHOOSE" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"CAMERA" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){[self camera];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"GALLERY" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){[self gallery];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

-(void)gallery{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    self.imgView.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"%@",info);
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)camera{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
