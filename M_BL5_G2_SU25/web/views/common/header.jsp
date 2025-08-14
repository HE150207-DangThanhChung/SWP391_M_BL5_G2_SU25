<%-- 
    Document   : header
    Created on : Aug 14, 2025, 9:12:51 AM
    Author     : tayho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Header Page</title>
        <style>
            :root{
                --bar-bg:#cfe6ff;         /* light blue */
                --chip-bg:#fff7b1;        /* pale yellow */
                --chip-text:#1b1c1d;
                --btn-bg:#9b5cf1;         /* purple */
                --btn-text:#ffffff;
                --ring:#8bb7ff;           /* outline ring */
                --radius:16px;
                --shadow:0 8px 20px rgba(0,0,0,.08);
            }

            *{
                box-sizing:border-box
            }
            body{
                margin:0;
                padding:32px;
                font-family:system-ui,-apple-system,Segoe UI,Roboto,Inter,Arial,sans-serif;
                color:#222;
                background:#f7fafc;
            }

            /* Wrapper just for demo spacing */
            .demo{
                display:grid;
                gap:40px
            }

            /* NAVBAR */
            .navbar{
                background:var(--bar-bg);
                border-radius:22px; /* slightly rounder than inside chips */
                padding:14px 20px;
                box-shadow:var(--shadow);
                border:2px solid #b9d6ff;
                display:flex;
                align-items:center;
                gap:20px;
            }

            .brand{
                font-weight:700;
                font-size:20px;
                padding:8px 12px;
                background:var(--chip-bg);
                color:var(--chip-text);
                border-radius:10px;
                white-space:nowrap;
            }

            /* centered menu */
            .menu{
                list-style:none;
                margin:0;
                padding:0;
                display:flex;
                gap:28px;
                align-items:center;
                flex:1;
                justify-content:center;
            }

            .menu > li{
                position:relative;
            }

            .chip{
                display:inline-block;
                padding:10px 14px;
                background:var(--chip-bg);
                color:var(--chip-text);
                border-radius:8px;
                font-weight:500;
                text-decoration:none;
                transition:transform .15s ease;
            }
            .chip:hover{
                transform:translateY(-1px);
            }

            /* dropdown under a top-level item */
            .submenu{
                position:absolute;
                left:0;
                top:100%;
                margin-top:8px;
                min-width:160px;
                background:var(--chip-bg);
                border-radius:10px;
                border:1px solid #efe39a;
                box-shadow:var(--shadow);
                display:grid;
                gap:6px;
                padding:10px;
                opacity:0;
                pointer-events:none;
                transform:translateY(6px);
                transition:opacity .15s ease, transform .15s ease;
                z-index:10;
            }
            .menu > li:hover > .submenu{
                opacity:1;
                pointer-events:auto;
                transform:translateY(0);
            }

            .submenu a{
                text-decoration:none;
                color:#222;
                padding:8px 10px;
                border-radius:8px;
                display:block;
            }
            .submenu a:hover{
                background:#fff3a1;
            }

            /* Right action button with stacked dropdown */
            .action{
                margin-left:auto;
                position:relative;
            }
            .btn{
                background:var(--btn-bg);
                color:var(--btn-text);
                border:none;
                cursor:pointer;
                font-weight:700;
                padding:14px 24px;
                border-radius:20px;
                outline:2px solid #7f49e8;
                outline-offset:0;
                box-shadow:var(--shadow);
            }

            .action-menu{
                position:absolute;
                right:0;
                top:100%;
                margin-top:10px;
                display:flex;
                flex-direction:column;
                gap:10px;
                opacity:0;
                pointer-events:none;
                transform:translateY(6px);
                transition:opacity .15s ease, transform .15s ease;
                z-index:12;
            }

            .action:has(:hover), .action:hover{
                isolation:isolate;
            }
            .action:hover .action-menu{
                opacity:1;
                pointer-events:auto;
                transform:translateY(0);
            }

            .action-item{
                background:var(--btn-bg);
                color:var(--btn-text);
                border-radius:18px;
                padding:14px 22px;
                min-width:180px;
                text-align:center;
                box-shadow:var(--shadow);
            }

            /* Make each successive item align like a stacked popover under the button */
            .action-menu .action-item:nth-child(1){
                margin-right:0;
            }
            .action-menu .action-item:nth-child(2){
            }
            .action-menu .action-item:nth-child(3){
            }

            /* Responsive tweaks */
            @media (max-width: 900px){
                .menu{
                    gap:16px;
                }
            }
            @media (max-width: 720px){
                .navbar{
                    flex-wrap:wrap;
                    row-gap:12px;
                }
                .menu{
                    order:3;
                    flex:1 1 100%;
                    justify-content:flex-start;
                }
                .action{
                    order:2;
                    margin-left:0;
                }
            }
        </style>
    </head>
    <body>
        <div class="demo">
            <!-- Example 1: Normal state -->
            <nav class="navbar">
                <div class="brand">Site name</div>

                <ul class="menu">
                    <li>
                        <a class="chip" href="#">Page 1</a>
                        <!-- dropdown visible when hovering Page 1 -->
                        <div class="submenu">
                            <a href="#">Subpage</a>
                            <a href="#">Subpage</a>
                        </div>
                    </li>
                    <li><a class="chip" href="#">Page 2</a></li>
                    <li><a class="chip" href="#">Page 3</a></li>
                </ul>

                <div class="action">
                    <button class="btn" type="button">Button</button>
                    <!-- stacked dropdown for the right button -->
                    <div class="action-menu" aria-label="Button menu">
                        <div class="action-item">Page</div>
                        <div class="action-item">Page</div>
                        <div class="action-item">Page</div>
                    </div>
                </div>
            </nav>

            <!-- Example 2: Same bar (to illustrate hover states while inspecting) -->
            <nav class="navbar">
                <div class="brand">Site name</div>
                <ul class="menu">
                    <li>
                        <a class="chip" href="#">Page 1</a>
                        <div class="submenu">
                            <a href="#">Subpage</a>
                            <a href="#">Subpage</a>
                        </div>
                    </li>
                    <li><a class="chip" href="#">Page 2</a></li>
                    <li><a class="chip" href="#">Page 3</a></li>
                </ul>
                <div class="action">
                    <button class="btn" type="button">Button</button>
                    <div class="action-menu" aria-label="Button menu">
                        <div class="action-item">Page</div>
                        <div class="action-item">Page</div>
                        <div class="action-item">Page</div>
                    </div>
                </div>
            </nav>
        </div>
    </body>
</html>
