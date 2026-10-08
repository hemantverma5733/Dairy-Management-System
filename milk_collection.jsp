<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Milk Collection - Smart Dairy</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f7f6;
        }

        .header {
            background: #2e7d32;
            color: white;
            padding: 18px 30px;
        }

        .header h2 {
            margin: 0;
        }

        .container {
            width: 700px;
            margin: 35px auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.12);
        }

        h1 {
            margin-top: 0;
            color: #2e7d32;
        }

        .form-row {
            display: flex;
            gap: 20px;
        }

        .form-group {
            flex: 1;
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-weight: bold;
        }

        input, select {
            width: 100%;
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
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

        .back {
            display: inline-block;
            margin-bottom: 20px;
            color: #2e7d32;
            text-decoration: none;
        }
    </style>
</head>

<body>

    <div class="header">
        <h2>Smart Dairy</h2>
    </div>

    <div class="container">

        <a href="dashboard.jsp" class="back">← Back to Dashboard</a>

        <h1>Daily Milk Collection</h1>

        <form action="MilkCollectionServlet" method="post">

            <div class="form-row">

                <div class="form-group">
                    <label>Collection Date</label>
                    <input type="date"
                           name="collection_date"
                           required>
                </div>

                <div class="form-group">
                    <label>Supplier / Farmer Name</label>
                    <input type="text"
                           name="supplier_name"
                           placeholder="Enter supplier name"
                           required>
                </div>

            </div>

            <div class="form-row">

                <div class="form-group">
                    <label>Shift</label>

                    <select name="shift" required>
                        <option value="">Select Shift</option>
                        <option value="MORNING">Morning</option>
                        <option value="EVENING">Evening</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Animal Type</label>

                    <select name="animal_type" required>
                        <option value="">Select Animal</option>
                        <option value="COW">Cow</option>
                        <option value="BUFFALO">Buffalo</option>
                    </select>
                </div>

            </div>

            <div class="form-row">

                <div class="form-group">
                    <label>Quantity (Litres)</label>
                    <input type="number"
                           name="quantity"
                           step="0.01"
                           placeholder="e.g. 25.50"
                           required>
                </div>

                <div class="form-group">
                    <label>Fat (%)</label>
                    <input type="number"
                           name="fat"
                           step="0.01"
                           placeholder="e.g. 4.50">
                </div>

            </div>

            <div class="form-row">

                <div class="form-group">
                    <label>SNF (%)</label>
                    <input type="number"
                           name="snf"
                           step="0.01"
                           placeholder="e.g. 8.50">
                </div>

                <div class="form-group">
                    <label>Rate (₹ / Litre)</label>
                    <input type="number"
                           name="rate"
                           step="0.01"
                           placeholder="e.g. 45"
                           required>
                </div>

            </div>

            <button type="submit">Save Milk Collection</button>

        </form>

    </div>

</body>
</html>