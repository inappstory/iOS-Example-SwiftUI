//
//  PreloaderView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 14.04.2022.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct PreloaderView: View
{
    @State var isStoryRefresh: Bool = false
    
    @State var isStoriesContent: Bool = false
    
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                StoryListView(
                    onUpdated: { isContent in
                        isStoriesContent = isContent
                    })
                    .frame(height: 150.0)
                if !isStoriesContent {
                    Text("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: 150.0)
                        .background(Color.white)
                }
            }
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Simple integration"))
    }
}

struct PreloaderView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleIntegrationView()
    }
}
