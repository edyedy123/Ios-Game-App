//
//  topTenVC.swift
//  week_five_game
//
//  Created by Eduardo Sorozabal on 2019-08-02.
//  Copyright © 2019 Alireza. All rights reserved.
//

import UIKit
import CoreData


class topTenVC: UIViewController, UITableViewDataSource{
    var users = [User]()
    

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        //load data saved on device
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(User.score), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let users1 = try PersistenceServce.context.fetch(fetchRequest)
            self.users = users1
            
        } catch {}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuse") as! CustomTableViewCell //1.
        var text = ""
        var score = ""
        if(users.count <= indexPath.row){
            text = "-------" //2.
            score = String(0) //2.
        }
        else{
            text = users[indexPath.row].username! //2.
            score = String(users[indexPath.row].score) //2.
        }
        cell.label1?.text = "\(indexPath.row + 1) - \(text)" //3.
        cell.label2?.text = score //3.
        
        return cell //4.
    }
    

}
