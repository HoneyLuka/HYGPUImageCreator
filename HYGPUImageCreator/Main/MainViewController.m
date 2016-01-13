//
//  MainViewController.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/12.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "MainViewController.h"
#import <SVProgressHUD.h>
#import "EditorViewController.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIBarButtonItem *addButton;
@property (nonatomic, strong) UIBarButtonItem *editButton;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self initView];
  [self initData];
}

- (void)initView
{
  self.title = @"My Filters";
  self.addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                target:self
                                                                action:@selector(addButtonClick)];
  self.editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                 target:self
                                                                 action:@selector(editButtonClick)];
  self.navigationItem.leftBarButtonItem = self.editButton;
  self.navigationItem.rightBarButtonItem = self.addButton;
}

- (void)initData
{
  
}

- (BOOL)checkIfCanLoadPhotoLibrary
{
  return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - Action

- (void)addButtonClick
{
  if (![self checkIfCanLoadPhotoLibrary]) {
    [SVProgressHUD showErrorWithStatus:@"没有查看照片的权限"];
    return;
  }
  
  UIImagePickerController *picker = [[UIImagePickerController alloc]init];
  picker.delegate = self;
  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  picker.allowsEditing = YES;
  [self presentViewController:picker animated:YES completion:nil];
}

- (void)editButtonClick
{
  
}

#pragma mark - ImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
  [picker dismissViewControllerAnimated:YES completion:^{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) {
      return;
    }
    EditorViewController *editVC = [EditorViewController controllerWithEditImage:image];
    [self.navigationController pushViewController:editVC animated:YES];
  }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TTT

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}

@end
