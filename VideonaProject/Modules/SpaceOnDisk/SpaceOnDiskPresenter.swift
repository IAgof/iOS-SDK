//
//  SpaceOnDiskPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

struct FreeMemoryMessageForLanguage {
    let message:String
    init(freeMemory: String) {
        let preferredLanguage = NSLocale.preferredLanguages[0] as String
        
        if preferredLanguage == "es-ES"{
            message = "Memoria libre \(freeMemory)"
        }else{
            message = "Free memory \(freeMemory)"
        }
    }
}

open class SpaceOnDiskPresenter:SpaceOnDiskPresenterInterface,SpaceOnDiskInteractorDelegate{
    //MARK : VIPER
    var delegate:SpaceOnDiskPresenterDelegate
    var interactor:SpaceOnDiskInteractorInterface?
    
    init(controller:SpaceOnDiskView){
        delegate = controller
        interactor = SpaceOnDiskInteractor(presenter: self)
    }
    
    func updateSpaceLeftLevel() {
        interactor?.getSpaceOnDiskValues()
    }
    
    //Interactor Delegate
    func setPercentValue(_ level: Float) {
        delegate.updateBarValue(CGFloat(level))
        self.updateSpaceLeftLevelColor(level)
    }
    
    func setFreeMemory(freeMemory: String) {
        delegate.updateTextSpaceLeft(FreeMemoryMessageForLanguage(freeMemory: freeMemory).message)
    }
    
    //MARK: - Inner function
    func updateSpaceLeftLevelColor(_ level:Float){
        var color = UIColor.red
        
        switch level {
        case 0...50:
            color = UIColor.green
            break
        case 51...80:
            color = UIColor.yellow
            break
        case 80...100:
            color = UIColor.red
            break            
        default:
            color = UIColor.red
            break
        }
        
        delegate.updateBarColor(color)
    }
}
