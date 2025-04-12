//
//  CollectionViewLayoutFactoryProtocol.swift
//  mazaady
//
//  Created by Mohamed on 12/04/2025.
//


import UIKit

// MARK: - Layout Factory Protocol
protocol CollectionViewLayoutFactoryProtocol {
    func createLayout() -> UICollectionViewCompositionalLayout
    func createSection(for sectionType: ProfileViewController.SectionType) -> NSCollectionLayoutSection
}

// MARK: - Layout Section Factory Protocol
protocol LayoutSectionFactoryProtocol {
    func createSection() -> NSCollectionLayoutSection
}