package Controlador;

import java.awt.Color;
import java.awt.Component;
import java.awt.Font;
import javax.swing.JTable;
import javax.swing.table.DefaultTableCellRenderer;

public class TablaRenderUsuario extends DefaultTableCellRenderer {

    @Override
    public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
        setForeground(Color.BLACK);
        if (table.getValueAt(row, 6).toString().equals("Activo")) {
            if (table.getValueAt(row, 8).toString().equals("1")) {
                setBackground(Color.GREEN);
            } else {
                setBackground(Color.WHITE);
            }
        } else if (table.getValueAt(row, 6).toString().equals("Inactivo")) {
            setBackground(Color.RED);
        }
        table.getTableHeader().setFont(new Font("Arial", 1, 16));
        
        super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column); //To change body of generated methods, choose Tools | Templates.
        return this;
    }

}
