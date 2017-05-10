//
//  DuplicatePresenterInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 4/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

public protocol DuplicatePresenterInterface {
    func viewDidLoad()
    func viewWillDissappear()
    func pushCancelHandler()
    func pushAcceptHandler()
    func pushBack()
    
    func pushLessClips()
    func pushPlusClips()
    func expandPlayer()
}

public protocol DuplicatePresenterDelegate {
    func setNumberDuplicates(_ text:String)
    func setCloneYourClipText(_ text:String)
    func setThumbnails(_ image:UIImage)
    func getThumbSize()->CGRect
    func showMinusButton()
    func hideMinusButton()
    func bringToFrontExpandPlayerButton()
    
    func acceptFinished()
    func pushBackFinished()
    func expandPlayerToView()
    func setStopToVideo()
    func updatePlayerOnView(_ composition:VideoComposition)
    func trackNumberOfDuplicates(numberOfDuplicates number:Int)
}
