<%-- 
    Document   : editCustomer
    Created on : Aug 13, 2025, 8:47:03 AM
    Author     : tayho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            :root{
                --page:#f7fafc;
                --panel:#d8ead9;   /* mint */
                --header:#cfe2ff;  /* light blue */
                --stroke:#2b6777;
                --btn:#a7f6ff;     /* aqua */
                --accent:#ff0e7a;  /* magenta */
                --shadow:0 8px 22px rgba(0,0,0,.08);
            }

            *{
                box-sizing:border-box
            }
            body{
                margin:0;
                background:var(--page);
                font-family:system-ui,-apple-system,Segoe UI,Roboto,Inter,Arial,sans-serif;
                color:#102a43;
                display:grid;
                place-items:center;
                min-height:100vh;
                padding:28px
            }

            .card{
                width:min(760px,96vw);
                border:2px solid #aac6c0;
                border-radius:10px;
                box-shadow:var(--shadow);
                overflow:hidden;
                background:var(--panel)
            }
            .card__header{
                background:var(--header);
                padding:14px 18px;
                text-align:center;
                font-weight:800
            }

            form{
                padding:28px 26px;
                max-width:640px;
                margin:0 auto
            }

            .row{
                display:grid;
                grid-template-columns: 180px 1fr;
                gap:14px 18px;
                align-items:center;
                margin-bottom:16px
            }
            label{
                font-weight:600
            }

            input[type=text], input[type=number], input[type=email]{
                width:100%;
                padding:10px 12px;
                border:2px solid var(--stroke);
                border-radius:10px;
                background:#fff;
                outline:none;
            }
            input:focus{
                box-shadow:0 0 0 4px rgba(127,199,255,.35);
                border-color:#7fc7ff;
            }

            .actions{
                display:flex;
                gap:24px;
                margin-top:22px;
                justify-content:center
            }
            .btn{
                min-width:120px;
                text-align:center;
                padding:10px 16px;
                border:2px solid var(--stroke);
                border-radius:10px;
                background:var(--btn);
                color:var(--accent);
                font-weight:800;
                cursor:pointer
            }
            .btn--ghost{
                background:#fff
            }
            .btn:hover{
                box-shadow:var(--shadow)
            }

            @media (max-width:680px){
                .row{
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <section class="card">
            <div class="card__header">Edit Record Form</div>

            <form action="#" method="post">
                <div class="row">
                    <label for="f1">Field number 1</label>
                    <input id="f1" name="field1" type="text" value="Current value 1" required />
                </div>

                <div class="row">
                    <label for="f2">Field number 2</label>
                    <input id="f2" name="field2" type="text" value="Current value 2" />
                </div>

                <div class="row">
                    <label for="f3">Field number 3</label>
                    <input id="f3" name="field3" type="text" value="Current value 3" />
                </div>

                <div class="row">
                    <label for="f4">Field number 4</label>
                    <input id="f4" name="field4" type="text" value="Current value 4" />
                </div>

                <div class="row">
                    <label for="f5">Field number 5</label>
                    <input id="f5" name="field5" type="text" value="Current value 5" />
                </div>

                <div class="row">
                    <label for="f6">Field number 6</label>
                    <input id="f6" name="field6" type="text" value="Current value 6" />
                </div>

                <div class="actions">
                    <button class="btn" type="submit">Edit</button>
                    <button class="btn btn--ghost" type="button" onclick="history.back()">Cancel</button>
                </div>
            </form>
        </section>
    </body>
</html>
