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
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = Settings(userID: "")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            StoryViewSUI()
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
