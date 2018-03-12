package Controlador;

import coltime.Menu;
import gnu.io.CommPort;
import gnu.io.CommPortIdentifier;
import gnu.io.SerialPort;
import java.io.PrintStream;
import java.util.Enumeration;
import java.util.Scanner;
import javax.swing.JComboBox;
import javax.swing.JOptionPane;

public class ConexionPS {

    public String mensaje = null;
    private int existePuerto = 0;
    private String v[] = null;
    private static String puertoCOM = "COM6";
    private static String usuariodoc = "";

    public ConexionPS() {//Constructos
    }

    int conexion = 0;
//Falta validar que el puerto este abierto y disponible para poder mandar informacion, y de no ser asì se va a notificar al usuario que no puede realizar la toma de tiempo correspondiente a si àrea de producciòn.
//Composición del código: orden;nDetalle;Negocio;IDlector;cantidadProductos;cantidadOperarios

    public void enlacePuertos(Menu menu) {//Ese metodo lo utilizan los roles de encargados de FE, EN y TE
        Menu obj = new Menu();
        CommPort puerto = null;
        String valorBeta = "";
        try {
            //Presenta problemas en la enumeration o en el getPortIdentifiers
            Enumeration commports;//Se traen todos los puertos disponibles
            commports = CommPortIdentifier.getPortIdentifiers();
//            JOptionPane.showMessageDialog(null, "Esta en estado de lectura");
            CommPortIdentifier myCPI = null;
            Scanner mySC;
            while (commports.hasMoreElements()) {//Se valida que el puerto que necesito este disponible
                existePuerto = 1;
                myCPI = (CommPortIdentifier) commports.nextElement();
                if (myCPI.getName().equals(obj.puertoActual)) {
                    puerto = myCPI.open("Puerto Serial Operario", 1000);//Abro el puerto y le mando dos parametros que son el nombre de la apertura y el tiempo de respuesta
                    SerialPort mySP = (SerialPort) puerto;
                    //                       Baudios           Data bits               stopBists                  Parity
                    mySP.setSerialPortParams(19200, SerialPort.DATABITS_8, SerialPort.STOPBITS_1, SerialPort.PARITY_NONE);//Configuracion del puerto serial: Velocidad de bits, Data bits, stopbits y Paridad
                    //
                    mySC = new Scanner(mySP.getInputStream());//Datos de entrada al puerto
                    obj.myPS = new PrintStream(mySP.getOutputStream());//Datos de salia del puerto

                    conexion = 1;
                    while (true) {//Valida el mismo puerto que se abrio!!
                        while (!mySC.hasNext()) {//Valida que en el puerto serial exista alguna linea de información
                            mySC.close();
                            mySC = null;
                            mySC = new Scanner(mySP.getInputStream());
                            //Se va a cerrar la conexion del puerto si el usuario se salio de la sesión.
                            if (!menu.diponible) {
                                puerto.close();
                                break;
                            }
                        }
                        if (!menu.diponible) {//Si se cierra la sesion del encargado de algun area de producción tambien se tiene que cerrar el puerto, de lo contrario se seguira trabajando con el puerto. 
                            break;
                        } else {
                            //Procedimiento de toma de tiempo
                            //La trama es:"N°Orden;DetalleSistema;Área;LectorID;Cantidad;N°Operarios".
                            valorBeta = mySC.next();//Valor de entrada
                            //...
//                            System.out.println(valorBeta.split(";").length+"/"+valorBeta);
                            if (valorBeta.split(";").length == 6) {//El codigo de operario siempre va a contener una longitud del vecto de 6 espaciós en la memoria EEPROM
                                //                        obj.LecturaCodigoQR(valorBeta);//Función con bluetooth
                                if (Character.isDigit(valorBeta.charAt(1))) {//Valida que el valor de entrada sea el correcto//Funcionamiento con wifi
                                    //...
                                    obj.LecturaCodigoQR(valorBeta);//Se encargara de ler el codigo QR
                                    //--------------------------------------------------
                                    //Limpieza de la memoria Volatil
                                    System.gc();//Garbage collector.  
                                }
                            }
                            //...
                        }
                        if (!menu.diponible) {
                            break;
                        }
                    }
                }
            }
            //
            if (conexion == 0) {// 0 =No se pudo realizar la conexion, 1: Conexion realizada correactamente.
                if (JOptionPane.showOptionDialog(null, "Error: " + "No se pudo conectar al puerto serial " + obj.puertoActual + ". " + "¿Desea seleccionar otro puerto serial disponible?",
                        "seleccione...", JOptionPane.YES_NO_CANCEL_OPTION,
                        JOptionPane.QUESTION_MESSAGE, null,// null para icono por defecto.
                        new Object[]{"SI", "NO"}, "SI") == 0) {
                    //Se podra modificar el puerto
                    puertosDisponibles();
                    Object dig = JOptionPane.showInputDialog(new JComboBox(),
                            "Seleccione el puerto",
                            "Selector de opciones",
                            JOptionPane.QUESTION_MESSAGE,
                            null, // null para icono defecto
                            vectorObjet(v),
                            "Cantidad proyectos área");
                    Usuario reg = new Usuario();
                    reg.RegistrarModificarPuertoSerialUsuario(obj.jDocumento.getText(), dig.toString());
                    obj.puertoActual = obj.ConsultarPueroGurdado(obj.jDocumento.getText());
                }
            }
            //
            if (existePuerto == 0) {//Se mostrara un mensaje diciendo que no existe ningun puerto serial disponible
                JOptionPane.showMessageDialog(null, "No existe ningun puerto serial disponible, por favor conecte el dispotitivo");
            } else {
                existePuerto = 0;
            }
            //
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error: " + e);
            puerto.close();
        }
    }

    public String[] puertosDisponibles() {
        int pos = 0;
        try {
            //Se utiliza para saber que longitud se va a realizar el vector
            Enumeration comports = CommPortIdentifier.getPortIdentifiers();
            while (comports.hasMoreElements()) {
                comports.nextElement();
                pos++;
            }
            v = new String[pos];
            pos = 0;
            comports = CommPortIdentifier.getPortIdentifiers();
            //Se a gregan lo valores al vector con longitud ya definida 
            while (comports.hasMoreElements()) {
                CommPortIdentifier comportIdenti = (CommPortIdentifier) comports.nextElement();
                v[pos] = comportIdenti.getName();
                pos++;
            }
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error: " + e);
        }
        return v;
    }

    public Object[] vectorObjet(String v[]) {
        Object items[] = new Object[v.length];
        for (int i = 0; i < items.length; i++) {
            items[i] = v[i];
        }
        v = null;
        return items;
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
}
