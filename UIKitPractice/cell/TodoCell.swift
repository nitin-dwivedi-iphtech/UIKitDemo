//
//  TodoCell.swift
//  UIKitPractice
//
//  Created by iPHTech 40 on 20/08/26.
//

import UIKit
import CoreData

class TodoCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let statusLabel = UILabel()
    private let categoryBadge = UILabel()
    private let accentBar = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        
        // Accent bar
        accentBar.translatesAutoresizingMaskIntoConstraints = false
        accentBar.layer.cornerRadius = 2
        accentBar.clipsToBounds = true
        
        // Title
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Category badge
        categoryBadge.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        categoryBadge.textColor = .white
        categoryBadge.backgroundColor = .systemGray
        categoryBadge.layer.cornerRadius = 4
        categoryBadge.layer.masksToBounds = true
        categoryBadge.textAlignment = .center
        categoryBadge.setContentHuggingPriority(.required, for: .horizontal)
        categoryBadge.translatesAutoresizingMaskIntoConstraints = false
        
        // Status label
        statusLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        statusLabel.setContentHuggingPriority(.required, for: .horizontal)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        contentView.addSubview(accentBar)
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryBadge)
        contentView.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            // Accent bar
            accentBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            accentBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            accentBar.widthAnchor.constraint(equalToConstant: 3),
            accentBar.heightAnchor.constraint(equalToConstant: 36),
            
            // Title - top left
            titleLabel.leadingAnchor.constraint(equalTo: accentBar.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusLabel.leadingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            // Category badge - bottom left
            categoryBadge.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            categoryBadge.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            categoryBadge.heightAnchor.constraint(equalToConstant: 16),
            categoryBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 44),
            
            // Status - top right
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            statusLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let inset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        contentView.frame = contentView.frame.inset(by: inset)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(named: "ThemeSurface") ?? .white
    }
    
    func configure(with task: Todo) {
        titleLabel.text = task.desc
        
        // Category badge
        if let categoryRaw = task.category, let section = TodoSections.allCases.first(where: { $0.rawValue == categoryRaw }) {
            categoryBadge.text = " \(section.rawValue) "
            categoryBadge.isHidden = false
            switch section {
            case .all:
                categoryBadge.backgroundColor = .systemGray
                accentBar.backgroundColor = .systemGray
            case .work:
                categoryBadge.backgroundColor = .systemBlue
                accentBar.backgroundColor = .systemBlue
            case .personal:
                categoryBadge.backgroundColor = .systemPurple
                accentBar.backgroundColor = .systemPurple
            case .shopping:
                categoryBadge.backgroundColor = .systemOrange
                accentBar.backgroundColor = .systemOrange
            }
        } else {
            categoryBadge.isHidden = true
            accentBar.backgroundColor = UIColor(named: "ThemeAccent")
        }
        
        // Status
        if let status = StatusEnum.from(task.status) {
            statusLabel.text = status.displayTitle
            statusLabel.textColor = status.statusColor
            
            if status == .completed {
                titleLabel.textColor = .tertiaryLabel
                categoryBadge.alpha = 0.5
                accentBar.alpha = 0.5
            } else {
                titleLabel.textColor = .label
                categoryBadge.alpha = 1.0
                accentBar.alpha = 1.0
            }
        } else {
            statusLabel.text = task.status
            statusLabel.textColor = .secondaryLabel
        }
    }
}
