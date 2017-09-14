//
//  VideosGalleryViewController.swift
//  VideosGallery
//
//  Created by Alejandro Arjonilla Garcia on 28/10/16.
//  Copyright © 2016 ArjonillaCorporation. All rights reserved.
//

import Foundation
import UIKit
import Photos
import AVKit

struct ChooseTitleForLanguage {
    let title: String
    init() {
        let preferredLanguage = NSLocale.preferredLanguages[0] as String

        if preferredLanguage == "es-ES"{
            title = "Elegir"
        } else {
            title = "Choose"
        }
    }
}

open class VideosGalleryViewController: UICollectionViewController {
    open var delegate: VideoGalleryDelegate?

    open var videosAsset: PHFetchResult<PHAsset>!
    open var assetThumbnailSize: CGSize!
    open var albumName: String = ""
    open var cellColor: UIColor?
    open var cellSpacing: CGFloat = 2.0

    @IBOutlet open var noPhotosLabel: UILabel!

    override open func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.allowsMultipleSelection = true
        cellColor = UIColor.black
    }

    func configureNavigationBarWithBackButton() {
        let saveItem = UIBarButtonItem(title: ChooseTitleForLanguage().title, style: .plain, target: self, action: #selector(saveButtonPushed(_:)))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPushed(_:)))

        UIApplication.topViewController()?.parent?.navigationItem.leftBarButtonItem = cancelItem
        UIApplication.topViewController()?.parent?.navigationItem.rightBarButtonItem = saveItem
    }

    override open func viewWillAppear(_ animated: Bool) {
        configureNavigationBarWithBackButton()

        // Get size of the collectionView cell for thumbnail image
        if let layout = self.collectionView!.collectionViewLayout as? UICollectionViewFlowLayout {
            let cellSize = layout.itemSize
            self.assetThumbnailSize = CGSize(width: cellSize.width, height: cellSize.height)
        }

        self.fetchVideos()

        if let photoCnt = self.videosAsset?.count {
            if(photoCnt == 0) {
                self.noPhotosLabel.isHidden = false
            } else {
                self.noPhotosLabel.isHidden = true
            }
        }
        self.collectionView!.reloadData()
    }
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveButtonPushed(_ sender: AnyObject) {
        getVideosSelectedURL({
            arrayURL in
            print("Selected arrayURL")
            print(arrayURL)
            self.delegate?.saveVideos(arrayURL)
        })
    }

    @IBAction func cancelButtonPushed(_ sender: AnyObject) {
        print("Cancel pushed")
        delegate?.cancelPushed()
    }
}

extension VideosGalleryViewController {
    open func fetchVideos() {
        //fetch the photos from collection
        self.navigationController?.hidesBarsOnTap = false   //!! Use optional chaining
        self.videosAsset = PHAsset.fetchAssets(with: .video, options: nil)
    }
}

extension VideosGalleryViewController {
    override open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView.cellForItem(at: indexPath) != nil else {return}
    }
}

extension VideosGalleryViewController {
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int = 0
        if(self.videosAsset != nil) {
            count = self.videosAsset.count
        }
        return count
    }

    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: VideoThumbnail = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VideoThumbnail

        //Modify the cell
        let asset: PHAsset = self.videosAsset[indexPath.item]
        cell.timeLabel.text = self.hourToString(asset.duration)

        PHImageManager.default().requestImage(for: asset, targetSize: self.assetThumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: {(result, _)in
            if let image = result {
                cell.setThumbnailImage(image)
            }
        })

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = cellColor
        cell.selectedBackgroundView = selectedBackgroundView

        return cell
    }

    func hourToString(_ time: Double) -> String {
        let mins = Int(floor(time.truncatingRemainder(dividingBy: 3600)) / 60)
        let secs = Int(floor(time.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60))

        return String(format:"%02d:%02d", mins, secs)
    }

}

extension VideosGalleryViewController:VideoGalleryInterface {
    public func getVideosSelectedURL(_ completion: @escaping ([URL]) -> Void) {
        var selectedURLs: [URL] = []
        guard let selectedIndexPaths = self.collectionView?.indexPathsForSelectedItems else {return}

        var countPaths = selectedIndexPaths.count

        for indexPath in selectedIndexPaths {
            let asset = self.videosAsset[indexPath.item]
//            var options:PHVideoRequestOptions = PHVideoRequestOptions()
//            options.version = PHVideoRequestOptionsVersion.original

            PHImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: {
                avasset, _, _ in

                if (avasset as? AVComposition) != nil {
                    let videoComposition: AVComposition = avasset as! AVComposition
                    let track = videoComposition.tracks(withMediaType: AVMediaTypeVideo).first
                    let segment = track?.segments.first

                    guard let url = segment?.sourceURL else {return}
                    selectedURLs.append(url)

                } else if let asset = avasset as? AVURLAsset {
                    selectedURLs.append(asset.url)

                }
                countPaths -= 1
                if countPaths == 0 {
                    completion(selectedURLs)
                }
            })
        }
    }
}

extension VideosGalleryViewController:UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = min(self.view.frame.width, self.view.frame.height)

        width = (width/3) - cellSpacing

        let size = CGSize(width: width, height: width)

        return size
    }

    public  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

}

extension UIApplication {
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
