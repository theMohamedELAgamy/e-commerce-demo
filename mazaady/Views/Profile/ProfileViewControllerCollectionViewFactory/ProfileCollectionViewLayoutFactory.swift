//
//  ProfileCollectionViewLayoutFactory.swift
//  mazaady
//
//  Created by Mohamed on 12/04/2025.
//


import UIKit

class ProfileCollectionViewLayoutFactory: CollectionViewLayoutFactoryProtocol {
    
    private let sectionFactories: [ProfileViewController.SectionType: LayoutSectionFactoryProtocol]
    
    init() {
        // Initialize all section factories
        sectionFactories = [
            .products: ProductsSectionFactory(),
            .advertisements: AdvertisementsSectionFactory(),
            .tags: TagsSectionFactory()
        ]
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self,
                  let sectionType = ProfileViewController.SectionType(rawValue: sectionIndex) else { 
                return nil 
            }
            
            return self.createSection(for: sectionType)
        }
    }
    
    func createSection(for sectionType: ProfileViewController.SectionType) -> NSCollectionLayoutSection {
        guard let factory = sectionFactories[sectionType] else {
            fatalError("No factory found for section type: \(sectionType)")
        }
        
        return factory.createSection()
    }
}