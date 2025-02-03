// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public protocol DataStore: Storable, CacheStorable where Item == LocalData, Identifier == URL {}
extension CoreDataStore: DataStore where CoreDataItem.Local == LocalData {}
