package transaction;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

import config.Serverinfo;

public class dd {

    public static void main(String[] args) {

        try {
            // 1. 드라이버 로딩
            Class.forName(Serverinfo.DRIVER_NAME);
            // 2. 데이터베이스 연결
            Connection conn = DriverManager.getConnection(Serverinfo.URL, Serverinfo.USER, Serverinfo.PASSWORD);

            PreparedStatement st1 = conn.prepareStatement("SELECT * FROM bank");
            ResultSet rs = st1.executeQuery();

            System.out.println("========== 은행 조회 ===========");
            while (rs.next()) {
                System.out.println(rs.getString("name") + " / " + rs.getString("bankname") + " / " + rs.getInt("balance"));
            }
            System.out.println("========================================================");

            /*
             * 민소 - > 도경 : 50만원씩 이체 이 관련 모든 쿼리를 하나로 묶는다.. 하나의 단일 트랙잭션 SetAutocommit(), commit(), rollback()..
             * 등등 사용을 해서 민소님의 잔액이 마이너스가 되면 취소!
             */

            conn.setAutoCommit(false);
            
            Scanner scanner = new Scanner(System.in);
            
            System.out.print("송금할 사람을 입력하세요: ");
            String sender = scanner.nextLine();
            
            System.out.print("송금받을 사람을 입력하세요: ");
            String receiver = scanner.nextLine();
            
            System.out.print("송금할 금액을 입력하세요: ");
            int amount = scanner.nextInt();
            
            String query2 = "UPDATE bank SET balance=balance-? WHERE name =?";
            PreparedStatement st2 = conn.prepareStatement(query2);
            st2.setInt(1, amount);
            st2.setString(2, sender);
            st2.executeUpdate();

            PreparedStatement st3 = conn.prepareStatement("UPDATE bank SET balance=balance+? WHERE name =?");
            st3.setInt(1, amount);
            st3.setString(2, receiver);
            st3.executeUpdate();

            PreparedStatement st4 = conn.prepareStatement("SELECT BALANCE FROM BANK WHERE NAME =?");
            st4.setString(1, sender);
            ResultSet rs2 = st4.executeQuery();
            if (rs2.next()) {
                if (rs2.getInt("balance") < 0) {
                    conn.rollback();
                    System.out.println("돈없어");
                } else {
                    conn.commit();
                    System.out.println("송금이 완료되었습니다.");
                }
            }
            conn.setAutoCommit(true);
            
            scanner.close();
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}