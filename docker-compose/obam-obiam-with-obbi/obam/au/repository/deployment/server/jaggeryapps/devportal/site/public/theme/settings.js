const Settings = {
    app: {
        context: '/devportal',
        customUrl: {
            enabled: false,
            forwardedHeader: 'X-Forwarded-For',
        },
        origin: {
            host: 'localhost',
        },
        subscriptionLimit: 1000,
        singleLogout: {
            enabled: true, // If enabled, user will be logged out from the App when logged out from the IDP (eg: SSO logout from a different App).
            timeout: 4000, // Defines the timeout for the above periodical session status check
        },
    },
    grantTypes: {
        authorization_code: 'Code',
        implicit: 'Implicit',
        refresh_token: 'Refresh Token',
        password: 'Password',
        'iwa:ntlm': 'IWA-NTLM',
        client_credentials: 'Client Credentials',
        'urn:ietf:params:oauth:grant-type:saml2-bearer': 'SAML2',
        'urn:ietf:params:oauth:grant-type:jwt-bearer': 'JWT',
        kerberos: 'Kerberos',
        'urn:ietf:params:oauth:grant-type:device_code': 'Device Code',
    },
    openbanking: {
        spec: 'AU',
        grantTypes: {
            authorization_code: 'Code',
            implicit: 'Implicit',
            refresh_token: 'Refresh Token',
            client_credentials: 'Client Credentials',
        },
    },
};
