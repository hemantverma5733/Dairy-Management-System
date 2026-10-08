<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List,com.smartdairy.entity.Product" %>
<% List<Product> products = (List<Product>) request.getAttribute("products"); %>
<!DOCTYPE html><html><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Products - Smart Dairy</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head><body class="bg-light">
<nav class="navbar navbar-dark bg-dark"><div class="container"><span class="navbar-brand fw-bold">Smart Dairy</span><span class="text-white">Product Management</span></div></nav>
<div class="container py-4">
<% if ("true".equals(request.getParameter("success"))) { %><div class="alert alert-success">Product added successfully.</div><% } %>
<% if ("true".equals(request.getParameter("updated"))) { %><div class="alert alert-success">Product updated successfully.</div><% } %>
<% if ("true".equals(request.getParameter("deleted"))) { %><div class="alert alert-success">Product deleted successfully.</div><% } %>
<% if (request.getParameter("error") != null) { %><div class="alert alert-danger">Operation failed: <%= request.getParameter("error") %></div><% } %>
<div class="row g-4">
<div class="col-lg-4"><div class="card shadow-sm"><div class="card-body"><h5 class="card-title">Add Product</h5>
<form action="ProductServlet" method="post" class="row g-3">
<div class="col-12"><label class="form-label">Product Name</label><input name="product_name" class="form-control" required></div>
<div class="col-md-6"><label class="form-label">Category</label><input name="category" class="form-control"></div>
<div class="col-md-6"><label class="form-label">Unit</label><input name="unit" class="form-control" placeholder="Litre / Kg / Pack"></div>
<div class="col-md-6"><label class="form-label">Purchase Price</label><input name="purchase_price" type="number" step="0.01" min="0" class="form-control" value="0"></div>
<div class="col-md-6"><label class="form-label">Selling Price</label><input name="selling_price" type="number" step="0.01" min="0" class="form-control" required></div>
<div class="col-md-6"><label class="form-label">Opening Stock</label><input name="stock" type="number" step="0.01" min="0" class="form-control" value="0"></div>
<div class="col-md-6"><label class="form-label">Minimum Stock</label><input name="minimum_stock" type="number" step="0.01" min="0" class="form-control" value="0"></div>
<div class="col-12"><label class="form-label">Status</label><select name="status" class="form-select"><option value="ACTIVE">ACTIVE</option><option value="INACTIVE">INACTIVE</option></select></div>
<div class="col-12"><button class="btn btn-dark w-100">Save Product</button></div>
</form></div></div></div>
<div class="col-lg-8"><div class="card shadow-sm"><div class="card-body"><div class="d-flex justify-content-between align-items-center mb-3"><h5 class="mb-0">Product List</h5><input id="search" class="form-control w-50" placeholder="Search product..." onkeyup="filterTable()"></div>
<div class="table-responsive"><table class="table table-hover align-middle" id="productTable"><thead class="table-dark"><tr><th>ID</th><th>Product</th><th>Category</th><th>Unit</th><th>Sell Price</th><th>Stock</th><th>Status</th><th>Action</th></tr></thead><tbody>
<% if (products != null) for (Product p : products) { %><tr><td><%=p.getId()%></td><td><%=p.getProductName()%></td><td><%=p.getCategory()%></td><td><%=p.getUnit()%></td><td>₹ <%=String.format("%.2f",p.getSellingPrice())%></td><td class="<%= p.getStock() <= p.getMinimumStock() ? "text-danger fw-bold" : "text-success" %>"><%=p.getStock()%></td><td><span class="badge <%= "ACTIVE".equalsIgnoreCase(p.getStatus()) ? "bg-success" : "bg-secondary" %>"><%=p.getStatus()%></span></td><td><a class="btn btn-sm btn-outline-primary" href="product_edit.jsp?id=<%=p.getId()%>">Edit</a> <a class="btn btn-sm btn-outline-danger" href="ProductDeleteServlet?id=<%=p.getId()%>" onclick="return confirm('Delete this product?')">Delete</a></td></tr><% } %>
</tbody></table></div></div></div></div></div>
</div><script>function filterTable(){let q=document.getElementById('search').value.toLowerCase();document.querySelectorAll('#productTable tbody tr').forEach(r=>r.style.display=r.innerText.toLowerCase().includes(q)?'':'none');}</script>
</body></html>
