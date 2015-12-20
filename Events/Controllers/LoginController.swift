
import UIKit
import Alamofire


class LoginViewController: UIViewController{
    
    @IBOutlet weak var txtname: UITextField!
    @IBOutlet weak var txtpas: UITextField!
    @IBAction func btnAanmeldenAction(sender: AnyObject) {
            if (txtname.text == "" || txtpas == "" ){
                txtname.backgroundColor = UIColor.redColor()
                txtpas.backgroundColor = UIColor.redColor()
            }else{
                let parameters = [
                    "username": txtname.text!,
                    "password": txtpas.text!]
                Alamofire.request(.POST, "https://eventsbackend.herokuapp.com/login", parameters: parameters,encoding: .JSON ).responseJSON {  result in
                    let json = JSON(data: result.data!)
                    let token = json["token"].stringValue
                    Globals.logedIn = token.isEmpty ? false : true
                    if(Globals.logedIn ){
                        Globals.token = "Bearer " + token
                        self.performSegueWithIdentifier("ShowEvents", sender: nil)
                    } else {
                        self.txtname.backgroundColor = UIColor.redColor()
                        self.txtpas.backgroundColor = UIColor.redColor()
                    }
                }
            }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if identifier == "NoLoginShowEvents"{
            Globals.token = ""
            Globals.logedIn = false
            print(Globals.logedIn)
            return true
            
        }
        
        return false
    }
    
}

