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
#import "FileManager.h"
#import "FilterListModel.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIBarButtonItem *addButton;
@property (nonatomic, strong) UIBarButtonItem *clearButton;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) FilterListModel *selectedFilter;

@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self initView];
//  [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self initData];
}

- (void)initView
{
  self.title = @"My Filters";
  self.addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                target:self
                                                                action:@selector(addButtonClick)];
  self.clearButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                 target:self
                                                                 action:@selector(clearButtonClick)];
  self.navigationItem.leftBarButtonItem = self.clearButton;
  self.navigationItem.rightBarButtonItem = self.addButton;
}

- (void)initData
{
  self.dataArray = [[FileManager sharedInstance]loadAllFilters];
  [self.tableView reloadData];
}

- (BOOL)checkIfCanLoadPhotoLibrary
{
  return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)showImagePicker
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

#pragma mark - Action

- (void)addButtonClick
{
  self.selectedFilter = nil;
  [self showImagePicker];
}

- (void)clearButtonClick
{
  [[[UIAlertView alloc]initWithTitle:@"Warning"
                             message:@"do you want to delete all filters?"
                            delegate:self
                   cancelButtonTitle:@"Cancel"
                   otherButtonTitles:@"Yes", nil]show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1) {
    [[FileManager sharedInstance]removeAllFile];
    [self initData];
  }
}

#pragma mark - ImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
  [picker dismissViewControllerAnimated:YES completion:^{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) {
      return;
    }
    EditorViewController *editVC = [EditorViewController controllerWithEditImage:image filter:self.selectedFilter];
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
  static NSString *cellId = @"cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
  if (!cell) {
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
  }
  
  FilterListModel *model = self.dataArray[indexPath.row];
  cell.textLabel.text = model.name;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  FilterListModel *model = self.dataArray[indexPath.row];
  self.selectedFilter = model;
  [self showImagePicker];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    FilterListModel *model = self.dataArray[indexPath.row];
    [self.dataArray removeObject:model];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[FileManager sharedInstance]deleteFile:model.name];
  }
}

@end
