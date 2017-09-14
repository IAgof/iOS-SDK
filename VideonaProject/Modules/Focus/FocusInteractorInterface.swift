//
//  FocusInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol FocusInteractorInterface {
    func setAutoFocusMode()
    func setManualFocusMode()
    func setManualFocusModeOff()

    func focusToPoint(_ tapLocation: CGPoint,
                      viewFrame: CGRect)
}

protocol FocusInteractorDelegate {
    func sendFocusPoint(_ point: CGPoint)
}
