//this program uses the "user-admin" options.
//in which, if you are a user, you can ONLY "borrow","return" and
//show books that areavailable to be borrowed
//it will have the "admin" option, meaning the admin will have certain previledges to manipulate the data
//only the admin can "add" books, see the different information about the books,
//like status of the book, number of books being lent, know the different books available for borrowing,
//change the status of the book, etc....

//since the library wants to know certain information before lending the books,
//i made the user interface prompt for their full name (last and first names) and address;
//next there will be a prompt to ask the user whether they want to return,borrow a book or show the status of the book
//whether the book may be available to be lent or not.

//if the user wants to borrow a book, a "TICKET" or a text will be shown to them.
//in which the users will "PRESENT" the ticket to the admin
//so that the admin can get their information (full name, address and book to borrow)
//to complete each borrowing and returning transactions.

//i made the program like this, so that the users cannot tamper with the information storred inside the system,
//but the admin can.

//for the admin interface, i made a few options for the admin to access like:
//total number of books, print books by title, lend books, accept returned books,
//change a book status from lend to returned and vice versa
//print the tittles/authors etc....

//the lent book and return books operations(function) will need the user's TICKET
//to make the transaction valid, or for the admin to input the information needed for the system
//to lend books to the users.

//one thing to remember is, the TABLES (LISTS)in the user interface,
//will only be updated after ADMIN CONFIRMATION
//orwhen the admin manipulates, or input data.

//this is my best attempt at solving the given problem.
//if there are things that i misunderstood or things that needs improvement, please let me know.
//thank you sir.

//by the way this program is case sensitive....
//--Lord Kelvin Abellana

import 'another.dart';
import 'dart:io';

void main() {
  User user = User(); //this will make a new user
  Admin admin = Admin(); //this will make a new admin
  //this will prompt the user on who will be accessing the program
  //he/she maybe a user or admin
  //there is also a "turn off" option in which the program will be teminated
  print("----------------------------------------");
  print("Who is using this program?");
  print("a.User/Borrower\nb.Admin\nc.Turn off");
  String? choice = stdin.readLineSync();
  switch (choice) {
    case 'a':
      user.whoRU(); //this function will send the user to the "user_interface"
      break;
    case 'b':
      admin.whoRU(); //this function will send the user to the "admin_interface"
      break;
    case 'c':
      //sometimes the "turn off" option will loop a couple of times
      //just continue on selecting "log out" and "turn off" option
      //until the program will terminate
      print("Thank you for using the system....");
      break; //this will terminate the program
    default:
      //if the choice is invalid, this will loop back to the function
      //this function can only be terminated by chosing option "c"
      //which is the "Turn off"option
      print("this is not a valid option, please try again");
      main();
  }
}
