<%-- 
    Document   : resetpassword
    Created on : Aug 13, 2025, 8:46:02 AM
    Author     : tayho
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Forgot Password</title>
        <style>
            :root{
                --page-bg:#d8ead9;     /* mint */
                --accent:#ff0e7a;      /* magenta */
                --ink:#0f172a;
                --btn-bg:#a7f6ff;      /* aqua */
                --ring:#7fc7ff;
                --shadow:0 10px 25px rgba(0,0,0,.08);
            }
            *{
                box-sizing:border-box
            }
            html,body{
                height:100%
            }
            body{
                margin:0;
                display:grid;
                place-items:center;
                background:var(--page-bg);
                font-family:system-ui,-apple-system,Segoe UI,Roboto,Inter,Arial,sans-serif;
                color:var(--ink);
            }

            .card{
                width:min(720px,94vw);
                background:rgba(255,255,255,.35);
                border:2px solid #a9cbb0;
                border-radius:20px;
                padding:44px 40px;
                box-shadow:var(--shadow);
            }

            h1{
                text-align:center;
                color:var(--accent);
                margin:0 0 12px;
            }
            .subtitle{
                text-align:center;
                color:var(--accent);
                margin:0 0 34px;
                font-weight:600;
            }

            label{
                display:block;
                margin-bottom:10px;
                font-weight:600;
                color:#444;
            }

            .field{
                position:relative;
            }
            input[type=email]{
                width:100%;
                padding:14px 16px;
                font-size:18px;
                border:2px solid #2b6777;
                border-radius:12px;
                background:#fff;
                outline:none;
            }
            input[type=email]:focus{
                border-color:var(--ring);
                box-shadow:0 0 0 4px rgba(127,199,255,.35);
            }

            .actions{
                display:flex;
                flex-direction:column;
                gap:18px;
                align-items:center;
                margin-top:28px;
            }

            .btn-primary{
                width:min(520px,100%);
                background:var(--btn-bg);
                color:var(--accent);
                border:2px solid #2b6777;
                border-radius:12px;
                padding:12px 18px;
                font-weight:800;
                letter-spacing:.3px;
                cursor:pointer;
            }
            .btn-primary:hover{
                box-shadow:var(--shadow);
            }

            .btn-ghost{
                background:#fff;
                color:var(--accent);
                border:2px solid #2b6777;
                border-radius:10px;
                padding:10px 16px;
                text-decoration:none;
                display:inline-block;
            }
            .btn-ghost:hover{
                box-shadow:var(--shadow);
            }

            .note{
                text-align:center;
                margin-top:12px;
                font-size:12px;
                opacity:.75;
            }
        </style>
    </head>
    <body>
        <main class="card" aria-labelledby="title">
            <h1 id="title">Forgot Password</h1>
            <p class="subtitle">Enter your email below and follow instruction</p>

            <form action="#" method="post" novalidate>
                <label for="email">Email</label>
                <div class="field">
                    <input id="email" name="email" type="email" placeholder="you@example.com" required />
                </div>

                <div class="actions">
                    <button class="btn-primary" type="submit">Reset Password</button>
                    <a class="btn-ghost" href="login.html">Back to Log in</a>
                </div>

                <p class="note">We will send a password reset link to your email if an account exists.</p>
            </form>
        </main>
    </body>
</html>
