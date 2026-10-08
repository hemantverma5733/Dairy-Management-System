
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Smart Dairy - Login</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f7f6;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .login-box {
            width: 360px;
            background: white;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }

        h1 {
            text-align: center;
            margin-bottom: 5px;
            color: #2e7d32;
        }

        .subtitle {
            text-align: center;
            color: #777;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 11px;
            margin-bottom: 18px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        button {
            width: 100%;
            padding: 12px;
            background: #2e7d32;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #256628;
        }

        .error {
            color: #d32f2f;
            text-align: center;
            margin-bottom: 15px;
        }

    </style>

</head>


<body>


    <div class="login-box">


        <h1>Smart Dairy</h1>


        <div class="subtitle">
            Milk Dairy Management System
        </div>


        <%
            String error = request.getParameter("error");

            if ("true".equals(error)) {
        %>

            <div class="error">
                Invalid Email or Password
            </div>

        <%
            }
        %>


        <form action="<%= request.getContextPath() %>/LoginServlet"
              method="post">


            <label for="email">
                Email
            </label>

            <input
                type="email"
                id="email"
                name="email"
                placeholder="Enter your email"
                required>


            <label for="password">
                Password
            </label>

            <input
                type="password"
                id="password"
                name="password"
                placeholder="Enter your password"
                required>


            <button type="submit">
                Login
            </button>


        </form>


    </div>


</body>

</html>