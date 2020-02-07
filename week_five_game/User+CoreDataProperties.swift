//
//  User+CoreDataProperties.swift
//  week_five_game
//
//  Created by Eduardo Sorozabal on 2019-07-30.
//  Copyright © 2019 Alireza. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var username: String?
    @NSManaged public var password: String?
    @NSManaged public var score: Int32

}
