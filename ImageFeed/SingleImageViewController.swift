//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Kirill Gontsov on 25.05.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return } // 1
            imageView.image = image // 2
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}
