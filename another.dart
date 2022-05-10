import 'dart:io';
import 'main.dart';

//=============================================================================
//this is the class for the books
//it contains tittle, author, genre, and isbn
//i added a boolean for lending/returned books
class Book {
  String? title;
  String? author;
  String? genre;
  int? isbn;
  bool isLent = false;

  //book constructor
//i added a status to know whether or not the book is lent or available to be lent
  Book(this.title, this.author, this.genre, this.isbn, this.isLent);
}

//==============================================================================
//i made a class that has a constructor about the users information (the one who will borrow)
//and the book that he/she wants to borrow.
class Userinfo {
  String? fullname;
  String? address;
  String? bookname;
  Userinfo(this.fullname, this.address, this.bookname);
  //thie data in here will be stored in a list
  //a list that only the admn can access.
  //inorder to verify each transaction.
}

//=============================================================================
//i made a list of default books
//since i don't know yet how to generate unique id's,
//so i just made a counter for each book
//since the count will increment when there is a new book added,no book will have the same id
int uid = 1;
bool status =
    false; //initializing the status to false. meaning the book is not lent
List<Book> allBooks = [
  Book("Comp Scie 1", "Compscie auhor1", "Computer Science", uid++, status),
  Book("Comp Scie 2", "Compscie auhor2", "Computer Science", uid++, status),
  Book("Philo 1", "Philo auhor1", "Philisophy", uid++, status),
  Book("Philo 2", "Philo auhor2", "Philisophy", uid++, status),
  Book("Pure Scie 1", "Purescie auhor1", "Pure Science", uid++, status),
  Book("Pure Scie 2", "Purescie auhor2", "Pure Science", uid++, status),
  Book("Art & Rec 1", "ArtRec auhor1", "Artand Recreation", uid++, status),
  Book("Art & Rec 2", "ArtRec auhor2", "Artand Recreation", uid++, status),
  Book("History 1", "History auhor1", "History", uid++, status),
  Book("History 2", "History auhor2", "History", uid++, status)
];

//==============================================================================
//this a list on the information about the user and the book that he/she borrowed
//this list can only be accessed by the ADMIN
//this can be used to store the information about the user who is
//borrowing the book.
List<Userinfo> lentBooks = [];

//==============================================================================
//this a list on the information baout the user and the book that he/she borrowed
//this is an exclusice list to the USERS
//this list will show the books that are not yet returned
//so the users can have an ease of access when they want to return the book.
List<Userinfo> returnBooks = [];

//=============================================================================
//this abstract class will be the parent class for the user and admin
abstract class Identify {
  void
      whoRU(); //a function that will prompt either user or admin. it depeds on what you choose
}

//==============================================================================
//USER CLASS is an extension of the abstract class, Identify
//and it includes the user operations mixin
//the user operations, is where all the functions or features
//that the uesr can access.
class User extends Identify with UserOperations {
  //this function is the greeting/log in page for users
  @override
  void whoRU() {
    separator(); //this function will print broken lines to indicate a new prompt
    //in this part the system will ask the users about their full name, and address.
    print("Enter LAST name:");
    String? lastname = stdin.readLineSync();
    print("Enter FIRST name:");
    String? firstname = stdin.readLineSync();
    print("Enter ADDRESS:");
    String? address = stdin.readLineSync();
    //i preemtively asked all these so that the transaction will be a lot smoother
    opperations(lastname, firstname!,
        address); //the users will be sent to the operations menu
  }

//this function will serve as the user interface for USERS
  //which contains all the functions that a user needs to
  //borrow and return books. they can also see the status on each book
  //whether the book is "lent out" or available
  void opperations(String? lastname, String firstname, String? address) {
    String? fullname = ("$lastname, $firstname");
    separator(); //this function will print broken lines to indicate a new prompt
    print("Hello $firstname, what would you like to do?");
    print(
        "a.Borrow Book\nb.Returnbook\nc.Show all Books\nd.Show books available for borrowing\ne.Log Out");
    String? choice = stdin.readLineSync();
    switch (choice) {
      case 'a':
        borrowBook(fullname,
            address); //this is the function that lets the users borrow books
        //when the function above is done, it will loop back to the user interface
        opperations(lastname, firstname, address);
        break;
      case 'b':
        returnBook(fullname,
            address); //this is the function that lets the users return books
        //the return bookfunction only asks the tittle of the books to be returned
        //when the function above is done, it will loop back to the user interface
        opperations(lastname, firstname, address);
        break;
      case 'c':
        printAllBooks(); //this is the function that prints the books in the entire library
        //when the function above is done, it will loop back to the user interface
        opperations(lastname, firstname, address);
        break;
      case 'd':
        printAvailableBook(); //this is the function will print books that are available for borrowing
        //it will show the book tittle and its status (lent our or available)
        //the list will only be updated after ADMIN CONFIRMATION
        //so the data will not be up to date if the admin didn't record the borrowing and returning of books
        //when the function above is done, it will loop back to the user interface
        opperations(lastname, firstname, address);
        break;
      case 'e':
        main(); //this will let you exit the user interface and go back to the USER-ADMIN selection
        break;
      default:
        print("this is not a valid input please try again...");
        opperations(lastname, firstname,
            address); //this will loop you back to the user interface
    }
  }
}

//this mixin contains the operations to be used by the user
//the operations in this mixin are:
//separator,adding of book, returning a book,
//print all the books in the library and all of its info,
//printing of TICKETS,
//and print the tittle and books and display its status
mixin UserOperations {
  //this function prints broken lines to indicate a new prompt
  void separator() {
    print("\n------------------------------");
  }

  //this function lets the user borrow books from the library (Book List)
  void borrowBook(String fullname, String? address) {
    printAvailableBook(); //this will print all the book titles
    //and their status making it easier for the user to choose which books to borrow
    print("\nFrom the list above, select the books that you want to borrow");
    String? bookname =
        stdin.readLineSync(); //asks for the book that the user will borrow
    if (findBook(allBooks, bookname) == true) {
      //if the book is found in the list, then you will be sent to the PRINTING OF TICKET function.
      //this ticket will serve as a "PROOF" of the transaction
      //also the admin will need this info, to complete the borrowing process
      print("the book $bookname is available");
      print("Please take a screenshot of this TICKET and show it to the admin");
      printBorrowTicket(fullname, address, bookname);
    } else {
      //if the book is not found, a text will appear.
      print(
          "this book is not available for borrowing, please select another book");
    }
    //this will let the user choose to continue to borrow books, or to go back to the menu
    print("Do you want to borrow books again?      y/n");
    String? choice = stdin.readLineSync();
    if (choice == 'y') {
      //if you chose 'y' then you will be looped back to the borrowbook option
      borrowBook(fullname, address);
    }
    //if the user wants to continue borrowing books, then he/she can do so.
    //but the list won't be updated to the latest changes since
    //the admin did not confirm the borrowing transaction.
  }

//this function will print a ticket.in which the user will present it to the admin
//to finalize the transaction of borrowing the book
//give or send this to the admin.
  void printBorrowTicket(String fullname, String? address, String? bookname) {
    separator();
    print("TICKET FOR BORROWING BOOKS");
    print("Full name:\t $fullname");
    print("Address:\t $address");
    print("Book title to borrow: $bookname");
    separator();
  }

  //this function lets the user return borrowed books
  //the function only accepts the tittle of the book to be returned
  void returnBook(String fullname, String? address) {
    printLentBooks(); //prints a list of the books that are borrowed.
    //so the user will have an ease of access when selecting the book to be returned
    print("What book would you like to return?");
    String? bookname = stdin.readLineSync();
    if (findBook(allBooks, bookname) == false) {
      //if the book is found in the list, then you will be sent to the PRINTING OF TICKET function.
      //this ticket will serve as a "PROOF" of the transaction
      //also the admin will need this info, to complete the returning process
      print("please screenshot the ticket and take it to the admin");
      print("to finalize the returning of your book");
      printReturnTicket(fullname, address, bookname);
    } else {
      //if the book is not found, a text will appear.
      print("Book not found/there are no books currently being lent");
    }
  }

//this function will print a ticket that will be presented to the admin
//to finalize the  transaction of returning the book
  void printReturnTicket(String fullname, String? address, String? bookname) {
    separator();
    print("TICKET FOR RETURNING BOOKS");
    print("Full name:\t $fullname");
    print("Address:\t $address");
    print("Book title to borrow: $bookname");
    separator();
  }

//this function prints all the book that are available for borrowing
  void printAvailableBook() {
    separator();
    print("Status of all books:");
    for (var element in allBooks) {
      //this wil print out each element in the list
      String stats; //a variable to hold the "lent out" or "available" status
      //if the boolean function turns out to be true, then it is currently being lent out.
      //else it is available for borrowing.
      if (element.isLent == true) {
        stats = "Lent out";
      } else {
        stats = "Available";
        print("${element.title} ----\t\t" + stats);
      }
    }
  }

//this function prints out all the books that are currently being borrowed
  void printLentBooks() {
    separator();
    print("Books being lent:\n");
    for (var element in allBooks) {
      //this wil print out each element in the list
      String stats; //a variable to hold the "lent out" or "available" status
      //if the boolean function turns out to be true, then it is currently being lent out.
      //else it is available for borrowing.
      if (element.isLent == true) {
        stats = "Lent out";
        print("${element.title} ----\t\t" + stats);
      } else {
        stats = "Available";
      }
    }
  }

//this function will find the book based on the tittle.
  //and returns a boolean TRUE if the book being searched
  //is available for borrowing
  bool findBook(List<Book> allBooks, String? bookname) {
    final index = allBooks.indexWhere((element) => element.title == bookname);
    return allBooks[index].isLent == false ? true : false;
  }

//this functions displays all the informtion about the books in the library
  void printAllBooks() {
    separator();
    print("List of books im the library:");
    for (var element in allBooks) {
      print("Tittle\t\tAuthor\t\tGenre\t\tISBN");
      print("${element.title}-----" +
          "${element.author}----" +
          "${element.genre}-----" +
          "${element.isbn}");
    }
  }
}

//=============================================================================
//ADMIN CLASS is an extension of the abstract class, identify
//and it includes the admin operations mixin
class Admin extends Identify with AdminOperations {
  //this will serve as the log in menu for the administrator
  @override
  void whoRU() {
    separator();
    print("Enter name:");
    //just type "admin" or any name to access the admin features.
    //it still lacks passwords tho...
    String? nameAdmin = stdin.readLineSync();
    opperations(nameAdmin); //will transfer you to the admin operation functions
  }

//this function will have the options on what the admin will do.
  void opperations(String? name) {
    separator(); //prints a bunch of broken line to indicate a new prompt
    print("Hello $name, what would you like to do?");
    print("\nWhat would you like to do?");
    //lets you choose different operations like
    //add books, accept books, information about the books
    //and more information about them
    print(
        "a. Add Books\nb. Lend Books\nc. Accept Returned Book\nd. Details about Books\ne.Log out");
    print("\nchoice:");
    String? choice = stdin.readLineSync();
    switch (choice) {
      case 'a':
        addBook(); //will transfer you to the addbook fucntion.
        //if hte operation is done, it will loop you back to the admin user interface
        opperations(name);
        break;
      case 'b':
        rentBook(); //will transfer you to the rentbook(lent) fucntion.
        //if hte operation is done, it will loop you back to the admin user interface
        opperations(name);
        break;
      case 'c':
        acceptBook(); //will transfer you to the acceptbook fucntion.
        //if hte operation is done, it will loop you back to the admin user interface
        opperations(name);
        break;
      case 'd':
        moreDetails(name); //will transfer you to the moredetails fucntion.
        //if hte operation is done, it will loop you back to the admin user interface
        opperations(name);
        break;
      case 'e':
        main(); //this will let you exit the user interface and go back to the USER-ADMIN selection
        break;
      default:
        print("please enter a valid choice...");
        opperations(name);
    }
  }

  //more details about books for the admin to access (quantity, status, etc.)
  void moreDetails(String? name) {
    separator();
    print("\nWhat would you like to know?");
    print(
        "a.total books\nb.all info of books\nc.status of books\nd.print info about rented books\ne.go back");
    print("\nchoice: ");
    String? choice = stdin.readLineSync();
    switch (choice) {
      case 'a':
        totalbooksNum();
        moreDetails(name);
        break;
      case 'b':
        printBooksInfo();
        moreDetails(name);
        break;
      case 'c':
        printStatus();
        moreDetails(name);
        break;
      case 'd':
        printLentStats();
        break;
      case 'e':
        opperations(name);
        break;
      default:
        print("please enter a valid choice...");
        moreDetails(name);
    }
  }
}

//this mixin class will be connected to the admin class
//so that it can hace different functions to access.
mixin AdminOperations {
  //this function prints a broken line to indicate that it is a new prompt.
  void separator() {
    print("\n------------------------------");
  }

//this is the function that will add a new book.
//the information given will be stored in the list "allBooks" along with the default books.
  void addBook() {
    separator();
    print("enter the following:");
    print("tittle: ");
    String? title = stdin.readLineSync();
    print("author: ");
    String? author = stdin.readLineSync();
    //since there are only 4 genres available,
    //i will just let the admin choose which of te 4 the book belongs to.
    print("What genre does the book belongs to?");
    String? genre;
    print(
        "a. Computer Science\nb. Philosophy\nc. Art and Recreation\nd. History");
    String? choice = stdin.readLineSync();
    switch (choice) {
      case 'a':
        genre = 'Computer Science';
        break;
      case 'b':
        genre = 'Philosophy';
        break;
      case 'c':
        genre = 'Art and Recreation';
        break;
      case 'd':
        genre = 'History';
        break;
      default:
        print("please select the proper genre for the book");
        addBook();
    }
    //the ISBN(uid) of the book will automatically be generated
    //since i made a counter for each book added
    //since no book be "DELETED" (at lest not in the problem),
    //then the counter is what i came up with
    Book book1 = Book(title, author, genre, uid++, status);
    allBooks.add(book1);
    print(
        "the book has been added..."); //this is the confiration that the book has been added to the list
  }

  //this function will help the admin find the book that the user wants to borrow,
  //with the TICKET handed from the users to the admin,
  //the admin enters in all the information needed so the user can borrow the books.
  //all information will bw stored in a list, which can be printed(displayed)
  void rentBook() {
    printStatus(); //this function will print a list of available books to be lent out
    print("From the selection above, Please select the book to be lent");
    String? bookname = stdin.readLineSync();
    findBookUsingTittle(allBooks, bookname); //function that will find the book
    print("The book has been found");
    //since the book has been found, and the status has been changed,
    //it is now time to accept the "TICKET" that was issued to the users
    //that wanted to borrow the book
    enterInfo(
        bookname); //this will send the admin to the function that will input the info from the users
    //a text confirmation that the data has been stored
    //and the book is now ready to be borrowed
    print("the information has been stored, you can now lend the book");
  }

//this function will help the admin determine the books that will be returned,
//it will search for the book and change the "isLent" from TRUE to FALSE,
//making the book available to be borrowed again.
  void acceptBook() {
    //foran ease of access, the function will print the lentBook list,
    //to see the books that are not yet returned.
    printLentStats(); //this will display the list
    print("what book would be returned?");
    //the admin will then input the BOOK TITTLE,
    //since it is the only way the system can find it, for now
    String? bookname = stdin.readLineSync();
    //the admin will then be transfered to a function that will find the book in the list
    //and change the book's status from isLent=true to isLent=false
    returnBook(allBooks, bookname);
    //this part will erase the book on the lis "lentBook"
    //indicating that the book has been returned.
    removeFromList(lentBooks,
        bookname); //this function will remove the book from the lent list
    print("the book has been deleted from the list");
    //text confirmation that the the admin can now accept the returned book
    print("you can now accept the returned book.");
  }

//this function will change the status from "lent" to "available"
  //in here we can determine whether the book is lent or not.
  void returnBook(List<Book> allBooks, String? bookname) {
    //searched every element to match the bookname of the book to be borrowed
    final index = allBooks.indexWhere((element) => element.title == bookname);
    if (index >= 0) {
      if (allBooks[index].isLent == true) {
        allBooks[index].isLent = false;
      }
    }
  }

//this functiomn will remove the book from the list that was returned
  void removeFromList(List<Userinfo> lentBooks, String? bookname) {
    lentBooks.removeWhere((element) => element.bookname == bookname);
  }

//this function will let the admin enter the information about the user
  void enterInfo(String? bookname) {
    print("who will lend this book?\nenter last name:");
    String? lastame = stdin.readLineSync();
    print("enter first name:");
    String? firstname = stdin.readLineSync();
    print("enter address");
    String? fullname = lastame! + firstname!;
    String? address = stdin.readLineSync();
    //all the info provided will be stored in a list
    //so the data will not be lost
    Userinfo info = Userinfo(fullname, address, bookname);
    lentBooks.add(info);
  }

//this function will find the book using the tittle
//it will find its index and change its status from "available" to "lent"
//so the admin can then lend this book to the user.
  void findBookUsingTittle(List<Book> allBooks, String? bookname) {
    final index = allBooks.indexWhere((element) => element.title == bookname);
    if (index >= 0) {
      //indicates that the book has been found
      //it will find the status of the book if it is lent or not
      //if it is avilable, then change the book's status from false to true.
      if (allBooks[index].isLent == false) {
        allBooks[index].isLent = true;
      } else {
        //if the book is already lent out, then the admin will just have to go back and find another book
        print("this book is not available,please find another book");
        rentBook();
      }
    } else {
      //if the book is not found, a text will appear
      print("Please make sure that the tittle of the book matches the list...");
      rentBook();
    }
  }

  //this function will print a list of the information on who borrowed the book.
  //their full name, address and the borrowed book will be shown
  void printLentStats() {
    separator();
    print("Full name\t\t Address\t\t Book Borrowed");
    for (var element in lentBooks) {
      print("${element.fullname}\t\t" +
          "${element.address}\t\t" +
          "${element.bookname}");
    }
  }

//prints the number of books in the library
  void totalbooksNum() {
    separator();
    print("Total number of books in the shelf:");
    print(allBooks.length);
  }

//print all the details about the book
  //tittle, author, genre, and ISBN
  void printBooksInfo() {
    separator();
    print("List of books im the library:");
    print("\nTittle\t\tAuthor\t\tGenre\t\tISBN");
    for (var element in allBooks) {
      print("${element.title}\t\t" +
          "${element.author}\t\t" +
          "${element.genre}\t\t" +
          "${element.isbn}");
    }
  }

// print all the books and shows their status(lent out or available)
  void printStatus() {
    separator();
    print("Status of all books:");
    for (var element in allBooks) {
      String stats;
      //if the boolean function turns out to be true, then it is currently being lent out.
      //else it is available for borrowing.
      if (element.isLent == true) {
        stats = "Lent out";
      } else {
        stats = "Available";
      }
      print("${element.title} ----\t\t" +
          stats); //prints out the element and its status
    }
  }

//this function will print the number of lent books or books returned/available
//you will be prompted to either print the lent or returned books depending on your choice.
  void printNumLenOrRet() {
    int count = 0; //this is the counter for the lent/returned books.
    separator();
    print("what would you like to know??");
    //lets the admin choose whether to print the number of borrowed books or the number of available books
    print("a.No. of Lent Books\nb.No. of Returned/Available Books");
    String? choice = stdin.readLineSync();
    switch (choice) {
      case 'a': //this will print the no. of lent books over the number of total books.
        for (var element in allBooks) {
          if (element.isLent == true) {
            count++;
          }
        }
        separator();
        print("Total Books lent:");
        print("$count/${allBooks.length}");
        break;
      case 'b': //this will print the no. of books available/returned over the total number of books.
        for (var element in allBooks) {
          if (element.isLent == false) {
            count++;
          }
        }
        separator();
        print("Total Books Returned:");
        print("$count/${allBooks.length}");
        break;
      default:
        print("please enter a valid choice...");
        printNumLenOrRet(); //loops you back to the menu
    }
  }

//this functoion will print all the books along with its author...
  void printTitleAuthor() {
    separator();
    print("List of books per tittle:");
    for (var element in allBooks) {
      print('${element.title}---\t' + '${element.author}');
    }
  }
}
