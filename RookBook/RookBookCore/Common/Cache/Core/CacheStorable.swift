// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public protocol CacheStorable: Storable where Item: Cacheable {}

extension CoreDataStore: CacheStorable where CoreDataItem.Local: Cacheable {}
