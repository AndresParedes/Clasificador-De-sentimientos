/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package clasificador;

import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;
import weka.classifiers.*;
import weka.classifiers.bayes.NaiveBayes;
import weka.classifiers.meta.FilteredClassifier;
import weka.core.converters.ConverterUtils;
 import weka.core.Instances;
 import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
 import java.io.FileReader;
import java.io.FileWriter;
import static java.util.Locale.filter;
import weka.classifiers.trees.J48;
import weka.classifiers.trees.NBTree;
import weka.filters.unsupervised.attribute.StringToWordVector;



public class Clasificador {
    
    File archivo = new File("archivo.arff");
    BufferedWriter bw;
    StringBuilder salida= new StringBuilder();
     public void clasificador(){
 StringToWordVector filter;
        try {
            BufferedReader reader = new BufferedReader(
                    new FileReader("salida.arff"));
            Instances data = new Instances(reader);
            reader.close();
            // setting class attribute
            data.setClassIndex(data.numAttributes() - 1);
            
            BufferedReader reader2 = new BufferedReader(
                    new FileReader("salida1.arff"));
            Instances data2 = new Instances(reader2);
            reader2.close();
            // setting class attribute
            data2.setClassIndex(data2.numAttributes() - 1);
            

            FilteredClassifier classifier = new FilteredClassifier();
            filter = new StringToWordVector();			
		System.out.println(filter);
		classifier = new FilteredClassifier();
		classifier.setFilter(filter);
		classifier.setClassifier(new J48());
		Evaluation eval = new Evaluation(data);	

            eval.crossValidateModel(classifier, data, 4, new Random(1));
            classifier.buildClassifier(data);
            System.out.println(eval.toSummaryString("______RESULTADO_____",true));
            System.out.println(eval.toMatrixString("______MATRIX CONFISION____"));
            //Salida Deseada
           
            eval.evaluateModel(classifier, data2);
            //recorrer el arreglo de doubles
            for (int i = 0; i < eval.evaluateModel(classifier, data2).length; i++) {
              

                if(eval.evaluateModel(classifier, data2)[i]==0){
                    
                    salida.append("Positivo"+"\n");   
                } 
                if(eval.evaluateModel(classifier, data2)[i]==1){
                    salida.append("Negativo"+"\n");                
                }  
                if(eval.evaluateModel(classifier, data2)[i]==2){
                   salida.append("Neutral"+"\n");                
                }  
                
                
            }
            bw = new BufferedWriter(new FileWriter(archivo));
            bw.write(salida.toString());
            bw.close();
      
        } catch (Exception ex) {
            Logger.getLogger(Clasificador.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
}
