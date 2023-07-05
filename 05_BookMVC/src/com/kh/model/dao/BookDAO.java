package com.kh.model.dao;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Properties;

import com.kh.model.vo.Book;
import com.kh.model.vo.Member;
import com.kh.model.vo.Rent;

import config.ServerInfo;

public class BookDAO implements BookDAOTemplate{
	private ArrayList<Book> test = new ArrayList<>();
	private Properties p = new Properties();
	
	public BookDAO() {
		try {
			p.load(new FileInputStream("src/config/jdbc.properties"));
			Class.forName(ServerInfo.DRIVER_NAME);
			System.out.println("연결");
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public Connection getConnect() throws SQLException {
		Connection conn = DriverManager.getConnection(ServerInfo.URL,ServerInfo.USER,ServerInfo.PASSWORD);
		return conn;
	}

	@Override
	public void closeAll(PreparedStatement st, Connection conn) throws SQLException {
		if(st!=null) st.close();
		if(conn!=null) conn.close();
	}

	@Override
	public void closeAll(ResultSet rs, PreparedStatement st, Connection conn) throws SQLException {
		if(rs!=null) rs.close();
		closeAll(st, conn);
	}

	@Override
	public ArrayList<Book> printBookAll() throws SQLException {
		Connection conn = getConnect();
		PreparedStatement st = conn.prepareStatement(p.getProperty("printBookAll"));
		ResultSet rs = st.executeQuery();
		System.out.println(rs.next());
		while(rs.next()) {
			Book bk = new Book();
			bk.setBkNo(rs.getInt("bk_no")); 
			bk.setBkTitle(rs.getString("bk_title"));
			bk.setBkAuthor(rs.getString("bk_author")); 
			test.add(bk);
			 
			}
		
		closeAll(rs, st, conn);
		return test;
	}

	@Override
	public int registerBook(Book book) throws SQLException {
		Connection conn = getConnect();
		PreparedStatement st = conn.prepareStatement(p.getProperty("registerBook"));
		st.setInt(1, book.getBkNo());
		st.setString(2, book.getBkTitle());
		st.setString(3, book.getBkAuthor());
		
		st.executeUpdate();
		closeAll(st, conn);
		return st.executeUpdate();
	}

	@Override
	public int sellBook(int no) throws SQLException {
		Connection conn = getConnect();
		PreparedStatement st = conn.prepareStatement(p.getProperty("sellBook"));
		st.setInt(1, no);
		
		st.executeUpdate();
		closeAll(st, conn);
		return st.executeUpdate();
		
	}

	@Override
	public int registerMember(Member member) throws SQLException {
		return 0;
	}

	@Override
	public Member login(String id, String password) throws SQLException {
		return null;
	}

	@Override
	public int deleteMember(String id, String password) throws SQLException {
		return 0;
	}

	@Override
	public int rentBook(Rent rent) throws SQLException {
		return 0;
	}

	@Override
	public int deleteRent(int no) throws SQLException {
		return 0;
	}

	@Override
	public ArrayList<Rent> printRentBook(String id) throws SQLException {
		return null;
	}
public static void main(String[] args) {
	BookDAO b = new BookDAO();
	
	try {
		ArrayList<Book> test = b.printBookAll();
		for (Book book : test) {
			System.out.println(book.getBkNo());
			System.out.println(book.getBkTitle());
			System.out.print(book.getBkAuthor());
		}
		
	} catch (SQLException e) {
		e.printStackTrace();
	}
}
}
