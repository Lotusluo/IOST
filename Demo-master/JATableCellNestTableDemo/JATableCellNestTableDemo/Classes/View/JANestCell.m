//
//  JANestCell.m
//  JATableCellNestTableDemo
//
//  Created by JasoneIo on 16/6/27.
//  Copyright © 2016年 littleBoy. All rights reserved.
//

#import "JANestCell.h"
#import "JALablelCell.h"
#import "JAPictureCell.h"
#import "JADataModel.h"

@interface JANestCell ()
<UITableViewDataSource,UITableViewDelegate>

typedef NS_ENUM(NSInteger,JAIconType){
    JAIconTypeBus = 0,
    JAIconTypeSpot,
    JAIconTypeFood,
    JAIconTypeHotel
};

typedef NS_ENUM(NSInteger,JATableCellType){
    JATableCellTypeText = 0,
    JATableCellTypePics
};

@property (weak, nonatomic) IBOutlet UILabel *lblTheme;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UIView *dotView;

@property (weak, nonatomic) IBOutlet UITableView *nestTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;

@property (strong, nonatomic) JALablelCell *lblCell;

@property (strong, nonatomic) NSDictionary *iconDict;
@end

@implementation JANestCell

#pragma mark - Init
- (NSDictionary *)iconDict
{
    if (!_iconDict) {
        _iconDict = @{@"0":@"icon_bus",
                      @"1":@"icon_spot",
                      @"2":@"icon_food",
                      @"3":@"icon_hotel"
                      };
    }
    return _iconDict;
}

- (JALablelCell *)lblCell
{
    if (!_lblCell) {
        _lblCell = [[NSBundle mainBundle] loadNibNamed:JALablelCellIdentifier owner:self options:nil].firstObject;
    }
    return _lblCell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lblTheme.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 83.0f;
    self.lblContent.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 83.0f;
    
    self.lblTheme.textColor = RGBA(46.0f,189.0f,89.0f,1.0f);
    self.lblTheme.font = [UIFont systemFontOfSize:14.0f];
    self.lblContent.textColor = [UIColor whiteColor];
    self.lblContent.font = [UIFont systemFontOfSize:14.0f];
    self.nestTableView.backgroundColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    self.dotView.layer.cornerRadius = 4.0f;
    self.dotView.clipsToBounds = YES;
    
    [self.nestTableView registerNib:[UINib nibWithNibName:JALablelCellIdentifier bundle:nil] forCellReuseIdentifier:JALablelCellIdentifier];
    [self.nestTableView registerNib:[UINib nibWithNibName:JAPictureCellIdentifier bundle:nil] forCellReuseIdentifier:JAPictureCellIdentifier];
    
}

#pragma mark - Public
- (void)setDayModel:(dayjourney *)dayModel
{
    _dayModel = dayModel;
    
    self.dotView.hidden = !dayModel.lastRow;
    self.lblTheme.text = dayModel.theme;
    self.lblContent.text = dayModel.content;
    self.icon.image = [UIImage imageNamed:[self fetchNameWithIconType:dayModel.type]];
    [self.nestTableView reloadData];
    self.tableHeightConstraint.constant = self.nestTableView.contentSize.height;
}

- (NSString *)fetchNameWithIconType:(NSString *)type
{
    NSString *iconName = @"";
    switch ([type integerValue]) {
        case JAIconTypeBus:
            iconName = self.iconDict[type];
            break;
        case JAIconTypeSpot:
            iconName = self.iconDict[type];
            break;
        case JAIconTypeFood:
            iconName = self.iconDict[type];
            break;
        case JAIconTypeHotel:
            iconName = self.iconDict[type];
            break;
        default:
            break;
    }
    return iconName;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return JATableCellTypePics + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == JATableCellTypeText) {
        return self.dayModel.journeyrange.count;
    }else if(section == JATableCellTypePics){
        return self.dayModel.picurls.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == JATableCellTypeText){
        JALablelCell *lblCell = [tableView dequeueReusableCellWithIdentifier:JALablelCellIdentifier forIndexPath:indexPath];
        lblCell.title = self.dayModel.journeyrange[indexPath.row];
        return lblCell;
    }else if (indexPath.section == JATableCellTypePics){
        JAPictureCell *picCell = [tableView dequeueReusableCellWithIdentifier:JAPictureCellIdentifier forIndexPath:indexPath];
        picCell.pics = self.dayModel.picurls[indexPath.row];
        return picCell;
    }else{
        return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == JATableCellTypeText){
        self.lblCell.title = self.dayModel.journeyrange[indexPath.row];
        return [self.lblCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    }else if (indexPath.section == JATableCellTypePics){
        if (self.dayModel.picurls[indexPath.row].img.length > 0) {
            return ([UIScreen mainScreen].bounds.size.width - 60.0f)/ 2.0f;
        }else{
            return CGFLOAT_MIN;
        }
    }else{
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == JATableCellTypePics) {
        return CGFLOAT_MIN;
    }else if (section == JATableCellTypeText){
        if (self.dayModel.journeyrange.count > 0) {
            return 10.0f;
        }else{
            return CGFLOAT_MIN;
        }
    }
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
}
@end
