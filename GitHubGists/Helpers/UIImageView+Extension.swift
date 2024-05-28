//
//  UIImageView+Extension.swift
//  GitHubGists
//
//  Created by Mauricio Lorenzetti on 28/05/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func configureForAvatar(with url: URL) {
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: .infinity)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage,
                .onFailureImage(UIImage(systemName: "wifi.slash"))
            ])
    }
}
