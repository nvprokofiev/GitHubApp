//
//  RepositoryTableViewCell.swift
//  course4
//
//  Created by Nikolai Prokofev on 2019-03-13.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import UIKit
import Kingfisher

class RepositoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    
    override func awakeFromNib() {
        setupViews()
    }
    
    private func setupViews() {
        authorImageView.layer.cornerRadius = authorImageView.frame.height / 2
        authorImageView.layer.masksToBounds = true
    }
    

    func configureCell(for repository: Repository) {
        titleLabel.text = repository.name
        subtitleLabel.text = repository.description
        authorLabel.text = repository.author.name
        guard let url = URL(string: repository.author.avatarUrl) else { return }
        authorImageView.kf.indicatorType = .activity
        authorImageView.kf.setImage(with: url)
    }
}
