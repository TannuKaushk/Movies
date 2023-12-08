//
//  GenreCollectionViewCell.swift
//  TheMovies
//
//  Created by Tannu Kaushik on 24/04/22.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    static let cellID = "GenreCollectionViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.sizeToFit()
        label.textColor = .cGrayDark
        label.textAlignment = .center
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    private func initViews() {
        backgroundColor = .clear
        contentView.addSubview(titleLabel)
        contentView.layer.borderColor = UIColor.cGray.cgColor
        contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = 12.0
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4)
        ])
    }
    //MARK: - Cell setup
    /**
     Setup cell using title string
     */
    func configure(with title: String) {
        self.titleLabel.text = title
    }
}
