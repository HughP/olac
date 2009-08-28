import java.io.*;
import java.util.*;
import cc.mallet.classify.*;
import cc.mallet.pipe.iterator.*;
import cc.mallet.types.*;

public class ResourceTypeClassify {
	// Usage: java ResourceTypeClassify classifier.mallet input-vectors output-file
	public static void main(String[] args) throws IllegalArgumentException,
		FileNotFoundException, IOException, ClassNotFoundException{
		if(args.length!=3){
			throw new IllegalArgumentException("Usage: java Classify classifier.mallet input-vectors output-file");
		}else{
			System.out.println("Loading classifier...");
			Classifier classifier = loadClassifier(new File(args[0]));
			System.out.println("Printing class labels...");
			printLabelings(classifier, new File(args[1]), args[2]);
		}
	}
	
	public static Classifier loadClassifier(File serializedFile)
	throws FileNotFoundException, IOException, ClassNotFoundException, IllegalArgumentException {

		// The standard way to save classifiers and Mallet data                                            
		//  for repeated use is through Java serialization.                                                
		// Here we load a serialized classifier from a file.                                               

		Classifier classifier;
		
		try{
		ObjectInputStream ois =
			new ObjectInputStream (new FileInputStream (serializedFile));
		classifier = (Classifier) ois.readObject();
		ois.close();

		return classifier;
		}catch (Exception e){
			e.printStackTrace();
			throw new IllegalArgumentException("Couldn't read classifier "+serializedFile.getName());
		}
	}
	
    public static void printLabelings(Classifier classifier, File vectorfile, String outputFilename) throws IOException {

        // Create a new iterator that will read raw instance data from                                     
        //  the lines of a file.                                                                           
        // Lines should be formatted as:                                                                   
        //                                                                                                 
        //   [name] [label] [data ... ]                                                                    
        //                                                                                                 
        //  in this case, "label" is ignored.                                                              

        CsvIterator reader =
            new CsvIterator(new FileReader(vectorfile),
                            "(\\w+)\\s+(\\w+)\\s+(.*)",
                            3, 2, 1);  // (data, label, name) field indices               

        // Create an iterator that will pass each instance through                                         
        //  the same pipe that was used to create the training data                                        
        //  for the classifier.                                                                            
        Iterator instances =
            classifier.getInstancePipe().newIteratorFrom(reader);

        // Classifier.classify() returns a Classification object                                           
        //  that includes the instance, the classifier, and the                                            
        //  classification results (the labeling). Here we only                                            
        //  care about the Labeling.
        PrintStream output = new PrintStream(new FileOutputStream(outputFilename));
        while (instances.hasNext()) {
        	Instance instance = (Instance) instances.next();
            Labeling labeling = classifier.classify(instance).getLabeling();

            // print the labels with their weights in descending order (ie best first)                     

            for (int rank = 0; rank < labeling.numLocations(); rank++){
            	output.print(instance.getName() + "\t");
                output.print(labeling.getLabelAtRank(rank) + ":" +
                                 labeling.getValueAtRank(rank) + " ");
            }
            output.println();

        }
    }
    
    public void evaluate(Classifier classifier, File file) throws IOException {

        // Create an InstanceList that will contain the test data.                                         
        // In order to ensure compatibility, process instances                                             
        //  with the pipe used to process the original training                                            
        //  instances.                                                                                     

        InstanceList testInstances = new InstanceList(classifier.getInstancePipe());

        // Create a new iterator that will read raw instance data from                                     
        //  the lines of a file.                                                                           
        // Lines should be formatted as:                                                                   
        //                                                                                                 
        //   [name] [label] [data ... ]                                                                    

        CsvIterator reader =
            new CsvIterator(new FileReader(file),
                            "(\\w+)\\s+(\\w+)\\s+(.*)",
                            3, 2, 1);  // (data, label, name) field indices               

        // Add all instances loaded by the iterator to                                                     
        //  our instance list, passing the raw input data                                                  
        //  through the classifier's original input pipe.                                                  

        testInstances.addThruPipe(reader);

        Trial trial = new Trial(classifier, testInstances);

        // The Trial class implements many standard evaluation                                             
        //  metrics. See the JavaDoc API for more details.  
        
        

        System.out.println("Accuracy: " + trial.getAccuracy());

	// precision, recall, and F1 are calcuated for a specific                                          
        //  class, which can be identified by an object (usually                                           
	//  a String) or the integer ID of the class                                                       

        System.out.println("F1 for class 'good': " + trial.getF1("good"));

        System.out.println("Precision for class '" +
                           classifier.getLabelAlphabet().lookupLabel(1) + "': " +
                           trial.getPrecision(1));
    }
}
