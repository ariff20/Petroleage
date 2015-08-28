//
//  PetrolCalculator.swift
//  PetroLeage
//
//  Created by Sharifah Nazreen Ashraff ali on 8/27/15.
//  Copyright (c) 2015 Syed Mohamed Ariff. All rights reserved.
//

import UIKit


class PetrolCalculator : UIViewController
{
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
  
    
    @IBAction func loginAction(sender: AnyObject) {
        var username = self.usernameField.text
        var password = self.passwordField.text
        
      
            self.actInd.startAnimating()
            
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                
                self.actInd.stopAnimating()
                
                if ((user) != nil) {
                    
                    var alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                     let nextPage = self.storyboard?.instantiateViewControllerWithIdentifier("tabbarcontroller") as! UITabBarController
                    
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.window?.rootViewController = nextPage
                    
                }else {
                    
                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    
                }
                
            })
            
        

    }
    
    @IBAction func signUpAction(sender: AnyObject) {
        self.performSegueWithIdentifier("signUp", sender: self)
    }
}
