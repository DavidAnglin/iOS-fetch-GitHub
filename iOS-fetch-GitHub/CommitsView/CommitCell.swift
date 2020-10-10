//
//  CommitCell.swift
//  iOS-fetch-GitHub
//
//  Created by David Anglin on 10/10/20.
//

import UIKit

class CommitCell: UITableViewCell {
    static var reuseIdentifier: String {
        return "CommitCell"
    }

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commitHashLabel: UILabel!
    @IBOutlet weak var commitMessageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with commitContainer: CommitContainer) {
        authorLabel.text = commitContainer.commit.author.authorString
        commitHashLabel.text = commitContainer.commitHash
        commitMessageLabel.text = commitContainer.commit.message
    }
}
