//
//  LoginVC.swift
//  week_five_game
//
//  Created by Eduardo Sorozabal on 2019-07-30.
//  Copyright © 2019 Alireza. All rights reserved.
//

import UIKit
import CoreData


class LoginVC: UIViewController {
    
    var users = [User]()
    var currentUser = CurrentUser();
    var loggedIn = false
    var valid = 0
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetch users from device storage
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users1 = try PersistenceServce.context.fetch(fetchRequest)
            self.users = users1
        } catch {}

    }
    
    @IBAction func SignIn(_ sender: UIButton) {
        valid = 0
        var valid2 = 0
        //validation checks
        if(userName.text == ""){
            label1.text = "Please Enter a user name"
            valid = 1
        }
        else{
            label1.text = ""
        }
        if(password.text == ""){
            label2.text = "Please Enter a password"
            valid = 1
        }
        else{
            label2.text = ""
        }
        if(valid == 0){
            let username = userName.text
            let pass = password.text
            for users in users {
                //checks if password and usernames match
                if(users.username!.elementsEqual(username!)){
                    if(users.password!.elementsEqual(pass!)){
                        
                        currentUser = CurrentUser(context: PersistenceServce.context)
                        currentUser.name = userName.text
                        
                        PersistenceServce.saveContext()

                        performSegue(withIdentifier: "LogIn", sender: self)
                    }
                }
                else{
                    valid2 = 1
                }
            }
            if(valid2 == 1){
                label2.text = "Wrong Username or Password"
            }
         
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "LogIn"){
            let vc = segue.destination as! ViewController
        }
    }
}
