//
//  ViewController.swift
//  week_five_game
//
//  Created by Eduardo Sorozabal on 2019-07-30.
//  Copyright © 2019 Alireza. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var score: UILabel!
    
    @IBOutlet weak var label1: UILabel!
    
    var loggedIn = false
    var currentUser = [CurrentUser]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        //fetch users from device storage
        let fetchRequest: NSFetchRequest<CurrentUser> = CurrentUser.fetchRequest()
        
        do {
            currentUser = try PersistenceServce.context.fetch(fetchRequest)
           
            if(currentUser.count != 0){
                loggedIn = true
                label1.text = "Current User: \(currentUser[0].name!)"
                
            }
            
        } catch {
            print("Not Logged In")
        }
        
        
    }
    //logout function deletes current user and jumps to login page
    @IBAction func logout(_ sender: UIButton) {
        loggedIn = false
        
        PersistenceServce.context.delete(currentUser[0])
        PersistenceServce.saveContext()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(newViewController, animated: true, completion: nil)
    }
    //checks if there is a curernt user at startup, if not, jump to login page
    override func viewDidAppear(_ animated: Bool) {
        if(loggedIn == false){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.present(newViewController, animated: true, completion: nil)
        }
    }
   
    @IBAction func play(_ sender: UIButton) {
        performSegue(withIdentifier: "Game", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Game"){
            let vc = segue.destination as! GameViewController
            vc.currentUser = currentUser[0].name!
        }
    }
}
