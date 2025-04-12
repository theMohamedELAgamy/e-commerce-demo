//
//  TagCellProvider.swift
//  mazaady
//
//  Created by Mohamed on 12/04/2025.
//


// TagCellProvider.swift
import UIKit

struct TagCellProvider: CellProviderProtocol {
    static var reuseIdentifier: String { "TagCell" }
    
    static func registerCell(for collectionView: UICollectionView) {
        collectionView.register(
            UINib(nibName: "TagCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: reuseIdentifier
        )
    }
    
    static func dequeueReusableCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    }
    
    func configureCell(_ cell: UICollectionViewCell, with data: Any) {
        guard let cell = cell as? TagCollectionViewCell,
              let tag = data as? Tag else { return }
        cell.configure(with: tag)
    }
}