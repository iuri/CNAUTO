<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
  <head>
                <title> [DESENVOLVE] INTEQ 8.2.0.74</title>
                <meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type"/>
                <link type="text/css" href="[themeDir]-login.css" rel="stylesheet"/>
                <script>
                    messageDiv = document.getElementById( "message" )
                    function imgMouseOver() {
                        this.firstChild.src = this.getAttribute( "img2" )
                    }
                    function imgMouseOut() {
                        this.firstChild.src = this.getAttribute( "img1" )
                    }

                    resultauth = ""

                    function doLogin() {
                        if ( !messageDiv )
                            messageDiv = document.getElementById( "message" )

                        messageDiv.firstChild.nodeValue = "Autenticando..."
                        document.formLogin.onSubmit = "return true;"
                        document.formLogin.submit()
                    }

                    function onKeyPress( event ) {
                        if ( document.all ) {
                            var keyCode = window.event.keyCode
                        } else {
                            var keyCode = event.which
                        }

                        if ( !messageDiv )
                            messageDiv = document.getElementById( "message" )

                        // Tenta verificar se o CAPS está ativado
                        if ( !event.shiftKey && keyCode >= 65 && keyCode <= 90 ) {
                            messageDiv.firstChild.nodeValue = "O CAPS LOCK está ativo!"
                        } else {
                            messageDiv.firstChild.nodeValue = ""
                        }

                        if ( keyCode == 13 ) {
                            doLogin()
                        } else {
                            if ( keyCode == 27 ) {
                                document.formLogin.password.value = ""
                                document.formLogin.username.value = ""
                                document.formLogin.username.focus()
                            }
                        }
                    }

                    function checkBrowserCompatibility() {
                        var browserUrl
                        var userAgent = navigator.userAgent.toLowerCase()
                        var isOpera   = ( userAgent.indexOf( "opera" ) > -1 )
                        var isIE      = ( !isOpera && ( userAgent.indexOf( "msie" ) != -1 ) )
                        if ( isIE ) {
                            var isMajor   = parseInt(navigator.appVersion);
                            var isIe3     = ( isIE && ( isMajor < 4 ) )
                            var isIe4     = ( isIE && ( isMajor == 4 ) && ( userAgent.indexOf( "msie 4" ) !=-1 ) )
                            var isIe5     = ( isIE && ( isMajor == 4 ) && ( userAgent.indexOf( "msie 5.0" ) !=-1 ) )
                            var isIe5_5   = ( isIE && ( isMajor == 4 ) && ( userAgent.indexOf( "msie 5.5" ) !=-1 ) )
                            var isIe5_5Up = ( isIE && !isIe3 && !isIe4 && !isIe5 )
                            // Somente versões do IE a partir da 5.5 são suportadas
                            browserUrl          = isIe5_5 || isIe5_5Up ? "" : "http://www.microsoft.com/ie"
                        } else {
                            // Firefox
                            var version = "0"
                            var userAgent = navigator.userAgent.toLowerCase()
                            var browserIndex = userAgent.indexOf( "firefox" )
                            if ( browserIndex >= 0 ) {
                                version = userAgent.substr( browserIndex )
                                version = version.substr( version.indexOf( "/" ) + 1 )
                                // Somente versões do Firefox a partir da 1.5.0.0 são suportadas
                                browserUrl          = version >= "1.5.0.0" ? "" : "http://www.getfirefox.com"
                            } else {
                                // Safari
                                // iPhone: "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1C25 Safari/419.3"
                                var browserIndex = userAgent.indexOf( "safari" )
                                if ( browserIndex == -1 ){
                                    // Recomendação é o Firefox
                                    browserUrl = "http://www.getfirefox.com"
                                }
                            }
                        }

                        if ( browserUrl ) {
                    	   alert( "A versão do seu browser é incompatível com o sistema Inteq (versão mínima: Firefox 1.5.0.0 ou Internet Explorer 5.5).\r\nVocê estará sendo redirecionado ao site do fabricante onde poderá obter a versão mais atual." )
                    	    	  window.location.href = browserUrl
                        }
                    }
                    //
                    if ( window.attachEvent ) {
                         var clearElementProps = [
                              "data",
                              "onmouseover",
                              "onmouseout",
                              "onmousedown",
                              "onmousemove",
                              "onmouseup",
                              "onkeydown",
                              "onkeypress",
                              "onresize",
                              "onload",
                              "ondblclick",
                              "onclick",
                              "onselectstart",
                              "onfocus",
                              "onblur",
                              "oncontextmenu" ]

                         window.attachEvent("onunload", function() {
                             window.status = "Cleaning events..."
                             var elt, d, c
                             d = document.all.length
                             while ( d-- ){
                                 elt = document.all[d]
                                 c = clearElementProps.length
                                 while ( c-- )
                                     elt[ clearElementProps[c] ] = null
                             }
                         })
                     }

                     function onLoadFunc () {
                        checkBrowserCompatibility()

                        document.formLogin.username.focus()
                        //
                        if ( resultauth ) {
                            if ( !messageDiv )
                                messageDiv = document.getElementById( "message" )
                            messageDiv.firstChild.nodeValue = resultauth
                        }
                     }
                </script>
            <style charset="utf-8" type="text/css">/* See license.txt for terms of usage */


/* Inicio do arquivo -login.css */
body, html {
 height: 100%;
}

.login-body {
background-color: #FFFFFF;
background-image: url("/resources/cnauto-capa.jpg");
background-repeat: no-repeat;
background-position: 250px 160px;
}

.login-body-natal {
background: url()
}

.login-box {
position: absolute;
top:100px; left:250px;
margin: 10px;
margin-left: 250px; 
height: 78px;
background-color: transparent;
border-width: 1px;
border-color: #000000;
border-style: solid;
padding: 5px;
}

.login-form {
background-color: transparent;
}

.login-label {
font-family: Verdana, Arial, Helvetica, sans-serif;
font-size: 10px;
font-weight: bold;
color: #000000;
text-align: right;
background-color: transparent;
border-width: 1px;
border-style: solid;
border-color: transparent;
height: 18px;
border-right-width: 0px;
display: none;
}

.login-label-base {

}

.login-label-user {
}

.login-label-password {
}

.login-field {
font-family: Verdana, Arial, Helvetica, sans-serif;
font-size: 10px;
color: red;
background-color: transparent;
text-align: left;
height: 14px;
width: 150px;
border-width: 1px;
border-style: solid;
border-color: #000000;
border-left-width: 1px;
}

.login-field-base {
position: absolute;
left: 55px;
top: 0px;
}

.login-field-user {
position: absolute;
left: 55px;
top: 24px;
}

.login-field-password {
position: absolute;
left: 55px;
top: 48px;
}

.login-message {
font-family: Verdana, Arial, Helvetica, sans-serif;
font-size: 10px;
line-height: 18px;
/*font-weight: bold;*/
color: #000000;
text-align: left;
position: absolute;
left: 425px;
top: 225px;
width: 217px;
height: 25px;
}

.login-input {
font-family: Verdana, Arial, Helvetica, sans-serif;
font-size: 10px;
color: red;
background-color: transparent;
text-align: left;
height: 14px;
width: 135px;
border-width: 0px;
}

.login-button {
border-color: #000000;
border-style: none;
color: #0000000;
background-color: transparent;
font-family: Verdana, Arial, Helvetica, sans-serif;
font-size: 10px;
cursor: pointer;
}

.login-button-ok {
position: absolute;
top: 77px;
left: 124px;
height: 17px;
width: 27px;
}

.login-button-cancel {
position: absolute;
top: 76px;
left: 157px;
height: 18px;
width: 65px;
}


/*workaround para resolver o seguinte problema do
       chome http://code.google.com/p/chromium/issues/detail?id=1334*/
input:-webkit-autofill {
color: #000066 !important;
}

/* FIM do arquivo -login.css */










.firebugHighlight {
     z-index: 2147483647;
     position: absolute;
     background-color: #3875d7;
}

.firebugLayoutBoxParent {
     z-index: 2147483647;
     position: absolute;
     background-color: transparent;
     border-right: 1px dashed #BBBBBB;
     border-bottom: 1px dashed #BBBBBB;
}

.firebugRulerH {
     position: absolute;
     top: -15px;
     left: 0;
     width: 100%;
     height: 14px;
     background: url(chrome://firebug/skin/rulerH.png) repeat-x;
     border-top: 1px solid #BBBBBB;
     border-right: 1px dashed #BBBBBB;
     border-bottom: 1px solid #000000;
}

.firebugRulerV {
     position: absolute;
     top: 0;
     left: -15px;
     width: 14px;
     height: 100%;
     background: url(chrome://firebug/skin/rulerV.png) repeat-y;
     border-left: 1px solid #BBBBBB;
     border-right: 1px solid #000000;
     border-bottom: 1px dashed #BBBBBB;
}

.overflowRulerX > .firebugRulerV {
     left: 0;
}

.overflowRulerY > .firebugRulerH {
     top: 0;
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

.firebugLayoutBoxOffset {
     z-index: 2147483647;
     position: absolute;
     opacity: 0.8;
}

.firebugLayoutBoxMargin {
     background-color: #EDFF64;
}

.firebugLayoutBoxBorder {
     background-color: #666666;
}

.firebugLayoutBoxPadding {
     background-color: SlateBlue;
}

.firebugLayoutBoxContent {
     background-color: SkyBlue;
}

/*.firebugHighlightGroup .firebugLayoutBox {
     background-color: transparent;
}

.firebugHighlightBox {
     background-color: Blue !important;
}*/

.firebugLayoutLine {
     z-index: 2147483647;
     background-color: #000000;
     opacity: 0.4;
}

.firebugLayoutLineLeft,
.firebugLayoutLineRight {
     position: fixed;
     width: 1px;
     height: 100%;
}

.firebugLayoutLineTop,
.firebugLayoutLineBottom {
     position: absolute;
     width: 100%;
     height: 1px;
}

.firebugLayoutLineTop {
     margin-top: -1px;
     border-top: 1px solid #999999;
}

.firebugLayoutLineRight {
     border-right: 1px solid #999999;
}

.firebugLayoutLineBottom {
     border-bottom: 1px solid #999999;
}

.firebugLayoutLineLeft {
     margin-left: -1px;
     border-left: 1px solid #999999;
}
</style></head>



<body marginwidth="0" marginheight="0" onload="onLoadFunc()" topmargin="0" leftmargin="0" class="login-body">
                <div class="login-form">
                <form onsubmit="return false;" method="post" action="-1898188217" name="formLogin">
                    <div class="login-box">
                        <input type="hidden" value="0" name="onlyLoginWithHTTPS"/>
                        <table cellspacing="0" cellpadding="0" border="0">
                            <tbody><tr>
                                <td class="login-label login-label-base">Base: </td>
                                <td class="login-field login-field-base"><input type="text" value="DESENVOLVE" readonly="" class="login-input" name="dbName"/></td>
                            </tr>
                            <tr>
                                <td class="login-label login-label-user">Usuário: </td>
                                <td class="login-field login-field-user"><input type="text" onkeypress="( event.keyCode == 13 ? document.formLogin.password.focus(): void(0) )" class="login-input" name="username"/></td>
                            </tr>
                            <tr>
                                <td class="login-label login-label-password">Senha: </td>
                                <td class="login-field login-field-password"><input type="password" onfocus="this.select()" onkeypress="onKeyPress( event )" name="password" class="login-input"/></td>
                            </tr>
                            <tr>
                                <td valign="middle" align="right" colspan="2">
                                    <div onclick="doLogin()" class="login-button login-button-ok"> </div>
                                    <div onclick="window.document.formLogin.reset()" class="login-button login-button-cancel"> </div>
                                </td>
                            </tr>
                        </tbody></table>
                    </div>
                </form>
                <div class="login-message" id="message">Sessão encerrada pelo usuário</div>
                </div>

            </body>


</html>
