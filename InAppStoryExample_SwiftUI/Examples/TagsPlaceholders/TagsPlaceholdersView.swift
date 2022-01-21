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
    private var storyView: StoryViewSUI = .init()
    
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
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            storyView
                .create()
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
