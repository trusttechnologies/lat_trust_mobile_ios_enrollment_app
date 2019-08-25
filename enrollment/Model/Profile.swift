//
//  Profile.swift
//  enrollment
//
//  Created by Kevin Torres on 8/21/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import ObjectMapper
import RealmSwift

// MARK: - Profile
class Profile: MappableObject {
    var credentials = List<Credential>()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        credentials <- (map["credentials"], ListTransformClass<Credential>())
    }
}
