#include "dataFiles.hpp"
using namespace std;

// Takes in a json file and returns a key-value pairing of the json file
Json::Value DataFiles::parseJson(string fname) {
    try {
        ifstream file;
        file.open(fname);

        Json::Value root;
        Json::Reader reader;

        file >> root;

        file.close();
        
        return root;
    } catch (ios_base::failure& e) {
        cerr << "Reading Json input file failed: " << e.what() << endl;
        return Json::Value();
    }
}

// Writes the output json file with the given parameters
bool DataFiles::writeJsonOutput(const string outputFileName, const string description, const string time, const Json::Value params, 
  const size_t numCols, const size_t numRows, const string colNames[], 
  const string colShortNames[], const string colUnits[], const Json::Value project) {
      try {
        Json::Value root;
        
        root["description"] = Json::Value(description);
        root["time"] = time;
        root["numCols"] = static_cast<int>(numCols);
        root["numRows"] = static_cast<int>(numRows);
        root["params"] = params;
        
        Json::Value columns(Json::arrayValue);

        for (size_t i = 0; i < numCols; ++i) {
            Json::Value column;
            column["name"] = Json::Value(colNames[i]);
            column["shortName"] = Json::Value(colShortNames[i]);
            column["units"] = Json::Value(colUnits[i]);

            columns.append(column);
        }

        root["columns"] = columns;

        ofstream outputFile;
        outputFile.open(outputFileName);
        outputFile << root.toStyledString();

        outputFile.close();

        return EXIT_SUCCESS;
      } catch (ios_base::failure& e) {
        cerr << "Writing Json output file failed: " << e.what() << endl;
        return EXIT_FAILURE;
      }

}