<%--
  ~ Copyright (c) 2020, WSO2 Inc. (http://www.wso2.com). All Rights Reserved.
  ~
  ~ This software is the property of WSO2 Inc. and its suppliers, if any.
  ~ Dissemination of any information or reproduction of any material contained
  ~ herein is strictly forbidden, unless permitted by WSO2 in accordance with
  ~ the WSO2 Commercial License available at http://wso2.com/licenses.
  ~ For specific language governing the permissions and limitations under this
  ~ license, please see the license as well as any agreement you’ve entered into
  ~ with WSO2 governing the purchase of this software and any associated services.
  --%>

<!-- localize.jsp MUST already be included in the calling script -->
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.util.IdentityManagementEndpointUtil" %>

<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="icon" href="libs/theme/assets/images/favicon.ico" type="image/x-icon"/>
<link href="libs/theme/wso2-default.min.css" rel="stylesheet">

<title>WSO2 Identity Server</title>

<style>
    html, body {
        height: 100%;
    }

    body {
        flex-direction: column;
        display: flex;
    }

    main {
        flex-shrink: 0;
    }

    main.center-segment {
        margin: auto;
        display: flex;
        align-items: center;
    }

    main.center-segment > .ui.container.medium {
        max-width: 450px !important;
    }

    main.center-segment > .ui.container.large {
        max-width: 700px !important;
    }

    main.center-segment > .ui.container > .ui.segment {
        padding: 3rem;
    }

    main.center-segment > .ui.container > .ui.segment .segment-form .buttons {
        margin-top: 1em;
    }

    main.center-segment > .ui.container > .ui.segment .segment-form .buttons.align-right button,
    main.center-segment > .ui.container > .ui.segment .segment-form .buttons.align-right input {
        margin: 0 0 0 0.25em;
    }

    main.center-segment > .ui.container > .ui.segment .segment-form .column .buttons.align-left button.link-button,
    main.center-segment > .ui.container > .ui.segment .segment-form .column .buttons.align-left input.link-button {
        padding: .78571429em 1.5em .78571429em 0;
    }

    main.center-segment > .ui.container > .ui.segment .segment-form {
        text-align: left;
    }

    main.center-segment > .ui.container > .ui.segment .segment-form .align-center {
        text-align: center;
    }

    main.center-segment > .ui.container > .ui.segment .segment-form .align-right {
        text-align: right;
    }
    
    .cookie-policy-message {
        font-size: 14px;
    }

    footer {
        padding: 2rem 0;
    }

    body .product-title .product-title-text {
        margin: 0;
    }

    body .center-segment .product-title .product-title-text {
        margin-top: 2em;
        margin-bottom: 1em;
    }

    .ui.menu.fixed.app-header .product-logo {
        padding-left: 0;
    }

    /* Table of content styling */

    main #toc {
        position: sticky;
        top: 93px;
    }

    main .ui.segment.toc {
        padding: 20px;
    }

    main .ui.segment.toc ul.ui.list.nav > li.sub {
        margin-left: 20px;
    }

    main .ui.segment.toc ul.ui.list.nav > li > a {
        color: rgba(0,0,0,.87);
        text-decoration: none;
    }

    main .ui.segment.toc ul.ui.list.nav > li:before {
        content: "\2219";
        font-weight: bold;
        font-size: 1.6em;
        line-height: 0.5em;
        display: inline-block;
        width: 1em;
        margin-left: -0.7em;
    }

    main .ui.segment.toc ul.ui.list.nav > li.sub:before {
        content: "\2192";
        margin-left: -1em;
    }

    main .ui.segment.toc ul.ui.list.nav > li:hover a {
        color: #ff5000;
        text-decoration: none;
    }

    main .ui.segment.toc ul.ui.list.nav > li:hover:before {
        color: #ff5000;
    }
</style>
