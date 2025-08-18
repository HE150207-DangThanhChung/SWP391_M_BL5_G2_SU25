<%-- 
    Document   : login
    Created on : Aug 13, 2025, 8:45:50 AM
    Author     : tayho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
        <style>
            :root{
                --page-bg:#d8ead9;      /* minty background like mock */
                --input-bg:#a7f6ff;     /* aqua inputs */
                --accent:#ff0e7a;       /* magenta text */
                --ink:#0f172a;          /* dark text */
                --ring:#7fc7ff;         /* focus ring */
                --radius:12px;
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
                width:min(520px, 92vw);
                background:rgba(255,255,255,.35);
                backdrop-filter:saturate(140%) blur(2px);
                border:2px solid #a9cbb0;
                border-radius:22px;
                padding:38px 28px 30px;
                box-shadow:var(--shadow);
            }

            .brand{
                display:grid;
                place-items:center;
                margin-bottom:26px;
            }
            .brand svg{
                width:72px;
                height:72px;
                stroke:#111;
            }

            h1{
                position:absolute;
                left:-9999px;
            }

            .field{
                position:relative;
                margin:16px 0;
            }
            .field input{
                width:100%;
                padding:14px 16px 14px 52px;
                font-size:18px;
                font-weight:600;
                color:var(--accent);
                background:var(--input-bg);
                border:2px solid #2b6777;
                border-radius:14px;
                outline:none;
                transition:border-color .15s ease, box-shadow .15s ease;
            }
            .field input::placeholder{
                color:var(--accent);
                opacity:1;
            }
            .field input:focus{
                border-color:var(--ring);
                box-shadow:0 0 0 4px rgba(127,199,255,.35);
            }

            .icon{
                position:absolute;
                left:12px;
                top:50%;
                transform:translateY(-50%);
                opacity:.9;
            }
            .icon svg{
                width:26px;
                height:26px;
                stroke:#1e90ff;
                fill:none;
                stroke-width:2;
            }

            .actions{
                margin-top:18px;
                display:flex;
                align-items:center;
                justify-content:space-between;
                gap:14px;
            }

            .btn-primary{
                flex:1;
                background:#fff;
                color:var(--accent);
                border:2px solid #2b6777;
                font-weight:700;
                font-size:18px;
                padding:12px 20px;
                border-radius:12px;
                cursor:pointer;
                transition:transform .1s ease, box-shadow .15s ease;
            }
            .btn-primary:hover{
                transform:translateY(-1px);
                box-shadow:var(--shadow);
            }

            .link{
                background:#fff;
                color:var(--accent);
                border:2px solid #2b6777;
                padding:10px 14px;
                border-radius:10px;
                text-decoration:none;
                white-space:nowrap;
            }
            .link:hover{
                box-shadow:var(--shadow);
            }

            .footnote{
                text-align:center;
                margin-top:18px;
                font-size:12px;
                opacity:.7;
            }
            h2{
                color:#ff0e7a;
            }
        </style>
    </head>
    <body>
        <main class="card" aria-labelledby="title">
            <h1 id="title">Account Login</h1>

            <div class="brand" aria-hidden="true">
                <h2>Chào mừng bạn đến với HappySale!</h2>
                <h2>Hãy bắt đầu 1 ngày làm việc nào!</h2>
                <!-- storefront icon -->
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path d="M3 7h18l-1.5 4a3 3 0 0 1-5.7 0A3 3 0 0 1 10 11a3 3 0 0 1-3.8 0A3 3 0 0 1 3 11L3 7Z"/>
                <path d="M5 11v9h14v-9"/>
                <path d="M10 20v-5h4v5"/>
                <path d="M4 7l2-3h12l2 3"/>
                </svg>
            </div>
            
            <form action="${pageContext.request.contextPath}/login" method="post" autocomplete="on">
                <div class="field">
                    <span class="icon" aria-hidden="true">
                        <!-- user icon -->
                        <svg viewBox="0 0 24 24">
                        <circle cx="12" cy="8" r="4" />
                        <path d="M4 20a8 8 0 0 1 16 0"/>
                        </svg>
                    </span>
                    <label class="sr-only" for="username">Tên đăng nhập:</label>
                    <input id="username" name="username" type="text" placeholder="Vui lòng điền tên đăng nhập" required />
                </div>

                <div class="field">
                    <span class="icon" aria-hidden="true">
                        <!-- lock icon -->
                        <svg viewBox="0 0 24 24">
                        <rect x="5" y="11" width="14" height="10" rx="2" />
                        <path d="M8 11V7a4 4 0 1 1 8 0v4"/>
                        </svg>
                    </span>
                    <label class="sr-only" for="password">Mật khẩu:</label>
                    <input id="password" name="password" type="password" placeholder="Vui lòng điền mật khẩu" required />
                </div>

                <div class="actions">
                    <button class="btn-primary" type="submit" value="Login">Đăng Nhập</button>
                    <a class="link" href="#">Quên mật khẩu?</a>
                </div>

                <p class="footnote">Chúng tôi rất vui mừng chào đón bạn</p>
            </form>
        </main>       
    </body>
</html>
