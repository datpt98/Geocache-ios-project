//
//  SearchResultList.swift
//  GeoCacheApp
//
//  Created by iosdev on 18.4.2023.
//

import SwiftUI
import MapKit

struct SearchResultList: View {
    var searchText: String
    @State var searchResults: [MatchingCache] = []
    @EnvironmentObject var modelData: ModelData
    @Binding var selectedCache: MatchingCache?
    @EnvironmentObject var manager: LocationManager

    
    var body: some View {
        ScrollView(.vertical) {
            ForEach(searchResults) { matchingCache in
                let coordinates = Cache.Coordinates(latitude: String(matchingCache.coordinates.latitude), longitude: String(matchingCache.coordinates.longitude))
                SearchItem(id: matchingCache.id, title: matchingCache.name, difficulty: matchingCache.difficulty, size: matchingCache.size, coordinates: matchingCache.coordinates)
                    .onTapGesture{
                        selectedCache = matchingCache
                        manager.region.center = matchingCache.coordinates
                    }
                    .sheet(item: $selectedCache){cache in
                        detailsSheet(cache: Cache(id: matchingCache.id, name: matchingCache.name, difficulty: matchingCache.difficulty, size: matchingCache.size, description: matchingCache.description, createdAt: matchingCache.createdAt, updatedAt: matchingCache.updatedAt, foundByCurrentUser: matchingCache.foundByCurrentUser, hint: matchingCache.hint, coordinates: coordinates, user: matchingCache.user))
                            .presentationDetents([.medium, .large])
                    }
            }
        }
        .onAppear {
            searchResults = searchCache(searchText: searchText, modelData: modelData)
        }
    }
}
