//
//  SignupVC.swift
//  week_five_game
//
//  Created by Eduardo Sorozabal on 2019-07-30.
//  Copyright © 2019 Alireza. All rights reserved.
//

import UIKit
import CoreData


class SignupVC: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var Pass: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    var users = [User]()
    var currentUser = CurrentUser();
    var uName = ""
    var pass  = ""
    var valid = 0
    var valid2 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users1 = try PersistenceServce.context.fetch(fetchRequest)
            self.users = users1
        } catch {}
        
     
        
    }
    @IBAction func SignUp(_ sender: UIButton) {
        valid = 0;
        valid2 = 0;
        //validation checks
        if(username.text == ""){
            label1.text = "Please Enter a user name"
            valid = 1
            valid2 = 1
        }
        else{
            label1.text = ""
        }
        if(Pass.text == ""){
            label2.text = "Please Enter a password"
            valid = 1
            valid2 = 1
        }
        else{
            label2.text = ""
        }
        if(confirmPass.text == ""){
            label3.text = "Please confirm password"
            valid = 1
            valid2 = 1
        }
        else{
            label3.text = ""
        }
        
        if(confirmPass.text!.elementsEqual(Pass.text!)){
        
        }
        else{
            label3.text = "Passwords do not match"
            valid = 1
            valid2 = 1
        }
        
        if (valid == 0){
            //make sure we do not allow duplicate names
            uName = username.text!
            pass = Pass.text!
            for users in users {
                if(users.username!.elementsEqual(uName)){
                    label1.text = "Username Already In Use"
                    valid2 = 1
                }
            }
        }
        if(valid2 == 0){
            //save user to device
            let user = User(context: PersistenceServce.context)
            user.username = uName
            user.password = pass
            user.score = Int32(0)
            //current user is used to know when a user is logged in, so that if they close the app they are still loged in
            currentUser = CurrentUser(context: PersistenceServce.context)
            currentUser.name = uName
            
            PersistenceServce.saveContext()

            
            performSegue(withIdentifier: "signUp", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "signUp"){
            let vc = segue.destination as! ViewController
        }
     
        
    }
}
