//
//  OnboardingView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct OnboardingView: View
{
    @State var isOnboardingPresent: Bool = false
    @State var isStoryRefresh: Bool = false
    
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            StoryListView(refresh: $isStoryRefresh)
                .frame(height: 150.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Onboarding"))
        .onAppear() {
            isOnboardingPresent = true
        }
        .onboardingStories(isPresented: $isOnboardingPresent,
                           onAction: { target, actionType in
            isOnboardingPresent = false // may call InAppStory.shared.closeReader()
        })
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
