//
//  UIViewController+Storage.swift
//  CoreDataDemo
//
//  Created by SERGEY VOROBEV on 06.07.2021.
//

import UIKit

extension UIViewController {
    func storage() -> DataStoring {
        (UIApplication.shared.delegate as! AppDelegate).storage
    }
}
