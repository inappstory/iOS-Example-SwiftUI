//
//  SimpleIntegrationView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct SimpleIntegrationView: View
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
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Simple integration"))
    }
}

struct SimpleIntegrationView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleIntegrationView()
    }
}
