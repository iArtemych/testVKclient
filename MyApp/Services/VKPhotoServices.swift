//
//  VKPhotoServices.swift
//  MyApp
//
//  Created by Артем Чурсин on 08.12.2017.
//  Заимствования у Дмитрий Федоринов
//  Copyright © 2017 Artem. All rights reserved.
//

import Foundation
import UIKit

class GetCacheImage: Operation {
    
    var cacheLifeTime: TimeInterval = 3600
    private let url: String
    var outputImage: UIImage?
    
    init(url: String) {
        self.url = url
    }
    init(url: String, cacheLifeTime: TimeInterval ) {
        self.url = url
        self.cacheLifeTime = cacheLifeTime
    }
    private static let pathName: String = {
        
        let pathName = "images"
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    private lazy var filePath: String? = {
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let hasheName = String(describing: self.url.hashValue)
        return cachesDirectory.appendingPathComponent(GetCacheImage.pathName + "/" + hasheName).path
    }()
    
    
    
    override func main() {
        
        guard filePath != nil && !isCancelled else { return }
        
        if getImageFormChache() { return }
        guard !isCancelled else { return }
        
        if !downloadImage() { return }
        guard !isCancelled else { return }
        
        saveImageToChache()
    }
    
    private func getImageFormChache() -> Bool {
        
        guard let fileName = filePath,
            let info = try? FileManager.default.attributesOfItem(atPath: fileName),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date else { return false }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileName) else { return false }
        
        self.outputImage = image
        return true
    }
    
    private func downloadImage() -> Bool  {
        
        guard let url = URL(string: url),
            let data = try? Data.init(contentsOf: url),
            let image = UIImage(data: data) else { return false }
        
        self.outputImage = image
        return true
    }
    
    private func saveImageToChache() {
        guard let fileName = filePath, let image = outputImage else { return }
        let data = UIImagePNGRepresentation(image)
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
    
}

class SetImageToRowInTabbleView: Operation {
    private let indexPath: IndexPath
    private weak var tableView: UITableView?
    private var cell: HaveImageView?
    
    init(cell: HaveImageView, indexPath: IndexPath, tableView: UITableView) {
        self.indexPath = indexPath
        self.tableView = tableView
        self.cell = cell
    }
    
    override func main() {
        
        guard let tableView = tableView,
            let cell = cell,
            let cashImage = dependencies[0] as? GetCacheImage,
            let image = cashImage.outputImage else { return }
        
        if let newIndexPath = tableView.indexPath(for: cell as! UITableViewCell), newIndexPath == indexPath {
            cell.giveImageView().image = image
        } else if tableView.indexPath(for: cell as! UITableViewCell) == nil {
            cell.giveImageView().image = image
        }
    }
}
class SetImageToRowInCollectionView: Operation {
    private let indexPath: IndexPath
    private weak var collectionView: UICollectionView?
    private var cell: HaveImageView?
    
    init(cell: HaveImageView, indexPath: IndexPath, collectionView: UICollectionView) {
        self.indexPath = indexPath
        self.collectionView = collectionView
        self.cell = cell
    }
    
    override func main() {
        
        guard let collectionView = collectionView,
            let cell = cell,
            let cashImage = dependencies[0] as? GetCacheImage,
            let image = cashImage.outputImage else { return }
        
        if let newIndexPath = collectionView.indexPath(for: cell as! UICollectionViewCell), newIndexPath == indexPath {
            cell.giveImageView().image = image
        } else if collectionView.indexPath(for: cell as! UICollectionViewCell) == nil {
            cell.giveImageView().image = image
        }
    }
}

protocol HaveImageView {
    func giveImageView() -> UIImageView
}
