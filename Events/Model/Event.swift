import UIKit

class Event : NSObject, NSCoding {
    //MARK: Properties
    
    var eventId :String
    var eventName : String
    var placeName : String
    var date : String
    var rating: Int
    var descr: String
    var town: String
    var regio : String
    var postalcode: Int
    var streetname: String
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("events")
    
   
    //MARK: Types
    struct PropertyKey {
        static let eventNameKey = "name"
        static let eventPlaceNameKey = "placename"
        static let eventDateKey = "date"
        static let eventRating = "rating"
        static let eventDescription = "description"
        static let eventTown = "town"
        static let eventRegion = "region"
        static let eventPostal = "postal"
        static let eventStreet = "streetname"
        static let eventId = "_id"
    }
    
    //MARK: Initialization
    init?(eventName: String,placeName : String, date : String, rating: Int, descr: String, town: String,regio:String,postalcode:Int,streetname:String, eventId: String){
        self.eventName = eventName
        self.placeName = placeName
       
        self.date = date.componentsSeparatedByString("T")[0]
        self.rating = rating
        self.descr = descr
        self.town = town
        self.regio=regio
        self.postalcode=postalcode
        self.streetname=streetname
        self.eventId = eventId
        
        //Nodig voor decoden
        super.init()
        
        if eventName.isEmpty || placeName.isEmpty || date.isEmpty {
            return nil
        }
    }
    
    //MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(eventName,  forKey:  PropertyKey.eventNameKey)
        aCoder.encodeObject(placeName,  forKey:  PropertyKey.eventPlaceNameKey)
        aCoder.encodeObject(date,       forKey:  PropertyKey.eventDateKey)
        aCoder.encodeInteger(rating,    forKey:  PropertyKey.eventRating)
        aCoder.encodeObject(descr,      forKey:  PropertyKey.eventDescription)
        aCoder.encodeObject(town,       forKey:  PropertyKey.eventTown)
        aCoder.encodeObject(regio,      forKey:  PropertyKey.eventRegion)
        aCoder.encodeInteger(postalcode,forKey:  PropertyKey.eventPostal)
        aCoder.encodeObject(streetname, forKey:  PropertyKey.eventStreet)
         aCoder.encodeObject(eventId,   forKey:  PropertyKey.eventId)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let eventName   = aDecoder.decodeObjectForKey(PropertyKey.eventNameKey) as! String
        let placeName   = aDecoder.decodeObjectForKey(PropertyKey.eventPlaceNameKey) as! String
        let date        = aDecoder.decodeObjectForKey(PropertyKey.eventDateKey) as! String
        let rating      = aDecoder.decodeIntegerForKey(PropertyKey.eventRating)
        let descr       = aDecoder.decodeObjectForKey(PropertyKey.eventDescription) as! String
        let town        = aDecoder.decodeObjectForKey(PropertyKey.eventTown) as! String
        let regio       = aDecoder.decodeObjectForKey(PropertyKey.eventRegion) as! String
        let postalcode  = aDecoder.decodeIntegerForKey(PropertyKey.eventPostal)
        let streetname  = aDecoder.decodeObjectForKey(PropertyKey.eventStreet) as! String
        let eventId     = aDecoder.decodeObjectForKey(PropertyKey.eventId) as! String
        self.init(eventName : eventName, placeName: placeName, date: date, rating : rating, descr:descr, town : town, regio: regio, postalcode: postalcode, streetname: streetname, eventId : eventId )
    }
    }

extension Event {
    
    
    convenience init(json:NSDictionary) throws{
        guard let eventName = json["name"] as? String else {
            throw Service.Error.MissingJsonProperty(name: "name")}
        guard let placeName = json["placename"] as? String else {
            throw Service.Error.MissingJsonProperty(name: "placename")}
        guard let date = json["date"] as? String else {
            throw Service.Error.MissingJsonProperty(name: "date")}
        guard let rating = json["rating"] as? Int else {
            throw Service.Error.MissingJsonProperty(name: "rating")}
        guard let descr = json["description"] as? String else {
            throw Service.Error.MissingJsonProperty(name: "description")}
        guard let town = json["location"]!["town"]  as? String else {
            throw Service.Error.MissingJsonProperty(name: "town")}
        guard let regio = json["location"]!["region"]  as? String else {
            throw Service.Error.MissingJsonProperty(name: "region")}
        guard let postalcode = json["location"]!["postalcode"]  as? Int else {
            throw Service.Error.MissingJsonProperty(name: "postalcode")}
        guard let streetname = json["location"]!["streetname"]  as? String else {
            throw Service.Error.MissingJsonProperty(name: "streetname")}
        guard let eventId = json["_id"]  as? String else {
            throw Service.Error.MissingJsonProperty(name: "_id")}
        
        self.init( eventName : eventName, placeName: placeName, date: date, rating : rating, descr:descr, town : town, regio: regio, postalcode: postalcode, streetname: streetname,eventId: eventId)!
    }
    
   
}

