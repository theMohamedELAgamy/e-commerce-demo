//
//  ProductCellProvider.swift
//  mazaady
//
//  Created by Mohamed on 12/04/2025.
//


// ProductCellProvider.swift
import UIKit

struct ProductCellProvider: CellProviderProtocol {
    static var reuseIdentifier: String { "ProductCell" }
    
    static func registerCell(for collectionView: UICollectionView) {
        collectionView.register(
            UINib(nibName: "ProductCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: reuseIdentifier
        )
    }
    
    static func dequeueReusableCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    }
    
    func configureCell(_ cell: UICollectionViewCell, with data: Any) {
        guard let cell = cell as? ProductCollectionViewCell,
              let product = data as? Product else { return }
        cell.configure(with: product)
    }
}