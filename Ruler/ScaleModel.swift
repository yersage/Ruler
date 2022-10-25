//
//  ScaleModel.swift
//  Ruler
//
//  Created by Yersage on 24.10.2022.
//

import Foundation

protocol ScaleModel {
    var step: Int { get }
    var isSmallScaleHidden: Bool { get }
    var scaleLength: CGFloat { get }
    var isSmaleScaleBig: Bool { get }
}
