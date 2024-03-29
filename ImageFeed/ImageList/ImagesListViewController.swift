//
//  ViewController.swift
//  ImageFeed
//
//  Created by Kirill Gontsov on 23.03.2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    @IBOutlet weak private var tableView: UITableView!
    
    private let imagesListService = ImagesListService()
    private var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableViewAnimated), name: ImagesListService.didChangeNotification, object: nil)
        imagesListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            guard let indexPath = sender as? IndexPath else { return }
            viewController.fullImageUrl = photos[indexPath.row].fullImageUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        if let image = UIImage(named: "\(indexPath.row)") {
            cell.cellImage.image = image
        } else {
            return
        }
        
        cell.dateLabel.text = dateFormatter.string(from: Date())
        cell.setIsLiked(photo.isLiked)
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        } else {
            return
        }
    }
    
    @objc private func updateTableViewAnimated() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let oldCount = self.photos.count
            let newPhotos = self.imagesListService.photos
            let uniqueNewPhotos = newPhotos.filter { newPhoto in
                !self.photos.contains { $0.id == newPhoto.id }
            }
            
            self.photos.append(contentsOf: uniqueNewPhotos)
            let newCount = self.photos.count
            
            if oldCount != newCount {
                self.tableView.performBatchUpdates({
                    let indexPaths = (oldCount..<newCount).map { i in
                        IndexPath(row: i, section: 0)
                    }
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                }, completion: nil)
            }
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: "\(indexPath.row)") else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / image.size.width
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImagesListCell", for: indexPath) as? ImagesListCell else { fatalError("Cannot extract cell") }
        cell.delegate = self
        let photo = photos[indexPath.row]

        cell.setIsLiked(photo.isLiked)

        if let url = URL(string: photo.thumbImageURL) {
            cell.cellImage.kf.indicatorType = .activity
            cell.cellImage.kf.setImage(with: url,
                                        placeholder: UIImage(named: "Cardstublenta"),
                                        options: []) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    if let created = photo.createdAt {
                        cell.dateLabel.text = self.dateFormatter.string(from: created)
                    } else {
                        cell.dateLabel.text = ""
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        return cell
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        let isLiked = !photo.isLiked
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: isLiked) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self.photos.firstIndex(where: { $0.id == photo.id }) {
                        self.photos[index].isLiked = isLiked
                        cell.setIsLiked(isLiked)
                    }
                case .failure(let error):
                    print("Error changing like: \(error)")
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}



