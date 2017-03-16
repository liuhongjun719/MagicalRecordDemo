//
//  Episode+CoreDataProperties.swift
//  
//
//  Created by 123456 on 17/3/16.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Episode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Episode> {
        return NSFetchRequest<Episode>(entityName: "Episode");
    }

    @NSManaged public var episodeID: Int16
    @NSManaged public var slug: String?
    @NSManaged public var small_artwork_url: String?
    @NSManaged public var title: String?
    @NSManaged public var video_url: String?

}
