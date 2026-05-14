// Carson Jones
// February 10, 2026
// GUI-based program to manage a list of people and perform searches by age or height

// Stores all Person objects
ArrayList<Person> people;

// Width and height of each button
int RECT_WIDTH = 100;

// Button objects for different actions
Button addPerson;
Button removePerson;
Button all;
Button findAge;
Button heightButton;

// Draws all buttons on the screen
void drawButtons() {
  addPerson.draw();
  removePerson.draw();
  all.draw();
  findAge.draw();
  heightButton.draw();
}

void setup() {
  // Sets up the window size and background color
  size(800, 600);
  background(#006E6E);

  // Initializes the ArrayList of people
  people = new ArrayList<Person>();

  // Creates and positions all buttons
  addPerson = new Button(width/4-RECT_WIDTH/2, height/4-RECT_WIDTH/2, RECT_WIDTH, RECT_WIDTH, #FF0000, "Add a \nperson");
  removePerson = new Button(3*width/4-RECT_WIDTH/2, height/4-RECT_WIDTH/2, RECT_WIDTH, RECT_WIDTH, #FF0000, "Remove a \nperson");
  all = new Button(width/2-RECT_WIDTH/2, height/2-RECT_WIDTH/2, RECT_WIDTH, RECT_WIDTH, #FF0000, "Print all");
  findAge = new Button(width/4-RECT_WIDTH/2, 3*height/4-RECT_WIDTH/2, RECT_WIDTH, RECT_WIDTH, #FF0000, "Find all people \nwith a given \nage");
  heightButton = new Button(3*width/4-RECT_WIDTH/2, 3*height/4-RECT_WIDTH/2, RECT_WIDTH, RECT_WIDTH, #FF0000, "Find all people \nwith a given \nheight or taller");
}

void draw() {
  // Continuously draws the buttons
  drawButtons();
}

// Handles mouse click events
void mouseReleased() {
  if (addPerson.isClicked(mouseX, mouseY)) addPerson();
  else if (removePerson.isClicked(mouseX, mouseY)) removePerson();
  else if (all.isClicked(mouseX, mouseY)) printAll();
  else if (findAge.isClicked(mouseX, mouseY)) findAge(getInt("What age?"));
  else if (heightButton.isClicked(mouseX, mouseY)) findHeight(getFloat("What height?"));
}

// Prompts the user for information and adds a new person
void addPerson() {
  String[] name = getString("Full name").split(" ");
  int age = getInt("Age");
  float height1 = getFloat("Height");
  people.add(new Person(name[0], name[1], age, height1));
}

// Removes a person matching the given full name
void removePerson() {
  String[] name = getString("Full name").split(" ");
  for (Person person : people) {
    if (person.getFirstName() == name[0] && person.getLastName() == name[1]) {
      people.remove(person);
      return;
    }
  }
}

// Prints information for all people in the list
void printAll() {
  for (Person person : people) {
    println(person.personToString());
  }
}

// Finds and prints all people at least a given age
void findAge(int age) {
  ArrayList<Person> older = new ArrayList<Person>();
  for (Person person : people) {
    if (person.getAge() >= age) older.add(person);
  }
  if (older.size() != 0) {
    for (Person person : older) {
      print(person.personToString());
    }
  } else println("None found");
}

// Finds and prints all people at least a given height
void findHeight(float height1) {
  ArrayList<Person> taller = new ArrayList<Person>();
  for (Person person : people) {
    if (person.getHeight() >= height1) taller.add(person);
  }
  if (taller.size() != 0) {
    for (Person person : taller) {
      print(person.personToString());
    }
  } else println("None found");
}
