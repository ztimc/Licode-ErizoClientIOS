//
//  ICNSettingTableViewController.m
//  ECIExampleLicode
//
//  Created by ztimc on 2018/5/28.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import "ICNSettingTableViewController.h"
#import "ICNSettingModel.h"

typedef NS_ENUM(int, ARDSettingsSections) {
    
    ARDSettingsSectionBitRate = 0,
    ARDSettingsSectionVideoResolution
};

@interface ICNSettingTableViewController ()<UITextFieldDelegate>{
    ICNSettingModel *_settingModel;
    UITableViewCell *currentSlected;
    
}

@property (strong, nonatomic) IBOutlet UITableView *settingTableView;

@property (weak, nonatomic) IBOutlet UITableViewCell *cell192x144;

@property (weak, nonatomic) IBOutlet UITableViewCell *cell320x240;

@property (weak, nonatomic) IBOutlet UITableViewCell *cell480x360;

@property (weak, nonatomic) IBOutlet UITableViewCell *cell640x480;

@property (weak, nonatomic) IBOutlet UITableViewCell *cell1280x720;

@property (weak, nonatomic) IBOutlet UITextField *audioBitrateTextField;

@property (weak, nonatomic) IBOutlet UITextField *videoBitarateTextField;

@end

@implementation ICNSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _settingModel = [[ICNSettingModel alloc] init];
    
    NSString *currentResolut = [_settingModel currentVideoResolutionSettingFromStore];
    
    currentSlected = [self resolut2Cell:currentResolut];
    if(currentSlected){
        currentSlected.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [self initTextField:_audioBitrateTextField bitrate:[_settingModel currentMaxAudioBitrateSettingFromStore].stringValue];
    [self initTextField:_videoBitarateTextField bitrate:[_settingModel currentMaxVideoBitrateSettingFromStore].stringValue];
}

- (void)initTextField: (UITextField *)textField
              bitrate: (NSString *)bitrate{
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.text = bitrate;
    
    UIToolbar *numberToolbar =
    [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    numberToolbar.items = @[
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                          target:nil
                                                                          action:nil],
                            [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(numberTextFieldDidEndEditing:)]
                            ];
    [numberToolbar sizeToFit];
    textField.delegate = self;
    textField.inputAccessoryView = numberToolbar;
}


# pragma mark - Table view bitrate cell
- (void)numberTextFieldDidEndEditing:(id)sender {
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSNumber *bitrateNumber = nil;
    
    if (textField.text.length != 0) {
        bitrateNumber = [NSNumber numberWithInteger:textField.text.intValue];
    }
    
    if(textField == _videoBitarateTextField){
        [_settingModel storeMaxVideoBitrateSetting:bitrateNumber];
    }else if(textField == _audioBitrateTextField){
        [_settingModel storeMaxAudioBitrateSetting:bitrateNumber];
    }
}

# pragma mark - dataSource
- (NSArray<NSString *> *)videoResolutionArray {
    return [_settingModel availableVideoResolutions];
}

- (UITableViewCell *)resolut2Cell:(NSString *)resolut{
    if([resolut caseInsensitiveCompare:@"192x144"] == NSOrderedSame){
        return _cell192x144;
    }else if([resolut caseInsensitiveCompare:@"320x240"] == NSOrderedSame){
        return _cell320x240;
    }else if([resolut caseInsensitiveCompare:@"480x360"] == NSOrderedSame){
        return _cell480x360;
    }else if([resolut caseInsensitiveCompare:@"640x480"] == NSOrderedSame){
        return _cell640x480;
    }else if([resolut caseInsensitiveCompare:@"1280x720"] == NSOrderedSame){
        return _cell1280x720;
    }
    return nil;
}

# pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView cellForRowAtIndexPath:indexPath].selected = false;

    
    switch (indexPath.section) {
        case ARDSettingsSectionVideoResolution:
            [self tableView:tableView disSelectVideoResolutionAtIndex:indexPath];
            break;
       
        default:
            break;
    }
    
}

# pragma mark - Table view reslution cell
- (void)selectedCell:(NSIndexPath * _Nonnull)indexPath tableViewCell:(UITableViewCell * _Nonnull)tableViewCell {
    currentSlected.accessoryType = UITableViewCellAccessoryNone;
    currentSlected = tableViewCell;
    currentSlected.accessoryType = UITableViewCellAccessoryCheckmark;
    [_settingTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView
        disSelectVideoResolutionAtIndex:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    [self selectedCell:indexPath tableViewCell:tableViewCell];
    
    NSString *videoResolution = self.videoResolutionArray[indexPath.row];
    [_settingModel storeVideoResolutionSetting:videoResolution];
}







@end
