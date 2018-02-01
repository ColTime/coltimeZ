package reportefe;

import java.awt.Color;
import java.awt.Component;
import javax.swing.JTable;
import javax.swing.table.TableCellRenderer;

public class MyRender extends JTable {
    //Variables
    int subProceso=5,proceso=6;
    
    @Override
    public Component prepareRenderer(TableCellRenderer renderer, int row, int column) {
        Component cell = super.prepareRenderer(renderer, row, column);
        cell.setBackground(Color.white);
        cell.setForeground(Color.BLACK);
        if (getValueAt(row, column) != null && column == 0 && (Object.class.equals(this.getColumnClass(column)))) {
            if (getValueAt(row, column).getClass().equals(String.class)) {
                String valor = String.valueOf(getValueAt(row, 2));
                this.setSelectionForeground(Color.red);
                if (valor.equals("Normal")) {
                    cell.setBackground(Color.white);
                    cell.setForeground(Color.BLACK);
                } else if (valor.equals("Quick")) {
                    cell.setBackground(Color.BLUE);
                    cell.setForeground(Color.WHITE);
                } else if (valor.equals("RQT")) {
                    cell.setBackground(Color.PINK);
                    cell.setForeground(Color.BLACK);
                }
            }
        }

        if (column > 5) {
            for (int i = 0; i < 10; i++) {
                if (column == proceso) {
                    //------------------------------------------------------
                    switch (getValueAt(row, subProceso).toString()) {
                        case "-1":
                            cell.setBackground(Color.GRAY);
                            break;
                        case "1":
                            cell.setBackground(Color.WHITE);
                            break;
                        case "2":
                            cell.setBackground(Color.RED);
                            break;
                        case "3":
                            cell.setBackground(Color.GREEN);
                            break;
                        case "4":
                            cell.setBackground(Color.ORANGE);
                            break;
                    }
                    //------------------------------------------------------
                }
                subProceso+=2;
                proceso+=2;
                break;
            }
//            if (column == 6) {
//                //------------------------------------------------------
//                switch (getValueAt(row, 5).toString()) {
//                    case "-1":
//                        cell.setBackground(Color.GRAY);
//                        break;
//                    case "1":
//                        cell.setBackground(Color.WHITE);
//                        break;
//                    case "2":
//                        cell.setBackground(Color.RED);
//                        break;
//                    case "3":
//                        cell.setBackground(Color.GREEN);
//                        break;
//                    case "4":
//                        cell.setBackground(Color.ORANGE);
//                        break;
//                }
//                //------------------------------------------------------
//            } else if (column == 8) {
//                //------------------------------------------------------
//                switch (getValueAt(row, 7).toString()) {
//                    case "-1":
//                        cell.setBackground(Color.GRAY);
//                        break;
//                    case "1":
//                        cell.setBackground(Color.WHITE);
//                        break;
//                    case "2":
//                        cell.setBackground(Color.RED);
//                        break;
//                    case "3":
//                        cell.setBackground(Color.GREEN);
//                        break;
//                    case "4":
//                        cell.setBackground(Color.ORANGE);
//                        break;
//                }
//                //------------------------------------------------------
//            } else if (column == 10) {
//                //------------------------------------------------------
//                switch (getValueAt(row, 9).toString()) {
//                    case "-1":
//                        cell.setBackground(Color.GRAY);
//                        break;
//                    case "1":
//                        cell.setBackground(Color.WHITE);
//                        break;
//                    case "2":
//                        cell.setBackground(Color.RED);
//                        break;
//                    case "3":
//                        cell.setBackground(Color.GREEN);
//                        break;
//                    case "4":
//                        cell.setBackground(Color.ORANGE);
//                        break;
//                }
//                //------------------------------------------------------
//            } else if (column == 12) {
//
//                //------------------------------------------------------
//                switch (getValueAt(row, 11).toString()) {
//                    case "-1":
//                        cell.setBackground(Color.GRAY);
//                        break;
//                    case "1":
//                        cell.setBackground(Color.WHITE);
//                        break;
//                    case "2":
//                        cell.setBackground(Color.RED);
//                        break;
//                    case "3":
//                        cell.setBackground(Color.GREEN);
//                        break;
//                    case "4":
//                        cell.setBackground(Color.ORANGE);
//                        break;
//                }
//                //------------------------------------------------------
//            } else if (column == 14) {
//                //------------------------------------------------------
//                switch (getValueAt(row, 13).toString()) {
//                    case "-1":
//                        cell.setBackground(Color.GRAY);
//                        break;
//                    case "1":
//                        cell.setBackground(Color.WHITE);
//                        break;
//                    case "2":
//                        cell.setBackground(Color.RED);
//                        break;
//                    case "3":
//                        cell.setBackground(Color.GREEN);
//                        break;
//                    case "4":
//                        cell.setBackground(Color.ORANGE);
//                        break;
//                }
//                //------------------------------------------------------
//            } else if (column == 16) {
//                //------------------------------------------------------
//                switch (getValueAt(row, 15).toString()) {
//                    case "-1":
//                        cell.setBackground(Color.GRAY);
//                        break;
//                    case "1":
//                        cell.setBackground(Color.WHITE);
//                        break;
//                    case "2":
//                        cell.setBackground(Color.RED);
//                        break;
//                    case "3":
//                        cell.setBackground(Color.GREEN);
//                        break;
//                    case "4":
//                        cell.setBackground(Color.ORANGE);
//                        break;
//                }
//                //------------------------------------------------------
//            } else if (column == 18) {
//                //------------------------------------------------------
//                switch (getValueAt(row, 17).toString()) {
//                    case "-1":
//                        cell.setBackground(Color.GRAY);
//                        break;
//                    case "1":
//                        cell.setBackground(Color.WHITE);
//                        break;
//                    case "2":
//                        cell.setBackground(Color.RED);
//                        break;
//                    case "3":
//                        cell.setBackground(Color.GREEN);
//                        break;
//                    case "4":
//                        cell.setBackground(Color.ORANGE);
//                        break;
//                }
//                //------------------------------------------------------
//            } else if (column == 20) {
//                //------------------------------------------------------
//                switch (getValueAt(row, 19).toString()) {
//                    case "-1":
//                        cell.setBackground(Color.GRAY);
//                        break;
//                    case "1":
//                        cell.setBackground(Color.WHITE);
//                        break;
//                    case "2":
//                        cell.setBackground(Color.RED);
//                        break;
//                    case "3":
//                        cell.setBackground(Color.GREEN);
//                        break;
//                    case "4":
//                        cell.setBackground(Color.ORANGE);
//                        break;
//                }
//                //------------------------------------------------------
//            } else if (column == 22) {
//                //------------------------------------------------------
//                switch (getValueAt(row, 21).toString()) {
//                    case "-1":
//                        cell.setBackground(Color.GRAY);
//                        break;
//                    case "1":
//                        cell.setBackground(Color.WHITE);
//                        break;
//                    case "2":
//                        cell.setBackground(Color.RED);
//                        break;
//                    case "3":
//                        cell.setBackground(Color.GREEN);
//                        break;
//                    case "4":
//                        cell.setBackground(Color.ORANGE);
//                        break;
//                }
//                //------------------------------------------------------
//            } else if (column == 24) {
//                //------------------------------------------------------
//                switch (getValueAt(row, 23).toString()) {
//                    case "-1":
//                        cell.setBackground(Color.GRAY);
//                        break;
//                    case "1":
//                        cell.setBackground(Color.WHITE);
//                        break;
//                    case "2":
//                        cell.setBackground(Color.RED);
//                        break;
//                    case "3":
//                        cell.setBackground(Color.GREEN);
//                        break;
//                    case "4":
//                        cell.setBackground(Color.ORANGE);
//                        break;
//                }
//                //------------------------------------------------------
//            }
        }
        return cell; //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public boolean isCellEditable(int row, int column) {
        return false; //To change body of generated methods, choose Tools | Templates.
    }

}
