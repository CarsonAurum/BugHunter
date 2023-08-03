//
//  Created by Carson Rau July 2023
//

/// A type capable of loading and managing static resources.
protocol ResourceLoadableType: AnyObject {
    /// Indicates that static resources need to be loaded.
    static var resourcesNeedLoading: Bool { get }
    
    /// Loads static resources into memory.
    static func loadResources(withCompletionHandler completionHandler: @escaping () -> ())
    
    /// Releases any static resources that can be loaded again later.
    static func purgeResources()
}
