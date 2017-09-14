//
//  FocusPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

protocol FocusPresenterInterface {
    func autoModePushed()
    func manualModePushed()
    func focusLensModePushed()

    func checkFocalLensEnabled()

    func setFocusAtPoint(_ point: CGPoint,
                         frame: CGRect)
}

protocol FocusPresenterDelegate {
    func showFocalLens()
    func hideFocalLens()

    func setAutoButtonSelected(_ state: Bool)
    func setTapManualButtonSelected(_ state: Bool)
    func setFocalLensManualButtonSelected(_ state: Bool)
    func sendFocusPoint(_ point: CGPoint)
}
