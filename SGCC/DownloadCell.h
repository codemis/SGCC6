@interface DownloadCell : UITableViewCell

@property(nonatomic)IBOutlet UILabel *titleLabel;
@property(nonatomic)IBOutlet UILabel *subtitleLabel;
@property(nonatomic,weak)UITableView *tableView;
@property(weak,nonatomic)IBOutlet UIProgressView *progressView;

-(void)updateProgressView:(float)percentCompleted;
@end