package com.badminton.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import com.badminton.model.ProductsBean;



public class ProductDao {
	
	
	//全部
	public List<ProductsBean> showProduct() {
		
		
		Connection connection = null;
		String  sql = "SELECT * FROM Products";
		ProductsBean product = null;
		List<ProductsBean> products = new ArrayList<ProductsBean>();
		
		try {
			Context initContext = new InitialContext();
			DataSource ds = (DataSource) initContext.lookup("java:comp/env/jdbc/BadmintonDB");
			connection = ds.getConnection();
			
			PreparedStatement preparedStatement = connection.prepareStatement(sql);
			
			ResultSet resultSet = preparedStatement.executeQuery();

			while (resultSet.next()) {
				
				product = new ProductsBean();
				
				product.setProductId(resultSet.getInt("product_id"));
				product.setProductName(resultSet.getString("product_name"));
				product.setCategory(resultSet.getString("category"));
				product.setBrand(resultSet.getString("brand"));
				product.setPrice(resultSet.getBigDecimal("price"));
				product.setStockQty(resultSet.getInt("stock_qty"));
				product.setDescription(resultSet.getString("description"));
				product.setImageUrl(resultSet.getString("image_url"));
				product.setStatus(resultSet.getString("status"));
				product.setProductCreateAt(resultSet.getDate("created_at"));
				products.add(product);
				
				
			}
			preparedStatement.close();
			
			
			
			
			
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			
			try {
				if (connection!=null) {
					
					connection.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}
		
		
		
		
		
		
		
		return products;
	} 
	
	// 模糊查詢
	public List<ProductsBean> searchProductsByKeyword(String keyword) {
	    
	    String sql = "SELECT * FROM Products "
	               + "WHERE product_name LIKE ? "
	               + "OR category LIKE ? "
	               + "OR brand LIKE ?";

	    List<ProductsBean> products = new ArrayList<ProductsBean>();
	    PreparedStatement preparedStatement = null;
	    Connection connection = null;
	    ResultSet resultSet = null;

	    try {
	        Context initContext = new InitialContext();
	        DataSource ds = (DataSource) initContext.lookup("java:comp/env/jdbc/BadmintonDB");
	        connection = ds.getConnection();

	        preparedStatement = connection.prepareStatement(sql);

	        String searchKeyword = "%" + keyword + "%";
	        preparedStatement.setString(1, searchKeyword);
	        preparedStatement.setString(2, searchKeyword);
	        preparedStatement.setString(3, searchKeyword);

	        resultSet = preparedStatement.executeQuery();

	        while (resultSet.next()) {
	            ProductsBean product = new ProductsBean();

	            product.setProductId(resultSet.getInt("product_id"));
	            product.setProductName(resultSet.getString("product_name"));
	            product.setCategory(resultSet.getString("category"));
	            product.setBrand(resultSet.getString("brand"));
	            product.setPrice(resultSet.getBigDecimal("price"));
	            product.setStockQty(resultSet.getInt("stock_qty"));
	            product.setDescription(resultSet.getString("description"));
	            product.setImageUrl(resultSet.getString("image_url"));
	            product.setStatus(resultSet.getString("status"));
	            product.setProductCreateAt(resultSet.getDate("created_at"));

	            products.add(product);
	        }

	    } catch (NamingException e) {
	        e.printStackTrace();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (resultSet != null) {
	                resultSet.close();
	            }
	            if (preparedStatement != null) {
	                preparedStatement.close();
	            }
	            if (connection != null) {
	                connection.close();
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }

	    return products;
	}
	
	
	
	
	
	public ProductsBean searchProductById(Integer productId) {

	    String sql = "SELECT * FROM Products WHERE product_id = ?";
	    ProductsBean product = null;

	    try {
	        Context initContext = new InitialContext();
	        DataSource ds = (DataSource) initContext.lookup("java:comp/env/jdbc/BadmintonDB");

	        try (Connection connection = ds.getConnection();
	             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

	            preparedStatement.setInt(1, productId);

	            try (ResultSet resultSet = preparedStatement.executeQuery()) {

	                if (resultSet.next()) {
	                    product = new ProductsBean(
	                        resultSet.getInt("product_id"),
	                        resultSet.getString("product_name"),
	                        resultSet.getString("category"),
	                        resultSet.getString("brand"),
	                        resultSet.getBigDecimal("price"),
	                        resultSet.getInt("stock_qty"),
	                        resultSet.getString("description"),
	                        resultSet.getString("image_url"),
	                        resultSet.getString("status"),
	                        resultSet.getDate("created_at")
	                    );
	                }
	            }
	        }

	    } catch (NamingException | SQLException e) {
	        e.printStackTrace();
	    }

	    return product;
	}
	
	
	
	
	
	
	//新增
	public void insertProduct(ProductsBean productBean) {
	    
	    String sql = "INSERT INTO Products "
	            + "(product_name, category, brand, price, stock_qty, description, image_url, status, created_at) "
	            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
	    
	    PreparedStatement preparedStatement = null;
		Connection connection = null;

	    try {
	        Context initContext = new InitialContext();
	        DataSource ds = (DataSource) initContext.lookup("java:comp/env/jdbc/BadmintonDB");
	        connection = ds.getConnection();
	        
	        preparedStatement = connection.prepareStatement(sql);
	        
	        preparedStatement.setString(1, productBean.getProductName());
	        preparedStatement.setString(2, productBean.getCategory());
	        preparedStatement.setString(3, productBean.getBrand());
	        preparedStatement.setBigDecimal(4, productBean.getPrice());
	        preparedStatement.setInt(5, productBean.getStockQty());
	        preparedStatement.setString(6, productBean.getDescription());
	        preparedStatement.setString(7, productBean.getImageUrl());
	        preparedStatement.setString(8, productBean.getStatus());
	        preparedStatement.setDate(9, productBean.getProductCreateAt());
	        
	        int rows = preparedStatement.executeUpdate();
	        
	        if (rows > 0) {
	            System.out.println("新增成功！");
	        } else {
	            System.out.println("新增失敗！");
	        }

	    } catch (NamingException e) {
	        e.printStackTrace();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (preparedStatement != null) {
	                preparedStatement.close();
	            }
	            if (connection != null) {
	                connection.close();
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	}
	
	//刪除
	public void deleteProduct(Integer productId) {
	    
	    String sql = "DELETE FROM Products WHERE product_id = ?";
	    
	    PreparedStatement preparedStatement = null;
		Connection connection = null;

	    try {
	        Context initContext = new InitialContext();
	        DataSource ds = (DataSource) initContext.lookup("java:comp/env/jdbc/BadmintonDB");
	        connection = ds.getConnection();
	        
	        preparedStatement = connection.prepareStatement(sql);
	        preparedStatement.setInt(1, productId);
	        
	        int rows = preparedStatement.executeUpdate();
	        
	        if (rows > 0) {
	            System.out.println("刪除成功！");
	        } else {
	            System.out.println("刪除失敗！");
	        }
	        
	    } catch (NamingException e) {
	        e.printStackTrace();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (preparedStatement != null) {
	                preparedStatement.close();
	            }
	            if (connection != null) {
	                connection.close();
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	}
	
	//修改
	public void updateProduct(ProductsBean productBean) {
	    
	    String sql = "UPDATE Products SET "
	            + "product_name = ?, "
	            + "category = ?, "
	            + "brand = ?, "
	            + "price = ?, "
	            + "stock_qty = ?, "
	            + "description = ?, "
	            + "image_url = ?, "
	            + "status = ? "
	            + "WHERE product_id = ?";
	    
	    PreparedStatement preparedStatement = null;
		Connection connection = null;

	    try {
	        Context initContext = new InitialContext();
	        DataSource ds = (DataSource) initContext.lookup("java:comp/env/jdbc/BadmintonDB");
	        connection = ds.getConnection();
	        
	        preparedStatement = connection.prepareStatement(sql);
	        
	        preparedStatement.setString(1, productBean.getProductName());
	        preparedStatement.setString(2, productBean.getCategory());
	        preparedStatement.setString(3, productBean.getBrand());
	        preparedStatement.setBigDecimal(4, productBean.getPrice());
	        preparedStatement.setInt(5, productBean.getStockQty());
	        preparedStatement.setString(6, productBean.getDescription());
	        preparedStatement.setString(7, productBean.getImageUrl());
	        preparedStatement.setString(8, productBean.getStatus());
	        preparedStatement.setInt(9, productBean.getProductId());
	        
	        int rows = preparedStatement.executeUpdate();
	        
	        if (rows > 0) {
	            System.out.println("修改成功！");
	        } else {
	            System.out.println("修改失敗！");
	        }
	        
	    } catch (NamingException e) {
	        e.printStackTrace();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (preparedStatement != null) {
	                preparedStatement.close();
	            }
	            if (connection != null) {
	                connection.close();
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	}
	

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		
		
		
		
	}

}
