//
//  Mascot.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 08/12/2016.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

public enum MascotMood {
    case smiley
    case happy
    case toothy
    case deadpan
    case worried
    
    public static let allValues = [smiley, happy, toothy, deadpan, worried]
    public static let positive = [smiley, happy, toothy]
    public static let negative = [worried, deadpan]
}

public enum MascotType {
    case sponge
    case spray
    case bucket
    case bubbleBottle
    case chamois
    case drop
    case hose
    case squirt
    case triggerSpray
    
    public static let allValues = [sponge, spray, bucket, bubbleBottle, chamois, drop, hose, squirt, triggerSpray]
    
    public static let leftSideTypes = [squirt, triggerSpray, bubbleBottle, sponge]
    public static let rightSideTypes = [spray, bubbleBottle, sponge]
}

public class Mascot {
    public var type: MascotType = .sponge
    public var mood: MascotMood = .happy
    
    init(type: MascotType!, mood: MascotMood!) {
        self.type = type
        self.mood = mood
    }
    
    init(rectSide: RectSide) {
        switch rectSide {
        case .left:
            self.type = MascotType.leftSideTypes.randomElement()
        case .right:
            self.type = MascotType.rightSideTypes.randomElement()
        default:
            self.type =  .sponge
        }
        
        self.mood = MascotMood.positive.randomElement()
    }
    
    init() {
        self.type = MascotType.allValues.randomElement()
        self.mood = MascotMood.allValues.randomElement()
    }
    
    init(positive: Bool) {
        switch positive {
        case true:
            self.type = MascotType.allValues.randomElement()
            self.mood = MascotMood.positive.randomElement()
            break
        case false:
            self.type = MascotType.allValues.randomElement()
            self.mood = MascotMood.negative.randomElement()
            break
        }
    }
    
    public func image() -> UIImage? {
        switch self.type {
        case .sponge:
            switch self.mood {
            case .smiley:
                return R.image.spongeSmiley()
            case .happy:
                return R.image.spongeHappy()
            case .toothy:
                return R.image.spongeToothy()
            case .deadpan:
                return R.image.spongeDeadpan()
            case .worried:
                return R.image.spongeWorried()
            }
        case .spray:
            switch self.mood {
            case .smiley:
                return R.image.spraySmiley()
            case .happy:
                return R.image.sprayHappy()
            case .toothy:
                return R.image.sprayToothy()
            case .deadpan:
                return R.image.sprayDeadpan()
            case .worried:
                return R.image.sprayWorried()
            }
        case .bucket:
            switch self.mood {
            case .smiley:
                return R.image.bucketSmiley()
            case .happy:
                return R.image.bucketHappy()
            case .toothy:
                return R.image.bucketToothy()
            case .deadpan:
                return R.image.bucketDeadpan()
            case .worried:
                return R.image.bucketWorried()
            }
        case .bubbleBottle:
            switch self.mood {
            case .smiley:
                return R.image.bubbleBottleSmiley()
            case .happy:
                return R.image.bubbleBottleHappy()
            case .toothy:
                return R.image.bubbleBottleToothy()
            case .deadpan:
                return R.image.bubbleBottleDeadpan()
            case .worried:
                return R.image.bubbleBottleWorried()
            }
        case .chamois:
            switch self.mood {
            case .smiley:
                return R.image.chamoisSmiley()
            case .happy:
                return R.image.chamoisHappy()
            case .toothy:
                return R.image.chamoisToothy()
            case .deadpan:
                return R.image.chamoisDeadpan()
            case .worried:
                return R.image.chamoisWorried()
            }
        case .drop:
            switch self.mood {
            case .smiley:
                return R.image.dropSmiley()
            case .happy:
                return R.image.dropHappy()
            case .toothy:
                return R.image.dropToothy()
            case .deadpan:
                return R.image.dropDeadpan()
            case .worried:
                return R.image.dropWorried()
            }
        case .hose:
            switch self.mood {
            case .smiley:
                return R.image.hoseSmiley()
            case .happy:
                return R.image.hoseHappy()
            case .toothy:
                return R.image.hoseToothy()
            case .deadpan:
                return R.image.hoseDeadpan()
            case .worried:
                return R.image.hoseWorried()
            }
        case .squirt:
            switch self.mood {
            case .smiley:
                return R.image.squirtSmiley()
            case .happy:
                return R.image.squirtHappy()
            case .toothy:
                return R.image.squirtToothy()
            case .deadpan:
                return R.image.squirtDeadpan()
            case .worried:
                return R.image.squirtWorried()
            }
        case .triggerSpray:
            switch self.mood {
            case .smiley:
                return R.image.triggerSpraySmiley()
            case .happy:
                return R.image.triggerSprayHappy()
            case .toothy:
                return R.image.triggerSprayToothy()
            case .deadpan:
                return R.image.triggerSprayDeadpan()
            case .worried:
                return R.image.triggerSprayWorried()
            }
        }
    }
}
