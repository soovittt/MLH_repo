String getInstructorLastName(String fullName) {
  // Check if the input string is empty or null
  if (fullName == null || fullName.isEmpty) {
    return ""; // You can change this to handle empty input as needed
  }

  // Split the full name into parts using a comma and trim any extra spaces
  List<String> nameParts = fullName.split(",");

  // Ensure there are at least two parts (last name and first initial)
  if (nameParts.length >= 2) {
    String lastName = nameParts[0].trim();
    return lastName;
  } else {
    return ""; // Handle cases where the input format is not as expected
  }
}
