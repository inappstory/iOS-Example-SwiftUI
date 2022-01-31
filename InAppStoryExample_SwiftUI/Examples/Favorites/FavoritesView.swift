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
    @ObservedObject fileprivate var favoriteDelegate = FavoritesStoryViewDelegate.shared
        
    private var storyView: StoryViewSUI = .init(delegate: FavoritesStoryViewDelegate.shared)
    
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
        // enable favorite button in reader & showinng favorite cell in the end of list
        InAppStory.shared.favoritePanel = true
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            storyView
                .frame(height: $favoriteDelegate.isContentExist.wrappedValue ? 150.0 : 0.0)
        }
        .padding(.top)
        .navigationBarTitle(Text("Favorites"))
        .sheet(isPresented: $favoriteDelegate.favoriteSelected) {
            NavigationView {
                StoryViewSUI(isFavorite: true)
                    .create()
                    .navigationBarTitle(Text("Favorites"), displayMode: .inline)
            }
        }
        .onAppear {
            storyView.create()
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}

fileprivate class FavoritesStoryViewDelegate: NSObject, InAppStoryDelegate, ObservableObject
{
    @Published var favoriteSelected = false
    @Published var isContentExist = false
    
    static let shared: FavoritesStoryViewDelegate = .init()
    
    func storiesDidUpdated(isContent: Bool, from storyType: StoriesType)
    {
        if self.isContentExist != isContent {
            self.isContentExist = isContent
        }
    }
    
    func storyReader(actionWith target: String, for type: ActionType, from storyType: StoriesType) {
        if let url = URL(string: target) {
            UIApplication.shared.open(url)
        }
    }
    
    func favoriteCellDidSelect() {
        favoriteSelected.toggle()
    }
}
