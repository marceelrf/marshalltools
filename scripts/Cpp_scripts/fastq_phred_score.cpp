#include <iostream>
#include <fstream>
#include <string>
#include <vector>

int calculatePhredScore(const std::string& qualityString) {
    int score = 0;
    for (char c : qualityString) {
        score += static_cast<int>(c) - 33; // Phred quality score offset is 33
    }
    return score;
}

void printResultsToTerminal(const std::vector<int>& results) {
    for (int score : results) {
        std::cout << "Phred Quality Score: " << score << std::endl;
    }
}

void writeResultsToFile(const std::vector<int>& results, const std::string& outputFilename, const std::string& format) {
    std::ofstream outputFile(outputFilename);
    if (!outputFile) {
        std::cerr << "Error: Unable to open the output file." << std::endl;
        return;
    }

    if (format == "csv") {
        for (int score : results) {
            outputFile << score << std::endl;
        }
    } else if (format == "txt") {
        for (int score : results) {
            outputFile << "Phred Quality Score: " << score << std::endl;
        }
    } else {
        std::cerr << "Error: Invalid output format. Use '--format csv' or '--format txt'." << std::endl;
    }

    outputFile.close();
}

int main(int argc, char* argv[]) {
    if (argc < 4 || argc > 5) {
        std::cerr << "Usage: " << argv[0] << " --input input.fastq --format output_format --destination output_destination [--output output_file]" << std::endl;
        std::cerr << "Examples:" << std::endl;
        std::cerr << "  " << argv[0] << " --input input.fastq --format csv --destination terminal" << std::endl;
        std::cerr << "  " << argv[0] << " --input input.fastq --format txt --destination file --output output.txt" << std::endl;
        return 1;
    }

    std::string inputFilename;
    std::string outputFormat;
    std::string outputDestination;
    std::string outputFilename;

    for (int i = 1; i < argc; i++) {
        std::string arg = argv[i];
        if (arg == "--input") {
            if (i + 1 < argc) {
                inputFilename = argv[i + 1];
                i++;
            } else {
                std::cerr << "Error: Missing input file argument." << std::endl;
                return 1;
            }
        } else if (arg == "--format") {
            if (i + 1 < argc) {
                outputFormat = argv[i + 1];
                i++;
            } else {
                std::cerr << "Error: Missing output format argument." << std::endl;
                return 1;
            }
        } else if (arg == "--destination") {
            if (i + 1 < argc) {
                outputDestination = argv[i + 1];
                i++;
            } else {
                std::cerr << "Error: Missing output destination argument." << std::endl;
                return 1;
            }
        } else if (arg == "--output") {
            if (i + 1 < argc) {
                outputFilename = argv[i + 1];
                i++;
            } else {
                std::cerr << "Error: Missing output file argument." << std::endl;
                return 1;
            }
        }
    }

    std::vector<std::string> qualityScores;
    std::vector<int> phredScores;

    std::ifstream inputFile(inputFilename);
    if (!inputFile) {
        std::cerr << "Error: Unable to open the input file." << std::endl;
        return 1;
    }

    std::string line;
    while (std::getline(inputFile, line)) {
        if (line[0] == '+') {
            std::getline(inputFile, line);
            qualityScores.push_back(line);
        }
    }

    inputFile.close();

    for (const std::string& qualityString : qualityScores) {
        int score = calculatePhredScore(qualityString);
        phredScores.push_back(score);
    }

    if (outputDestination == "terminal") {
        // Print results to the terminal
        printResultsToTerminal(phredScores);
    } else if (outputDestination == "file") {
        if (outputFilename.empty()) {
            std::cerr << "Error: Missing output file argument." << std::endl;
            return 1;
        }

        // Write results to a file
        writeResultsToFile(phredScores, outputFilename, outputFormat);
    } else {
        std::cerr << "Error: Invalid output_destination. Use 'terminal' or 'file'." << std::endl;
        return 1;
    }

    return 0;
}
