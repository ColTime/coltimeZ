package reportegenerarcoltime;

import java.awt.Color;
import java.awt.Component;
import java.awt.Font;
import javax.swing.JTable;
import javax.swing.SwingConstants;
import javax.swing.table.DefaultTableCellRenderer;

public class Render extends DefaultTableCellRenderer {

    @Override
    public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
        //Color por defecto
        setForeground(Color.BLACK);
        setBackground(Color.WHITE);
        //Celdas de la tabla
        if (table.getValueAt(row, 10).toString().equals("true")) {//No esta parada
            if (table.getValueAt(row, 8).toString().equals("A tiempo")) {
                setBackground(Color.GREEN);
            } else if (table.getValueAt(row, 8).toString().equals("Retraso")) {
                setBackground(new Color(255, 132, 8));//Naranjado
            } else if (table.getValueAt(row, 8).toString().equals("Por iniciar")) {
                setBackground(Color.WHITE);
            }
        } else {//esta parada
            setBackground(Color.RED);//Estado parada
        }
        //Header de la tabla
        table.getTableHeader().setFont(new Font("Arial", 1, 20));
        table.getTableHeader().setBackground(Color.WHITE);
        //Centrar texto de las celdas
        this.setHorizontalAlignment(SwingConstants.CENTER);
        super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column);

        return this; //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
