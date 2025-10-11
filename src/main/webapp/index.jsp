<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simulateur d'Entretien</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        h1 {
            color: white;
            text-align: center;
            margin-bottom: 30px;
            font-size: 2.5em;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }

        a {
            display: inline-block;
            padding: 15px 30px;
            background-color: white;
            color: #667eea;
            text-decoration: none;
            border-radius: 25px;
            font-weight: bold;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin: 10px;
        }

        a:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.2);
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
    <h1>🎯 Bienvenue au Simulateur d'Entretien</h1>
    <div style="display: flex; gap: 20px; flex-wrap: wrap; justify-content: center;">
        <a href="register" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">✨ S'inscrire</a>
    </div>
    <div style="margin-top: 30px;">
        <a href="testdb" style="background-color: #f8f9fa; color: #666; font-size: 0.9em; padding: 10px 20px;">🔧 Tester la DB</a>
    </div>
</body>
</html>