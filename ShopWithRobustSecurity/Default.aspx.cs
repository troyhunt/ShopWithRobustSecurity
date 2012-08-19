using System;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using Microsoft.Security.Application;

namespace ShopWithRobustSecurity
{
  public partial class Default : Page
  {
    protected void Page_Load(object sender, EventArgs e)
    {
      // Because this cookie isn't marked as HTTP only it can be read by client script, including by malicious XSS.
      var myPersonalDetailsCookie = new HttpCookie("MyPersonalDetails")
      {
        Value = "Mr John Smith",

        // A far reaching expiry date means the cookie is still accessible long, long after the person leaves the site.
        Expires = DateTime.Now.AddYears(1)

        // This is how to set HTTP only - one tiny attribute and the cookie is no longer accessible to client script.
        //,HttpOnly = true
      };
      Response.Cookies.Add(myPersonalDetailsCookie);

      // Let's add another unprotected cookie accessible via JavaScript.
      var myCustomerIdCookie = new HttpCookie("MyCustomerId") { Value = "2342374329", Expires = DateTime.Now.AddYears(1) };
      Response.Cookies.Add(myCustomerIdCookie);

      // The ASP.NET session cookie (named "ASP.NET_Session") is always flagged as HTTP only so cannot be read by client script.
      // But it *CAN* be intercepted and the session hijacked if it's sent over HTTP and not HTTPS.
      Session["MyPersonalSessionData"] = "Some personal details that anyone who can hijack this session can now potentially access.";

      // Of course there may well be a legit use for this input param.
      var legitParam = Request.QueryString["LegitParam"];

      // But it's important that the input is validated against a whitelist of allowable values.
      var regex = new Regex("^[0-9a-zA-Z ]+$"); 
      if (!string.IsNullOrEmpty(legitParam) && !regex.IsMatch(legitParam))
      {
        // Right about here is when we should know that something is wrong!
      }

      // And always - ALWAYS - output encode for the intended context. 
      // Either use System.Web.Security.AntiXss in .NET 4.5 or get AntiXSS from NuGet: http://nuget.org/packages/AntiXSS
      var encodedForHtml = Encoder.HtmlEncode(legitParam);
      var encodedForHtmlAttribute = Encoder.HtmlAttributeEncode(legitParam);
      var encodedForFormUrl = Encoder.HtmlFormUrlEncode(legitParam);
      var encodedForCss = Encoder.CssEncode(legitParam);
      var encodedForJavaScript = Encoder.JavaScriptEncode(legitParam);
      var encodedForUrl = Encoder.UrlEncode(legitParam);
      var encodedForXml = Encoder.XmlEncode(legitParam);
      var encodedForXmlAttribute = Encoder.XmlAttributeEncode(legitParam);
    }
  }
}