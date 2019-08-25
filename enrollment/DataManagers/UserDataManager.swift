//
//  UserDataManager.swift
//  enrollment
//
//  Created by Kevin Torres on 8/21/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

// MARK: - UserDataManagerProtocol
protocol UserDataManagerProtocol: AnyObject {
    func add(user: User, completion: CompletionHandler)
    func getUser() -> User?
    func deleteAll(completion: CompletionHandler)
}

// MARK: - UserDataManager
class UserDataManager: UserDataManagerProtocol {
    func add(user: User, completion: CompletionHandler) {
        RealmRepo<User>.add(
            item: user,
            completion: completion
        )
    }
    
    func getUser() -> User? {
        return RealmRepo<User>.getFirst()
    }
    
    func deleteAll(completion: CompletionHandler) {
        RealmRepo<User>.deleteAll(completion: completion)
    }
}
