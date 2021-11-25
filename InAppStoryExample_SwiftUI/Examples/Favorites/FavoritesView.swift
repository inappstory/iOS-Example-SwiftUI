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
    @State private var isFavoriteSelected: Bool = false
        
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = Settings(userID: "")
        // enable favorite button in reader & showinng favorite cell in the end of list
        InAppStory.shared.favoritePanel = true
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            StoryViewSUI(delegate: FavoritesStoryViewDelegate(isFavoriteSelected: $isFavoriteSelected))
                .create()
                .frame(height: 150.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Favorites"))
        .sheet(isPresented: $isFavoriteSelected) {
            NavigationView {
                StoryViewSUI(isFavorite: true)
                    .create()
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

fileprivate class FavoritesStoryViewDelegate: NSObject, InAppStoryDelegate
{
    @Binding var favoriteSelected: Bool
    
    init(isFavoriteSelected: Binding<Bool>) {
        self._favoriteSelected = isFavoriteSelected
        
        super.init()
    }
    
    func storiesDidUpdated(isContent: Bool, from storyType: StoriesType) {}
    
    func storyReader(actionWith target: String, for type: ActionType, from storyType: StoriesType) {
        if let url = URL(string: target) {
            UIApplication.shared.open(url)
        }
    }
    
    func favoriteCellDidSelect() {
        favoriteSelected = true
    }
}
