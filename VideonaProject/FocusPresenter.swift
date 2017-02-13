//
//  FocusPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

open class FocusPresenter:FocusPresenterInterface{
    //MARK : VIPER
    var delegate:FocusPresenterDelegate
    var interactor:FocusInteractorInterface?
    
    var isFocalLensShowing = false
    
    init(controller:FocusView){
        delegate = controller
        interactor = FocusInteractor(presenter: self)
    }
    
    func autoModePushed() {
        interactor?.setAutoFocusMode()
        
        delegate.hideFocalLens()
        
        setAllButtonsUnSelected()
        
        isFocalLensShowing = false
        
        delegate.setAutoButtonSelected(true)
    }
    
    func manualModePushed() {
        interactor?.setManualFocusMode()
        
        delegate.hideFocalLens()
        
        setAllButtonsUnSelected()
        
        isFocalLensShowing = false
        
        delegate.setTapManualButtonSelected(true)
    }
    
    func checkFocalLensEnabled() {
        if isFocalLensShowing {
            delegate.showFocalLens()
        }
    }
    
    func focusLensModePushed() {
        if isFocalLensShowing {
            delegate.hideFocalLens()
            
            isFocalLensShowing = false
        }else{
            delegate.showFocalLens()
            
            isFocalLensShowing = true
            
            interactor?.setManualFocusModeOff()
            setAllButtonsUnSelected()
            delegate.setFocalLensManualButtonSelected(true)
        }
    }
    
    func setAllButtonsUnSelected(){
        delegate.setAutoButtonSelected(false)
        delegate.setTapManualButtonSelected(false)
        delegate.setFocalLensManualButtonSelected(false)
    }
    
    func setFocusAtPoint(_ point: CGPoint, frame: CGRect) {
        interactor?.focusToPoint(point,
                                 viewFrame: frame)
    }
}

extension FocusPresenter:FocusInteractorDelegate{
    func sendFocusPoint(_ point: CGPoint){
        delegate.sendFocusPoint(point)
    }
}
