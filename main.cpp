// Name: Carlos Secas
// CWID: 886088269
// Class: 240-09 Section 09
// Email: carlosJsecas@gmail.com
// Today's date : 4/23/2025
// Final Program


#include <iostream>

extern "C" long analyzer();

int main() {
    std::cout << "Welcome to AR Investigator programmed by Carlos Secas.\n\n";

    long result = analyzer(); // Call to assembly function

    std::cout << "\nThe main function received this number " << result
              << " (decimal) and will keep it for a while.\n";
    std::cout << "\nA zero will be returned to the OS as a sign of a successful run.  Have a good day.\n";

    return 0;
}