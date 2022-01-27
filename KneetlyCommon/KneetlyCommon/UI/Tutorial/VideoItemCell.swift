//
//  VideoItemCell.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 1/26/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

struct VideoItemCellInfo {
    let name: String?
    let info: NSAttributedString?
}

extension VideoItemCellInfo {
    
    private static let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.maximumUnitCount = 2
        return formatter
    }()
    
    static func makeInfo(withVideoItem item: VideoItem) -> VideoItemCellInfo {
        let name = item.title
        let baseFont = R.font.gibsonLight(size: 16)!
        
        let info: NSMutableAttributedString
        var durationStr = formatDurationTime(time: item.duration)
        var watchedStr: String?
        if let isWatched = item.isWatched {
            info = NSMutableAttributedString(string: durationStr)
            watchedStr = " (\(isWatched ? R.string.localized.tutorialWatched() : R.string.localized.tutorialUnwatched()))"
        }
        else {
            info = NSMutableAttributedString(string: durationStr)
        }
        
        let resultInfoStr = durationStr + (watchedStr ?? "")
        
        let value = NSMutableAttributedString(string: resultInfoStr, attributes: [NSForegroundColorAttributeName: R.color.kneetly.navyTone3(),
                                                                                  NSFontAttributeName: baseFont,
                                                                                  ])
        
        if watchedStr != nil {
            let range = NSMakeRange(0, watchedStr!.characters.count - 1)
            value.addAttributes([NSFontAttributeName : baseFont], range: range)
        }
        
        return VideoItemCellInfo(name: name, info: value)
    }
 
    private static func formatDurationTime(time: Int) -> String {
        let interval = TimeInterval(time)
        let result = VideoItemCellInfo.timeFormatter.string(from: interval)
        return result!
    }
}

class VideoItemCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var infoLabel: UILabel?
    
    var info: VideoItemCellInfo? {
        didSet {
            nameLabel?.text = info?.name
            infoLabel?.attributedText = info?.info
        }
    }
    
}
