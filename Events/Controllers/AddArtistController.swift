import UIKit

class AddArtistController : UIViewController
{
    
    @IBOutlet weak var txtArtistName: UITextField!
    
    @IBOutlet weak var stackview: UIStackView!
    
    var eventId : String!
    
    //toevoegen van de artiest aan de server
    @IBAction func addKey(sender: AnyObject) {
       Service.sharedService.setNewArtist(eventId,name: txtArtistName.text!)
        performSegueWithIdentifier("unwindAddArtists", sender: self)
    }

    override func viewWillAppear(animated: Bool) {
        if presentingViewController!.traitCollection.horizontalSizeClass == .Regular {
            navigationController!.navigationBarHidden = true
            let buttonSize = stackview.bounds.size
            preferredContentSize = CGSize(width: buttonSize.width + 16, height: buttonSize.height + 16)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "unwindAddArtists"){
            let oneEventViewCtr = segue.destinationViewController as! OneEventTableViewController
           // let oneEventViewCtr = addArtistNavCtr.de as! OneEventTableViewController
            
            oneEventViewCtr.items.append(txtArtistName.text!)
        }
    }
    
    
    
    
   
    
    
}
