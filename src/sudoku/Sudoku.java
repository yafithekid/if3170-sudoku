/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import java.io.FileReader;
import java.util.Scanner;
import jess.JessException;
import jess.Rete;
/**
 *
 * @author yafithekid
 */
public class Sudoku {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            Rete env = new Rete();
            env.eval("(open \"test.txt\" out \"w\")");
            env.clear();
            env.batch("sudoku.clp");
            env.batch("solve.clp");
            env.batch("output-frills.clp");
            env.batch("grid3x3-p1.clp");
            env.reset();
            env.run();
            env.eval("(close out)");
        } catch (JessException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
        }
        FileReader fr;
        try {
            fr = new FileReader("test.txt");
            Scanner sc = new Scanner(fr);
            while (sc.hasNext()){
                System.out.println(sc.next());
            }
        } catch (Exception e){
        }
        
    }
    
}
