//
//  SimpleIntegrationView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct MultifeedView: View
{
    @State var isStoryRefresh: Bool = false
    
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
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
                .padding(.bottom)
            StoryListView(
                feed: "custom_feed", // Stories list with custom feed id
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
        .navigationBarTitle(Text("Multi feed"))
    }
}

struct MultifeedView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleIntegrationView()
    }
}
