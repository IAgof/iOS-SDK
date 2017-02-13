//
//  ZoomSliderInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol ZoomSliderInteractorInterface{
    func setZoomTo(_ value:Float)
    func setZoomTo(_ scale:CGFloat,
              velocity:CGFloat)
}

protocol ZoomSliderInteractorDelegate{
    func zoomPinchedValueUpdate(_ value:Float)
}
