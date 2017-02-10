//
//  SpaceOnDiskInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

class SpaceOnDiskInteractor: SpaceOnDiskInteractorInterface {
    //MARK : VIPER
    var delegate:SpaceOnDiskInteractorDelegate?
    
    init(presenter:SpaceOnDiskPresenter){
        delegate = presenter
    }
    
    func getSpaceOnDiskValues() {
        deviceRemainingFreeSpaceInBytes()
    }
    
    func deviceRemainingFreeSpaceInBytes(){
        let usedDiskSpace = DiskStatus.usedDiskSpace
        let storageSizeText = DiskStatus.totalDiskSpace
        
        delegate?.setFreeMemory(freeMemory: DiskStatus.freeDiskSpace)
        
        let usedMemoryFloat:Float = Float(DiskStatus.usedDiskSpaceInBytes)
        let totalMemoryFloat:Float = Float(DiskStatus.totalDiskSpaceInBytes)
        
        delegate?.setPercentValue((usedMemoryFloat/totalMemoryFloat) * 100)
        
    }
    
    
    class DiskStatus {
        
        //MARK: Formatter MB only
        class func MBFormatter(_ bytes: Int64) -> String {
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = ByteCountFormatter.Units.useMB
            formatter.countStyle = ByteCountFormatter.CountStyle.decimal
            formatter.includesUnit = false
            return formatter.string(fromByteCount: bytes) as String
        }
        
        
        //MARK: Get String Value
        class var totalDiskSpace:String {
            get {
                return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
            }
        }
        
        class var freeDiskSpace:String {
            get {
                return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
            }
        }
        
        class var usedDiskSpace:String {
            get {
                return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
            }
        }
        
        
        //MARK: Get raw value
        class var totalDiskSpaceInBytes:Int64 {
            get {
                do {
                    let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                    let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
                    return space!
                } catch {
                    return 0
                }
            }
        }
        
        class var freeDiskSpaceInBytes:Int64 {
            get {
                do {
                    let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                    let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
                    return freeSpace!
                } catch {
                    return 0
                }
            }
        }
        
        class var usedDiskSpaceInBytes:Int64 {
            get {
                let usedSpace = totalDiskSpaceInBytes - freeDiskSpaceInBytes
                return usedSpace
            }
        }
        
    }
}
