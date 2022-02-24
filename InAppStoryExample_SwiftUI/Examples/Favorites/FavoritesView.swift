//
//  FavoritesView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct FavoritesView: View
{
    @State var isFavoriteSelected: Bool = false
    @State var isStoryRefresh: Bool = false
    @State var isFavoriteRefresh: Bool = false
    
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
        // enable favorite button in reader & showinng favorite cell in the end of list
        InAppStory.shared.favoritePanel = true
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            StoryListView(onAction: { target, actionType in
                InAppStory.shared.closeReader {
                    if let url = URL(string: target) {
                        UIApplication.shared.open(url)
                    }
                }
            }, favoritesSelect: {
                isFavoriteSelected = true
            }, refresh: $isStoryRefresh)
                .frame(height: 150.0)
        }
        .padding(.top)
        .navigationBarTitle(Text("Favorites"))
        .sheet(isPresented: $isFavoriteSelected) {
            NavigationView {
                StoryListView(isFavorite: true, refresh: $isFavoriteRefresh)
                    .navigationBarTitle(Text("Favorites"), displayMode: .inline)
            }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
