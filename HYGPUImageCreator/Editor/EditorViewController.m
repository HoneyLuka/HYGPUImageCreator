//
//  EditorViewController.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/12.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "EditorViewController.h"
#import "Utils.h"
#import "UIColor+Utils.h"
#import "EditorFilterSectionHeaderView.h"
#import "EditorFilterSlideCell.h"
#import "BrightnessFilterItem.h"
#import "AppConst.h"
#import "UIImage+ImageFilter.h"
#import "FilterSelectViewController.h"
#import "FileManager.h"
#import "SVProgressHUD.h"
#import "ShareManager.h"

@interface EditorViewController () <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, FilterSelectViewControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIImage *editImage;

@property (nonatomic, strong) UIButton *addFilterButton;

@property (nonatomic, strong) UILabel *titleView;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIView *dragger;
@property (nonatomic, strong) IBOutlet UILabel *draggerLabel;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *equalWidthConstraint;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@property (nonatomic, assign) BOOL canDrag;

@property (nonatomic, strong) FilterListModel *listModel;

@property (nonatomic, strong) NSMutableSet *hideDetailSet;

@property (nonatomic, copy) NSString *oldName;
@property (nonatomic, assign) BOOL needReplace;

@property (nonatomic, strong) NSData *jsonData;

@end

@implementation EditorViewController

+ (instancetype)controllerWithEditImage:(UIImage *)image
                                 filter:(FilterListModel *)filter
{
  EditorViewController *vc = [[EditorViewController alloc]init];
  vc.editImage = image;
  vc.listModel = filter;
  return vc;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.hideDetailSet = [NSMutableSet set];
  [self initView];
  [self initData];
  
  [[NSNotificationCenter defaultCenter]addObserver:self
                                          selector:@selector(filterValueDidChangedAction:)
                                              name:kFilterValueDidChangedNotification
                                            object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)initView
{
  UINib *cellNib = [UINib nibWithNibName:@"EditorFilterSlideCell" bundle:nil];
  [self.tableView registerNib:cellNib forCellReuseIdentifier:@"EditorFilterSlideCell"];
  
  self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
  self.pan.delegate = self;
  [self.dragger addGestureRecognizer:self.pan];
  self.longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
  self.longPress.delegate = self;
  [self.dragger addGestureRecognizer:self.longPress];
  
  self.imageView.image = self.editImage;
  
  UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                             target:self
                                                                             action:@selector(saveButtonClick)];
  UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                              target:self
                                                                              action:@selector(shareButtonClick)];
  self.navigationItem.rightBarButtonItems = @[saveButton, shareButton];
  
  self.addFilterButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.addFilterButton setTitle:@"Add filter element" forState:UIControlStateNormal];
  self.addFilterButton.frame = CGRectMake(0, 0, 0, 60);
  [self.addFilterButton addTarget:self
                           action:@selector(addFilterButtonClick)
                 forControlEvents:UIControlEventTouchUpInside];
  self.tableView.tableFooterView = self.addFilterButton;
  
  //titleView
  self.titleView = [[UILabel alloc]init];
  self.titleView.textAlignment = NSTextAlignmentCenter;
  self.titleView.font = [UIFont boldSystemFontOfSize:17.f];
  self.titleView.userInteractionEnabled = YES;
  self.navigationItem.titleView = self.titleView;
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeNameButtonClick)];
  [self.titleView addGestureRecognizer:tap];
}

- (void)initData
{
  if (!self.listModel) {
    self.listModel = [[FilterListModel alloc]init];
  }
  
  self.oldName = self.listModel.name;
  
  [self reloadTitle];
  
  [self.tableView reloadData];
  [self reloadImage];
}

- (void)showDragger
{
  [UIView animateWithDuration:0.3f animations:^{
    self.draggerLabel.alpha = 1;
    self.dragger.backgroundColor = [UIColor colorWithHex:0xFEDC62];
  }];
}

- (void)hideDragger
{
  [UIView animateWithDuration:0.3f animations:^{
    self.draggerLabel.alpha = 0;
    self.dragger.backgroundColor = [UIColor colorWithHex:0xFFFFFF alpha:0.5];
  }];
}

- (void)reloadImage
{
  NSArray *filterList = [self.listModel generateFilterArray];
  if (filterList.count) {
    self.imageView.image = [self.editImage _processFilters:filterList];
  } else {
    self.imageView.image = self.editImage;
  }
}

- (void)reloadTitle
{
  self.navigationItem.titleView = nil;
  
  self.title = self.listModel.name;
  self.titleView.text = self.listModel.name;
  [self.titleView sizeToFit];
  
  self.navigationItem.titleView = self.titleView;
}

#pragma mark - action

- (void)shareButtonClick
{
  NSDictionary *shareDict = [self.listModel dictionaryForJSON];
  NSError *error;
  NSData *data = [NSJSONSerialization dataWithJSONObject:shareDict
                                                 options:NSJSONWritingPrettyPrinted
                                                   error:&error];
  
  if (!data || error) {
    [SVProgressHUD showErrorWithStatus:@"Generate JSON data error."];
    return;
  }
  self.jsonData = data;
  
  UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Choose a way to share"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"Copy to pasteboard", @"Save to Dropbox", nil];
  [sheet showInView:self.view];
}

- (void)changeNameButtonClick
{
  UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Input Filter Name"
                                                     message:nil
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Confirm", nil];
  alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
  [alertView show];
  
  UITextField *textField = [alertView textFieldAtIndex:0];
  textField.text = self.listModel.name;
}

- (void)saveButtonClick
{
  if (self.needReplace) {
    [[FileManager sharedInstance]deleteFile:self.oldName];
  }
  
  if ([[FileManager sharedInstance]saveFilterList:self.listModel]) {
    [SVProgressHUD showSuccessWithStatus:@"Saved."];
  } else {
    [SVProgressHUD showErrorWithStatus:@"Something wrong."];
  }
}

- (void)filterValueDidChangedAction:(NSNotification *)noti
{
  [self reloadImage];
}

- (void)addFilterButtonClick
{
  FilterSelectViewController *vc = [FilterSelectViewController controllerWithUsedFilters:self.listModel.filterList];
  vc.delegate = self;
  [self presentViewController:vc animated:YES completion:nil];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
  if (!self.canDrag) {
    return;
  }
  
  CGPoint point = [pan locationInView:self.view];
  CGFloat y = point.y;
  CGFloat offset = MIN(y - [Utils appWidth], 0);
  if ([Utils appWidth] - ABS(offset) < 100) {
    offset = ([Utils appWidth] - 100) * -1;
  }
  
  if (self.equalWidthConstraint.constant == offset) {
    return;
  }
  
  self.equalWidthConstraint.constant = offset;
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
  switch (longPress.state) {
    case UIGestureRecognizerStateBegan:
      self.canDrag = YES;
      [self showDragger];
      break;
    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateFailed:
    case UIGestureRecognizerStateCancelled:
      self.canDrag = NO;
      [self hideDragger];
      break;
      
    default:
      break;
  }
}

- (void)sectionHeaderClick:(UITapGestureRecognizer *)tap
{
  EditorFilterSectionHeaderView *headerView = (EditorFilterSectionHeaderView *)tap.view;
  NSInteger section = headerView.section;
  FilterItem *item = self.listModel.filterList[section];
  
  if ([self.hideDetailSet containsObject:item.name]) {
    [self.hideDetailSet removeObject:item.name];
  } else {
    [self.hideDetailSet addObject:item.name];
  }
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
                withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0) {
    NSString *test = [[NSString alloc]initWithData:self.jsonData encoding:NSUTF8StringEncoding];
    [UIPasteboard generalPasteboard].string = test;
    [SVProgressHUD showSuccessWithStatus:@"Copied to pasteboard"];
  } else if (buttonIndex == 1) {
    [[ShareManager sharedInstance]shareToDropboxWithName:self.listModel.name data:self.jsonData fromController:self];
  }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1) {
    UITextField *textField = [alertView textFieldAtIndex:0];
    NSString *name = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([[FileManager sharedInstance]filterIsExist:name]) {
      [SVProgressHUD showErrorWithStatus:@"Name is duplicate."];
      return;
    }
    
    self.listModel.name = name;
    [self reloadTitle];
    self.needReplace = YES;
  }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
  UITextField *textField = [alertView textFieldAtIndex:0];
  NSString *trimedString = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
  if (trimedString.length) {
    return YES;
  }
  
  return NO;
}

#pragma mark - SelectVCDelegate

- (void)viewControllerDidFinishSelectingFilters:(FilterSelectViewController *)sender
{
  self.listModel.filterList = sender.usedArray;
  [self.tableView reloadData];
  [self reloadImage];
}

#pragma mark - UIGestureDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
  if (gestureRecognizer == self.longPress) {
    if (otherGestureRecognizer == self.pan) {
      return YES;
    }
  } else if (gestureRecognizer == self.pan) {
    if (otherGestureRecognizer == self.longPress) {
      return YES;
    }
  }
  
  return NO;
}

#pragma mark - TTT

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return self.listModel.filterList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  FilterItem *item = self.listModel.filterList[section];
  if ([self.hideDetailSet containsObject:item.name]) {
    return 0;
  }
  
  return item.elements.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  FilterItem *item = self.listModel.filterList[indexPath.section];
  FilterElement *element = item.elements[indexPath.row];
  if (element.showType == FilterElementShowTypeSlider) {
    return 90;
  }
  
  return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  FilterItem *item = self.listModel.filterList[section];
  
  EditorFilterSectionHeaderView *headerView = [EditorFilterSectionHeaderView createView];
  headerView.section = section;
  [headerView configureWithFilterItem:item];
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionHeaderClick:)];
  [headerView addGestureRecognizer:tap];
  
  return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  FilterItem *item = self.listModel.filterList[indexPath.section];
  FilterElement *element = item.elements[indexPath.row];
  if (element.showType == FilterElementShowTypeSlider) {
    EditorFilterSlideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditorFilterSlideCell"];
    [cell configureWithElement:element];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
  }
  
  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}

@end
