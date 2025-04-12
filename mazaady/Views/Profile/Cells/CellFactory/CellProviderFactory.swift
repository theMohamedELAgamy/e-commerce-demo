//
//  CellProviderFactory.swift
//  mazaady
//
//  Created by Mohamed on 12/04/2025.
//


// CellProviderFactory.swift
import UIKit

enum CellProviderFactory {
    static func provider(for sectionType: ProfileViewController.SectionType) -> CellProviderProtocol {
        switch sectionType {
        case .products:
            return ProductCellProvider()
        case .advertisements:
            return AdvertisementCellProvider()
        case .tags:
            return TagCellProvider()
        }
    }
    
    static func registerAllCells(for collectionView: UICollectionView) {
        ProfileViewController.SectionType.allCases.forEach { sectionType in
            let provider = self.provider(for: sectionType)
            type(of: provider).registerCell(for: collectionView)
        }
        
        // Register header
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "HeaderCell"
        )
    }
}