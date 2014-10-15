package sudoku;
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import java.awt.Component;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.Scanner;
import javax.swing.*;
import jess.JessException;
import jess.Rete;
import sudoku.GUISudoku;

/**
 *
 * @author yafithekid
 */
public class Sudoku {
    public static final int ANY = 0;
    public static GUISudoku gui;
    
    private static int id[][] = {
                {1,2,3,7,8,9},
                {4,5,6,10,11,12},
                {13,14,15,19,20,21},
                {16,17,18,22,23,24},
                {25,26,27,31,32,33},
                {28,29,30,34,35,36}
            };
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) { 
        gui = new GUISudoku();
        gui.setVisible(true);

    }
    
    public static void solve(){
        // TODO code application logic here
        try {
            Rete env = new Rete();
            env.clear();
            env.batch("sudoku.clp");
			env.batch("solve.clp");
            env.batch("output-frills.clp");
            env.batch("guess.clp");
            env.batch("grid3x3-p1.clp");
	    env.eval("(open \"test.txt\" output \"w\")");
            env.reset();
            env.eval("(assert (try guess))");
            env.run();
            env.eval("(close output)");
        } catch (JessException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
        }
        System.out.println("ok");
        FileReader fr;
        try {
            int r = 0,c = 0;
            fr = new FileReader("test.txt");
            Scanner sc = new Scanner(fr);
            
            while (sc.hasNextInt()){
                int next = sc.nextInt();
                int i = id[r][c];
                gui.setSudokuValue(i-1, next);
                c++;
                if (c >= 6){
                    c = 0; r++;
                }
            }
        } catch (Exception e){
        }
        
    }
    
    
    public static void createClipsFile(String inputFilename){
        try {
            FileWriter fw = new FileWriter("grid3x3-p1.clp");
            FileReader fr = new FileReader(inputFilename);
            Scanner sc = new Scanner(fr);
            fw.write("(defrule grid-values\n\n");
            fw.write("?f <- (phase grid-values)\n\n");
            fw.write("=>\n\n");
            fw.write("(retract ?f)\n\n");
            fw.write("(assert (phase expand-any))\n\n");
            fw.write("(assert (size 3))\n\n");
            int x[][] = new int[10][10];
            int g[][] = {
                {1,1,1,2,2,2},
                {1,1,1,2,2,2},
                {3,3,3,4,4,4},
                {3,3,3,4,4,4},
                {5,5,5,6,6,6},
                {5,5,5,6,6,6}
            };
            
            int r = 0, c = 0;
            while (sc.hasNextInt()){
                int nextInt = sc.nextInt();
                x[r][c] = nextInt;
                c++;
                if (c >= 6){ r++; c = 0; }
            }
            
            for(int group = 1; group <= 6; group++){
                for(r = 0; r < 6; r++){
                    for( c = 0; c < 6; c++){
                        if (g[r][c] == group){
                            String out = (x[r][c] == Sudoku.ANY)?"any":String.valueOf(x[r][c]);
                            fw.write("(assert (possible (row "+(r+1)+") (column "+(c+1)+") (value "+out+") (group "+group+") (id "+id[r][c]+")))\n");
                            gui.setSudokuValue(id[r][c]-1,x[r][c]);
                        }
                    }
                }
                fw.write("\n");
            }
            fw.write(")\n");
            fw.close();
        } catch (Exception e){
            e.printStackTrace();
        }
        
        
    }
    
}
