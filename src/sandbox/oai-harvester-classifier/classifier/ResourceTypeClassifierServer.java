import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.PrintStream;
import java.util.Iterator;

import cc.mallet.classify.Classifier;
import cc.mallet.pipe.iterator.CsvIterator;
import cc.mallet.types.Instance;
import cc.mallet.types.Labeling;

/**
 *  start up classifier
 * @author svenpedersen
 *
 * start the classifier
 *   - open the *.mallet file
 *   - load it into an object
 * check for file to classify
 *   - process the file:
 *     - open file for testing
 *     - create the temporary output file (ProcFile.tmp)
 *     - when done, move to final output (OutputFile.tmp)
 * sleep
 * loop
 * 
 * USAGE:
 * Copy an input file to "MalletClassifierInputFile.tmp"
 *   -- when MalletClassifierOutputFile.tmp appears, copy it somewhere else...
 *   Then rinse and repeat...
 */

public class ResourceTypeClassifierServer {
	private static String classifierFile = "resourceTypeBinaryClassifier.mallet";
	private static Classifier classifier = null;
	private static String fileName = "MalletClassifierInputFile.tmp";
	private static String processingFileName = "MalletClassifierProcFile.tmp";
	private static String outputName = "MalletClassifierOutputFile.tmp";
	private static int waitTimeMilliSecs = 4000;
	
	/**
	 *  Test stage of resource type classifier, uses saved mallet classifier
	 * @param args
	 */
    public static void main(String[] args)
	{
		if(args.length > 1) {
			System.out.println("Usage: java ResourceTypeClassifierServer [classifier.mallet]");
			// default to binary classifier file
			System.exit(1);
		}
		else if(args.length == 1) {
	    	classifierFile = args[0];
		}
		// else default to binary
		System.out.println("Loading classifier...");
		try {
			try {
				classifier = loadClassifier(new File(classifierFile));
			} catch (FileNotFoundException e) {
				System.out.println("Unable to load classifier file \""+classifierFile+"\"");
				System.out.println("Usage: java ResourceTypeClassifierServer classifier.mallet");
				System.exit(1);
			} catch (IOException e) {
				System.out.println("Exception loading classifier file \""+classifierFile+"\"");
				e.printStackTrace();
			}
		} catch (ClassNotFoundException e) {
			System.out.println("Unable to load classifier");
		}
		
		// infinite loop of "server" process
		while(true) {
			boolean exists = (new File(fileName)).exists();
			if (exists) {
				// input file exists
				System.out.println("Found input file...");
				File inputVectorsFile = new File(fileName);
				
				File processingFile = new File(processingFileName);
				File outputFile = new File(outputName);
				if( processingFile.exists() ) {
					System.out.println("Deleting old temporary file.");
					processingFile.delete();
				}
				
				// write the classifications to a temporary processing file
				try {
					printLabelings(classifier, inputVectorsFile, processingFile);
				} catch (IOException e) {
					System.out.println("Exception running classifier \""+classifierFile+"\"");
					e.printStackTrace();
				}

				// delete input file so it will not be re-processed
				if( inputVectorsFile.exists() ) {
					System.out.println("Deleting input file.");
					inputVectorsFile.delete();
				}
				
				// move the completed temporary file to the output file
				if( processingFile.renameTo(outputFile) ) {
					System.out.println("   Processed file \""+fileName+"\" with classifier \""+classifierFile+"\"...");
				}
				else {
					System.out.println("   Failed to move file \""+fileName+"\": stopping server process.");
					System.exit(1);
				}
				// disconnect from output file
				outputFile = null;
			}
			
			// pause to allow other processes to eat the CPU
			try {
				Thread.sleep(waitTimeMilliSecs);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
    }
    
    /**
     *  Load mallet classifier from serialized file
     * @param serializedFile
     * @return
     * @throws FileNotFoundException
     * @throws IOException
     * @throws ClassNotFoundException
     * @throws IllegalArgumentException
     */
	public static Classifier loadClassifier(File serializedFile)
	throws FileNotFoundException, IOException, ClassNotFoundException, IllegalArgumentException {
		Classifier classifier;
		try {
			ObjectInputStream ois =
				new ObjectInputStream (new FileInputStream (serializedFile));
			classifier = (Classifier) ois.readObject();
			ois.close();
	
			return classifier;
		} catch (Exception e) {
			e.printStackTrace();
			throw new IllegalArgumentException("Couldn't read classifier "+serializedFile.getName());
		}
	}
	
    /**
     *  classify documents from "vectorfile", which is in plaintext format, and prints classifier output to file
     * @param classifier
     * @param vectorfile
     * @param outputFilename
     * @throws IOException
     */
    public static void printLabelings(Classifier classifier, File vectorfile, File outputfile) throws IOException {
        // format of data in vectorfile is: [name]\t[label]\t[data]
        CsvIterator reader =
            new CsvIterator(new FileReader(vectorfile),
                            "(.+)\\t(.*)\\t(.*)",
                            3, 2, 1);
        Iterator<Instance> instances =
            classifier.getInstancePipe().newIteratorFrom(reader);
        
        // We need a second reader here because Iterator<Instance> ignores class labels that do not exist in the classifier.
        CsvIterator reader2 =
            new CsvIterator(new FileReader(vectorfile),
                            "(.+)\\t(.*)\\t(.*)",
                            3, 2, 1);

        PrintStream output = new PrintStream(new FileOutputStream(outputfile));
        while (instances.hasNext()) {
        	Instance reader2Instance = reader2.next();
        	Instance instance = (Instance) instances.next();
            Labeling labeling = classifier.classify(instance).getLabeling();

            // print the labels with their weights in descending order (i.e., best first)                     
//            System.out.println(instance.getLabeling()+ " " + instance.getSource());
            output.print(instance.getName() + "\t");
            Object trueLabel = reader2Instance.getTarget();
            if(trueLabel != null)
            	output.print(trueLabel.toString() + "\t");
            for (int rank = 0; rank < labeling.numLocations(); rank++){
                output.print(labeling.getLabelAtRank(rank) + ":" +
                                 labeling.getValueAtRank(rank) + " ");
            }
            output.println();

        }
    }
}