//
//  User.swift
//  enrollment
//
//  Created by Kevin Torres on 8/21/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import ObjectMapper
import RealmSwift

typealias MappableObject = Object & Mappable

// MARK: - Gender
enum Gender: String {
    case male
    case female
    
    var icon: UIImage? {
        switch self {
        case .male: return UIImage(named: "ifUser13356511")
        case .female: return UIImage(named: "path3326")
        }
    }
    
    var asInt: Int {
        switch self {
        case .male: return 0
        case .female: return 1
        }
    }
}

// MARK: - User
class User: MappableObject, PrimaryKeyable {
    typealias KeyType = String
    
    @objc dynamic var id: String? = "1"
    
    @objc dynamic var sub: String?
    @objc dynamic var country: String?
    
    @objc dynamic var birthDate: String?
    @objc dynamic var genderAsString: String?
    @objc dynamic var givenName: String?
    @objc dynamic var middleName: String?
    @objc dynamic var familyName: String?
    
    @objc dynamic var profileAsString: String?
    @objc dynamic var profile: Profile?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        sub <- map["sub"]
        country <- map["address.country"]
        birthDate <- map["birthdate"]
        genderAsString <- map["gender"]
        givenName <- map["given_name"]
        middleName <- map["middle_name"]
        familyName <- map["family_name"]
        profileAsString <- map["profile"]
        
        if let profileAsString = profileAsString {
            profile = Profile(JSONString: profileAsString)
        }
    }
    
    override static func primaryKey() -> String? {
        return primaryKeyIdentifier
    }
}

// MARK: - Methods
extension User {
    func checkIfUserHasMissingInfo() -> Bool {
        return
            givenName == nil ||
                familyName == nil ||
                middleName == nil ||
                genderAsString == nil ||
                country == nil ||
                birthDate == nil ? true : birthDate!.elementsEqual("19000101000000.000Z")
    }
}

// MARK: - ProfileDataSource
extension User: ProfileDataSource {
    var completeName: String? {
        return "\(givenName ?? .empty) \(familyName ?? .empty) \(middleName ?? .empty)"
    }
    
    var name: String? {
        return "\(givenName ?? .empty)"
    }
    
    var lastName: String? {
        return "\(familyName ?? .empty) \(middleName ?? .empty)"
    }
    
    var rut: String? {
        return profile?.credentials.first?.sub
    }
    
    var gender: Gender? {
        guard let genderAsString = genderAsString else {
            return nil
        }
        
        return Gender(rawValue: genderAsString)
    }
}
