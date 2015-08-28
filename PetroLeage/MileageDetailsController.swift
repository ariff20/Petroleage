//
//  MileageDetailsController.swift
//  PetroLeage
//
//  Created by Sharifah Nazreen Ashraff ali on 8/27/15.
//  Copyright (c) 2015 Syed Mohamed Ariff. All rights reserved.
//

import UIKit

class MileageDetailsViewController : UIViewController ,UITextFieldDelegate{
    
    
    @IBOutlet weak var cardetaillabel: UILabel!
    
    @IBOutlet weak var carbackgroundtextfield: UITextField!
    @IBOutlet weak var carmodeltextfield: UITextField!
    
    
    @IBOutlet weak var currentestimatedfield: UITextField!
    
    @IBOutlet weak var enginecctetfield: UITextField!
    
    @IBOutlet weak var imageview: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
        self.subscribeToKeyboardHideNotifications()
        self.navigationController?.setToolbarHidden(true, animated: true)
        
    }
    
    override func  viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribefromKeyboardNotifications()
        self.unsubscribefromKeyboardHideNotifications()
        self.navigationController?.setToolbarHidden(false, animated: animated)
        
    }
    func textFieldShouldReturn(texfieldtop: UITextField) -> Bool {
        
        texfieldtop.resignFirstResponder()
        
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        carbackgroundtextfield.delegate = self
        carmodeltextfield.delegate = self
        currentestimatedfield.delegate = self
        enginecctetfield.delegate = self
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func keyboardWillShow(notification: NSNotification){
            self.view.frame.origin.y = -getKeyboardHeight(notification)
    }
    func keyboardWillHide(notifications: NSNotification){
        
            self.view.frame.origin.y = 0
        
        
    }
    func getKeyboardHeight(notification: NSNotification)->CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    func subscribeToKeyboardHideNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    func unsubscribefromKeyboardHideNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    func unsubscribefromKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }

    @IBAction func submit(sender: AnyObject) {
        var detail = ParseObject(Car_model : carmodeltextfield.text! , car_brand : carbackgroundtextfield.text! , engine_cc : enginecctetfield.text!)
        (UIApplication.sharedApplication().delegate as! AppDelegate).car.append(detail)

    }




    
}
