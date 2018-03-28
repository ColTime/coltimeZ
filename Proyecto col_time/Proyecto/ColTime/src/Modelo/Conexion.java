package Modelo;

import java.sql.*;
import javax.swing.JOptionPane;
//import javax.swing.JOptionPane;

public class Conexion {

    private Connection conexion;
    static String bd = "coltime";//Base de datos actual
    static String user = "root";//Usuario de mysql
    static String password = "";//contraseña
    static String server = "jdbc:mysql://localhost:3306/" + bd;//Servicio de mysql   
    //El puerto por el cual funciona es el <9090>

    public Conexion() {

    }
    //Pedir permiso al puerto de comunicaciones al puerto 3306
    public void establecerConexion() {  
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conexion = DriverManager.getConnection(server, user, password);
//            if (conexion != null) {
//                JOptionPane.showMessageDialog(null, "Conexion exitosa");
//            }
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Imposible realizar conexion con la BD" + e);
            e.printStackTrace();
        }
    }

    public Connection getConexion() {   
        return conexion;
    }

    public void cerrar(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (Exception e) {
                System.out.print("No es posible cerrar la Conexion");
            }
        }
    }

    public void destruir() {

        if (conexion != null) {

            try {
                conexion.close();
            } catch (Exception e) {
            }
        }
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
