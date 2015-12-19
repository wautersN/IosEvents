
import UIKit
import Alamofire

class EventTableViewController: UITableViewController {
    
    //MARK: Properties
    var events = [ Event ]()
    var currentTask : NSURLSessionTask?
    var even:Int = 0
    
    //MARK: ReloadFromServer
    @IBAction func reloadFromServer(sender: UIBarButtonItem) {
        loadEventsFromServer()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedEvents = loadEvents(){
            events += savedEvents
        }else {
            loadEventsFromServer()
        }
        saveEvents()
    }
    
    
    // MARK: TableView Datasource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "EventTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EventTableViewCell
        
        let event = events[indexPath.row]
        
        cell.eventNameLabel.text = event.eventName
        cell.eventDateLabel.text = event.date
        cell.placeNameLabel.text = event.placeName
        
        if (even % 2 == 0) {
            cell.backgroundColor = UIColor(red: 183/255.0, green: 183/255.0, blue: 183/255.0,alpha: 1)
        } else{
            cell.backgroundColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0,alpha: 1)
        }
        even++
        return cell
    }
    
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let destinationNav = segue.destinationViewController as! UINavigationController
            let oneEventViewDetail = destinationNav.topViewController as! OneEventTableViewController
            if let selectedEventCell = sender as? EventTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedEventCell)!
                let selectedEvent = events[indexPath.row]
                oneEventViewDetail.event = selectedEvent
            }
        }
    }
    
    //MARK: NSCoding
    func saveEvents(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(events, toFile: Event.ArchiveURL.path!)
        if !isSuccessfulSave{
            print("Failed to save events...")
        }
    }
    
    func loadEvents() -> [Event]?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Event.ArchiveURL.path!) as? [Event]
    }
    
    func loadEventsFromServer(){
        currentTask = Service.sharedService.createFetchTask{
            [unowned self] result in switch result {
            case .Success(let events):
                
                self.events = events
                self.saveEvents()
                self.tableView.reloadData()
            case .Failure(let error):
                debugPrint(error)
            }
        }
        currentTask!.resume()
    }
    
    @IBAction func unwindToEventList(segue: UIStoryboardSegue) {
        segue.sourceViewController as! OneEventTableViewController
    }
}
