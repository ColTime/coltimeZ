/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reportefe;

import javax.sql.rowset.CachedRowSet;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author acomercial05
 */
public class FE extends javax.swing.JFrame {

    /**
     * Creates new form FE
     */
    public FE() {
        initComponents();
        this.setExtendedState(FE.MAXIMIZED_BOTH);
        cargarTablaInformeFE();
    }
    //Variables
    CachedRowSet crs = null;
    int rep = 0;
    int cantidadRestante = 0, cantidadPasada = 0;
    int cont = 0;
    String tipo_negocio = "", producto1 = "", Orden1 = "";
    Object v[] = new Object[25];
    String NamesOrden[]=new String[5];
    int P = 0, Q = 0, C = 0, CTH = 0, QUE = 0, S = 0, E = 0, C2 = 0, R = 0, M = 0;

    private void cargarTablaInformeFE() {
        //                                                      6                     8                    10                   12                   14                  16                  18                  20            22                    24   
        String names[] = {"N°Orden", "Material", "Tipo", "C.T", "TipoNegocio", "sub_P", "Perforado", "sub_Q", "Quimicos", "sub_C", "Caminos", "sub_CTH", "C.C.TH", "sub_Que", "Quemado", "sub_S", "Screen", "sub_E", "Estañado", "sub_C2", "C2", "sub_R", "Ruteo", "sub_M", "Maquinas"};

        DefaultTableModel df = new DefaultTableModel(null, names);
        ProyectoController obj = new ProyectoController();
        try {
            crs = obj.consultarProceso();
            while (crs.next()) {
//                cont++;
//                Orden1 = crs.getString(1);
//                producto1 = crs.getString(4);
                cont++;
                if (cont == 47) {
                    v[0] = crs.getString(1);//
                }
                if (rep == 0) {//Se puede cambiar la información principal
                    reinicializarVector(crs);//Se vuleve a poner el vector en estado base
                    rep = 1;
                } else {
                    if (v[4].toString().equals(crs.getString(4)) && v[0].toString().equals(crs.getString(1))) {
                        rep = 1;
                    } else {
                        organizarVector();
                        df.addRow(v);//Información del proyecto
                        //Estado inicial del proyecto
                        reinicializarVector(crs);//Se vuleve a poner el vector en estado base
//                        rep = 1;
                    }
                }
                if (v[4].toString().equals(crs.getString(4)) && v[0].toString().equals(crs.getString(1))) {//Numero de orden
                    //Se valida que el nuevo numero de la orden se agrege solo una sola vez al vector
                    cantidadRestante = 0;
                    cantidadPasada = 0;
                    switch (crs.getInt(7)) {
                        case 1://Perforado
                            v[5] = crs.getInt(8);//Estado del perforado
                            cantidadRestante = crs.getInt(5) - crs.getInt(6);//Cantidad Total - Cantidad Terminada Proceso.
                            cantidadPasada = crs.getInt(5) - cantidadRestante;//Cantidad Total- Cantidad Restante Proceso
                            v[6] = cantidadRestante;//Perforado
                            v[8] = cantidadPasada;//Quimicos
                            break;
                        case 2://Quimicos
                            v[7] = crs.getInt(8);//Estado de quimicos
//                          //...
                            v[10] = crs.getInt(6);//Cantidad que se le pasa al siguiente proceso
                            break;
                        case 3://Caminos
                            v[9] = crs.getInt(8);//Estado de Caminos
                            //...
                            v[12] = crs.getInt(6);//Cantidad que se le pasa al siguiente proceso
                            break;
                        case 4://C.C.TH
                            v[11] = crs.getInt(8);//Estado de C.C.TH
                            //...
                            v[14] = crs.getInt(6);//Cantidad que se le pasa al siguiente proceso
                            break;
                        case 5://Quemado
                            v[13] = crs.getInt(8);//Estado de quemado
                            //...
                            v[16] = crs.getInt(6);//Cantidad que se le pasa al siguiente proceso
                            break;
                        case 6://Screen
                            v[15] = crs.getInt(8);//Estado de Screen
                            //...
                            v[18] = crs.getInt(6);//Cantidad que se le pasa al siguiente proceso
                            break;
                        case 7://Estañado
                            v[17] = crs.getInt(8);//Estado de Estañado
                            //...
                            v[20] = crs.getInt(6);//Cantidad que se le pasa al siguiente proceso
                            break;
                        case 8://C2
                            v[19] = crs.getInt(8);//Estado de C2
                            //...
                            v[22] = crs.getInt(6);//Cantidad que se le pasa al siguiente proceso
                            break;
                        case 9://Ruteo
                            v[21] = crs.getInt(8);//Estado de ruteo
                            //...
                            v[24] = crs.getInt(6);//Cantidad que se le pasa al siguiente proceso
                            break;
                        case 10://Maquinas
                            v[23] = crs.getInt(8);//Estado de maquinas
                            //...
                            break;
                    }
                    /*
                    subs_POS
                    -subP=5;
                    -subC=7;
                    -subQ=9;
                    -subCTH=11;
                    -subQUE=13;
                    -subS=15;
                    -subE=17;
                    -subC2=19;
                    -subR=21;
                    -subM=23;
                    
                    Procesos_POS
                    -P=6;
                    -C=8;
                    -Q=10;
                    -CTH=12;
                    -QUE=14;
                    -S=16;
                    -E=18;
                    -C2=20;
                    -R=22;
                    -M=24;
                     */
                }
            }
            organizarVector();
            df.addRow(v);//Información del proyecto
            jTReporte.setModel(df);
//            jTReporte.setDefaultRenderer(Object.class, render);
            columnasOcultas();

        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error: " + e);
        }
    }

    private void columnasOcultas() {
        //tipo de proyecto
        jTReporte.getColumnModel().getColumn(2).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(2).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(2).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(2).setMinWidth(0);
        //Perforado
        jTReporte.getColumnModel().getColumn(5).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(5).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(5).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(5).setMinWidth(0);
        //Quimicos
        jTReporte.getColumnModel().getColumn(7).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(7).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(7).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(7).setMinWidth(0);
        //Caminos
        jTReporte.getColumnModel().getColumn(9).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(9).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(9).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(9).setMinWidth(0);
        //C.C.TH
        jTReporte.getColumnModel().getColumn(11).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(11).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(11).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(11).setMinWidth(0);
        //Quemado
        jTReporte.getColumnModel().getColumn(13).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(13).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(13).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(13).setMinWidth(0);
        //Screen
        jTReporte.getColumnModel().getColumn(15).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(15).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(15).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(15).setMinWidth(0);
        //Estañado
        jTReporte.getColumnModel().getColumn(17).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(17).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(17).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(17).setMinWidth(0);
        //C2
        jTReporte.getColumnModel().getColumn(19).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(19).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(19).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(19).setMinWidth(0);
        //Ruteo
        jTReporte.getColumnModel().getColumn(21).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(21).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(21).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(21).setMinWidth(0);
        //Maquinas
        jTReporte.getColumnModel().getColumn(23).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(23).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(23).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(23).setMinWidth(0);
    }

    private void organizarVector() {
        int cantidadPasada = 0, prceso = 8, subProceso = 7;

        if (v[7].toString().equals("-1")) {//Cuando no lleva quimicos
//            if(){
//                
//            }
            v[10] = v[8];
            v[8] = 0;
        }
        if (v[15].toString().equals("-1")) {//Cuendo no lleva Screen.
            v[18] = v[16];
            v[16] = 0;
        }
        if (v[21].toString().equals("-1")) {//Cuando no lleva ruteo
            v[24] = v[22];
            v[22] = 0;
        }
        //----------------------------------------------------------------------
        for (int i = 0; i < 8; i++) {
            if (!v[subProceso].toString().equals("-1") && !v[subProceso].toString().equals("1")) {//Todos los sub
                cantidadPasada = Integer.parseInt(v[prceso].toString()) - Integer.parseInt(v[prceso + 2].toString());//Cantidad que tiene Quimicos
                v[prceso] = cantidadPasada;//Se asigna la cantidad a Quimicos
            }
            prceso += 2;
            subProceso += 2;
        }
        prceso = 8;
        subProceso = 7;

//        if ((v[4].toString().equals("PCB") || v[4].toString().equals("Circuito")) && v[1].toString().equals("TH")) {//Circuito o PCB TH
//            //------------------------------------------------------------------------
//            for (int i = 0; i < 8; i++) {
//                if (!v[subProceso].toString().equals("-1") && !v[subProceso].toString().equals("1")) {//Todos los sub
//                    cantidadPasada = Integer.parseInt(v[prceso].toString()) - Integer.parseInt(v[prceso + 2].toString());//Cantidad que tiene Quimicos
//                    v[prceso] = cantidadPasada;//Se asigna la cantidad a Quimicos
//                }
//                prceso += 2;
//                subProceso += 2;
//            }
//            prceso = 8;
//            subProceso = 7;
//            //------------------------------------------------------------------------
//        } else if (v[4].toString().equals("Circuito") && v[1].toString().equals("FV")) {//Circuito FV
//            for (int i = 0; i < 8; i++) {
//                if (!v[subProceso].toString().equals("-1") && !v[subProceso].toString().equals("1")) {//Todos los sub
//                    cantidadPasada = Integer.parseInt(v[prceso].toString()) - Integer.parseInt(v[prceso + 2].toString());//Cantidad que tiene Quimicos
//                    v[prceso] = cantidadPasada;//Se asigna la cantidad a Quimicos
//                }
//                prceso += 2;
//                subProceso += 2;
//            }
//            prceso = 8;
//            subProceso = 7;
//        }
        /*
                    subs_POS
                    -subP=5;
                    -subQ=7;
                    -subC=9;
                    -subCTH=11;
                    -subQUE=13;
                    -subS=15;
                    -subE=17;
                    -subC2=19;
                    -subR=21;
                    -subM=23;
                    
                    Procesos_POS
                    -P=6;
                    -C=8;
                    -Q=10;
                    -CTH=12;
                    -QUE=14;
                    -S=16;
                    -E=18;
                    -C2=20;
                    -R=22;
                    -M=24;
         */
    }

    private void reinicializarVector(CachedRowSet crs) {
        try {
            v[0] = crs.getString(1);//Numero de orden
            v[1] = crs.getString(2);//Material
            v[2] = crs.getString(3);//Tipo(Normal,Quick,RQT)
            v[3] = crs.getString(5);//Cantidad total del proyecto
            v[4] = crs.getString(4);//Tipo de negocio
            //Procesos
            v[6] = 0;
            v[8] = 0;
            v[10] = 0;
            v[12] = 0;
            v[14] = 0;
            v[16] = 0;
            v[18] = 0;
            v[20] = 0;
            v[22] = 0;
            v[24] = 0;
            //sub en estado por iniciar
            v[5] = -1;
            v[7] = -1;
            v[9] = -1;
            v[11] = -1;
            v[13] = -1;
            v[15] = -1;
            v[17] = -1;
            v[19] = -1;
            v[21] = -1;
            v[23] = -1;

        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error: " + e);
        }
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTReporte = new reportefe.MyRender();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jPanel1.setBackground(new java.awt.Color(255, 255, 255));

        jTReporte.setAutoCreateRowSorter(true);
        jTReporte.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTReporte.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null}
            },
            new String [] {
                "N°Orden", "Tipo", "tipo_Proyecto", "C.T", "TipoNegocio", "sub_p", "Perforado", "sub_Q", "Quimicos", "sub_C", "Caminos", "sub_CTH", "C.C.TH", "sub_QUE", "Quemado", "sub_S", "Screen", "sub_E", "Estañado", "sub_C2", "C2", "sub_R", "Ruteo", "sub_M", "Maquinas"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.Integer.class, java.lang.String.class, java.lang.String.class, java.lang.String.class, java.lang.String.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }
        });
        jTReporte.setFocusable(false);
        jTReporte.setGridColor(new java.awt.Color(153, 153, 153));
        jTReporte.setRowHeight(40);
        jTReporte.setSelectionBackground(new java.awt.Color(120, 187, 253));
        jTReporte.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jScrollPane1.setViewportView(jTReporte);

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 1355, Short.MAX_VALUE)
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addGap(10, 10, 10)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 607, Short.MAX_VALUE)
                .addContainerGap())
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

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
            java.util.logging.Logger.getLogger(FE.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(FE.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(FE.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(FE.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new FE().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTable jTReporte;
    // End of variables declaration//GEN-END:variables
}
