package Controlador;

import Vistas.proyecto;
import coltime.Menu;
import gnu.io.CommPort;
import gnu.io.CommPortIdentifier;
import gnu.io.SerialPort;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.Scanner;
import javax.swing.JOptionPane;
import rojerusan.RSNotifyAnimated;

public class ProyectoQR implements Runnable {

    //Variables 
    Thread QRProyecto = null;
    public CommPort puerto = null;
    int puertoProyecto = 0;
    proyecto obj = new proyecto();
    DateFormat formato = new SimpleDateFormat("YYYY/MM/dd");
    Menu menu = new Menu();

    //...
    public ProyectoQR() {
        Thread QRProyecto = new Thread(this);
        QRProyecto.start();
    }

    @Override
    public void run() {
        int abierto = 1;
        while (abierto == 1) {
            String valor = proyectoQR();
            if (puertoProyecto == 1) {
                puertoProyecto = 0;
                llenarCamporProyecto(valor);
                abierto = 0;
            } else {
                //No se pudo establecer la conexión con el puerto COM, desea cambiarlo o volver a intentar? 
                if (JOptionPane.showOptionDialog(null, "No se pudo establecer la conexión con el puerto COM, ¿dese volver a intentarlo?",
                        "seleccione...", JOptionPane.YES_NO_CANCEL_OPTION,
                        JOptionPane.QUESTION_MESSAGE, null,// null para icono por defecto.
                        new Object[]{"SI", "NO"}, "SI") == 0) {
                    abierto = 1;
                } else {
                    abierto = 0;
                    //QRProyecto.isInterrupted();
                }
            }
        }
        obj.lector = null;
    }

    private String proyectoQR() {
        String valor = "";
        try {
            Enumeration commports = CommPortIdentifier.getPortIdentifiers();//Enumeracion de todos los puertos.
            CommPortIdentifier myCPI = null;
            Scanner mySC;
            while (commports.hasMoreElements()) {
                myCPI = (CommPortIdentifier) commports.nextElement();
                if (myCPI.getName().equals(menu.puertoActual)) {//Localización del puerto 
                    puertoProyecto = 1;
                    puerto = myCPI.open("Puerto serial Proyecto", 100);//Apertura y nombre del puerto
                    SerialPort mySP = (SerialPort) puerto;
                    //Configuracion del puerto
                    mySP.setSerialPortParams(9600, SerialPort.DATABITS_8, SerialPort.STOPBITS_1, SerialPort.PARITY_NONE);
                    mySC = new Scanner(mySP.getInputStream());//Datos de entrada al puerto
                    //----------------------------------------------------------
                    while (true) {
                        while (!mySC.hasNext()) {//Valida la informacion que va a ingresar!!
                            mySC.close();
                            mySC = null;
                            mySC = new Scanner(mySP.getInputStream());
                        }
                        valor = mySC.next();
                        if (Character.isDigit(valor.charAt(0))) {
                            //Cerrar puerto
                            puerto.close();
                            puerto = null;
                            break;//Salida del loop
                        }
                    }
                    //----------------------------------------------------------
                }
            }
        } catch (Exception e) {
            //Error al leer por el puerto serial.
            JOptionPane.showMessageDialog(null, "Error: " + e);
            puerto.close();
            puerto = null;
        }
        return valor;
    }

    public void llenarCamporProyecto(String QRProyecto) {
        //Registro de proyecto mediante lectura de codigo QR (Actual)
        //29359;Micro Hom Cali S.A.S;Control Planta;FE;Normal;15/01/2018;null;null;null;null;25;TH;SI;SI;null;null;NO;NO;null;null;null;null;null;null;null;null
        String nombreCliente = "";
        try {
//            String valor[] = QRProyecto.split("/");
////            String cadena = "";
////            for (int i = 1; i <= 4; i++) {
////                if (i == 4) {
////                    cadena = cadena + valor[i];
////                } else {
////                    cadena = cadena + valor[i] + "/";
////                }
////            }

            String InformacionProyecto[] = QRProyecto.split(";");
            System.out.println(InformacionProyecto.length);
            if (InformacionProyecto.length == 26) {
                obj.jTNorden.setText(InformacionProyecto[0]);//Numero de orden
                String infoC[] = InformacionProyecto[1].split("-");
                for (int i = 0; i < infoC.length; i++) {
                    nombreCliente += infoC[i] + " ";
                }
                obj.jTNombreCliente.setText(nombreCliente);//Nombre del cliente
                nombreCliente = "";
                String infoP[] = InformacionProyecto[2].split("-");
                for (int i = 0; i < infoP.length; i++) {
                    nombreCliente += infoP[i] + " ";
                }
                obj.jTNombreProyecto.setText(nombreCliente);//Nombre del proyecto
                obj.cbNegocio.setSelectedItem(InformacionProyecto[3]);//Negocios implicados
                obj.cbTipo.setSelectedItem(InformacionProyecto[4]);//Tipo de proyecto
                obj.jDentrega.setDate(formato.parse(InformacionProyecto[5]));//Fecha de entrega al cliente
                if (!InformacionProyecto[6].equals("null")) {//Conversor
                    obj.jCConversor.setSelected(true);
                    obj.jTConversor.setText(InformacionProyecto[6]);
                    obj.jTConversor.setEnabled(true);
                }
                if (!InformacionProyecto[7].equals("null")) {//Troquel
                    obj.jCTroquel.setSelected(true);
                    obj.jTTroquel.setText(InformacionProyecto[7]);
                    obj.jTTroquel.setEnabled(true);
                }
                if (!InformacionProyecto[8].equals("null")) {//Repujado
                    obj.jCRepujado.setSelected(true);
                    obj.jTRepujado.setText(InformacionProyecto[8]);
                    obj.jTRepujado.setEnabled(true);
                }
                if (!InformacionProyecto[9].equals("null")) {//Stencil
                    obj.jCStencil.setSelected(true);
                    obj.jTStencil.setText(InformacionProyecto[9]);
                    obj.jTStencil.setEnabled(true);
                }
                if (!InformacionProyecto[10].equals("null")) {//Circuito de FE
                    obj.jCCircuito.setSelected(true);
                    obj.jTCircuito.setText(InformacionProyecto[10]);
                    obj.jTCircuito.setEnabled(true);
                    obj.cbMaterialCircuito.setSelectedItem(InformacionProyecto[11]);
                    obj.cbMaterialCircuito.setEnabled(true);
                    obj.jCAntisolderC.setSelected(InformacionProyecto[12].toUpperCase().equals("SI"));
                    obj.jCRuteoC.setSelected(InformacionProyecto[13].toUpperCase().equals("SI"));
                }
                if (!InformacionProyecto[14].equals("null")) {//PCB TE
                    obj.jCPCBTE.setSelected(true);
                    obj.jTPCBTE.setText(InformacionProyecto[14]);
                    obj.jTPCBTE.setEnabled(true);
                    obj.cbMaterialPCBTE.setSelectedItem(InformacionProyecto[15]);
                    obj.cbMaterialPCBTE.setEnabled(true);
                    obj.jCAntisolderP.setSelected(InformacionProyecto[16].toUpperCase().equals("SI"));
                    obj.jCRuteoP.setSelected(InformacionProyecto[17].toUpperCase().equals("SI"));
                    obj.jRPCBCOM.setSelected(InformacionProyecto[18].toUpperCase().equals("SI"));
                    obj.jRPCBCOM.setEnabled(true);
                    obj.jRPIntegracion.setSelected(InformacionProyecto[19].toUpperCase().equals("SI"));
                    obj.jRPIntegracion.setEnabled(true);
                    if (obj.jRPCBCOM.isSelected()) {//Componentes de la PCB del teclado
                        obj.jDFechaEntregaPCBCOMGF.setVisible(true);
                        if (!InformacionProyecto[25].equals("null")) {
                            obj.jDFechaEntregaPCBCOMGF.setDate(formato.parse(InformacionProyecto[25]));//Fecha de entrega de componentes de la PCB_TE:
                        }
                        obj.jLpcbGF.setVisible(true);
                    }
                    if (obj.jRPIntegracion.isSelected()) {//Integración de la PCB del teclado 
                        obj.jDFechaEntregaPCBGF.setVisible(true);
                        if (!InformacionProyecto[24].equals("null")) {
                            obj.jDFechaEntregaPCBGF.setDate(formato.parse(InformacionProyecto[24]));//Fecha de entrega de la PCB_TE(TH,FV,GF):
                        }
                        obj.jLCircuitoGF.setVisible(true);
                    }
                }
                if (!InformacionProyecto[20].equals("null")) {//Teclado
                    obj.jCTeclado.setSelected(true);
                    obj.jTTeclado.setText(InformacionProyecto[20]);
                    obj.jTTeclado.setEnabled(true);
                }
                if (!InformacionProyecto[21].equals("null")) {//Ensamble
                    obj.jCIntegracion.setSelected(true);
                    obj.jTIntegracion.setText(InformacionProyecto[21]);
                    obj.jTIntegracion.setEnabled(true);
                }
                if (obj.jCCircuito.isSelected() && obj.jCIntegracion.isSelected()) {//Esto se le conoce como integración.
                    obj.jLComCircuitos.setVisible(true);
                    if (!InformacionProyecto[23].equals("null")) {
                        obj.jDFechaEntregaFECOM.setDate(formato.parse(InformacionProyecto[23]));//Fecha de entrega de los componentes del circuito_FE:
                    }
                    obj.jDFechaEntregaFECOM.setVisible(true);
                    obj.jLCircuitoFE.setVisible(true);
                    if (!InformacionProyecto[22].equals("null")) {
                        obj.jDFechaEntregaFE.setDate(formato.parse(InformacionProyecto[22]));//Fecha de entrega del Circuito_FE(TH,FV,GF) a ensamble:
                    }
                    obj.jDFechaEntregaFE.setVisible(true);
                }
                if (obj.jTNombreCliente.getText().length() > 0 && obj.jTNombreProyecto.getText().length() > 0 && obj.jDentrega.getDate() != null && !obj.cbNegocio.getSelectedItem().toString().equals("Seleccione...")
                        && !obj.cbTipo.getSelectedItem().toString().equals("Seleccione...")) {
                    obj.btnGuardar.setEnabled(true);
                }
            } else {
                //Mensaje...
                //Al QR del proyecto le falta información para poder realizar el registro
                new rojerusan.RSNotifyAnimated("¡Alerta!", "El código QR esta mal estructurado.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error: " + e);
        }
        obj.lector = null;
        //Fin de la lectura del Código QR del proyecto.
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
