//
//  MusicAlbumTableViewCell.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 18.06.23.
//

import UIKit

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

class MusicAlbumTableViewCell: UITableViewCell, ReuseIdentifiable {
    static let reuseIdentifier = "MusicAlbumTableViewCell"

    private var tokenLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private var albumImageView = UIImageView()

    var dataTask: URLSessionDataTask?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        contentView.addSubview(tokenLabel)
        contentView.addSubview(albumImageView)

        tokenLabel.translatesAutoresizingMaskIntoConstraints = false
        albumImageView.translatesAutoresizingMaskIntoConstraints = false

        tokenLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        tokenLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        tokenLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        tokenLabel.trailingAnchor.constraint(equalTo: albumImageView.leadingAnchor, constant: -10).isActive = true

        albumImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        albumImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        albumImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        albumImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        albumImageView.widthAnchor.constraint(equalTo: albumImageView.heightAnchor).isActive = true
    }

    func setup(with data: AlbumCellData) {
        tokenLabel.text = data.collectionName

        let request = URLRequest(url: URL(string: data.artworkUrl100)!)
        dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self?.albumImageView.image = UIImage(data: data)
            }
        }
        dataTask?.resume()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = nil
        dataTask?.cancel()
    }
}
