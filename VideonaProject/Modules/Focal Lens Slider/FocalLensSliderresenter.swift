//
//  FocalLensSliderPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

open class FocalLensSliderPresenter:FocalLensSliderPresenterInterface,FocalLensSliderInteractorDelegate{
    //MARK : VIPER
    var delegate:FocalLensSliderPresenterDelegate
    var interactor:FocalLensSliderInteractorInterface?
    
    init(controller:FocalLensSliderView){
        delegate = controller
        interactor = FocalLensSliderInteractor(presenter: self)
    }
    
    func sliderValueHasChangedTo(_ value: Float) {
        interactor?.setLensDistanceTo(value)
    }
}
