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
    String tipo_negocio = "",producto1="",Orden1="";

    private void cargarTablaInformeFE() {
        Object v[] = new Object[25];//                                                      6                     8                    10                   12                   14                  16                  18                  20            22                    24   
        String names[] = {"N°Orden", "Material", "Tipo", "C.T", "TipoNegocio", "sub_P", "Perforado", "sub_Q", "Quimicos", "sub_C", "Caminos", "sub_CTH", "C.C.TH", "sub_Que", "Quemado", "sub_S", "Screen", "sub_E", "Estañado", "sub_C2", "C2", "sub_R", "Ruteo", "sub_M", "Maquinas"};

        DefaultTableModel df = new DefaultTableModel(null, names);
        ProyectoController obj = new ProyectoController();
        try {
            crs = obj.consultarProceso();
            while (crs.next()) {
                cont++;
                Orden1=crs.getString(1);
                producto1=crs.getString(4);
                //Pendiente por corregir
                //----------------------------------------------------------------------------------------------------------------
                if (rep == 0) {//Se valida que el nuevo numero de la orden se agrege solo una sola vez al vector
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
                    rep = 1;
                }//-----------------------------------------------------------------------------------------------------------
                if (v[4].toString().equals(crs.getString(4)) && v[0].toString().equals(crs.getString(1))) {//Numero de orden
                    switch (crs.getInt(7)) {
                        case 1://Perforado
                            v[5] = crs.getInt(8);
                            cantidadRestante = crs.getInt(5) - crs.getInt(6);//Cantidad Total - Cantidad Terminada Proceso.
                            cantidadPasada = crs.getInt(5) - cantidadRestante;//Cantidad Total- Cantidad Restante Proceso
                            v[6] = cantidadRestante;//Perforado
                            v[8] = cantidadRestante;//Quimicos
                            break;
                        case 2://Quimicos
                            v[7] = crs.getInt(8);
                            break;
                        case 3://Caminos
                            v[9] = crs.getInt(8);
                            break;
                        case 4://C.C.TH
                            v[11] = crs.getInt(8);
                            break;
                        case 5://Quemado
                            v[13] = crs.getInt(8);
                            break;
                        case 6://Screen
                            v[15] = crs.getInt(8);
                            break;
                        case 7://Estañado
                            v[17] = crs.getInt(8);
                            break;
                        case 8://C2
                            v[19] = crs.getInt(8);
                            break;
                        case 9://Ruteo
                            v[21] = crs.getInt(8);
                            break;
                        case 10://Maquinas
                            v[23] = crs.getInt(8);
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
                } else {
                    df.addRow(v);//Información del proyecto
                    rep = 0; //se reinicia la variable para poder comparar la orden anterior con la siguiente.
                    for (int i = 0; i < 25; i++) {//Reinicializa el vector
                        v[i] = null;
                    }
                }
            }
            jTReporte.setModel(df);
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
        jTReporte = new javax.swing.JTable();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jPanel1.setBackground(new java.awt.Color(255, 255, 255));

        jTReporte.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null}
            },
            new String [] {
                "N°Orden", "Tipo", "C.T", "TipoNegocio", "sub_p", "Perforado", "sub_Q", "Quimicos", "sub_C", "Caminos", "sub_CTH", "C.C.TH", "sub_QUE", "Quemado", "sub_S", "Screen", "sub_E", "Estañado", "sub_C2", "C2", "sub_R", "Ruteo", "sub_M", "Maquinas"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.String.class, java.lang.String.class, java.lang.String.class, java.lang.String.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }
        });
        jTReporte.setFocusable(false);
        jTReporte.setGridColor(new java.awt.Color(255, 255, 255));
        jTReporte.setIntercellSpacing(new java.awt.Dimension(0, 0));
        jTReporte.setRowHeight(50);
        jTReporte.setSelectionBackground(new java.awt.Color(120, 187, 253));
        jTReporte.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jScrollPane1.setViewportView(jTReporte);

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 1335, Short.MAX_VALUE)
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 607, Short.MAX_VALUE)
                .addGap(10, 10, 10))
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
