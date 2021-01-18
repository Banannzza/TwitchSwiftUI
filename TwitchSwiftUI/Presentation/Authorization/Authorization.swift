//
//  Authorization.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import SwiftUI

struct Authorization: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = AuthorizationViewModel()
    let redirectHost: String
    let method = AuthorizationMethod(clientID: AppConfiguration.clientID, redirectURI: AppConfiguration.authorizationRedirectUri, scope: .userEdit)
    
    var codeRequestView: some View {
        Web(
            request: method.request,
            delegate: AuthorizationWebNavigationDelegate(redirectClosure: { url in
                viewModel.process(codeRedirectURL: url)
            }, redirectHost: redirectHost)
        )
        .onReceive(viewModel.token.publisher) { _ in
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        codeRequestView
    }
}
