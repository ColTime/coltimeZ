package Modelo;

import java.sql.*;
import javax.swing.JOptionPane;
//import javax.swing.JOptionPane;

public class Conexion {

    private Connection conexion;
    static String bd = "coltime";//Base de datos actual
    static String user = "coluser";//Usuario de mysql
    static String password = "";//contraseña
    static String server = "jdbc:mysql://192.168.4.1:3306/" + bd;//Servicio de mysql   
    //El puerto por el cual el servidor apache es el <9090>
    //El puerto 3306 es por el cual se hace la comunicacion con el motor de bases de datos.
    
    public Conexion() {}
    
    //Pedir permiso desde el servidor al puerto de comunicaciones <3306>
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
//Traer conexión a la base de datos.
    public Connection getConexion() {   
        return conexion;
    }
//cerrar la conexión que trae el resulset.
    public void cerrar(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (Exception e) {
                System.out.print("No es posible cerrar la Conexion");
            }
        }
    }
//Destruye el camino de conexión a la base de datos.
    public void destruir() {

        if (conexion != null) {

            try {
                conexion.close();
            } catch (Exception e) {
            }
        }
    }
//Autoeliminacion de la instancia de esta clase cuando no se este usando para liberar espacio en la memoria volatil del pc.
    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
