//
//  OAuth2ClientHandler.swift
//  enrollment
//
//  Created by Kevin Torres on 8/21/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import p2_OAuth2

struct OAuth2ClientHandler {
    private static var oauth2: OAuth2CodeGrant = {
        let clientId = "@!3011.6F0A.B190.8457!0001!294E.B0CD!0008!145D.F522.FFC3.439E"
        let clientSecret = "P2qr7PbPR3QxMMRIJwxqWO81"
        
        let authorizeURI = "https://api.autentia.id/oxauth/restv1/authorize"
        let tokenURI = "https://api.autentia.id/oxauth/restv1/token"
        
        let redirectURI = "trust.enrollment.app://auth.id"
        let scope = "openid uma_protection profile profile.r profile.w address audit.r audit.w"
        
        let oauth2 = OAuth2CodeGrant(
            settings: [
                "client_id": clientId,
                "client_secret": clientSecret,
                "authorize_uri": authorizeURI,
                "token_uri": tokenURI,
                "redirect_uris": [redirectURI],
                "scope": scope,
                ] as OAuth2JSON
        )
        
        oauth2.logger = OAuth2DebugLogger(.trace)
        
        return oauth2
    }()
    
    private init() {}
    
    static var shared: OAuth2CodeGrant {
        return oauth2
    }
}
