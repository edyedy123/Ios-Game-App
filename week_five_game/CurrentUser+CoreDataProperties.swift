//
//  CurrentUser+CoreDataProperties.swift
//  week_five_game
//
//  Created by Eduardo Sorozabal on 2019-08-02.
//  Copyright © 2019 Alireza. All rights reserved.
//
//

import Foundation
import CoreData


extension CurrentUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentUser> {
        return NSFetchRequest<CurrentUser>(entityName: "CurrentUser")
    }

    @NSManaged public var name: String?

}
