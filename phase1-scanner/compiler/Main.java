package compiler;

import java.io.FileWriter;

public class Main {

    public static String run(java.io.File inputFile) throws Exception {
        //StringBuilder str = new StringBuilder();
        /* dshuisdhuihdsu/*fuihfuahuhd */
        PreScanner preScanner = null;
        try {
            java.io.FileInputStream stream = new java.io.FileInputStream(inputFile);
            java.io.Reader reader = new java.io.InputStreamReader(stream);
            preScanner = new PreScanner(reader);
            while (!preScanner.zzAtEOF) preScanner.yylex();
            FileWriter fileWriter= new FileWriter(inputFile);
            fileWriter.write(preScanner.out.toString());
            fileWriter.flush();
            //System.out.println(preScanner.out.toString());
            String sdsa = preScanner.out.toString();

        } catch (Exception e) {

            System.out.println("Unexpected exception:");
            e.printStackTrace();
        }
        //PreScanner preScanner = new PreScanner(new FileReader(inputFile));
        //new FileWriter(inputFile).write(preScanner.out.toString());
        Lexer scanner = null;
        try {
            java.io.FileInputStream stream = new java.io.FileInputStream(inputFile);
            java.io.Reader reader = new java.io.InputStreamReader(stream);
            scanner = new Lexer(reader);
            while (!scanner.zzAtEOF) scanner.yylex();

            //.out.println(scanner.out.toString());
            return scanner.out.toString();
        } catch (Exception e) {
            System.out.println("Unexpected exception:");
            e.printStackTrace();
        }
        return null;

        //Laxer scanner = new Laxer(new FileReader(inputFile));


    }
}