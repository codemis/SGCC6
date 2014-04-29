@interface DownloadCell : UITableViewCell

@property(nonatomic)IBOutlet UILabel *titleLabel;
@property(nonatomic)IBOutlet UILabel *subtitleLabel;
@property(nonatomic,weak)UITableView *tableView;

@end