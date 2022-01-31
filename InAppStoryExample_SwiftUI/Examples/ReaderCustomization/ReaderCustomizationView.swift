//
//  ReaderCustomizationView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct ReaderCustomizationView: View
{
    @ObservedObject fileprivate var readerCustomViewDelegate = ReaderCustomStoryViewDelegate.shared
    
    private var storyView: StoryViewSUI = .init(delegate: ReaderCustomStoryViewDelegate.shared)
    
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
        // disable swipe gesture for reader closing
        InAppStory.shared.swipeToClose = false
        // disabling closing the reader after scrolling through the last story
        InAppStory.shared.overScrollToClose = false
        // placeholder color when loading stories
        InAppStory.shared.placeholderElementColor = .lightGray
        // placeholder background color when loading stories
        InAppStory.shared.placeholderBackgroundColor = .white
        // placeholder color when loading game
        InAppStory.shared.gamePlaceholderTint = .lightGray
        
        // enable gradient shadow under timers in story
        InAppStory.shared.timerGradientEnable = false
        
        // set new icons for buttons in the reader
        InAppStory.shared.likeImage = UIImage(named: "like")!
        InAppStory.shared.likeSelectedImage = UIImage(named: "likeSelected")!
        InAppStory.shared.dislikeImage = UIImage(named: "dislike")!
        InAppStory.shared.dislikeSelectedImage = UIImage(named: "dislikeSelected")!
        InAppStory.shared.favoriteImage = UIImage(named: "favorite")!
        InAppStory.shared.favoriteSelectedImag = UIImage(named: "favoriteSelected")!
        InAppStory.shared.shareImage = UIImage(named: "sharing")!
        InAppStory.shared.shareSelectedImage = UIImage(named: "sharingSelected")!
        InAppStory.shared.soundImage = UIImage(named: "sound")!
        InAppStory.shared.soundSelectedImage = UIImage(named: "soundSelected")!
        
        InAppStory.shared.refreshImage = UIImage(named: "refresh")!
        // enable like function in reader
        InAppStory.shared.likePanel = true
        // enable favorite function in reader
        InAppStory.shared.favoritePanel = true
        // enable share function in reader
        InAppStory.shared.sharePanel = true
        // set position of close button in reader
        InAppStory.shared.closeButtonPosition = .bottomLeft
        // set animation for switching between stories in the reader
        InAppStory.shared.scrollStyle = .cube
        // set the animation for the reader
        InAppStory.shared.presentationStyle = .modal
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            storyView
                .frame(height: $readerCustomViewDelegate.isContentExist.wrappedValue ? 150.0 : 0.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Reader Customization"))
        .onAppear {
            storyView.create()
        }
        .sheet(isPresented: $readerCustomViewDelegate.favoriteSelected) {
            NavigationView {
                StoryViewSUI(isFavorite: true)
                    .create()
                    .navigationBarTitle(Text("Favorites"), displayMode: .inline)
            }
        }
    }
}

struct ReaderCustomizationView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderCustomizationView()
    }
}

fileprivate class ReaderCustomStoryViewDelegate: NSObject, InAppStoryDelegate, ObservableObject
{
    @Published var favoriteSelected = false
    @Published var isContentExist = false
    
    static let shared: ReaderCustomStoryViewDelegate = .init()
    
    func storiesDidUpdated(isContent: Bool, from storyType: StoriesType)
    {
        self.isContentExist = isContent
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
