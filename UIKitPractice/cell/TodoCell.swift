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
        
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        
        statusLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        statusLabel.textAlignment = .right
        statusLabel.setContentHuggingPriority(.required, for: .horizontal)
        statusLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(statusLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusLabel.leadingAnchor, constant: -8),
            
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statusLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds.inset(by: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(named: "ThemeSurface") ?? .white
    }
    
    func configure(with task: Todo) {
        titleLabel.attributedText = nil
        titleLabel.text = task.desc
        titleLabel.textColor = UIColor(named: "ThemeAccent") ?? .label
        
        if let status = StatusEnum.from(task.status) {
            statusLabel.text = status.displayTitle
            statusLabel.textColor = status.statusColor
            accessoryType = .none
            if status == .completed {
                titleLabel.textColor = .tertiaryLabel
                statusLabel.textColor = status.statusColor.withAlphaComponent(0.6)
            }
        } else {
            statusLabel.text = task.status
            statusLabel.textColor = .secondaryLabel
            accessoryType = .none
        }
    }
}
