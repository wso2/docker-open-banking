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

<%@ page import="org.apache.cxf.jaxrs.client.JAXRSClientFactory" %>
<%@ page import="org.apache.cxf.jaxrs.provider.json.JSONProvider" %>
<%@ page import="org.apache.http.HttpStatus" %>
<%@ page import="org.owasp.encoder.Encode" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.client.SelfUserRegistrationResource" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.AuthenticationEndpointUtil" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.bean.ResendCodeRequestDTO" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.bean.UserDTO" %>
<%@ page import="com.wso2.finance.open.banking.application.authenticator.identifier.first.OBIdentifierAuthenticator" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="javax.ws.rs.core.Response" %>
<%@ page import="static org.wso2.carbon.identity.core.util.IdentityUtil.isSelfSignUpEPAvailable" %>
<%@ page import="static org.wso2.carbon.identity.core.util.IdentityUtil.isRecoveryEPAvailable" %>
<%@ page import="static org.wso2.carbon.identity.core.util.IdentityUtil.isEmailUsernameEnabled" %>
<%@ page import="static org.wso2.carbon.identity.core.util.IdentityUtil.getServerURL" %>
<%@ page import="org.json.JSONObject" %>

<jsp:directive.include file="includes/init-loginform-action-url.jsp"/>

<%
    String emailUsernameEnable = application.getInitParameter("EnableEmailUserName");
    Boolean isEmailUsernameEnabled = false;

    if (StringUtils.isNotBlank(emailUsernameEnable)) {
        isEmailUsernameEnabled = Boolean.valueOf(emailUsernameEnable);
    } else {
        isEmailUsernameEnabled = isEmailUsernameEnabled();
    }

    OBIdentifierAuthenticator sessionDetails = new OBIdentifierAuthenticator();
    String sessionDataKey = Encode.forHtmlAttribute(request.getParameter("sessionDataKey"));
    String output = sessionDetails.getSessionData(sessionDataKey);

    String spDetails = "";
    String callbackURL = null;
    boolean disableInput = false;

    if (output != null){
        JSONObject sessionDetailsJson = new JSONObject(output);
        spDetails = sessionDetails.getSPName(sessionDetailsJson.getString("client_id"));
        callbackURL = sessionDetailsJson.getString("redirect_uri");
    } else {
        loginFailed = "true";
        errorMessage = "session.expired";
    }

    response.addCookie(new Cookie("spDetails", URLEncoder.encode(spDetails,"UTF-8")));
    response.addCookie(new Cookie("callbackURL", URLEncoder.encode(callbackURL,"UTF-8")));

%>

<script>
    function submitIdentifier () {
        var isEmailUsernameEnabled = JSON.parse("<%= isEmailUsernameEnabled %>");
        var isSaaSApp = false;
        var tenantName = getParameterByName("tenantDomain");

        var userName = document.getElementById("username");
        var usernameUserInput = document.getElementById("usernameUserInput");

        if (usernameUserInput) {
            var usernameUserInputValue = usernameUserInput.value.trim();

            if (tenantName && tenantName !== "null") {

                if (isEmailUsernameEnabled) {

                    if (usernameUserInputValue.split("@").length <= 1) {
                        var errorMessage = document.getElementById("error-msg");

                        errorMessage.innerHTML = "Invalid Username. Username has to be an email address.";
                        errorMessage.style.display = "block";

                        return;
                    }

                    if (usernameUserInputValue.split("@").length === 2) {
                        userName.value = usernameUserInputValue + "@" + tenantName;
                    }
                    else {
                        userName.value = usernameUserInputValue;
                    }
                } else {
                    if (usernameUserInputValue.split("@").length > 1) {
                        userName.value = usernameUserInputValue;
                    } else {
                        userName.value = usernameUserInputValue + "@" + tenantName;
                    }

                }
                
            } else {
                userName.value = usernameUserInputValue;
            }
        }

        if (username.value) {
            document.getElementById("identifierForm").submit();
        }
    }
</script>

<form class="ui large form" action="<%=loginFormActionURL%>" method="post" id="identifierForm">
    <%
        if (loginFormActionURL.equals(samlssoURL) || loginFormActionURL.equals(oauth2AuthorizeURL)) {
    %>
    <input id="tocommonauth" name="tocommonauth" type="hidden" value="true">
    <%
        }
    %>
    <% if (Boolean.parseBoolean(loginFailed)) { %>
    <div class="ui visible negative message" id="error-msg">
        <%

        String error = "Something has gone wrong. Please try again.";

        if (errorMessage.equals("Too.many.attempts")) {
             error = "These Details are incorrect. Please visit Internet Banking to retrieve your Customer ID or contact the bank.";
             disableInput = true;
             response.sendRedirect(callbackURL + "/#error=access_denied&error_description=" + error);

        } else if (errorMessage.equals("Login.failed")) {
            error = "These Details are incorrect. Please try again.";

        } else if (errorMessage.equals("session.expired")) {
            disableInput = true;

        }
        out.println(error);
        %>
    </div>
    <% } else if ((Boolean.TRUE.toString()).equals(request.getParameter("authz_failure"))) { %>
    <div class="ui visible negative message" id="error-msg">
        <%=AuthenticationEndpointUtil.i18n(resourceBundle, "unauthorized.to.login")%>
    </div>
    <% } else { %>
        <div class="ui visible negative message" style="display: none;" id="error-msg"></div>
    <% } %>
    
    <div class="field">
        <div class="ui fluid left icon input">
            <input
                type="text"
                id="usernameUserInput"
                value=""
                name="usernameUserInput"
                tabindex="0"
                placeholder="<%=AuthenticationEndpointUtil.i18n(resourceBundle, "username")%>"
                required />
            <i aria-hidden="true" class="user icon"></i>
        </div>
        <input id="username" name="username" type="hidden" value="">
        <input id="authType" name="authType" type="hidden" value="idf">
    </div>
    <%
        if (reCaptchaEnabled) {
    %>
    <div class="field">
        <div class="g-recaptcha"
             data-sitekey="<%=Encode.forHtmlContent(request.getParameter("reCaptchaKey"))%>">
        </div>
    </div>
    <%
        }
    %>

    <input type="hidden" name="sessionDataKey" value='<%=Encode.forHtmlAttribute
        (request.getParameter("sessionDataKey"))%>'/>

    <%
        String recoveryEPAvailable = application.getInitParameter("EnableRecoveryEndpoint");
        String enableSelfSignUpEndpoint = application.getInitParameter("EnableSelfSignUpEndpoint");
        Boolean isRecoveryEPAvailable = false;
        Boolean isSelfSignUpEPAvailable = false;
        String identityMgtEndpointContext = "";
        String urlEncodedURL = "";
        String urlParameters = "";
        
        if (StringUtils.isNotBlank(recoveryEPAvailable)) {
            isRecoveryEPAvailable = Boolean.valueOf(recoveryEPAvailable);
        } else {
            isRecoveryEPAvailable = isRecoveryEPAvailable();
        }
        
        if (StringUtils.isNotBlank(enableSelfSignUpEndpoint)) {
            isSelfSignUpEPAvailable = Boolean.valueOf(enableSelfSignUpEndpoint);
        } else {
            isSelfSignUpEPAvailable = isSelfSignUpEPAvailable();
        }
  
        if (isRecoveryEPAvailable || isSelfSignUpEPAvailable) {
            String scheme = request.getScheme();
            String serverName = request.getServerName();
            int serverPort = request.getServerPort();
            String uri = (String) request.getAttribute(JAVAX_SERVLET_FORWARD_REQUEST_URI);
            String prmstr = (String) request.getAttribute(JAVAX_SERVLET_FORWARD_QUERY_STRING);
            String urlWithoutEncoding = scheme + "://" +serverName + ":" + serverPort + uri + "?" + prmstr;

            urlEncodedURL = URLEncoder.encode(urlWithoutEncoding, UTF_8);
            urlParameters = prmstr;
            
            identityMgtEndpointContext =
                    application.getInitParameter("IdentityManagementEndpointContextURL");
            if (StringUtils.isBlank(identityMgtEndpointContext)) {
                identityMgtEndpointContext = getServerURL("/accountrecoveryendpoint", true, true);
            }
        }
    %>

    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 form-group">
        <div class="field disclaimer">
            Forgot Customer ID? Go to the WSO2 Open Banking website to retrieve it.
        </div>
    </div>

    <div class="ui two column grid">
        <div class="column align-left buttons">
            <% if (isRecoveryEPAvailable) { %>
            <input
                type="button"
                onclick="showModal()"
                class="ui large button link-button"
                id="cancel"
                role="button"
                data-toggle="modal"
                data-target="#cancelModel"
                value="<%=AuthenticationEndpointUtil.i18n(resourceBundle, "cancel")%>" />
            <% } %>
        </div>
        <div class="column align-right buttons">
            <input
                type="submit"
                onclick="submitIdentifier()"
                class="ui primary large button"
                role="button"
                id="submitBtn"
                disabled=true
                value="<%=AuthenticationEndpointUtil.i18n(resourceBundle, "next")%>" />
        </div>
    </div>
    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 form-group">
       <hr class="separator">
       <div class="form-actions disclaimer">
         Your Customer ID will not be shared with "<%=spDetails%>". One time passwords are used
         to share CDR data. You will never be asked to provide your real password to share CDR data.
       </div>
    </div>
</form>


<!-- The Modal -->
<div class="modal" id="cancelModal">
  <div class="modal-dialog">
    <div class="modal-content">

      <!-- Modal body -->
      <div class="modal-body">
        <p style="color:black"> Unless you confirm your authorisation, we won't be able to share your data with
        "<%=spDetails%>". <br> <br> Are you sure you would like to cancel this process? </p>

        <div class="ui two column grid">
            <div class="column align-left buttons">
                <input
                    type="button"
                    onclick="redirect()"
                    class="ui danger button"
                    id="registerLink"
                    role="button"
                    value="Yes cancel" />
            </div>
            <div class="column align-right buttons">
                <input
                    type="button"
                    onclick="closeModal()"
                    class="ui primary button"
                    role="button"
                    value="No continue" />
            </div>
        </div>
      </div>

    </div>
  </div>
</div>

<script>

    var modal = document.getElementById("cancelModal");

    function showModal() {
        modal.style.display = "block";
    }

    function closeModal() {
        modal.style.display = "none";
    }

    function redirect() {
        var error = "User skip the consent flow";
        top.location = "<%=callbackURL%>/#error=access_denied&error_description=" + error;
    }

    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }

    // enable "next" btn until the input count equal to 8
    document.getElementById('usernameUserInput').addEventListener('input', function () {
        var text = this.value,
        count = text.trim().length;
        if (count >= 8) {
            document.getElementById("submitBtn").disabled = false;
        }

    });

    $(document).ready(function(){
        if(<%=disableInput%>) {
            document.getElementById("usernameUserInput").disabled = true;
        }
    });
</script>