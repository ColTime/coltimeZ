package Controlador;

import coltime.Menu;
import java.awt.Color;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DisponibilidadConexion implements Runnable {

    @Override
    public void run() {
        Menu vista = new Menu();
        while (true) {
            Modelo.Conexion obj = new Modelo.Conexion();
            obj.establecerConexion();
            if (obj.getConexion() != null) {
                vista.jLConexion.setText("Linea");
                vista.jLConexion.setForeground(Color.GREEN);
            } else {
                vista.jLConexion.setText("Sin conexión");
                vista.jLConexion.setForeground(Color.RED);
            }
            obj.destruir();
            try {
                Thread.sleep(1000);
            } catch (InterruptedException ex) {
                Logger.getLogger(DisponibilidadConexion.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

    
}
