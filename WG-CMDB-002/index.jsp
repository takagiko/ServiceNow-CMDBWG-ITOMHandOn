<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.commons.dbcp2.BasicDataSource" %>
<%@ page import="java.sql.*" %>
<%!
    // JSP上で静的にデータソース（コネクションプール）を定義
    private static BasicDataSource ds = null;

    // データソースの初期化（未初期化の場合のみ）
    private void initDataSource() {
        if (ds == null) {
            ds = new BasicDataSource();
            ds.setDriverClassName("org.postgresql.Driver");
            ds.setUrl("jdbc:postgresql://172.31.15.184:5432/mydatabase");
            ds.setUsername("postgres");
            ds.setPassword("CmdbWG2025");

            // 初期サイズ、最大接続数などの設定（必要に応じて調整）
            ds.setInitialSize(5);
            ds.setMaxTotal(20);
        }
    }
%>
<%
    // ページ読み込み時にデータソースを初期化
    initDataSource();

    // --- 初回アクセス時にテーブルが存在しなければ作成 ---
    Connection conn = null;
    try {
        conn = ds.getConnection();
        Statement stmt = conn.createStatement();
        String createTableSQL = "CREATE TABLE IF NOT EXISTS messages ("
                              + "id SERIAL PRIMARY KEY, "
                              + "name VARCHAR(100) NOT NULL, "
                              + "message TEXT NOT NULL, "
                              + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
                              + ")";
        stmt.executeUpdate(createTableSQL);
        stmt.close();
    } catch(Exception e) {
        out.println("<p>データベース接続エラー: " + e.getMessage() + "</p>");
        return;
    } finally {
        if(conn != null){
            try { conn.close(); } catch(SQLException ignore) {}
        }
    }
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>みんな★なかよし掲示板</title>
</head>
<body>
    <h1>💛💛💛みんな★なかよし掲示板💛💛💛</h1>
<%
    // --- POSTリクエストによるメッセージ投稿処理 ---
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String message = request.getParameter("message");
        if(name != null && message != null && !name.trim().isEmpty() && !message.trim().isEmpty()){
            try {
                conn = ds.getConnection();
                PreparedStatement pstmt = conn.prepareStatement("INSERT INTO messages (name, message) VALUES (?, ?)");
                pstmt.setString(1, name);
                pstmt.setString(2, message);
                pstmt.executeUpdate();
                pstmt.close();
%>
                <p style="color: green;">メッセージが投稿されました。</p>
<%
            } catch(SQLException ex) {
%>
                <p style="color: red;">投稿エラー: <%= ex.getMessage() %></p>
<%
            } finally {
                if(conn != null){
                    try { conn.close(); } catch(SQLException ignore) {}
                }
            }
        } else {
%>
            <p style="color: red;">名前とメッセージの両方を入力してください。</p>
<%
        }
    }
%>
    <!-- 投稿フォーム -->
    <form method="post" action="">
        <label>名前: <input type="text" name="name" size="30"/></label><br/><br/>
        <label>メッセージ:</label><br/>
        <textarea name="message" rows="4" cols="50"></textarea><br/><br/>
        <input type="submit" value="投稿"/>
    </form>
    <hr/>
    <h2>投稿一覧</h2>
<%
    // --- 投稿一覧の取得 ---
    try {
        conn = ds.getConnection();
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM messages ORDER BY created_at DESC");
        while(rs.next()){
            String poster = rs.getString("name");
            String msg = rs.getString("message");
            Timestamp ts = rs.getTimestamp("created_at");
%>
            <div style="border:1px solid #ccc; padding:10px; margin-bottom:10px;">
                <strong><%= poster %></strong> [<%= ts %>]<br/>
                <pre style="white-space: pre-wrap;"><%= msg %></pre>
            </div>
<%
        }
        rs.close();
        stmt.close();
    } catch(SQLException ex) {
        out.println("<p>投稿一覧取得エラー: " + ex.getMessage() + "</p>");
    } finally {
        if(conn != null){
            try { conn.close(); } catch(SQLException ignore) {}
        }
    }
%>
</body>
</html>
