
import UIKit


class OneEventTableViewController: UITableViewController {
    //MARK: Properties
    @IBOutlet weak var eventNameTxt: UILabel!
    @IBOutlet weak var eventPlaceTxt: UILabel!
    
    @IBOutlet weak var eventDateTxt: UILabel!
    
    
    @IBOutlet weak var eventRegionTxt: UILabel!
    @IBOutlet weak var eventTownTxt: UILabel!
    @IBOutlet weak var eventStreetNameTxt: UILabel!
    @IBOutlet weak var eventDescriptionTxt: UILabel!
    @IBOutlet weak var eventRatingCtr: RatingControl!

    @IBOutlet var detailEventView: UITableView!
    @IBOutlet weak var alertLogedIn: UILabel!
    
    var items: [String] = []
    
    @IBOutlet weak var eventDescCell: UITableViewCell!
    
    var event: Event?
    
    @IBOutlet weak var addartistBarBtn: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let event = event{

            eventNameTxt.text = event.eventName
            eventPlaceTxt.text = event.placeName
            
            eventRegionTxt.text = event.regio
            eventTownTxt.text = "\(event.postalcode.description) " + "\(event.town)"
            eventStreetNameTxt.text = event.streetname
            eventDateTxt.text = event.date
            eventDescriptionTxt.text = event.descr
           
            
            Service.sharedService.getArtists(event.eventId, completion: { (response) -> () in
                self.items = response
                self.reloaddata()
            })
            eventRatingCtr.rating = event.rating
            
 
            eventDescCell.sizeToFit()
            //self.testviewke.rowHeight = 100
       
            addartistBarBtn.enabled = Globals.logedIn
               alertLogedIn.hidden = Globals.logedIn
            eventRatingCtr.userInteractionEnabled = Globals.logedIn
            
            
        }
        self.detailEventView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
    }
  
   
    
    func reloaddata(){
        
        print(self.items)
        detailEventView.reloadData()
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return items.count
        }
        else
        {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
   
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        if indexPath.section == 4 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier( "cell", forIndexPath: indexPath)
            cell.textLabel?.text = items[indexPath.row]
            return cell
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        if Globals.logedIn {
            event?.rating = eventRatingCtr.rating
            Service.sharedService.setPostScore((event?.eventId)!, rating: eventRatingCtr.rating)
            
        }
    }
    
   
    
    
    @IBAction func unwindFromAdd(segue: UIStoryboardSegue) {
      
        self.reloaddata()
        segue.sourceViewController as! AddArtistController
       
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "addArtist"){
            let addArtistNavCtr = segue.destinationViewController as! UINavigationController
            let addArtistViewCtr = addArtistNavCtr.topViewController as! AddArtistController
        
            addArtistViewCtr.eventId = event?.eventId
        }
    }
  
    
}