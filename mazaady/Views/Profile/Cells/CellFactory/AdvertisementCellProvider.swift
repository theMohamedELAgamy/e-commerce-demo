//
//  AdvertisementCellProvider.swift
//  mazaady
//
//  Created by Mohamed on 12/04/2025.
//


// AdvertisementCellProvider.swift
import UIKit

struct AdvertisementCellProvider: CellProviderProtocol {
    static var reuseIdentifier: String { "AdvertisementCell" }
    
    static func registerCell(for collectionView: UICollectionView) {
        collectionView.register(
            UINib(nibName: "AdvertisementCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: reuseIdentifier
        )
    }
    
    static func dequeueReusableCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    }
    
    func configureCell(_ cell: UICollectionViewCell, with data: Any) {
        guard let cell = cell as? AdvertisementCollectionViewCell,
              let advertisement = data as? Advertisement else { return }
        cell.configure(with: advertisement)
    }
}