//
//  Extensions.swift
//  UIKitPractice
//
//  Created by iPHTech 40 on 19/08/26.
//
import CoreData

extension NSManagedObjectContext {
    
    @discardableResult
    func saveData() -> Bool{
        do {
            try self.save()
            return true
        } catch {
            print("Error fetching ...")
            return false
        }
    }
}
