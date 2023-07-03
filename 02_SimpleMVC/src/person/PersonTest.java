package person;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import config.Serverinfo1;

public class PersonTest {
	
	private Properties p = new Properties();
	
	public PersonTest() {
		try {
			p.load(new FileInputStream("src/config/jdbc.properties1"));
		} catch (IOException e) {
			e.printStackTrace();
		}
	
	}
	// 고정적인 반복 메서드 -- 디비연결, 자원 반납
	public Connection getConnect() throws SQLException {
			Connection conn = DriverManager.getConnection(Serverinfo1.URL, Serverinfo1.USER, Serverinfo1.PASSWORD);
			return conn;
	}
	
	public void closeAll(Connection conn, PreparedStatement st) throws SQLException {
		if(st!=null) st.close();
		if(conn!=null) conn.close();
	}
	
	public void closeAll(Connection conn, PreparedStatement st, ResultSet rs) throws SQLException {
		if(rs!=null) rs.close();
		closeAll(conn, st);
		
	}
	
	// 변동적인 반복.. 비즈니스 로직 DAO(Database Access Object)
	public void addPerson(String name, String address) throws SQLException {
			Connection conn = getConnect();
			PreparedStatement st = conn.prepareStatement(p.getProperty("jdbc.sql.insert"));
			
			st.setString(1, name);
			st.setString(2, address);
			
			int result = st.executeUpdate();
			if(result==1) {
				System.out.println(name + "님, 추가!");
			}
			
			closeAll(conn, st);
		}
		
	
	
	public void removePerson(int id) throws SQLException {
			
			
			Connection conn = getConnect();
			PreparedStatement st = conn.prepareStatement(p.getProperty("jdbc.sql.delete"));
			st.setInt(1, id);
			
			int result = st.executeUpdate();
			
			System.out.println(result + " 명 삭제");
			
			closeAll(conn, st);
			
	}
		
	
	public void updatePerson(int id, String address) throws SQLException {
		Connection conn = getConnect();
		PreparedStatement st = conn.prepareStatement(p.getProperty("updatePerson"));
		st.setString(1, address);
		st.setInt(2, id);
		
		int result = st.executeUpdate();
		System.out.println(result + "명 수정!");
		
		closeAll(conn, st);
	}
	
	public void searchAllPerson() throws SQLException {
		Connection conn = getConnect();
		PreparedStatement st = conn.prepareStatement(p.getProperty("searchAllPerson"));
		ResultSet rs = st.executeQuery();
		
		while(rs.next()) {
			System.out.println(rs.getString("name") + "," + rs.getString("address")); 
		}
	}
	
	public void viewPerson(int id) throws SQLException {
		Connection conn = getConnect();
		PreparedStatement st = conn.prepareStatement(p.getProperty("viewPerson"));
		st.setInt(1, id);
		
		ResultSet rs = st.executeQuery();
		if(rs.next()) {
			System.out.println(rs.getString("name") + "," + rs.getString("address"));
		}
		
	}
	

	public static void main(String[] args) throws SQLException {
		
		
		
				try {
					Class.forName(Serverinfo1.DRIVER_NAME);
					PersonTest pt = new PersonTest();
					System.out.println(" 로딩");
					
					pt.addPerson("김김강강우우", "서울");
					pt.addPerson("고아라", "제주도");
					pt.addPerson("강태주", "경기도");
					
					pt.searchAllPerson();
					
					pt.removePerson(3); // 강태주 삭제
					
					pt.updatePerson(1, "제주도");
					
					pt.viewPerson(1);
				} catch (ClassNotFoundException e) {
					e.printStackTrace();
				}
		
	

	}
	// set은 물음표있을때마다 한개씩써야함 두개나오면 두개 세개나오면 세개
	// 셀렉트는 executeQuery
	// 수정은 executeUpdate
	

}
