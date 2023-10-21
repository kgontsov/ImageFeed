//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Kirill Gontsov on 06.04.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        if isLiked {
            self.likeButton.imageView?.image = UIImage(named: "activeLike")
        } else {
            self.likeButton.imageView?.image = UIImage(named: "inActiveLike")
        }
    }
}

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
