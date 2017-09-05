//
//  MDChatVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 07/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDChatVC.h"
#import "Macro.h"
#import "MDSocketHelper.h"
#import "MealDeal-Swift.h"


static NSString *SenderCellIdentifier = @"SenderTVCell";
static NSString *ReceiverCellIdentifier = @"ReciverTVCell";
static NSString *SenderCellImageIdentifier = @"SenderImageTVCell";
static NSString *ReceiverCellImageIdentifier = @"ReciverImageTVCell";

@interface MDChatVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,MWPhotoBrowserDelegate> {
    NSMutableArray *chatHistoryArray;
   
    NSMutableArray *_photos;
    SocketIOClient* socket;
    BOOL connected;
    
    NSOperationQueue *queue;
    NSOperationQueue *readStatusQueue;
    NSOperationQueue *discardStatusQueue;

}

@property (strong, nonatomic) IBOutlet UIImageView *imgDish;
@property (weak, nonatomic) IBOutlet UILabel *chefNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet AHTextView *replyTextView;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomConstraint;

@end

@implementation MDChatVC

#pragma mark - UIViewController Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
    
    //[[MDSocketHelper sharedSocketHelper] initializeSocket];
    [self initializeSocket];

}

-(void)viewWillAppear:(BOOL)animated {
    
    self.replyTextView.placeholderText = @"Write text..";
    //Notification For Keyboard Up and Down

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)initializeSocket
{
 //   ChatModal *chat = [chatHistoryArray objectAtIndex:0];
    queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount =1;
    
    readStatusQueue = [[NSOperationQueue alloc] init];
    readStatusQueue.maxConcurrentOperationCount = 1;
    
    discardStatusQueue = [[NSOperationQueue alloc] init];
    discardStatusQueue.maxConcurrentOperationCount =1;
    
    NSURL *url = [NSURL URLWithString:@"http://ec2-52-76-162-65.ap-southeast-1.compute.amazonaws.com:1420"];
    
    connected = NO;
    
    if (!socket) {
        socket = [[SocketIOClient alloc] initWithSocketURL:url config:nil];
        
        [socket connect];
    }
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@">>>>>>>>>  %ld",socket.status);
    // [socket emit:@"initChat" with:[NSArray array]];
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        connected = YES;
        NSLog(@"socket connected  %@",data);
        NSLog(@">>>>>>>>22222>  %ld   %@",socket.status, socket.sid);
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:@"2345678" forKey:@"userId"];
        [params setObject:kDummyDeviceToken forKey:@"deviceToken"];
        [params setObject:[NSUSERDEFAULT objectForKey:pUserName] forKey:@"userName"];
        
        NSLog(@"Socketd Event:  initChat    %@",params);
        
        [socket emit:@"initChat" with:[NSArray arrayWithObject:params]];
        NSMutableDictionary *readMessageParams = [NSMutableDictionary dictionary];
        [readMessageParams setObject:[NSUSERDEFAULT valueForKey:p_id] forKey:@"senderId"];
        [readMessageParams setObject:self.strReciverId forKey:@"receiverId"];
        [readMessageParams setObject:app.strLastMsgId forKey:@"lastmsgId"];
        [socket emit:@"readMessage" with:[NSArray arrayWithObject:readMessageParams]];
    }];
    
    [socket on:@"receivemessage" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"Hello Receive Message ");
        ChatModal *modalObj = [ChatModal new];
        NSDictionary *messageDict = [data objectAtIndex:0];
        NSDictionary *requiredData = [messageDict objectForKey:@"requireData"];
        app.strLastMsgId = [requiredData objectForKey:@"lastmsgId"];
        modalObj.message = [requiredData objectForKey:@"message"];
        modalObj.messageType = [requiredData objectForKey:@"messageType"];
        modalObj.senderImage = [requiredData objectForKey:@""];
        modalObj.date = [requiredData objectForKey:@"timeStamp"];
        modalObj.senderId = [requiredData objectForKey:@"senderId"];
        if([modalObj.messageType isEqualToString:@"image"]){
        NSArray *imageArary = [requiredData objectForKey:@"media"];
        modalObj.image = [imageArary objectAtIndex:0];
        }else{
            modalObj.image = [requiredData objectForKey:@"media"];
        }
        [chatHistoryArray addObject:modalObj];
        [self.sendButton setEnabled:NO];
        [self.sendButton setAlpha:0.5];
        [self.replyTextView setText:[NSString string]];
        if ([chatHistoryArray count]) {
            [self.tableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[chatHistoryArray count] - 1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];
    
    
    [socket on:@"messageRead" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"Message Read");

    }];


    [socket on:@"disconnect" callback:^(NSArray * data, SocketAckEmitter * ack) {
        connected = NO;
        NSLog(@"Socket disconnected  data ");
    }];
    
    
    
    NSLog(@">>>>>  %@   %d",url.host, url.port.intValue);
    
}

#pragma mark - Private Methods

-(void)initialSetup {
    
    chatHistoryArray = [NSMutableArray new];
    self.chefNameLabel.text = [NSUSERDEFAULT valueForKey:pUserName];
    self.dishNameLabel.text = self.strDishName;
    [self.imgDish sd_setImageWithURL:[NSURL URLWithString:self.strDishImage]];
    self.tableView.estimatedRowHeight = 86.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.sendButton setEnabled:NO];
    [self.sendButton setAlpha:0.5];
    [self callApiForChatHistory];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Notification Methods

- (void)keyboardWillShow:(NSNotification *)note {
    
    CGSize kbSize = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:[[[note userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.viewBottomConstraint.constant = kbSize.height;
        [self.view layoutSubviews];
        
    } completion:^(BOOL finished) {
        if ([chatHistoryArray count]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[chatHistoryArray count]-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)note {
    
    [UIView animateWithDuration:[[[note userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.viewBottomConstraint.constant = 0;
        [self.view layoutSubviews];
    } completion:^(BOOL finished) {
        if ([chatHistoryArray count]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[chatHistoryArray count]-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}


#pragma mark - TextView Delegate Method

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        
    if ([TRIM_SPACE(newString) length]) {
        [self.sendButton setEnabled:YES];
        [self.sendButton setAlpha:1.0];
        
    }else {
        [self.sendButton setEnabled:NO];
        [self.sendButton setAlpha:0.5];
    }
    
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

#pragma mark- UIButton Actions

- (IBAction)sendButtonAction:(id)sender {
    [self.view endEditing:YES];
    NSTimeInterval  today = [[NSDate date] timeIntervalSince1970];
    NSString *intervalString = [NSString stringWithFormat:@"%f", today];
   [socket emit:@"sendmessage" with:@[@{@"senderId":[NSUSERDEFAULT valueForKey:p_id], @"senderName" : [NSUSERDEFAULT valueForKey:pUserName], @"message":self.replyTextView.text, @"receiverId":self.strReciverId,@"receiverName":self.strReceiverName,@"messageType":@"text",@"timeStamp":intervalString,@"media":@"",@"senderImage":[NSUSERDEFAULT valueForKey:@"userImage"],@"receiverImage":@""}]];


   /* ChatModal *modalObj = [ChatModal new];
    modalObj.message = self.replyTextView.text;
    [chatHistoryArray addObject:modalObj];
    
    [self.sendButton setEnabled:NO];
    [self.sendButton setAlpha:0.5];
    [self.replyTextView setText:[NSString string]];
    
    if ([chatHistoryArray count]) {
        [self.tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[chatHistoryArray count]-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }*/
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)attatchButtonAction:(id)sender {
    [self.view endEditing:YES];
    
    [AlertController actionSheet:nil message:nil andButtonsWithTitle:@[@"Take from Camera", @"Choose from Gallery"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        
        UIImagePickerController *profileImagePicker = [[UIImagePickerController alloc] init];
        profileImagePicker.delegate = self;
        profileImagePicker.allowsEditing = YES;
        
        if (!index) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                profileImagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:profileImagePicker animated:YES completion:NULL];
            } else {
                [AlertController title:@"Camera is not available."];
            }
        } else if (index == 1) {
            [self presentViewController:profileImagePicker animated:YES completion:NULL];
        }
    }];
}

#pragma mark - UITableView Datasource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatModal *obj = [chatHistoryArray objectAtIndex:indexPath.row];

    if ([obj.messageType isEqualToString:@"image"])
        return 150;
    else
        return tableView.rowHeight;
}

-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [chatHistoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatModal *obj = [chatHistoryArray objectAtIndex:indexPath.row];
    
  /*  if (indexPath.row % 2 == 0) {
        
        if (obj.image) {
            
            MDChatSenderCell *senderImageCell = (MDChatSenderCell *)[tableView dequeueReusableCellWithIdentifier:SenderCellImageIdentifier forIndexPath:indexPath];
           
            [senderImageCell.sendedImageView setImage: obj.image];
            return senderImageCell;

        } else {
        
        MDChatSenderCell *senderCell = (MDChatSenderCell *)[tableView dequeueReusableCellWithIdentifier:SenderCellIdentifier forIndexPath:indexPath];
        
        [senderCell.senderTextLabel setText:obj.message];
      //  [senderCell.senderTimeLabel setText:@""];
        
        return senderCell;
        }
    } else{
        
        if (obj.image) {
            MDChatRecieverCell *receiverImageCell = (MDChatRecieverCell *)[tableView dequeueReusableCellWithIdentifier:ReceiverCellImageIdentifier forIndexPath:indexPath];
            
            [receiverImageCell.recievedImageView setImage: obj.image];
            return receiverImageCell;
        } else {
        
        MDChatRecieverCell *receiverCell = (MDChatRecieverCell *)[tableView dequeueReusableCellWithIdentifier:ReceiverCellIdentifier forIndexPath:indexPath];
        
        [receiverCell.reciverTextLabel setText:obj.message];
       // [receiverCell.reciverTimeLabel setText:@""];
        
        return receiverCell;
        }
    }*/
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if([obj.senderId isEqualToString:[NSUSERDEFAULT objectForKey:p_id]]){
        if([obj.messageType isEqualToString:@"text"]){
            MDChatSenderCell *senderCell = (MDChatSenderCell *)[tableView dequeueReusableCellWithIdentifier:SenderCellIdentifier forIndexPath:indexPath];
        [senderCell.senderTextLabel setText:obj.message];
            [senderCell.senderImageView sd_setImageWithURL:[NSURL URLWithString:[NSUSERDEFAULT objectForKey:@"userImage"]]];
           [senderCell.senderTimeLabel setText:[AppUtility timestampToTime:obj.date]];
            if(([obj.lastMsgId intValue] < [app.strLastMsgId intValue]))
                senderCell.imgSendMessageReadStatus.image = [UIImage imageNamed:@""];
            else
                senderCell.imgSendMessageReadStatus.image = [UIImage imageNamed:@""];
        
        return senderCell;

        }
        else if ([obj.messageType isEqualToString:@"image"]){
            MDChatSenderCell *senderImageCell = (MDChatSenderCell *)[tableView dequeueReusableCellWithIdentifier:SenderCellImageIdentifier forIndexPath:indexPath];
            [senderImageCell.senderImageView sd_setImageWithURL:[NSURL URLWithString:[NSUSERDEFAULT objectForKey:@"userImage"]]];
            [senderImageCell.sendedImageView sd_setImageWithURL:[NSURL URLWithString:obj.image]];
            [senderImageCell.senderTimeLabel setText:[AppUtility timestampToTime:obj.date]];
            senderImageCell.btnSendImageShow.tag = indexPath.row;
            if(([obj.lastMsgId intValue] < [app.strLastMsgId intValue]))
                senderImageCell.sendedImageReadStatusImg.image = [UIImage imageNamed:@""];
            else
                senderImageCell.sendedImageReadStatusImg.image = [UIImage imageNamed:@""];
            
            [senderImageCell.btnSendImageShow addTarget:self action:@selector(btnSendImageShowAction:) forControlEvents:UIControlEventTouchUpInside];
            return senderImageCell;
        }
    }
    else{
        if([obj.messageType isEqualToString:@"text"]){
            MDChatRecieverCell *receiverCell = (MDChatRecieverCell *)[tableView dequeueReusableCellWithIdentifier:ReceiverCellIdentifier forIndexPath:indexPath];
            [receiverCell.recieverImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
            [receiverCell.reciverTextLabel setText:obj.message];
            [receiverCell.reciverTimeLabel setText:[AppUtility timestampToTime:obj.date]];
            receiverCell.imgMessaeReadStatus.hidden = YES;
            return receiverCell;
        }else if ([obj.messageType isEqualToString:@"image"]){
            MDChatRecieverCell *receiverImageCell = (MDChatRecieverCell *)[tableView dequeueReusableCellWithIdentifier:ReceiverCellImageIdentifier forIndexPath:indexPath];
            [receiverImageCell.recieverImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
            [receiverImageCell.recievedImageView sd_setImageWithURL:[NSURL URLWithString:obj.image]];
            [receiverImageCell.reciverTimeLabel setText:[AppUtility timestampToTime:obj.date]];
            receiverImageCell.btnReceiveImageShowBtn.tag = indexPath.row;
            receiverImageCell.imgMessaeReadStatus.hidden = YES;
            [receiverImageCell.btnReceiveImageShowBtn addTarget:self action:@selector(btnReceiveImageShowAction:) forControlEvents:UIControlEventTouchUpInside];

            return receiverImageCell;
        }
    }
    return nil;

}


- (IBAction) btnSendImageShowAction:(UIButton *)sender {
    //do as you please with buttonClicked.argOne
    NSIndexPath *path = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    MDChatSenderCell *cell = [self.tableView cellForRowAtIndexPath:path];
    [EXPhotoViewer showImageFrom:cell.sendedImageView];
}

- (IBAction) btnReceiveImageShowAction:(UIButton *)sender {
    //do as you please with buttonClicked.argOne
    NSIndexPath *path = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    MDChatRecieverCell *cell = [self.tableView cellForRowAtIndexPath:path];
    [EXPhotoViewer showImageFrom:cell.recievedImageView];
}


/*-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatModal *chatObj = [chatHistoryArray objectAtIndex:indexPath.row];
    
     if (chatObj.image) {
        
        _photos = [[NSMutableArray alloc] init];
         
        [_photos addObject:[MWPhoto photoWithImage:chatObj.image]];
        
        BOOL displayActionButton = YES;
        BOOL displaySelectionButtons = NO;
        BOOL displayNavArrows = NO;
        BOOL enableGrid = YES;
        BOOL startOnGrid = NO;
        BOOL autoPlayOnAppear = NO;
        
        // Create browser
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = displayActionButton;
        browser.displayNavArrows = displayNavArrows;
        browser.displaySelectionButtons = displaySelectionButtons;
        browser.alwaysShowControls = displaySelectionButtons;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = enableGrid;
        browser.startOnGrid = startOnGrid;
        browser.enableSwipeToDismiss = NO;
        browser.autoPlayOnAppear = autoPlayOnAppear;
        [browser setCurrentPhotoIndex:0];
        
        [self.navigationController pushViewController:browser animated:YES];
    }
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    
    return nil;
}


- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}*/

#pragma mark - UIImagePicker Delegate method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    NSTimeInterval  today = [[NSDate date] timeIntervalSince1970];
    NSString *intervalString = [NSString stringWithFormat:@"%f", today];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *encodedString = [imageData base64EncodedStringWithOptions:0];
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    [imageArray addObject:encodedString];
    [socket emit:@"sendmessage" with:@[@{@"senderId":[NSUSERDEFAULT valueForKey:p_id], @"senderName" : [NSUSERDEFAULT valueForKey:pUserName], @"message":@"", @"receiverId":self.strReciverId,@"receiverName":self.strReceiverName,@"messageType":@"image",@"timeStamp":intervalString,@"media":imageArray,@"senderImage":[NSUSERDEFAULT valueForKey:@"userImage"],@"receiverImage":@""}]];
    [self dismissViewControllerAnimated:YES completion:^{
//        self.replyTextView.text = [NSString string];
//         ChatModal *modalObj = [ChatModal new];
//        modalObj.image = image;
//        [chatHistoryArray addObject:modalObj];
//        [self.tableView reloadData];
    }];
 }

#pragma mark - Web Api Section

- (void)callApiForChatHistory {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULT valueForKey:p_id] forKey:@"senderId"];
    [dict setValue:self.strReciverId forKey:@"receiverId"];
    [dict setValue:@"1" forKey:@"pageNumber"];
    [ServiceHelper request:dict apiName:kAPIChatHistory method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:@"responseCode" expectedObj:@""];
            NSString *responseMessage = [resultDict objectForKeyNotNull:@"responseMessage" expectedObj:@""];
            if ([statusCode integerValue] == 200) {
                chatHistoryArray = [ChatModal parseDataForChatHistory:[resultDict objectForKey:@"DataList"]];
                [self.tableView reloadData];
            } else {
                [AlertController title:responseMessage];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
    }];
}


#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
