/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo;

import com.sun.rowset.CachedRowSetImpl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.sql.rowset.CachedRowSet;

/**
 *
 * @author PC
 */
public class ProcesosM {

    public ProcesosM() {

    }
    Conexion conexion = null;
    CachedRowSet crs = null;
    Connection con = null;
    PreparedStatement pps = null;
    ResultSet rs = null;
    boolean res = false;

    public boolean guardarModificarProcesosM(int op, String nombre, int area) {
        try {
            conexion = new Conexion();
            conexion.establecerConexion();
            con = conexion.getConexion();
            pps = con.prepareStatement("SELECT FU_RegistrarModificarProcesos(?,?,?)");//op,nombre del proceso y area a la que aplica.
            pps.setInt(1, op);
            pps.setString(2, nombre);
            pps.setInt(3, area);
            rs = pps.executeQuery();
            rs.next();
            res = rs.getBoolean(1);
            rs.close();
            pps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {//Errores
        }
        return res;
    }

    public CachedRowSet consultarProcesosM() {
        try {
            conexion = new Conexion();
            conexion.establecerConexion();
            con = conexion.getConexion();
            pps = con.prepareStatement("CALL PA_ConsultarProcesos()");
            crs = new CachedRowSetImpl();
            rs = pps.executeQuery();
            crs.populate(rs);
            rs.close();
            pps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {//Errores
        }
        return crs;
    }

    public boolean cambiarEstadoProcesosM(int estado, int id) {
        try {
            conexion = new Conexion();
            conexion.establecerConexion();
            con = conexion.getConexion();
            pps = con.prepareStatement("SELECT FU_CambiarEstadoProcesos(?,?)");//op,nombre del proceso y area a la que aplica.
            pps.setInt(1, id);
            pps.setInt(2, estado);
            rs = pps.executeQuery();
            res = rs.getBoolean(1);
            rs.close();
            pps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {//Errores
        }
        return res;
    }
}
