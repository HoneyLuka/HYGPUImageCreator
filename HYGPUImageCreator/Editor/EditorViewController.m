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
#import "FilterListModel.h"
#import "EditorFilterSectionHeaderView.h"
#import "EditorFilterSlideCell.h"
#import "BrightnessFilterItem.h"
#import "AppConst.h"
#import "UIImage+ImageFilter.h"
#import "FilterSelectViewController.h"

@interface EditorViewController () <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, FilterSelectViewControllerDelegate>

@property (nonatomic, strong) UIImage *editImage;

@property (nonatomic, strong) UIButton *addFilterButton;

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

@end

@implementation EditorViewController

+ (instancetype)controllerWithEditImage:(UIImage *)image
{
  EditorViewController *vc = [[EditorViewController alloc]init];
  vc.editImage = image;
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
  self.navigationItem.rightBarButtonItem = saveButton;
  
  self.addFilterButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.addFilterButton setTitle:@"Add filter element" forState:UIControlStateNormal];
  self.addFilterButton.frame = CGRectMake(0, 0, 0, 60);
  [self.addFilterButton addTarget:self
                           action:@selector(addFilterButtonClick)
                 forControlEvents:UIControlEventTouchUpInside];
  self.tableView.tableFooterView = self.addFilterButton;
}

- (void)initData
{
  self.listModel = [[FilterListModel alloc]init];
  self.title = self.listModel.name;
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

#pragma mark - action

- (void)saveButtonClick
{
//   NSDictionary *dict = [self.listModel toDictionary];
  NSLog(@"dict = %@", [self.listModel toJSONString]);
}

- (void)filterValueDidChangedAction:(NSNotification *)noti
{
  NSArray *filterList = [self.listModel generateFilterArray];
  if (filterList.count) {
    self.imageView.image = [self.editImage _processFilters:filterList];
  } else {
    self.imageView.image = self.editImage;
  }
  
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

#pragma mark - SelectVCDelegate

- (void)viewControllerDidFinishSelectingFilters:(FilterSelectViewController *)sender
{
  self.listModel.filterList = sender.usedArray;
  [self.tableView reloadData];
  [self filterValueDidChangedAction:nil];
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
