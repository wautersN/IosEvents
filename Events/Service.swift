

import Foundation
import Alamofire

class Service{
    
    enum Error: ErrorType{
        case MissingJsonProperty(name:String)
        case NetworkError(message: String?)
        case UnexpetedStatusCode(code: Int)
        case InvalidJsonData
        case MissingData
        
    }
    
    //MARK: Singleton
    static let sharedService = Service()
    
    //MARK: Properties
    private let eventsUrl:NSURL
    private let ratingUrl:NSURL
    private let session: NSURLSession
    private let baseUrl : String
    
    
    init(){
        let propertiesPath = NSBundle.mainBundle().pathForResource("Properties", ofType: "plist")!
        let properties = NSDictionary(contentsOfFile: propertiesPath)!
        baseUrl = properties["baseUrl"] as! String
        eventsUrl = NSURL(string: baseUrl + "/events" )!
        ratingUrl = NSURL(string: baseUrl + "/events" )!
        session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    }
    
    
    
    func createFetchTask(completionHandler: (Result<[Event]>)-> Void) -> NSURLSessionTask{
        return session.dataTaskWithURL( eventsUrl ) { data, response, error in
            
            let completionHandler: Result<[Event]> -> Void = {
                result in
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(result)
                }
            }
            
            guard let response = response as? NSHTTPURLResponse else{
                completionHandler(.Failure(Service.Error.NetworkError(message: error?.description)))
                return
            }
            
            guard response.statusCode == 200 else{
                completionHandler(.Failure(.UnexpetedStatusCode(code: response.statusCode)))
                return
            }
            guard let data = data else{
                completionHandler(.Failure(.MissingData))
                return
            }
            
            do{
                let data = try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions()) as! NSArray                
                let results = try data.map { try Event(json: $0 as! NSDictionary) }
                completionHandler(.Success(results))
            } catch _ as NSError{
                completionHandler(.Failure(.InvalidJsonData))
            } catch let error as Service.Error{
                completionHandler(.Failure(error))
                
            }
        }
    }
    
    
    func setPostScore(eventId: String, rating : Int){
        let headers = ["Authorization" : Globals.token,]
        let parameters = [
            "rating": rating]
        //Set scrore on backend
        Alamofire.request(.POST, baseUrl + "/events/" + eventId + "/score", parameters: parameters, encoding: .URL, headers: headers)
    }
    
    func setNewArtist(eventId : String,name : String){
        let headers = ["Authorization" : Globals.token,]
        let parameters = ["artistname": name]
        Alamofire.request(.POST, baseUrl + "/events/" + eventId + "/artist", parameters: parameters, encoding: .URL, headers: headers).responseJSON {  result in
            let json = JSON(data: result.data!)
            print(json)
        }

    }

    
    func getArtists(eventId: String, completion : (response : [String]) -> ()) -> (){
          let headers = ["Authorization" : Globals.token,]
        var items: [String] = []
        
        Alamofire.request(.GET, baseUrl + "/events/" + eventId, parameters: nil, encoding: .URL, headers: headers).responseJSON {  result in
            let json = JSON(data: result.data!)
            let list : Array<JSON> = json["artists"].arrayValue
            for art in list{
                items.append(art["artistname"].stringValue)
            }
            completion(response: items)
        }
        
    }
    
}




