//
//  User.swift
//  LoginCoreData
//
//  Created by Appinventiv Mac on 06/03/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import Foundation
import CoreData
@objc(User)
class User: NSManagedObject {

}

extension User {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    
    @NSManaged public var username: String?
    @NSManaged public var contactNo: String?
    @NSManaged public var age: String?
    @NSManaged public var email:String?
}

