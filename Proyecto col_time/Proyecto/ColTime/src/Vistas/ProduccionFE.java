
package Vistas;


public class ProduccionFE extends javax.swing.JPanel {


    public ProduccionFE() {
        initComponents();
    }
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jScrollPane1 = new javax.swing.JScrollPane();
        contenidoFE = new javax.swing.JPanel();

        setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(153, 153, 153)));
        setName("FE"); // NOI18N

        jScrollPane1.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
        jScrollPane1.setPreferredSize(new java.awt.Dimension(1094, 300));

        contenidoFE.setBackground(new java.awt.Color(255, 255, 255));
        contenidoFE.setMaximumSize(new java.awt.Dimension(40000, 40000));
        contenidoFE.setPreferredSize(new java.awt.Dimension(0, 500));

        javax.swing.GroupLayout contenidoFELayout = new javax.swing.GroupLayout(contenidoFE);
        contenidoFE.setLayout(contenidoFELayout);
        contenidoFELayout.setHorizontalGroup(
            contenidoFELayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 0, Short.MAX_VALUE)
        );
        contenidoFELayout.setVerticalGroup(
            contenidoFELayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 529, Short.MAX_VALUE)
        );

        jScrollPane1.setViewportView(contenidoFE);
        contenidoFE.getAccessibleContext().setAccessibleParent(contenidoFE);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 1106, Short.MAX_VALUE)
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 531, Short.MAX_VALUE)
                .addContainerGap())
        );
    }// </editor-fold>//GEN-END:initComponents


    // Variables declaration - do not modify//GEN-BEGIN:variables
    public static javax.swing.JPanel contenidoFE;
    public static javax.swing.JScrollPane jScrollPane1;
    // End of variables declaration//GEN-END:variables
 @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
}
