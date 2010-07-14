import java.io.*;
import java.util.*;
import cc.mallet.classify.*;
import cc.mallet.pipe.iterator.*;
import cc.mallet.types.*;

public class ResourceTypeClassify {
	// Test stage of resource type classifier, uses saved mallet classifier
    public static void main(String[] args) throws IllegalArgumentException,
		FileNotFoundException, IOException, ClassNotFoundException{
		if(args.length!=3){
			throw new IllegalArgumentException("Usage: java ResourceTypeClassify classifier.mallet input-vectors output-file");
		}
		else {
			String classifierFile = args[0];
			String inputVectorsFile = args[1];
			String outputFile = args[2];
			System.out.println("Loading classifier...");
			Classifier classifier = loadClassifier(new File(classifierFile));
			System.out.println("Printing class labels...");
			printLabelings(classifier, new File(inputVectorsFile), outputFile);
		}
	}
	
    // Loads mallet classifier from serialized file
	public static Classifier loadClassifier(File serializedFile)
	throws FileNotFoundException, IOException, ClassNotFoundException, IllegalArgumentException {
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
	
    // classifies documents from "vectorfile", which is in plaintext format, and prints classifier output to file
    public static void printLabelings(Classifier classifier, File vectorfile, String outputFilename) throws IOException {
        //format of data in vectorfile is: [name]\t[label]\t[data]
        CsvIterator reader =
            new CsvIterator(new FileReader(vectorfile),
                            "(\\w+)\\t(\\w.*)\\t(\\w.*)",
                            3, 2, 1);
        Iterator<Instance> instances =
            classifier.getInstancePipe().newIteratorFrom(reader);
        
        CsvIterator reader2 = // We need a second reader here because Iterator<Instance> ignores class labels that do not exist in the classifier.
            new CsvIterator(new FileReader(vectorfile),
                            "(\\w.+)\\t(\\w.*)\\t(\\w.*)",
                            3, 2, 1);

        PrintStream output = new PrintStream(new FileOutputStream(outputFilename));
        while (instances.hasNext()) {
        	Instance reader2Instance = reader2.next();
        	Instance instance = (Instance) instances.next();
            Labeling labeling = classifier.classify(instance).getLabeling();

            // print the labels with their weights in descending order (i.e., best first)                     
//            System.out.println(instance.getLabeling()+ " " + instance.getSource());
            output.print(instance.getName() + "\t");
            Object trueLabel = reader2Instance.getTarget();
            if(trueLabel!=null)
            	output.print(trueLabel.toString() + "\t");
            for (int rank = 0; rank < labeling.numLocations(); rank++){
                output.print(labeling.getLabelAtRank(rank) + ":" +
                                 labeling.getValueAtRank(rank) + " ");
            }
            output.println();

        }
    }
}
