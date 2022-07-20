//
//  TagsPlaceholdersView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct TagsPlaceholdersView: View
{
    @State var isStoryRefresh: Bool = false
    
    init() {
        // setup InAppStorySDK for user with ID & tags
        InAppStory.shared.settings = .init(userID: "", tags: ["one", "two"])
        // add tags after set settings
        InAppStory.shared.addTags(["three", "four"])
        // remove tags if needed
        InAppStory.shared.removeTags(["three"])
        
        // if the StoryViewSUI has already been created, after adding or removing tags, you need to refresh the StoryViewSUI
        // storyView.refresh()
        
        // set replacing placeholders list
        InAppStory.shared.placeholders = ["one" : "Replace one", "two" : "Replace two"]
        
        // set replacing images placeholders list
        InAppStory.shared.imagesPlaceholders = ["img_1" : "imageURL_1", "img_2" : "imageURL_1"]
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            StoryListView(
                // actionTypes is .button, .game, .deeplink, .swipe
                onAction: { target, actionType in
                InAppStory.shared.closeReader {
                    if let url = URL(string: target) {
                        UIApplication.shared.open(url)
                    }
                }
              }, refresh: $isStoryRefresh)
                .frame(height: 150.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Tags & Placeholders"))
    }
}

struct TagsPlaceholdersView_Previews: PreviewProvider {
    static var previews: some View {
        TagsPlaceholdersView()
    }
}
