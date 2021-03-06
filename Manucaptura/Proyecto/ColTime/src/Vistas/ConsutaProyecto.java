package Vistas;

import Controlador.DetalleProyecto;
import Controlador.FormatoTabla;
import elaprendiz.gui.textField.TextFieldRoundBackground;
import java.awt.Color;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.sql.rowset.CachedRowSet;
import javax.swing.ImageIcon;
import javax.swing.JCheckBox;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

public class ConsutaProyecto extends javax.swing.JFrame {

    public ConsutaProyecto() {
        initComponents();
        jDFecha.setEnabled(false);
        jRnulo.setVisible(false);
        jTtipo.setText("");
        consultarProyectos("", "", "", "", 0);
        editarColumnasPNC();
        editarColumnasDetalle();
        this.setIconImage(new ImageIcon(getClass().getResource("/imagenesEmpresa/favicon.png")).getImage());
        TProyecto.getTableHeader().setReorderingAllowed(false);//Tabla proyecto
        TPNC.getTableHeader().setReorderingAllowed(false);//Tabla producto no conforme(PNC)
        TProyecto.getTableHeader().setReorderingAllowed(false);//Tabla proyecto
        TDetalle.getTableHeader().setReorderingAllowed(false);//Tabla detalle del proyecto
//        System.out.println("width: " + jPEncabezado.getWidth() + "\n"
//                + "Heigth: " + jPEncabezado.getHeight());
    }
    //Variables globales
    int posX = 0;
    int posY = 0;
    int count = 0;
    int estado = 1, row = 0;
    int cantidadRegistros = 0;
    CachedRowSet crs;
    //Botones de radio
    String encabezado1[] = {"idDetalle", "Negocio", "Tipo de negocio", "Cantidad", "Estado", "Material"};//Detalle del proyecto
    String encabezado2[] = {"idDetalle", "Negocio", "Tipo de negocio", "Cantidad", "Ubicación", "Estado"};//PNC

    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        fechas = new javax.swing.ButtonGroup();
        jPEncabezado = new javax.swing.JPanel();
        jButton9 = new javax.swing.JButton();
        jButton10 = new javax.swing.JButton();
        jPanel4 = new javax.swing.JPanel();
        jTtipo = new javax.swing.JLabel();
        jTtipo2 = new javax.swing.JLabel();
        jPanel3 = new javax.swing.JPanel();
        jTNumerOrden = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel3 = new javax.swing.JLabel();
        jTNombreCliente = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel5 = new javax.swing.JLabel();
        jTNombreProyecto = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel4 = new javax.swing.JLabel();
        jButton1 = new javax.swing.JButton();
        jDFecha = new com.toedter.calendar.JDateChooser();
        jREntrega = new javax.swing.JRadioButton();
        jRIngreso = new javax.swing.JRadioButton();
        jRSalida = new javax.swing.JRadioButton();
        jRnulo = new javax.swing.JRadioButton();
        btnEliminados = new elaprendiz.gui.button.ButtonColoredAction();
        jTtipo1 = new javax.swing.JLabel();
        jTtipo3 = new javax.swing.JLabel();
        jTtipo4 = new javax.swing.JLabel();
        jTtipo5 = new javax.swing.JLabel();
        jPanel2 = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        TProyecto = new javax.swing.JTable();
        jTCantidadRegistros = new javax.swing.JLabel();
        jTCantidadRegistros1 = new javax.swing.JLabel();
        jPanel5 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        TPNC = new javax.swing.JTable();
        jPanel6 = new javax.swing.JPanel();
        jScrollPane3 = new javax.swing.JScrollPane();
        TDetalle = new javax.swing.JTable();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setUndecorated(true);

        jPEncabezado.setBackground(new java.awt.Color(60, 141, 188));
        jPEncabezado.setBorder(javax.swing.BorderFactory.createMatteBorder(2, 2, 0, 2, new java.awt.Color(153, 153, 153)));
        jPEncabezado.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        jPEncabezado.addMouseMotionListener(new java.awt.event.MouseMotionAdapter() {
            public void mouseDragged(java.awt.event.MouseEvent evt) {
                jPEncabezadoMouseDragged(evt);
            }
        });
        jPEncabezado.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jPEncabezadoMousePressed(evt);
            }
        });

        jButton9.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/close.png"))); // NOI18N
        jButton9.setBorderPainted(false);
        jButton9.setContentAreaFilled(false);
        jButton9.setFocusPainted(false);
        jButton9.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/close1.png"))); // NOI18N
        jButton9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton9ActionPerformed(evt);
            }
        });

        jButton10.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/minus1.png"))); // NOI18N
        jButton10.setBorderPainted(false);
        jButton10.setContentAreaFilled(false);
        jButton10.setFocusPainted(false);
        jButton10.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/minus.png"))); // NOI18N
        jButton10.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton10ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPEncabezadoLayout = new javax.swing.GroupLayout(jPEncabezado);
        jPEncabezado.setLayout(jPEncabezadoLayout);
        jPEncabezadoLayout.setHorizontalGroup(
            jPEncabezadoLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPEncabezadoLayout.createSequentialGroup()
                .addGap(1163, 1163, 1163)
                .addComponent(jButton10, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(6, 6, 6)
                .addComponent(jButton9, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
        jPEncabezadoLayout.setVerticalGroup(
            jPEncabezadoLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPEncabezadoLayout.createSequentialGroup()
                .addGap(11, 11, 11)
                .addGroup(jPEncabezadoLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButton10)
                    .addComponent(jButton9))
                .addContainerGap(25, Short.MAX_VALUE))
        );

        jPanel4.setBackground(new java.awt.Color(255, 255, 255));
        jPanel4.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(153, 153, 153), 2));
        jPanel4.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jTtipo.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo.setText("Tipo:");
        jPanel4.add(jTtipo, new org.netbeans.lib.awtextra.AbsoluteConstraints(1140, 110, 71, -1));

        jTtipo2.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo2.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo2.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (2).png"))); // NOI18N
        jTtipo2.setText("Parada");
        jPanel4.add(jTtipo2, new org.netbeans.lib.awtextra.AbsoluteConstraints(330, 100, 120, 30));

        jPanel3.setBackground(new java.awt.Color(255, 255, 255));
        jPanel3.setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createTitledBorder(null, "", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 0, 11), new java.awt.Color(204, 204, 204)), "Busqueda", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 14), new java.awt.Color(204, 204, 204))); // NOI18N
        jPanel3.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jTNumerOrden.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTNumerOrden.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTNumerOrden.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTNumerOrdenKeyReleased(evt);
            }
        });
        jPanel3.add(jTNumerOrden, new org.netbeans.lib.awtextra.AbsoluteConstraints(38, 51, 90, 25));

        jLabel3.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel3.setForeground(new java.awt.Color(128, 128, 131));
        jLabel3.setText(" Orden °N:");
        jPanel3.add(jLabel3, new org.netbeans.lib.awtextra.AbsoluteConstraints(38, 30, 71, -1));

        jTNombreCliente.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTNombreCliente.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTNombreCliente.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTNombreClienteKeyReleased(evt);
            }
        });
        jPanel3.add(jTNombreCliente, new org.netbeans.lib.awtextra.AbsoluteConstraints(154, 51, 239, 25));

        jLabel5.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel5.setForeground(new java.awt.Color(128, 128, 131));
        jLabel5.setText("Nombre del cliente:");
        jPanel3.add(jLabel5, new org.netbeans.lib.awtextra.AbsoluteConstraints(154, 30, 129, -1));

        jTNombreProyecto.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTNombreProyecto.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTNombreProyecto.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTNombreProyectoKeyReleased(evt);
            }
        });
        jPanel3.add(jTNombreProyecto, new org.netbeans.lib.awtextra.AbsoluteConstraints(409, 51, 250, 25));

        jLabel4.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel4.setForeground(new java.awt.Color(128, 128, 131));
        jLabel4.setText("Nombre del proyecto:");
        jPanel3.add(jLabel4, new org.netbeans.lib.awtextra.AbsoluteConstraints(409, 30, -1, -1));

        jButton1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/retro.png"))); // NOI18N
        jButton1.setToolTipText("");
        jButton1.setContentAreaFilled(false);
        jButton1.setFocusable(false);
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });
        jPanel3.add(jButton1, new org.netbeans.lib.awtextra.AbsoluteConstraints(1178, 12, 20, 20));

        jDFecha.setToolTipText("");
        jDFecha.setDateFormatString("dd/MM/yyyy");
        jDFecha.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jDFecha.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                jDFechaPropertyChange(evt);
            }
        });
        jPanel3.add(jDFecha, new org.netbeans.lib.awtextra.AbsoluteConstraints(680, 50, 140, -1));

        jREntrega.setBackground(new java.awt.Color(255, 255, 255));
        fechas.add(jREntrega);
        jREntrega.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jREntrega.setForeground(new java.awt.Color(128, 128, 131));
        jREntrega.setText("E");
        jREntrega.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jREntregaMouseClicked(evt);
            }
        });
        jPanel3.add(jREntrega, new org.netbeans.lib.awtextra.AbsoluteConstraints(680, 20, -1, -1));

        jRIngreso.setBackground(new java.awt.Color(255, 255, 255));
        fechas.add(jRIngreso);
        jRIngreso.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jRIngreso.setForeground(new java.awt.Color(128, 128, 131));
        jRIngreso.setText("I");
        jRIngreso.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jRIngresoMouseClicked(evt);
            }
        });
        jPanel3.add(jRIngreso, new org.netbeans.lib.awtextra.AbsoluteConstraints(730, 20, -1, -1));

        jRSalida.setBackground(new java.awt.Color(255, 255, 255));
        fechas.add(jRSalida);
        jRSalida.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jRSalida.setForeground(new java.awt.Color(128, 128, 131));
        jRSalida.setText("S");
        jRSalida.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jRSalidaMouseClicked(evt);
            }
        });
        jRSalida.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRSalidaActionPerformed(evt);
            }
        });
        jPanel3.add(jRSalida, new org.netbeans.lib.awtextra.AbsoluteConstraints(780, 20, -1, -1));

        jRnulo.setBackground(new java.awt.Color(255, 255, 255));
        fechas.add(jRnulo);
        jRnulo.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jRnulo.setForeground(new java.awt.Color(128, 128, 131));
        jRnulo.setText("null");
        jRnulo.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jRnuloMouseClicked(evt);
            }
        });
        jPanel3.add(jRnulo, new org.netbeans.lib.awtextra.AbsoluteConstraints(830, 20, -1, -1));

        btnEliminados.setText("Eliminados");
        btnEliminados.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnEliminadosActionPerformed(evt);
            }
        });
        jPanel3.add(btnEliminados, new org.netbeans.lib.awtextra.AbsoluteConstraints(1080, 50, 110, -1));

        jPanel4.add(jPanel3, new org.netbeans.lib.awtextra.AbsoluteConstraints(11, 12, 1203, 92));

        jTtipo1.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo1.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo1.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo1.setText("Tipo:");
        jPanel4.add(jTtipo1, new org.netbeans.lib.awtextra.AbsoluteConstraints(1090, 110, 60, -1));

        jTtipo3.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo3.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo3.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (3).png"))); // NOI18N
        jTtipo3.setText("Terminado");
        jPanel4.add(jTtipo3, new org.netbeans.lib.awtextra.AbsoluteConstraints(14, 100, 100, 30));

        jTtipo4.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo4.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo4.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (1).png"))); // NOI18N
        jTtipo4.setText("Pausado");
        jPanel4.add(jTtipo4, new org.netbeans.lib.awtextra.AbsoluteConstraints(110, 100, 120, 30));

        jTtipo5.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo5.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo5.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo5.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (4).png"))); // NOI18N
        jTtipo5.setText("Ejecución");
        jPanel4.add(jTtipo5, new org.netbeans.lib.awtextra.AbsoluteConstraints(220, 100, 120, 30));

        jPanel2.setBackground(new java.awt.Color(255, 255, 255));
        jPanel2.setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createTitledBorder(null, "", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 0, 11), new java.awt.Color(153, 153, 153)), "Proyecto", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 14), new java.awt.Color(204, 204, 204))); // NOI18N
        jPanel2.setLayout(new java.awt.CardLayout());

        TProyecto = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                return false; //Disallow the editing of any cell
            }
        };
        TProyecto.setAutoCreateRowSorter(true);
        TProyecto.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        TProyecto.setForeground(new java.awt.Color(128, 128, 131));
        TProyecto.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null}
            },
            new String [] {
                "Orden °N", "Registro de", "Nombre Cliente", "Nombre  Proyecto", "Fecha Ingreso", "Fecha Entrega", "Fecha Salida", "Estado", "Tipo", "FE", "TE", "IN", "Ruteo", "Antisolder"
            }
        ));
        TProyecto.setFillsViewportHeight(true);
        TProyecto.setFocusTraversalPolicyProvider(true);
        TProyecto.setGridColor(new java.awt.Color(255, 255, 255));
        TProyecto.setIntercellSpacing(new java.awt.Dimension(0, 0));
        TProyecto.setName("Proyecto"); // NOI18N
        TProyecto.setRequestFocusEnabled(false);
        TProyecto.setRowHeight(17);
        TProyecto.setSelectionBackground(new java.awt.Color(63, 179, 255));
        TProyecto.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        TProyecto.setShowHorizontalLines(false);
        TProyecto.setShowVerticalLines(false);
        TProyecto.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                TProyectoMousePressed(evt);
            }
        });
        jScrollPane2.setViewportView(TProyecto);

        jPanel2.add(jScrollPane2, "card2");

        jPanel4.add(jPanel2, new org.netbeans.lib.awtextra.AbsoluteConstraints(11, 122, 1203, 300));

        jTCantidadRegistros.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTCantidadRegistros.setForeground(new java.awt.Color(128, 128, 131));
        jTCantidadRegistros.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTCantidadRegistros.setText("1000000");
        jPanel4.add(jTCantidadRegistros, new org.netbeans.lib.awtextra.AbsoluteConstraints(1140, 417, 70, 30));

        jTCantidadRegistros1.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTCantidadRegistros1.setForeground(new java.awt.Color(128, 128, 131));
        jTCantidadRegistros1.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTCantidadRegistros1.setText("Cantidad de registros:");
        jPanel4.add(jTCantidadRegistros1, new org.netbeans.lib.awtextra.AbsoluteConstraints(965, 417, 180, 30));

        jPanel5.setBackground(new java.awt.Color(255, 255, 255));
        jPanel5.setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createTitledBorder(null, "", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 0, 11), new java.awt.Color(153, 153, 153)), "PNC", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 14), new java.awt.Color(204, 204, 204))); // NOI18N
        jPanel5.setLayout(new java.awt.CardLayout());

        TPNC = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                return false; //Disallow the editing of any cell
            }
        };
        TPNC.setAutoCreateRowSorter(true);
        TPNC.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        TPNC.setForeground(new java.awt.Color(128, 128, 131));
        TPNC.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null, null, null},
                {null, null, null, null, null, null},
                {null, null, null, null, null, null},
                {null, null, null, null, null, null}
            },
            new String [] {
                "idDetalle", "Negocio", "Tipo de negocio", "Cantidad", "Ubicación", "Estado"
            }
        ));
        TPNC.setFillsViewportHeight(true);
        TPNC.setFocusTraversalPolicyProvider(true);
        TPNC.setFocusable(false);
        TPNC.setGridColor(new java.awt.Color(255, 255, 255));
        TPNC.setIntercellSpacing(new java.awt.Dimension(0, 0));
        TPNC.setName("Detalle"); // NOI18N
        TPNC.setSelectionBackground(new java.awt.Color(63, 179, 255));
        TPNC.setShowHorizontalLines(false);
        TPNC.setShowVerticalLines(false);
        jScrollPane1.setViewportView(TPNC);

        jPanel5.add(jScrollPane1, "card2");

        jPanel4.add(jPanel5, new org.netbeans.lib.awtextra.AbsoluteConstraints(650, 440, 560, 190));

        jPanel6.setBackground(new java.awt.Color(255, 255, 255));
        jPanel6.setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createTitledBorder(null, "", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 0, 11), new java.awt.Color(153, 153, 153)), "Detalles delproyecto", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 14), new java.awt.Color(204, 204, 204))); // NOI18N
        jPanel6.setLayout(new java.awt.CardLayout());

        TDetalle = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                return false; //Disallow the editing of any cell
            }
        };
        TDetalle.setAutoCreateRowSorter(true);
        TDetalle.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        TDetalle.setForeground(new java.awt.Color(128, 128, 131));
        TDetalle.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null, null, null},
                {null, null, null, null, null, null},
                {null, null, null, null, null, null},
                {null, null, null, null, null, null}
            },
            new String [] {
                "idDetalle", "Negocio", "Tipo de negocio", "Cantidad", "Estado", "Material"
            }
        ));
        TDetalle.setFillsViewportHeight(true);
        TDetalle.setFocusTraversalPolicyProvider(true);
        TDetalle.setFocusable(false);
        TDetalle.setGridColor(new java.awt.Color(255, 255, 255));
        TDetalle.setIntercellSpacing(new java.awt.Dimension(0, 0));
        TDetalle.setName("Detalle"); // NOI18N
        TDetalle.setSelectionBackground(new java.awt.Color(63, 179, 255));
        TDetalle.setShowHorizontalLines(false);
        TDetalle.setShowVerticalLines(false);
        jScrollPane3.setViewportView(TDetalle);

        jPanel6.add(jScrollPane3, "card2");

        jPanel4.add(jPanel6, new org.netbeans.lib.awtextra.AbsoluteConstraints(10, 440, 600, 190));

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPEncabezado, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel4, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 1225, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPEncabezado, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, 633, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jButton9ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton9ActionPerformed
        this.dispose();
    }//GEN-LAST:event_jButton9ActionPerformed

    private void jButton10ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton10ActionPerformed
        setExtendedState(JFrame.CROSSHAIR_CURSOR);
    }//GEN-LAST:event_jButton10ActionPerformed

    private void jPEncabezadoMouseDragged(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPEncabezadoMouseDragged
        this.setLocation(evt.getXOnScreen() - posX, evt.getYOnScreen() - posY);
    }//GEN-LAST:event_jPEncabezadoMouseDragged

    private void jPEncabezadoMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPEncabezadoMousePressed
        posX = evt.getX();
        posY = evt.getY();
    }//GEN-LAST:event_jPEncabezadoMousePressed

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        consultarProyectos("", "", "", "", 0);
        TDetalle.setModel(new DefaultTableModel(null, encabezado1));
        TPNC.setModel(new DefaultTableModel(null, encabezado2));
        limpiarCampos();
        editarColumnasDetalle();
        editarColumnasPNC();
        jTNumerOrden.setEnabled(true);
        jTNombreCliente.setEnabled(true);
        jTNombreProyecto.setEnabled(true);
        jREntrega.setEnabled(true);
        jRSalida.setEnabled(true);
        jRIngreso.setEnabled(true);
        jTtipo.setText("");
        estado = 1;
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jTNumerOrdenKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTNumerOrdenKeyReleased
        controlBusqueda();
    }//GEN-LAST:event_jTNumerOrdenKeyReleased

    private void jTNombreClienteKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTNombreClienteKeyReleased
        controlBusqueda();
    }//GEN-LAST:event_jTNombreClienteKeyReleased

    private void jTNombreProyectoKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTNombreProyectoKeyReleased
        controlBusqueda();
    }//GEN-LAST:event_jTNombreProyectoKeyReleased

    private void jREntregaMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jREntregaMouseClicked
        jRnulo.setVisible(true);
        jDFecha.setEnabled(true);
        action();
    }//GEN-LAST:event_jREntregaMouseClicked

    private void jRIngresoMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jRIngresoMouseClicked
        jRnulo.setVisible(true);
        jDFecha.setEnabled(true);
        action();
    }//GEN-LAST:event_jRIngresoMouseClicked

    private void jRSalidaMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jRSalidaMouseClicked
        jRnulo.setVisible(true);
        jDFecha.setEnabled(true);
        action();
    }//GEN-LAST:event_jRSalidaMouseClicked

    private void jRnuloMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jRnuloMouseClicked
        jRnulo.setVisible(false);
        jDFecha.setEnabled(false);
        jDFecha.setDate(null);
        consultarProyectos(jTNumerOrden.getText(), jTNombreCliente.getText(), jTNombreProyecto.getText(), "", 0);
    }//GEN-LAST:event_jRnuloMouseClicked

    private void jDFechaPropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_jDFechaPropertyChange
        if ((jRIngreso.isSelected() || jREntrega.isSelected() || jRSalida.isSelected()) && jDFecha.getDate() != null) {
            controlBusqueda();
        }
    }//GEN-LAST:event_jDFechaPropertyChange

    private void TProyectoMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_TProyectoMousePressed
        if (TProyecto.getSelectedRow() >= 0) {
            if (evt.getClickCount() == 1) {
                if (TProyecto.getRowCount() > 0) {
                    row = TProyecto.getSelectedRow();
                    //----------------------------------------------------------
                    String valor = TProyecto.getValueAt(row, 8).toString();
                    jTtipo.setText(valor);
                    if (valor.equals("Normal")) {
                        jTtipo.setForeground(new Color(128, 128, 131));
                    } else if (valor.equals("Quick")) {
                        jTtipo.setForeground(Color.blue);
                    } else if (valor.equals("RQT")) {
                        jTtipo.setForeground(Color.ORANGE);
                    }
                    consultarDetalle(TProyecto.getValueAt(row, 0).toString());
                    //----------------------------------------------------------
                }
            }
            if (evt.getClickCount() == 2) {
                if (TProyecto.getRowCount() > 0) {
                    SimpleDateFormat fecha = new SimpleDateFormat("yyyy-MM-dd");
                    Date fechaEntrega = null;
                    proyecto obj = new proyecto(2);
                    obj.setFocusable(true);
                    try {
                        int f = TProyecto.getSelectedRow();
                        //Activar componentes
                        activarCamposproyecto(obj);
                        //Asignar valores a componentes
                        obj.jTNorden.setText(TProyecto.getValueAt(f, 0).toString());
                        obj.jTNombreCliente.setText(TProyecto.getValueAt(f, 2).toString());
                        obj.jTNombreProyecto.setText(TProyecto.getValueAt(f, 3).toString());
                        String fet[] = TProyecto.getValueAt(f, 4).toString().split(" ");
                        obj.jLIngreso.setText(fet[0]);
                        fechaEntrega = fecha.parse(TProyecto.getValueAt(f, 5).toString());
                        obj.jDentrega.setDate(fechaEntrega);
                        obj.cbTipo.setSelectedItem(TProyecto.getValueAt(f, 8).toString());
                        //Estado proyecto
                        if (TProyecto.getValueAt(f, 22).toString() != null && !TProyecto.getValueAt(f, 22).toString().equals("null")) {//Estado del proyecto
                            obj.jPEstadoProyecto.setVisible(true);
                            if (TProyecto.getValueAt(f, 22).toString().equals("A tiempo")) {
                                obj.jRATiempo.setSelected(true);
                            } else {
                                obj.jRRetraso.setSelected(true);
                            }
                            if (TProyecto.getValueAt(f, 23).toString() != null && !TProyecto.getValueAt(f, 23).toString().equals("") && !TProyecto.getValueAt(f, 23).toString().equals("null")) {
                                fechaEntrega = fecha.parse(TProyecto.getValueAt(f, 23).toString());
                                obj.jDNFEE.setDate(fechaEntrega);
                            } else {
                                obj.jDNFEE.setDate(null);
                            }
                        } else {
                            obj.jPEstadoProyecto.setVisible(false);
                        }
                        //Estado
                        obj.Notificacion1.setVisible(true);
                        if (Integer.parseInt(TProyecto.getValueAt(f, 16).toString()) == 1) {
                            obj.Notificacion1.setText(TProyecto.getValueAt(f, 7).toString());
                            if (TProyecto.getValueAt(f, 7).toString().equals("Terminado")) {
                                obj.Notificacion1.setForeground(Color.GREEN);
                                obj.btnUpdate.setEnabled(false);
                                obj.btnTomaTiempos.setVisible(true);
                                obj.GenerarQR.setEnabled(false);
                                obj.btnDelete.setEnabled(true);
                                obj.jRParada.setEnabled(false);
                            } else if (TProyecto.getValueAt(f, 7).toString().equals("Pausado")) {
                                obj.Notificacion1.setForeground(Color.ORANGE);
                                obj.btnTomaTiempos.setVisible(false);//Es false
                                obj.btnDelete.setEnabled(true);
                                obj.jRParada.setEnabled(true);
                            } else if (TProyecto.getValueAt(f, 7).toString().equals("Por iniciar")) {
                                obj.Notificacion1.setForeground(Color.GRAY);
                                obj.btnTomaTiempos.setVisible(false);//Es false
                                obj.btnDelete.setEnabled(true);
                                obj.jRParada.setEnabled(true);
                            } else if (TProyecto.getValueAt(f, 7).toString().equals("Ejecucion")) {
                                obj.Notificacion1.setForeground(Color.GRAY);
                                obj.btnTomaTiempos.setVisible(false);//Es false
                                obj.btnDelete.setEnabled(false);
                                obj.jRParada.setEnabled(true);
                            }
                            //Estado en ejecución
                            obj.jREjecucion.setSelected(true);
                        } else {
                            //Estado parado
                            obj.Notificacion1.setText("Parada");
                            obj.Notificacion1.setForeground(Color.RED);
                            obj.jREjecucion.setSelected(false);
                            obj.jREjecucion.setEnabled(true);
                            obj.jRParada.setSelected(true);
                            obj.btnUpdate.setEnabled(false);
                        }

                        //Tipos de negocios implicados
                        if (TProyecto.getValueAt(f, 9).toString().equals("true") && TProyecto.getValueAt(f, 10).toString().equals("false") && TProyecto.getValueAt(f, 11).toString().equals("false")) {
                            obj.cbNegocio.setSelectedIndex(1);
                        }
                        if (TProyecto.getValueAt(f, 9).toString().equals("false") && TProyecto.getValueAt(f, 10).toString().equals("true") && TProyecto.getValueAt(f, 11).toString().equals("false")) {
                            obj.cbNegocio.setSelectedIndex(2);
                        }
                        if (TProyecto.getValueAt(f, 9).toString().equals("false") && TProyecto.getValueAt(f, 10).toString().equals("false") && TProyecto.getValueAt(f, 11).toString().equals("true")) {
                            obj.cbNegocio.setSelectedIndex(3);
                        }
                        if (TProyecto.getValueAt(f, 9).toString().equals("true") && TProyecto.getValueAt(f, 10).toString().equals("true") && TProyecto.getValueAt(f, 11).toString().equals("false")) {
                            obj.cbNegocio.setSelectedIndex(4);
                        }
                        if (TProyecto.getValueAt(f, 9).toString().equals("true") && TProyecto.getValueAt(f, 10).toString().equals("false") && TProyecto.getValueAt(f, 11).toString().equals("true")) {
                            obj.cbNegocio.setSelectedIndex(5);
                        }
                        if (TProyecto.getValueAt(f, 9).toString().equals("true") && TProyecto.getValueAt(f, 10).toString().equals("true") && TProyecto.getValueAt(f, 11).toString().equals("true")) {
                            obj.cbNegocio.setSelectedIndex(6);
                        }
                        //RuteoC y antisolderC
                        if (TProyecto.getValueAt(f, 12).toString().equals("true")) {
                            obj.jCRuteoC.setSelected(true);
                        } else {
                            obj.jCRuteoC.setSelected(false);
                        }

                        if (TProyecto.getValueAt(f, 13).toString().equals("true")) {
                            obj.jCAntisolderC.setSelected(true);
                        } else {
                            obj.jCAntisolderC.setSelected(false);
                        }
                        //RuteoP y AntisolderP
                        if (TProyecto.getValueAt(f, 14).toString().equals("true")) {
                            obj.jCRuteoP.setSelected(true);
                        } else {
                            obj.jCRuteoP.setSelected(false);
                        }

                        if (TProyecto.getValueAt(f, 15).toString().equals("true")) {
                            obj.jCAntisolderP.setSelected(true);
                        } else {
                            obj.jCAntisolderP.setSelected(false);
                        }
                        //Limpiar labes de id de detalle
                        obj.jLIDConversor.setText("0");
                        obj.jLIDTroquel.setText("0");
                        obj.jLIDRepujado.setText("0");
                        obj.jLIDStencil.setText("0");
                        obj.jLIDPCB.setText("0");
                        obj.jLIDCircuito.setText("0");
                        obj.jLIDTeclado.setText("0");
                        obj.jLIDIntegracion.setText("0");
                        obj.jLIDPCBCOM.setText("0");
                        obj.jLIDPCBEN.setText("0");
                        obj.jLIDPCBGF.setText("0");
                        obj.jLIDCircuitoCOM.setText("0");
                        obj.jLIDCircuitoGF.setText("0");

                        obj.jRPCBCOM.setSelected(false);
                        obj.jRPIntegracion.setSelected(false);
//                        obj.disponibilidad = false;
                        
                        for (int i = 0; i < TDetalle.getRowCount(); i++) {
                            //Buscamos que detalles tiene este proyecto para enviar a la vista de proyecto
                            if (TDetalle.getValueAt(i, 2).toString().equals("Conversor")) {
                                obj.jLIDConversor.setText(TDetalle.getValueAt(i, 0).toString());
                                obj.jCConversor.setSelected(true);
                                obj.jCConversor.setEnabled(true);
                                obj.jTConversor.setEnabled(true);
                                obj.jTConversor.setText(TDetalle.getValueAt(i, 3).toString());
                            } else if (TDetalle.getValueAt(i, 2).toString().equals("Troquel")) {
                                obj.jLIDTroquel.setText(TDetalle.getValueAt(i, 0).toString());
                                obj.jCTroquel.setSelected(true);
                                obj.jCTroquel.setEnabled(true);
                                obj.jTTroquel.setEnabled(true);
                                obj.jTTroquel.setText(TDetalle.getValueAt(i, 3).toString());
                            } else if (TDetalle.getValueAt(i, 2).toString().equals("Repujado")) {
                                obj.jLIDRepujado.setText(TDetalle.getValueAt(i, 0).toString());
                                obj.jCRepujado.setSelected(true);
                                obj.jCRepujado.setEnabled(true);
                                obj.jTRepujado.setEnabled(true);
                                obj.jTRepujado.setText(TDetalle.getValueAt(i, 3).toString());
                            } else if (TDetalle.getValueAt(i, 2).toString().equals("Stencil")) {
                                obj.jLIDStencil.setText(TDetalle.getValueAt(i, 0).toString());
                                obj.jCStencil.setSelected(true);
                                obj.jCStencil.setEnabled(true);
                                obj.jTStencil.setEnabled(true);
                                obj.jTStencil.setText(TDetalle.getValueAt(i, 3).toString());
                            } else if (TDetalle.getValueAt(i, 2).toString().equals("PCB") || TDetalle.getValueAt(i, 2).toString().equals("PCB GF")) {
                                if (TDetalle.getValueAt(i, 2).toString().equals("PCB GF")) {
                                    obj.jCAntisolderP.setEnabled(false);
                                    obj.jCRuteoP.setEnabled(false);
                                    obj.jLIDPCBGF.setText(TDetalle.getValueAt(i, 0).toString());
                                } else {
                                    obj.jLIDPCB.setText(TDetalle.getValueAt(i, 0).toString());
                                    obj.jCAntisolderP.setEnabled(true);
                                    obj.jCRuteoP.setEnabled(true);
                                }
                                if (TDetalle.getValueAt(i, 4).toString().equals("Terminado") || TDetalle.getValueAt(i, 4).toString().equals("Ejecucion")) {
                                    obj.cbMaterialPCBTE.setEnabled(true);
                                    obj.cbMaterialPCBTE.setSelectedItem(TDetalle.getValueAt(i, 5).toString());
                                    obj.jCPCBTE.setEnabled(false);
                                    obj.jTPCBTE.setEditable(false);
                                    obj.jTPCBTE.setEnabled(true);
                                } else {
                                    obj.cbMaterialPCBTE.setEnabled(true);
                                    obj.cbMaterialPCBTE.setSelectedItem(TDetalle.getValueAt(i, 5).toString());
                                    obj.jCPCBTE.setEnabled(true);
                                    obj.jTPCBTE.setEnabled(true);
                                }                             
                                obj.jCPCBTE.setSelected(true);
                                obj.jTPCBTE.setText(TDetalle.getValueAt(i, 3).toString());
                                obj.jLMaterialPCB.setText(TDetalle.getValueAt(i, 5).toString());
                            } else if (TDetalle.getValueAt(i, 2).toString().equals("Circuito") && TDetalle.getValueAt(i, 1).toString().equals("EN")) {
                                obj.jLIDIntegracion.setText(TDetalle.getValueAt(i, 0).toString());
                                obj.jCIntegracion.setSelected(true);
                                obj.jCIntegracion.setEnabled(true);
                                obj.jTIntegracion.setEnabled(true);
                                obj.jTIntegracion.setText(TDetalle.getValueAt(i, 3).toString());
                            } else if (TDetalle.getValueAt(i, 2).toString().equals("Circuito-TE") && TDetalle.getValueAt(i, 1).toString().equals("EN")) {
                                obj.jLIDPCBEN.setText(TDetalle.getValueAt(i, 0).toString());
                                obj.jRPIntegracion.setSelected(true);
                            } else if (TDetalle.getValueAt(i, 2).toString().equals("Teclado") && TDetalle.getValueAt(i, 1).toString().equals("TE")) {
                                obj.jLIDTeclado.setText(TDetalle.getValueAt(i, 0).toString());
                                obj.jCTeclado.setSelected(true);
                                obj.jCTeclado.setEnabled(true);
                                obj.jTTeclado.setEnabled(true);
                                obj.jTTeclado.setText(TDetalle.getValueAt(i, 3).toString());
                            } else if ((TDetalle.getValueAt(i, 2).toString().equals("Circuito") || TDetalle.getValueAt(i, 2).toString().equals("Circuito GF")) && (TDetalle.getValueAt(i, 1).toString().equals("ALMACEN") || TDetalle.getValueAt(i, 1).toString().equals("FE"))) {
                                if (TDetalle.getValueAt(i, 2).toString().equals("Circuito GF")) {
                                    obj.jLIDCircuitoGF.setText(TDetalle.getValueAt(i, 0).toString());//Detalle de proyecto
                                } else {
                                    obj.jLIDCircuito.setText(TDetalle.getValueAt(i, 0).toString());//Detalle de proyecto
                                }
                                obj.jCRuteoC.setEnabled(true);
                                obj.jCAntisolderC.setEnabled(true);
                                obj.jCCircuito.setSelected(true);
                                obj.jCCircuito.setEnabled(true);
                                obj.jTCircuito.setEnabled(true);
                                obj.jTCircuito.setText(TDetalle.getValueAt(i, 3).toString());
                                obj.cbMaterialCircuito.setEnabled(true);
                                obj.cbMaterialCircuito.setSelectedItem(TDetalle.getValueAt(i, 5).toString());
                                obj.jLMaterialCircuito.setText(TDetalle.getValueAt(i, 5).toString());
                            } else {//Componentes del almacen

                                if (TDetalle.getValueAt(i, 2).toString().equals("Circuito COM")) {
                                    obj.jLIDCircuitoCOM.setText(TDetalle.getValueAt(i, 0).toString());//Detalle de proyecto
                                } else if (TDetalle.getValueAt(i, 2).toString().equals("PCB COM")) {
                                    obj.jRPCBCOM.setSelected(true);
                                    obj.jLIDPCBCOM.setText(TDetalle.getValueAt(i, 0).toString());//Detalle de proyecto
                                }
                            }
                        }
                        //Fechas de entrega a otros procesos.
                        if (!TProyecto.getValueAt(f, 17).toString().equals("null")) {
                            fechaEntrega = fecha.parse(TProyecto.getValueAt(f, 17).toString());//Fecha de entrega FE Circuito
                            obj.jDFechaEntregaFE.setDate(fechaEntrega);
                            obj.jDFechaEntregaFE.setVisible(true);
                            obj.jLCircuitoFE.setVisible(true);
                        }
                        if (!TProyecto.getValueAt(f, 18).toString().equals("null")) {
                            fechaEntrega = fecha.parse(TProyecto.getValueAt(f, 18).toString());//Fecha de entrega COM Circuito
                            obj.jDFechaEntregaFECOM.setDate(fechaEntrega);
                            obj.jDFechaEntregaFECOM.setVisible(true);
                            obj.jLComCircuitos.setVisible(true);
                        }

                        if (!TProyecto.getValueAt(f, 19).toString().equals("null")) {
                            fechaEntrega = fecha.parse(TProyecto.getValueAt(f, 19).toString());//Fecha de entrega PCB GF
                            obj.jDFechaEntregaPCBGF.setDate(fechaEntrega);
                            obj.jDFechaEntregaPCBGF.setVisible(true);
                            obj.jLCircuitoGF.setVisible(true);
                        }

                        if (!TProyecto.getValueAt(f, 20).toString().equals("null")) {
                            fechaEntrega = fecha.parse(TProyecto.getValueAt(f, 20).toString());//Fecha de entrega COM GF
                            obj.jDFechaEntregaPCBCOMGF.setDate(fechaEntrega);
                            obj.jDFechaEntregaPCBCOMGF.setVisible(true);
                            obj.jLpcbGF.setVisible(true);
                        }
                        //Validación de edición
                        validarEdiciones(obj);
                        //
                        obj.jScrollPane1.setVisible(true);
                        obj.jLNovedades.setVisible(true);
                        obj.jTNovedades.setVisible(true);
                        obj.jLNCaracteres.setVisible(true);
                        //texto de novedades del proyecto
                        if(!TProyecto.getValueAt(f, 21).toString().equals("null")){
                           obj.jTNovedades.setText(TProyecto.getValueAt(f, 21).toString());//Mensaje de alguna novedad 
                        }else{
                            obj.jTNovedades.setText("");//Mensaje de alguna novedad
                        }
                        obj.jLNCaracteres.setText(String.valueOf(250 - TProyecto.getValueAt(f, 21).toString().length()));//Cantidad de caracteres.

                        this.dispose();
                    } catch (Exception e) {
                        //Si se genera algun error a la hora del paso de informacion a la vista
                        JOptionPane.showMessageDialog(null, "Error! " + e);
                    }
                }
            }
        }
    }//GEN-LAST:event_TProyectoMousePressed

    //Este procedimiento va a permitir saber que proyectos se pueden modificar y cuales no
    private void validarEdiciones(proyecto obj) {
        //Componentes del almacen
        for (int i = 0; i < TDetalle.getRowCount(); i++) {
            if (TDetalle.getValueAt(i, 1).toString().equals("FE") && TDetalle.getValueAt(i, 2).toString().equals("Conversor")) {
                //Se valida el estado del Conversor de FE 
                estadoModificacion(i, obj.jCConversor, obj.jTConversor);
            } else {
                if (TDetalle.getValueAt(i, 1).toString().equals("FE") && TDetalle.getValueAt(i, 2).toString().equals("Troquel")) {
                    //Se valida el estado del Troquel de FE 
                    estadoModificacion(i, obj.jCTroquel, obj.jTTroquel);
                } else {
                    if (TDetalle.getValueAt(i, 1).toString().equals("FE") && TDetalle.getValueAt(i, 2).toString().equals("Repujado")) {
                        //Se valida el estado del Repujado de FE 
                        estadoModificacion(i, obj.jCRepujado, obj.jTRepujado);
                    } else {
                        if (TDetalle.getValueAt(i, 1).toString().equals("FE") && TDetalle.getValueAt(i, 2).toString().equals("Stencil")) {
                            //Se valida el estado del Stencil de FE 
                            estadoModificacion(i, obj.jCStencil, obj.jTStencil);
                        } else {
                            if (TDetalle.getValueAt(i, 1).toString().equals("FE") && TDetalle.getValueAt(i, 2).toString().equals("Circuito")) {
                                //Se valida el estado del Circuito de FE 
                                estadoModificacion(i, obj.jCCircuito, obj.jTCircuito);

                            } else {
                                if ((TDetalle.getValueAt(i, 1).toString().equals("FE") || TDetalle.getValueAt(i, 1).toString().equals("ALMACEN")) && (TDetalle.getValueAt(i, 2).toString().equals("PCB") || TDetalle.getValueAt(i, 2).toString().equals("PCB GF") || TDetalle.getValueAt(i, 2).toString().equals("PCB COM"))) {
                                    //Se valida el estado del PCB de FE 
                                    if (TDetalle.getValueAt(i, 2).toString().equals("PCB COM")) {
                                        if (TDetalle.getValueAt(i, 4).toString().equals("Terminado")) {
                                            obj.jRPCBCOM.setEnabled(false);
                                        } else {
                                            obj.jRPCBCOM.setEnabled(true);
                                        }
                                    }
                                } else {
                                    if (TDetalle.getValueAt(i, 1).toString().equals("TE") && TDetalle.getValueAt(i, 2).toString().equals("Teclado")) {
                                        //Se valida el estado del Teclado de TE 
                                        estadoModificacion(i, obj.jCTeclado, obj.jTTeclado);
                                    } else {
                                        if (TDetalle.getValueAt(i, 1).toString().equals("IN") && TDetalle.getValueAt(i, 2).toString().equals("Circuito")) {
                                            //Se valida el estado del Circuito de IN 
                                            estadoModificacion(i, obj.jCIntegracion, obj.jTIntegracion);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        if (count == 0) {
            //Permite editar el tipo de negocío.
            obj.cbNegocio.setEnabled(true);
        } else {
            //No permiti editar el tipo de negocío.
            obj.cbNegocio.setEnabled(false);
        }
    }

    private void estadoModificacion(int row, JCheckBox check, TextFieldRoundBackground text) {
        if (TDetalle.getValueAt(row, 4).toString().equals("Terminado") || TDetalle.getValueAt(row, 4).toString().equals("Ejecucion") || TDetalle.getValueAt(row, 4).toString().equals("Pausado")) {
            //No se permitira modificar nada del conversor
            check.setEnabled(false);
            text.setEditable(false);
            count++;
        } else {
            check.setEnabled(true);
            text.setEditable(true);
        }
    }

    private void jRSalidaActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRSalidaActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jRSalidaActionPerformed

    private void btnEliminadosActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnEliminadosActionPerformed
        //Arreglar el boton de consultar eliminados------------------------------------------>
        consultarProyectos("", "", "", "", 1);
        TDetalle.setModel(new DefaultTableModel(null, encabezado1));
        TPNC.setModel(new DefaultTableModel(null, encabezado2));
        limpiarCampos() ;
        editarColumnasDetalle();
        editarColumnasPNC();
        jTNumerOrden.setEnabled(false);
        jTNombreCliente.setEnabled(false);
        jTNombreProyecto.setEnabled(false);
        jREntrega.setEnabled(false);
        jRSalida.setEnabled(false);
        jRIngreso.setEnabled(false);
        jTtipo.setText("");
        estado = 0;
        //------------------------------------------------------------------------------------>
    }//GEN-LAST:event_btnEliminadosActionPerformed

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
            java.util.logging.Logger.getLogger(ConsutaProyecto.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(ConsutaProyecto.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(ConsutaProyecto.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(ConsutaProyecto.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new ConsutaProyecto().setVisible(true);
            }
        });
    }
//Metodos---------------------------------------------------------------------->
    private void activarCamposproyecto(proyecto obj) {
        obj.btnNuevo.setEnabled(true);
        obj.jTNombreCliente.setEnabled(true);
        obj.jTNombreProyecto.setEnabled(true);
        obj.jDentrega.setEnabled(true);
        obj.cbNegocio.setEnabled(true);
        obj.cbTipo.setEnabled(true);
        obj.jTIntegracion.setEnabled(true);
        obj.jPInformacion.setBackground(new Color(255, 255, 255));
        obj.jPDetalles1.setBackground(new Color(255, 255, 255));
        obj.jPDetalles.setBackground(new Color(255, 255, 255));
        if (estado == 1) {//Activo
            obj.btnDelete.setEnabled(true);
            obj.btnDelete.setVisible(true);
            obj.btnActivar.setVisible(false);
            obj.GenerarQR.setEnabled(true);
            obj.btnUpdate.setEnabled(true);
        } else {//Eliminado
            obj.btnActivar.setEnabled(true);
            obj.btnDelete.setVisible(false);
            obj.btnActivar.setVisible(true);
            obj.GenerarQR.setEnabled(false);
            obj.btnUpdate.setEnabled(false);
        }
    }

//Se valida que si se pueda ejecutar la consulta sin tener ningun problema
    private void action() {
        if ((jRIngreso.isSelected() || jREntrega.isSelected() || jRSalida.isSelected()) && jDFecha.getDate() != null) {
            controlBusqueda();
        }
    }

    private void controlBusqueda() {
        String fecha = "";
        if (jDFecha.getDate() != null) {
            DateFormat formato = new SimpleDateFormat("YYYY-MM-dd");
            fecha = formato.format(jDFecha.getDate());
        }
        consultarProyectos(jTNumerOrden.getText(), jTNombreCliente.getText(), jTNombreProyecto.getText(), fecha, 0);
    }

    private void consultarProyectos(String numerOrden, String nombrecliente, String nombreProyecto, String fecha, int eliminados) {
        Controlador.Proyecto obj = new Controlador.Proyecto();
        if (eliminados == 1) {
            //Estan eliminados
            crs = obj.consultar_ProyectoEliminados();
        } else {
            if (!numerOrden.equals("")) {
                obj.setIdOrden(Integer.parseInt(numerOrden));
            } else {
                obj.setIdOrden(0);
            }
            obj.setNombreCliente(nombrecliente);
            obj.setNombreProyecto(nombreProyecto);
            obj.setFecha(fecha);
            String tipo = "";
            if (jRIngreso.isSelected()) {
                tipo = "Ingreso";
            } else if (jREntrega.isSelected()) {
                tipo = "Entrega";
            } else if (jRSalida.isSelected()) {
                tipo = "Salida";
            }
            //No estan eliminados
            crs = obj.consultar_Proyecto(tipo);
        }
        try {
            String v[] = {"N° Orden", "Registro de", "Nombre Cliente", "Nombre Proyecto", "Fecha Ingreso", "Fecha Entrega", "Fecha Salida", "Estado", "Tipo", "FE", "TE", "IN", "RuteoC", "AntisolderC", "RuteoP", "AntisolderP", "Parada", "Fecha1", "Fecha2", "Fecha3", "Fecha4", "Novedad", "EstadoProyec", "NFEE"};
            DefaultTableModel model = new DefaultTableModel(null, v);
            String v1[] = new String[24];
            while (crs.next()) {
                cantidadRegistros++;
                v1[0] = String.valueOf(crs.getInt(1));
                v1[1] = crs.getString(2);
                v1[2] = crs.getString(3);
                v1[3] = crs.getString(4);
                v1[4] = crs.getString(5);
                v1[5] = crs.getString(6);
                v1[6] = crs.getString(7);
                if (crs.getBoolean(17)) {
                    v1[7] = crs.getString(8);//Estado
                } else {
                    v1[7] = "Parada";//Estado
                }
                v1[8] = crs.getString(9);
                v1[9] = String.valueOf(crs.getBoolean(10));
                v1[10] = String.valueOf(crs.getBoolean(11));
                v1[11] = String.valueOf(crs.getBoolean(12));
                v1[12] = String.valueOf(crs.getBoolean(13));
                v1[13] = String.valueOf(crs.getBoolean(14));
                v1[14] = String.valueOf(crs.getBoolean(15));
                v1[15] = String.valueOf(crs.getBoolean(16));
                v1[16] = String.valueOf(crs.getBoolean(17) ? 1 : 0);
                v1[17] = String.valueOf(crs.getString(18));//Fecha1
                v1[18] = String.valueOf(crs.getString(19));//Fecha2
                v1[19] = String.valueOf(crs.getString(20));//Fecha3
                v1[20] = String.valueOf(crs.getString(21));//Fecha4
                v1[21] = String.valueOf(crs.getString(22));//Novedad
                v1[22] = String.valueOf(crs.getString(23));//Estado Proyecto
                v1[23] = String.valueOf(crs.getString(24));//NFEE
                model.addRow(v1);
            }
            //Cantidad de registros
            jTCantidadRegistros.setText(String.valueOf(cantidadRegistros));
            cantidadRegistros = 0;
            crs.close();
            TProyecto.setModel(model);
            editarColumnasProyecto();
            FormatoTabla ftProyect = new FormatoTabla(7);
            TProyecto.setDefaultRenderer(Object.class, ftProyect);
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "¡Error! " + e);
        }
    }

    private void consultarDetalle(String numerOrden) {
        DetalleProyecto obj = new DetalleProyecto();
        try {
            crs = obj.consultar_Detalle_Proyecto(numerOrden, 0);
            DefaultTableModel model1 = new DefaultTableModel(null, encabezado1);
            DefaultTableModel model2 = new DefaultTableModel(null, encabezado2);
            String v1[] = new String[6];
            String v2[] = new String[6];
            while (crs.next()) {
                if (crs.getBoolean(6)) {
                    //PNC del proyecto
                    v2[0] = String.valueOf(crs.getInt(1));//idDetalle
                    v2[1] = crs.getString(2).equals("IN") ? "EN" : crs.getString(2);//Negocio
                    v2[2] = crs.getString(3);//Tipo negocio
                    v2[3] = crs.getString(4);//Cantidad
                    v2[4] = crs.getString(7);//Ubicacion del PNC
                    if (TProyecto.getValueAt(row, 16).toString().equals("1")) {
                        v2[5] = crs.getString(5);//Estado
                    } else {
                        v2[5] = "Parada";//Estado
                    }
                    model2.addRow(v2);
                } else {
                    //Detalle del proyecto
                    v1[0] = String.valueOf(crs.getInt(1));//idDetalle
                    v1[1] = crs.getString(2).equals("IN") ? "EN" : crs.getString(2);//Negocio
                    v1[2] = crs.getString(3);//Tipo negocio
                    v1[3] = crs.getString(4);//Cantidad
                    if (TProyecto.getValueAt(row, 16).toString().equals("1")) {
                        v1[4] = crs.getString(5);//Estado
                    } else {
                        v1[4] = "Parada";//Estado
                    }
                    v1[5] = crs.getString(8);//Material
                    model1.addRow(v1);
                }
            }
            crs.close();
            TDetalle.setModel(model1);
            editarColumnasDetalle();
            TPNC.setModel(model2);
            editarColumnasPNC();
            FormatoTabla ft = new FormatoTabla(4);
            TDetalle.setDefaultRenderer(Object.class, ft);
            FormatoTabla ftP = new FormatoTabla(5);
            TPNC.setDefaultRenderer(Object.class, ftP);
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error! " + e);
        }
    }

    private void limpiarCampos() {
        jTNumerOrden.setText("");
        jTNombreCliente.setText("");
        jTNombreProyecto.setText("");
        jDFecha.setDate(null);
        jDFecha.setEnabled(false);
        jRnulo.setSelected(true);
        jRnulo.setVisible(false);
    }

    private void editarColumnasDetalle() {
        TDetalle.getColumnModel().getColumn(0).setMinWidth(58);
        TDetalle.getColumnModel().getColumn(0).setMaxWidth(58);
        TDetalle.getTableHeader().getColumnModel().getColumn(0).setMaxWidth(58);
        TDetalle.getTableHeader().getColumnModel().getColumn(0).setMinWidth(58);
        TDetalle.getColumnModel().getColumn(1).setMinWidth(70);
        TDetalle.getColumnModel().getColumn(1).setMaxWidth(70);
        TDetalle.getTableHeader().getColumnModel().getColumn(1).setMaxWidth(70);
        TDetalle.getTableHeader().getColumnModel().getColumn(1).setMinWidth(70);
        TDetalle.getColumnModel().getColumn(2).setMinWidth(250);
        TDetalle.getColumnModel().getColumn(2).setMaxWidth(250);
        TDetalle.getTableHeader().getColumnModel().getColumn(2).setMaxWidth(250);
        TDetalle.getTableHeader().getColumnModel().getColumn(2).setMinWidth(250);
        TDetalle.getColumnModel().getColumn(3).setMinWidth(100);
        TDetalle.getColumnModel().getColumn(3).setMaxWidth(100);
        TDetalle.getTableHeader().getColumnModel().getColumn(3).setMaxWidth(100);
        TDetalle.getTableHeader().getColumnModel().getColumn(3).setMinWidth(100);
        TDetalle.getColumnModel().getColumn(4).setMinWidth(113);
        TDetalle.getColumnModel().getColumn(4).setMaxWidth(113);
        TDetalle.getTableHeader().getColumnModel().getColumn(4).setMaxWidth(113);
        TDetalle.getTableHeader().getColumnModel().getColumn(4).setMinWidth(113);
        TDetalle.getColumnModel().getColumn(5).setMinWidth(0);
        TDetalle.getColumnModel().getColumn(5).setMaxWidth(0);
        TDetalle.getTableHeader().getColumnModel().getColumn(5).setMaxWidth(0);
        TDetalle.getTableHeader().getColumnModel().getColumn(5).setMinWidth(0);
    }

    private void editarColumnasPNC() {
        TPNC.getColumnModel().getColumn(0).setMinWidth(58);
        TPNC.getColumnModel().getColumn(0).setMaxWidth(58);
        TPNC.getTableHeader().getColumnModel().getColumn(0).setMaxWidth(58);
        TPNC.getTableHeader().getColumnModel().getColumn(0).setMinWidth(58);
        TPNC.getColumnModel().getColumn(1).setMinWidth(100);
        TPNC.getColumnModel().getColumn(1).setMaxWidth(100);
        TPNC.getTableHeader().getColumnModel().getColumn(1).setMaxWidth(100);
        TPNC.getTableHeader().getColumnModel().getColumn(1).setMinWidth(100);
        TPNC.getColumnModel().getColumn(2).setMinWidth(100);
        TPNC.getColumnModel().getColumn(2).setMaxWidth(100);
        TPNC.getTableHeader().getColumnModel().getColumn(2).setMaxWidth(100);
        TPNC.getTableHeader().getColumnModel().getColumn(2).setMinWidth(100);
        TPNC.getColumnModel().getColumn(3).setMinWidth(100);
        TPNC.getColumnModel().getColumn(3).setMaxWidth(100);
        TPNC.getTableHeader().getColumnModel().getColumn(3).setMaxWidth(100);
        TPNC.getTableHeader().getColumnModel().getColumn(3).setMinWidth(100);
        TPNC.getColumnModel().getColumn(4).setMinWidth(100);
        TPNC.getColumnModel().getColumn(4).setMaxWidth(100);
        TPNC.getTableHeader().getColumnModel().getColumn(4).setMaxWidth(100);
        TPNC.getTableHeader().getColumnModel().getColumn(4).setMinWidth(100);
        TPNC.getColumnModel().getColumn(5).setMinWidth(100);
        TPNC.getColumnModel().getColumn(5).setMaxWidth(100);
        TPNC.getTableHeader().getColumnModel().getColumn(5).setMaxWidth(100);
        TPNC.getTableHeader().getColumnModel().getColumn(5).setMinWidth(100);
    }

    private void editarColumnasProyecto() {
        TProyecto.getColumnModel().getColumn(0).setMinWidth(75);
        TProyecto.getColumnModel().getColumn(0).setMaxWidth(75);
        TProyecto.getTableHeader().getColumnModel().getColumn(0).setMaxWidth(75);
        TProyecto.getTableHeader().getColumnModel().getColumn(0).setMinWidth(75);
        TProyecto.getColumnModel().getColumn(1).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(1).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(1).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(1).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(2).setMinWidth(255);
        TProyecto.getColumnModel().getColumn(2).setMaxWidth(255);
        TProyecto.getTableHeader().getColumnModel().getColumn(2).setMaxWidth(255);
        TProyecto.getTableHeader().getColumnModel().getColumn(2).setMinWidth(255);
        TProyecto.getColumnModel().getColumn(3).setMinWidth(315);
        TProyecto.getColumnModel().getColumn(3).setMaxWidth(315);
        TProyecto.getTableHeader().getColumnModel().getColumn(3).setMaxWidth(315);
        TProyecto.getTableHeader().getColumnModel().getColumn(3).setMinWidth(315);
        TProyecto.getColumnModel().getColumn(4).setMinWidth(185);
        TProyecto.getColumnModel().getColumn(4).setMaxWidth(185);
        TProyecto.getTableHeader().getColumnModel().getColumn(4).setMaxWidth(185);
        TProyecto.getTableHeader().getColumnModel().getColumn(4).setMinWidth(185);
        TProyecto.getColumnModel().getColumn(5).setMinWidth(95);
        TProyecto.getColumnModel().getColumn(5).setMaxWidth(95);
        TProyecto.getTableHeader().getColumnModel().getColumn(5).setMaxWidth(95);
        TProyecto.getTableHeader().getColumnModel().getColumn(5).setMinWidth(95);
        TProyecto.getColumnModel().getColumn(6).setMinWidth(185);
        TProyecto.getColumnModel().getColumn(6).setMaxWidth(185);
        TProyecto.getTableHeader().getColumnModel().getColumn(6).setMaxWidth(185);
        TProyecto.getTableHeader().getColumnModel().getColumn(6).setMinWidth(185);
        TProyecto.getColumnModel().getColumn(7).setMinWidth(82);
        TProyecto.getColumnModel().getColumn(7).setMaxWidth(82);
        TProyecto.getTableHeader().getColumnModel().getColumn(7).setMaxWidth(82);
        TProyecto.getTableHeader().getColumnModel().getColumn(7).setMinWidth(82);
        TProyecto.getColumnModel().getColumn(8).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(8).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(8).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(8).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(9).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(9).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(9).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(9).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(10).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(10).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(10).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(10).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(11).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(11).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(11).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(11).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(12).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(12).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(12).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(12).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(13).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(13).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(13).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(13).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(14).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(14).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(14).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(14).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(15).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(15).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(15).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(15).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(16).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(16).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(16).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(16).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(17).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(17).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(17).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(17).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(18).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(18).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(18).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(18).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(19).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(19).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(19).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(19).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(20).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(20).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(20).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(20).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(21).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(21).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(21).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(21).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(22).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(22).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(22).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(22).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(23).setMinWidth(0);
        TProyecto.getColumnModel().getColumn(23).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(23).setMaxWidth(0);
        TProyecto.getTableHeader().getColumnModel().getColumn(23).setMinWidth(0);
    }

//Metodo de finalizacion de clase---------------------------------------------->
    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JTable TDetalle;
    private javax.swing.JTable TPNC;
    private javax.swing.JTable TProyecto;
    public static elaprendiz.gui.button.ButtonColoredAction btnEliminados;
    private javax.swing.ButtonGroup fechas;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton10;
    private javax.swing.JButton jButton9;
    private com.toedter.calendar.JDateChooser jDFecha;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JPanel jPEncabezado;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JRadioButton jREntrega;
    private javax.swing.JRadioButton jRIngreso;
    private javax.swing.JRadioButton jRSalida;
    private javax.swing.JRadioButton jRnulo;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JLabel jTCantidadRegistros;
    private javax.swing.JLabel jTCantidadRegistros1;
    private elaprendiz.gui.textField.TextFieldRoundBackground jTNombreCliente;
    private elaprendiz.gui.textField.TextFieldRoundBackground jTNombreProyecto;
    private elaprendiz.gui.textField.TextFieldRoundBackground jTNumerOrden;
    private javax.swing.JLabel jTtipo;
    private javax.swing.JLabel jTtipo1;
    private javax.swing.JLabel jTtipo2;
    private javax.swing.JLabel jTtipo3;
    private javax.swing.JLabel jTtipo4;
    private javax.swing.JLabel jTtipo5;
    // End of variables declaration//GEN-END:variables
}
