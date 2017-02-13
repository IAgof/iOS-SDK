//
//  DuplicatePresenter.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 4/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

open class DuplicatePresenter: NSObject,DuplicatePresenterInterface,DuplicateInteractorDelegate {
    //MARK: - Variables VIPER
    open var delegate:DuplicatePresenterDelegate?
    open var interactor: DuplicateInteractorInterface?
    
    //MARK: - Variables
    open var videoSelectedIndex:Int!{
        didSet{
            interactor?.setVideoPosition(videoSelectedIndex)
        }
    }
    
    open var numberOfDuplicates:Int = 2 {
        didSet{
            if numberOfDuplicates<=2{
                numberOfDuplicates = 2
                delegate?.hideMinusButton()
            }else if numberOfDuplicates == 3{
                delegate?.showMinusButton()
            }
            
            delegate?.setNumberDuplicates("x\(numberOfDuplicates)")
        }
    }
    open var isGoingToExpandPlayer = false
    
    //MARK: - Interface
    open func viewDidLoad() {
        numberOfDuplicates = 2

        delegate?.bringToFrontExpandPlayerButton()

        interactor?.getThumbnail((delegate?.getThumbSize())!)
        
        if let index = videoSelectedIndex {
            interactor?.setUpComposition(index,
                                         completion: {composition in
                                            self.delegate?.updatePlayerOnView(composition)
            })
        }
    }
    
    open func viewWillDissappear() {
        if !isGoingToExpandPlayer{
            delegate?.setStopToVideo()
        }
    }
    
    open func pushAcceptHandler() {
        interactor?.setDuplicateVideoToProject(numberOfDuplicates)
        
        delegate?.acceptFinished()
        delegate?.trackNumberOfDuplicates(numberOfDuplicates: numberOfDuplicates)
    }
    
    open func pushCancelHandler() {
        delegate?.pushBackFinished()
    }
    open func pushBack() {
        delegate?.pushBackFinished()
    }
    
    open func pushLessClips() {
        numberOfDuplicates -= 1
    }
    
    open func pushPlusClips() {
        numberOfDuplicates += 1
    }
    
    open func expandPlayer() {
        delegate?.expandPlayerToView()
        
        isGoingToExpandPlayer = true
    }
    
    //MARK: Interactor Delegate
    open func setThumbnail(_ image: UIImage) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.setThumbnails(image)
        })
    }
}
