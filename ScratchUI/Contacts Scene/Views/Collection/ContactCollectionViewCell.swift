//
//  ContactCollectionViewCell.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 17/10/24.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.backgroundColor = .gray
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(lastNameLabel)

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),

            lastNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            lastNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            lastNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            lastNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with contact: ContactDisplay<Info.Basic>) {
        nameLabel.text = contact.name
        lastNameLabel.text = contact.lastName
        // TODO: Set avatar image when available
        avatarImageView.image = UIImage(data: contact.avatarData ?? Data())
        avatarImageView.backgroundColor = .lightGray
    }
}



//extension ContactCollectionCell {
//    func configure() {
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.adjustsFontForContentSizeCategory = true
//        contentView.addSubview(label)
//        label.font = UIFont.preferredFont(forTextStyle: .caption1)
//        let inset = CGFloat(10)
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
//            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
//            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
//            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
//        ])
//    }
//}
