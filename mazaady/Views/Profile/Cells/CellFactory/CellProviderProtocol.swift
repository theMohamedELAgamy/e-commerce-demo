//
//  CellProviderProtocol.swift
//  mazaady
//
//  Created by Mohamed on 12/04/2025.
//


// CellProviderProtocol.swift
import UIKit

protocol CellProviderProtocol {
    static var reuseIdentifier: String { get }
    static func registerCell(for collectionView: UICollectionView)
    static func dequeueReusableCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    func configureCell(_ cell: UICollectionViewCell, with data: Any)
}