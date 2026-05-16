<%--
    sessionCheck.jsp
    Include this at the TOP of every protected JSP page using:
    <%@ include file="sessionCheck.jsp" %>

    This redirects unauthenticated users to the login page.
--%>
<%
    HttpSession authSession = request.getSession(false);
    if (authSession == null || authSession.getAttribute("loggedInUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String loggedInUser = (String) authSession.getAttribute("loggedInUser");
    String userRole     = (String) authSession.getAttribute("userRole");
    boolean isAdmin     = Boolean.TRUE.equals(authSession.getAttribute("isAdmin"));
%>
