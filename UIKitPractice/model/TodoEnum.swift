//
//  TodoEnum.swift
//  UIKitPractice
//
//  Created by iPHTech 40 on 20/08/26.
//
import UIKit

enum StatusEnum: String, Identifiable, CaseIterable {
    case pending = "pending"
    case completed = "completed"
    
    var id: String { self.rawValue }
    
    var displayTitle: String {
        switch self {
        case .pending:
            return "Pending"
        case .completed:
            return "Completed"
        }
    }
    
    var statusColor: UIColor {
        switch self {
        case .pending:
            return .systemRed
        case .completed:
            return .systemGreen
        }
    }
    
    static func from(_ raw: String?) -> StatusEnum? {
        guard let raw else { return nil }
        return allCases.first { $0.rawValue == raw.lowercased() }
    }
}

enum TodoSections: String, Identifiable, CaseIterable {
    case all = "All"
    case work = "Work"
    case personal = "Personal"
    case shopping = "Shopping"
    
    var id: String { self.rawValue }
}
