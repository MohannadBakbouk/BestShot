//
//  UIDynamicCollectionLayout.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import Foundation
import UIKit

protocol UIDynamicCollectionLayoutDelegate: AnyObject {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath , cellWidth : CGFloat ) -> CGFloat
}

final class UIDynamicCollectionLayout: UICollectionViewLayout {
  private let numberOfColumns = 2
  private let cellPadding: CGFloat = 6
  private var cache: [UICollectionViewLayoutAttributes] = []
  private var contentHeight: CGFloat = 0
  private var contentWidth: CGFloat {
    guard let collectionView = collectionView else {return 0}
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }
    
  weak var delegate: UIDynamicCollectionLayoutDelegate?

  override var collectionViewContentSize: CGSize {
     return CGSize(width: contentWidth, height: contentHeight)
  }
    
   override func invalidateLayout() {
      super.invalidateLayout()
      cache.removeAll()
      contentHeight = 0
   }
  
  override func prepare() {
      guard cache.isEmpty == true , let collectionView = collectionView else {return}
      let columnWidth = contentWidth / CGFloat(numberOfColumns)
      var xOffset: [CGFloat] = []
      _ = (0..<numberOfColumns).map{xOffset.append(CGFloat($0) * columnWidth)}
      var column = 0
      var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
      
    for item in 0..<collectionView.numberOfItems(inSection: 0) {
      let indexPath = IndexPath(item: item, section: 0)
      let photoHeight = delegate?.collectionView( collectionView,
        heightForPhotoAtIndexPath: indexPath , cellWidth: columnWidth) ?? 180
      let height = cellPadding * 2 + photoHeight
      let frame = CGRect(x: xOffset[column],y: yOffset[column],width: columnWidth,height: height)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      cache.append(attributes)
      contentHeight = max(contentHeight, frame.maxY)
      yOffset[column] = yOffset[column] + height
      column = column < (numberOfColumns - 1) ? (column + 1) : 0
    }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    for attributes in cache {
        _ = attributes.frame.intersects(rect) ? visibleLayoutAttributes.append(attributes) : ()
    }
    return visibleLayoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
}

