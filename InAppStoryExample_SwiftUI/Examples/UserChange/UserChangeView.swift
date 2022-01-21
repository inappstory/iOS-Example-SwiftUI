//
//  UserChangeView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct UserChangeView: View
{
    private var storyView: StoryViewSUI = .init()
    
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            storyView
                .create()
                .frame(height: 150.0)
            HStack {
                Spacer()
                Button("Change user") {
                    InAppStory.shared.settings = .init(userID: "666")
                    _ = storyView.refresh()
                }
                Spacer()
            }
            .padding()
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("User Change"))
    }
}

struct UserChangeView_Previews: PreviewProvider {
    static var previews: some View {
        UserChangeView()
    }
}
