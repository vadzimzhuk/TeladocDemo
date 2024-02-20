//
//  DefaultTableViewCell.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 18.06.23.
//

import UIKit

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

class DefaultTableViewCell: UITableViewCell, ReuseIdentifiable {
    static let reuseIdentifier = "DefaultWordTagCell"

    private var tokenLabel = UILabel()
    private var numberLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        contentView.addSubview(tokenLabel)
        contentView.addSubview(numberLabel)

        tokenLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.translatesAutoresizingMaskIntoConstraints = false

        tokenLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        tokenLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        tokenLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        tokenLabel.trailingAnchor.constraint(equalTo: numberLabel.leadingAnchor, constant: -10).isActive = true
        numberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        numberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        numberLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2).isActive = true
    }

    func setup(with data: WordTagCellData) {
        tokenLabel.text = data.word
        numberLabel.text = String(data.number)
    }
}
