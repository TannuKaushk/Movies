//
//  ListTableViewCell.swift
//  TheMovies
//
//  Created by Tannu Kaushik on 20/04/22.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    static let cellID = "ListTableViewCell"

    private lazy var itemImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .cGrayDark
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .cGrayDark
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .cGrayDark
        return label
    }()
    
    private lazy var ratingImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.tintColor = .cTheme
        view.image = UIImage(named: "starIcon")
        return view
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.clipsToBounds = true
        stackView.alignment = .leading
        stackView.backgroundColor = .white
        return stackView
    }()
    private let dataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)
        return stackView
    }()
    
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .horizontal
        return stackView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        initViews()
    }
    
    private func initViews() {
        backgroundColor = .clear
        contentView.addSubview(mainStackView)
        configureConstraints()
        [ratingImageView,
         ratingLabel].forEach { ratingStackView.addArrangedSubview($0) }
        [titleLabel,
         yearLabel,
         ratingStackView].forEach { dataStackView.addArrangedSubview($0) }
        [itemImageView,
         dataStackView].forEach { mainStackView.addArrangedSubview($0) }
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            mainStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            mainStackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            itemImageView.heightAnchor.constraint(equalToConstant: 120.0),
            itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor, multiplier: 0.8)
        ])
    }
    
    //MARK: - Cell setup
    /**
     Setup cell using model
     */
    func configure(with model: Result, imageService: ImageService) {
        let placeholderImage = "placeholderIcon"        
        if let imagePath = model.posterPath {
            do {
                Task {
                    let imageData = try await imageService.load(urlPath: imagePath)
                    DispatchQueue.main.async {
                        if let image = UIImage(data: imageData) {
                            self.itemImageView.image = image
                        } else {
                            self.itemImageView.image = UIImage(named: placeholderImage)
                        }
                    }
                }
            }
        } else {
            //add placeholder
            itemImageView.image = UIImage(named: placeholderImage)
        }
        titleLabel.text = model.title
        
        if let date = model.releaseDate.getDate() {
            let year = Calendar.current.component(.year, from: date)
            yearLabel.text = String(year)
        }
        ratingLabel.text = String(model.voteAverage)
    }


}
