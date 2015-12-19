//
//  ViewController.swift
//  Events
//
//  Created by niels on 28/11/15.
//  Copyright © 2015 niels. All rights reserved.
//

import UIKit
import Alamofire

class EventViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {


    //MARK: Properties
    @IBOutlet weak var eventNameTxt: UILabel!
    @IBOutlet weak var eventPlaceTxt: UILabel!
    
    @IBOutlet weak var eventDateTxt: UILabel!
    @IBOutlet weak var eventRatingTxt: RatingControl!
    
    @IBOutlet weak var eventRegionTxt: UILabel!
    @IBOutlet weak var eventTownTxt: UILabel!
    @IBOutlet weak var eventStreetNameTxt: UILabel!
    @IBOutlet weak var alertLogedIn: UIButton!
    
   
    @IBOutlet weak var eventArtistTblV: UITableView!
    @IBOutlet weak var eventDescriptionTxt: UITextView!
    
    
   
    var event: Event?
    var items: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let event = event{

            
            
            
            eventNameTxt.text = event.eventName
            eventPlaceTxt.text = event.placeName
            
           eventRegionTxt.text = event.regio
            eventTownTxt.text = "\(event.postalcode.description) " + "\(event.town)"
            eventStreetNameTxt.text = event.streetname
            eventRatingTxt.rating = event.rating
            eventDateTxt.text = event.date
            eventDescriptionTxt.text = event.descr
            alertLogedIn.hidden = Globals.logedIn
            alertLogedIn.removeFromSuperview()        
            eventDescriptionTxt.text = event.descr
            
            print(self.items)
          
            
        }
        self.eventArtistTblV.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
        func reloaddata(){
    
            print(self.items)
            eventArtistTblV.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.eventArtistTblV.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         print("You selected cell #\(indexPath.row)!")
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }

    }
    
   

}

