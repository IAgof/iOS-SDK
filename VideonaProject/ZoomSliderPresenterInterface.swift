//
//  ZoomSliderPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//


protocol ZoomSliderPresenterInterface{
    func sliderValueHasChangedTo(_ value:Float)
    func setZoomWithPinch(_ scale:CGFloat,
                          velocity:CGFloat)
}

protocol ZoomSliderPresenterDelegate{
    func updateSliderValue(_ value:Float)
}
