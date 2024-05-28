//
//  GistCell.swift
//  GitHubGists
//
//  Created by Mauricio Lorenzetti on 27/05/24.
//

import UIKit

class GistCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var filesCountLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.masksToBounds = true
    }
}
