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

/*It is an approach to make the cell's height dynamic, I published an article two years ago about it.
  Feel free to check it out the links
  https://medium.com/swift2go/implementing-a-dynamic-height-uicollectionviewcell-in-swift-5-bdd912acd5c8
  https://github.com/MohannadBakbouk/DynamicCell */

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
      cache.removeAll()
      contentHeight = 0
      super.invalidateLayout()
   }
  
  override func prepare() {
      guard cache.isEmpty == true , let collectionView = collectionView else {return}
      let columnWidth = contentWidth / CGFloat(numberOfColumns)
      var xOffset: [CGFloat] = []
      _ = (0..<numberOfColumns).map{xOffset.append(CGFloat($0) * columnWidth)}
      var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
      
    for item in 0..<collectionView.numberOfItems(inSection: 0) {
      let column = yOffset.firstIndex(of: yOffset.min() ?? 0) ?? 0
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

