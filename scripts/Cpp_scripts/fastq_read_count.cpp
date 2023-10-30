#include <iostream>
#include <fstream>
#include <string>

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <input_fastq_file>" << std::endl;
        return 1;
    }

    const std::string inputFilename = argv[1];
    std::ifstream inputFile(inputFilename);

    if (!inputFile) {
        std::cerr << "Error: Unable to open the input file." << std::endl;
        return 1;
    }

    int readCount = 0;
    std::string line;
    
    while (std::getline(inputFile, line)) {
        if (line[0] == '@') {
            readCount++;
        }
    }

    inputFile.close();

    std::cout << "Number of reads: " << readCount << std::endl;

    return 0;
}
