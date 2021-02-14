//
//  PersonalInfo.swift
//  realmINECRUD
//
//  Created by IDS Comercial on 14/02/21.
//  Copyright © 2021 Americo MQ. All rights reserved.
//

import Foundation
import RealmSwift

class PersonalInfo: Object {
    @objc dynamic var fullName: String?
    @objc dynamic var email: String?
    @objc dynamic var age: String?
    @objc dynamic var country: String?
}
