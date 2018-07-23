/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reportegenerarcoltime;

import java.text.DecimalFormat;
import javax.sql.rowset.CachedRowSet;
import javax.swing.ImageIcon;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author comunicaciones03
 */
public class ReporteColtime extends javax.swing.JFrame implements Runnable {

    /**
     * Creates new form ReporteColtime
     */
    public ReporteColtime() {
        initComponents();
        this.setTitle("Informe de General de la empresa");
        this.setExtendedState(ReporteColtime.MAXIMIZED_BOTH);
        jTInforme.getTableHeader().setReorderingAllowed(false);
        reporte.start();
        this.setIconImage(new ImageIcon(getClass().getResource("/img/GN.png")).getImage());
    }
    //Variables
    CachedRowSet crs = null;
    CachedRowSet proc = null;
    String namesHeader[] = {"N°Orden", "Cliente", "Proyecto", "U.Negocio", "F.Ingreso", "FEE", "Proceso", "% Proyecto", "Estado", "NFEE", "Parada"};
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    //Variables
    String orden = "";
    int rep = 0, parada = 0, FE = 0, TE = 0, EN = 0, i = -1, contador = 0;
    int cantidadBeta = 0, procesoBeta = 0, proceso = 0, mayorCantidad = 0, entro = 0;
    int cantidadTotalProceso = 0, cantidadTotatlUnidadesAProcesasP = 0;
    float porProyecto = 0, porUnidad = 0;

    Object v[] = new Object[11];
    String nombreProcesos[] = new String[30];//Cantidad de proceso
    Modelo obj = null;
    Thread reporte = new Thread(this);

    /*
    orden=0
    cliente=1;
    proyecto=2;
    U.negocio=3;
    F.Ingreso=4;
    FEE=5;
    Proceso=6;
    % Proyecto=7;
    Estado=8;
    NFEE=9;
    Parada=10;
     */
    //--------------------------------------------------------------------------
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTInforme = new javax.swing.JTable();
        jTtipo3 = new javax.swing.JLabel();
        jTtipo4 = new javax.swing.JLabel();
        jTtipo5 = new javax.swing.JLabel();
        jTtipo2 = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jPanel1.setBackground(new java.awt.Color(204, 220, 226));

        jTInforme = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                return false; //Disallow the editing of any cell
            }
        };
        jTInforme.setAutoCreateRowSorter(true);
        jTInforme.setFont(new java.awt.Font("Arial", 1, 18)); // NOI18N
        jTInforme.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "N°Orden", "Cliente", "nombreProyecto", "N.Negocio", "F.ingreso", "FEE", "Proceso", "% proyecto", "Estado", "NFEE", "parada"
            }
        ));
        jTInforme.setFocusable(false);
        jTInforme.setGridColor(new java.awt.Color(255, 255, 255));
        jTInforme.setIntercellSpacing(new java.awt.Dimension(0, 0));
        jTInforme.setRowHeight(50);
        jScrollPane1.setViewportView(jTInforme);

        jTtipo3.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo3.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo3.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (3).png"))); // NOI18N
        jTtipo3.setText("A tiempo");

        jTtipo4.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo4.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo4.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (1).png"))); // NOI18N
        jTtipo4.setText("Retrasado");

        jTtipo5.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo5.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo5.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo5.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (2).png"))); // NOI18N
        jTtipo5.setText("Parada");

        jTtipo2.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo2.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo2.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (5).png"))); // NOI18N
        jTtipo2.setText("Por iniciar");

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 960, Short.MAX_VALUE)
                .addContainerGap())
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(jTtipo3, javax.swing.GroupLayout.PREFERRED_SIZE, 100, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(5, 5, 5)
                .addComponent(jTtipo4, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTtipo5, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTtipo2, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 334, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTtipo2, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jTtipo4, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTtipo5, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTtipo3, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(0, 0, 0))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(0, 0, 0))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents
    @Override
    public void run() {
        while (true) {
            InformeGeneralEmpresaColcircuitos();
            try {
                Thread.sleep(10000);//Diez segundos
            } catch (InterruptedException ex) {
//                Logger.getLogger(ReporteColtime.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    private void InformeGeneralEmpresaColcircuitos() {
        try {
            obj = new Modelo();
            crs = obj.informacionInformeGeneral();
            obj = null;
            DefaultTableModel df = new DefaultTableModel(null, namesHeader);
//          jTInforme.setModel(null);
            while (crs.next()) {
                //...
                if (rep == 0) {
                    entro++;
                    vectorInicial();//Inicio del vector
                    procesoMayorCantidad();
                    tipoNegocio();//Para calcurar la unidad de negocio
                    //...
                    sumaCantidadTotalTerminadaPRoceso();
                    sacarTotalCandidadesAProcesarProyectos();
                    rep = 1;
                } else {
                    if (!v[0].toString().equals(crs.getString(1))) {//Si el numero de orden es diferente a la que se guardo en el vector va a calcular el porcentaje y el proceso donde se encuentra la mayor cantidad de productos
                        //%...
                        //Cantidad Proceso
                        //Ingreso de vector a la tabla
                        asignarTiposNegosio();//Tipo de unidad de negocio
                        v[6] = asignacionDeProceso(proceso);
                        //Se calcula el porcentaje (Aprox) del proyecto
                        calcularProcentajeProyecto();
                        //calcularProcentajeTotalProceso();//Se calcula el porcentaje (Aprox.) del proyecto.
                        df.addRow(v);
                        //Reinicializacion de variabel
                        reinicializarVariables();
                        vectorInicial();//Inicio del vector
                        //Se tiene en cuenta la linea que se esta cruzando
                        tipoNegocio();//Para calcurar la unidad de negocio
                        procesoMayorCantidad();
                        //...
                        sumaCantidadTotalTerminadaPRoceso();
                        sacarTotalCandidadesAProcesarProyectos();
                        //se cuentan los proceso del siguiente proyecto
                    } else {
                        //vectorInicial();//Inicio del vector
                        procesoMayorCantidad();
                        tipoNegocio();//Para calcurar la unidad de negocio
                        //...
                        sumaCantidadTotalTerminadaPRoceso();
                        sacarTotalCandidadesAProcesarProyectos();
                        rep = 1;
                    }
                }
            }
            //Se ejecuta siempre y cuando haya entrada una vez al loop
            if (entro != 0) {
                asignarTiposNegosio();//Tipo de unidad e negocio
                v[6] = asignacionDeProceso(proceso);
                calcularProcentajeProyecto();//Se calcula el porcentaje (Aprox) del proyecto
                df.addRow(v);
                //Reinicializar variables
                reinicializarVariables();
                //System.out.println("FE: " + FE + " TE: " + TE + " EN: " + EN);

                jTInforme.setModel(df);//Se agrega el modelo a la tabla
            }
            Render render = new Render();
            jTInforme.setDefaultRenderer(Object.class, render);
            //Se ejecuta siempre
            ocultarColumnas();//Oculta la columna estado parada del proyecto
            //...
            rep = 0;
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error: " + e);
        }
    }

    private void ocultarColumnas() {
        jTInforme.getColumnModel().getColumn(10).setMaxWidth(0);
        jTInforme.getColumnModel().getColumn(10).setMinWidth(0);
        jTInforme.getTableHeader().getColumnModel().getColumn(10).setMaxWidth(0);
        jTInforme.getTableHeader().getColumnModel().getColumn(10).setMinWidth(0);
    }

    private void sumaCantidadTotalTerminadaPRoceso() {
        try {
            switch (crs.getInt(6)) {
                case 1://Formato estandar
                    cantidadTotalProceso += crs.getInt(14);//Cantidad beta de formato estandar
                    break;
                case 2://Teclados
                    cantidadTotalProceso += crs.getInt(16);//Cantidad beta de teclados
                    break;
                case 3://Ensamble
                    cantidadTotalProceso += crs.getInt(18);//Cantidad beta de ensamble
                    break;
            }
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error: " + e);
        }
    }

    private void sacarTotalCandidadesAProcesarProyectos() {
        try {
            cantidadTotatlUnidadesAProcesasP += crs.getInt(19);
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error: " + e);
        }
    }

    private void calcularProcentajeProyecto() {
        float cien = 100;
        //Se busca el procentaje por unidad.
        porUnidad = cien / cantidadTotatlUnidadesAProcesasP;
//        redondearDecimales(porUnidad,2);
        //Se multiplica el procentaje por unidad por la cantidad total terminada de todos lo proceso.
        porProyecto = porUnidad * cantidadTotalProceso;
        DecimalFormat decimal = new DecimalFormat("#.00");
        //El valor final se le da un formato y se redondea a dos cifras .
        //se le asigna la variable al vector.
        if (porProyecto > 100) {
            porProyecto = 100;
        }
        v[7] = decimal.format(porProyecto);
    }

    public static double redondearDecimales(double valorInicial, int numeroDecimales) {
        double parteEntera, resultado;
        resultado = valorInicial;
        parteEntera = Math.floor(resultado);
        resultado = (resultado - parteEntera) * Math.pow(10, numeroDecimales);
        resultado = Math.round(resultado);
        resultado = (resultado / Math.pow(10, numeroDecimales)) + parteEntera;
        return resultado;
    }

    private String asignacionDeProceso(int proceso) {
        try {
            if (obj == null) {
                obj = new Modelo();
                proc = obj.procesos();

                while (proc.next()) {
                    nombreProcesos[++i] = proc.getString(2);
                }
                i = -1;
            }
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error: " + e);
        }
        if (proceso == 0) {
            return "";
        } else {
            return nombreProcesos[proceso - 1];
        }
    }

    private void reinicializarVariables() {
        FE = 0;
        TE = 0;
        EN = 0;
        cantidadBeta = 0;
        proceso = 0;
        mayorCantidad = 0;
        procesoBeta = 0;
        cantidadTotalProceso = 0;
        cantidadTotatlUnidadesAProcesasP = 0;
        contador = 0;
    }

    private void procesoMayorCantidad() {
        //Presenta problemas
        try {
            switch (crs.getInt(6)) {
                case 1://Formato estandar
                    procesoBeta = crs.getInt(13);//Proceso beta de formato estandar
                    cantidadBeta = crs.getInt(14);//Cantidad beta de formato estandar
                    break;
                case 2://Teclados
                    procesoBeta = crs.getInt(15);//Proceso beta de teclados
                    cantidadBeta = crs.getInt(16);//Cantidad beta de teclados
                    break;
                case 3://Ensamble
                    procesoBeta = crs.getInt(17);//Proceso beta de ensamble
                    cantidadBeta = crs.getInt(18);//Cantidad beta de ensamble
                    break;
            }
            //Busca la mayor cantidad dentro de todos los proceso y la pone de primera
            metodoBurbujaManual();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Erro: " + e);
        }
    }

    public void metodoBurbujaManual() {
//        if(v[0].equals("30544")){
//            System.out.println("orden 30544");
//        }
        if (cantidadBeta >= mayorCantidad) {
            mayorCantidad = cantidadBeta;
            if (v[8].equals("Por iniciar")) {
                proceso = 0;
            } else {
                proceso = procesoBeta;
            }
            if (cantidadBeta == 0) {
                proceso = 0;
            }
            //      Se utiliza para poder pasar al sigueinte proceso de produccion.
        } else if (cantidadBeta == 0 && procesoBeta > proceso && mayorCantidad > 0 && contador == 0) {
            proceso = procesoBeta;
            contador++;
        }
    }

    private void tipoNegocio() {
        try {
            switch (crs.getInt(6)) {
                case 1://Formato estandar
                    FE++;
                    break;
                case 2://Teclados   
                    TE++;
                    break;
                case 3://Ensamble
                    EN++;
                    break;
            }
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Erro: " + e);
        }
    }

    private void asignarTiposNegosio() {
        if (FE >= 1 && TE == 0 && EN == 0) {//Formato estandar
            v[3] = "FE";//Unidad de negocio;
        } else if (FE == 0 && TE >= 1 && EN == 0) {//teclado
            v[3] = "TE";//Unidad de negocio;
        } else if (FE == 0 && TE == 0 && EN >= 1) {//Ensamble
            v[3] = "EN";//Unidad de negocio;
        } else if ((FE >= 1 && TE == 0 && EN >= 1) || (FE >= 1 && TE >= 1 && EN >= 1) || (FE == 0 && TE >= 1 && EN >= 1) || (FE >= 1 && TE >= 1 && EN == 0)) {//Integracion
            v[3] = "IN";//Unidad de negocio;
        }
    }

    private void vectorInicial() {
        try {
            v[0] = crs.getString(1);//Oreden
            v[1] = crs.getString(3);//Nombre cliente
            v[2] = crs.getString(4);//Nombre Proyecto
            v[4] = crs.getString(7);//Ingreso
            v[5] = crs.getString(8);//FEE
            if (crs.getBoolean(2)) {//"0" significa que esta parada
                if (crs.getString(9) != null) {//Sub estado de la empresa
                    v[8] = crs.getString(9);//Estado
                } else {
                    v[8] = "Por iniciar";//Estado
                }
            } else {
                v[8] = "Parada";//Estado
            }
            v[10] = crs.getString(2);
            v[9] = crs.getString(10);

        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error" + e);
        }
    }

//------------------------------------------------------------------------------
    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(ReporteColtime.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(ReporteColtime.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(ReporteColtime.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(ReporteColtime.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new ReporteColtime().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTable jTInforme;
    private javax.swing.JLabel jTtipo2;
    private javax.swing.JLabel jTtipo3;
    private javax.swing.JLabel jTtipo4;
    private javax.swing.JLabel jTtipo5;
    // End of variables declaration//GEN-END:variables

}
