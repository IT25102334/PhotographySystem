<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Customer Management</title>

    <style>
        body{
            font-family: Arial;
            background:#f5f5f5;
            padding:40px;
        }

        .box{
            width:500px;
            margin:auto;
            background:white;
            padding:30px;
            border-radius:10px;
            box-shadow:0 0 10px rgba(0,0,0,0.1);
        }

        h2{
            text-align:center;
            color:#333;
        }

        input{
            width:100%;
            padding:10px;
            margin-top:8px;
            margin-bottom:15px;
        }

        button{
            width:100%;
            padding:12px;
            background:#007bff;
            color:white;
            border:none;
            cursor:pointer;
        }

        button:hover{
            background:#0056b3;
        }

        table{
            width:100%;
            margin-top:30px;
            border-collapse:collapse;
        }

        table, th, td{
            border:1px solid #ccc;
        }

        th, td{
            padding:10px;
            text-align:center;
        }

        th{
            background:#007bff;
            color:white;
        }
    </style>

</head>
<body>

<div class="box">

<h2>Add Customer</h2>

<form action="CustomerServlet" method="post">

    ID:
    <input type="text" name="id" required>

    Name:
    <input type="text" name="name" required>

    Email:
    <input type="email" name="email" required>

    <button type="submit">Add Customer</button>

</form>

</div>

</body>
</html>