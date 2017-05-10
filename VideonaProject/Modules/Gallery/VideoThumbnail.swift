//
//  VideoThumbnail.swift
//  VideosGallery
//
//  Created by Alejandro Arjonilla Garcia on 28/10/16.
//  Copyright © 2016 ArjonillaCorporation. All rights reserved.
//

import UIKit

public let reuseIdentifier = "VideoCell"
open class VideoThumbnail: UICollectionViewCell {
    
    @IBOutlet var imgView : UIImageView!
    @IBOutlet var timeLabel : UILabel!

    func setThumbnailImage(_ thumbnailImage: UIImage){
        self.imgView.image = thumbnailImage
    }
    
    func setTimeText(_ time:String){
        self.timeLabel.text = time
    }
}
