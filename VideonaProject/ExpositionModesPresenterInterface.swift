//
//  ExpositionModesPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

protocol ExpositionModesPresenterInterface{
    func autoModePushed()
    func manualModePushed()
    func centerModePushed()
    func manualSliderPushed()
    
    func checkIfHadToShowSlider()
    func setFocusAtPoint(_ point:CGPoint,
                         frame:CGRect)
}

protocol ExpositionModesPresenterDelegate{
    func setAutoButtonSelected(_ state:Bool)
    func setSliderManualButtonSelected(_ state:Bool)
    func setManualButtonSelected(_ state:Bool)
    func setCenterButtonSelected(_ state:Bool)
    
    func showExpositionSlider()
    func hideExpositionSlider()
    
    func sendFocusPoint(_ point: CGPoint)
}
