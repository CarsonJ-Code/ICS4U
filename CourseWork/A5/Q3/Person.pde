class Person {
  // Stores the person's first and last name
  String first, last;

  // Stores the person's age
  int age;

  // Stores the person's height
  float personHeight;

  // Constructor to initialize all instance variables
  Person(String firstArg, String lastArg, int ageArg, float heightArg) {
    first = firstArg;
    last = lastArg;
    age = ageArg;
    personHeight = heightArg;
  }

  // Returns the first name
  String getFirstName() {
    return first;
  }

  // Returns the last name
  String getLastName() {
    return last;
  }

  // Returns the full name (first + last)
  String getFullName(){
    return(getFirstName() + ' ' + getLastName());
  }

  // Updates the first name
  void setFirstName(String newFirst){
    first = newFirst;
  }

  // Updates the last name
  void setLastName(String newLast){
    last = newLast;
  }
  
  // Returns the age
  int getAge() {
    return age; 
  }

  // Updates the age
  void setAge(int newAge){
    age = newAge; 
  }
  
  // Returns the height
  float getHeight() {
    return personHeight; 
  }

  // Updates the height
  void setHeight(int newHeight){
    personHeight = newHeight; 
  }
  
  // Returns a formatted string describing the person
  String personToString(){
    return ("Name: " + first + ' ' + last + "\nAge: " + age + "\nHeight: " + personHeight + '\n');
  }
}
