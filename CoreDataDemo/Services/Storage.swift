//
//  Storage.swift
//  CoreDataDemo
//
//  Created by SERGEY VOROBEV on 06.07.2021.
//

import Foundation

enum StorageService {
    case coreData
}

class Storage {
    static var shared = Storage()
    
    func service(with service: StorageService) -> DataStoring {
        switch service {
        case .coreData:
            return CoreDataStorage()
        }
            
    }
    
    private init() { }
}
