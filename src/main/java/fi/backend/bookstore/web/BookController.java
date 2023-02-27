package fi.backend.bookstore.web;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import fi.backend.bookstore.domain.Book;
import fi.backend.bookstore.domain.BookRepository;
import fi.backend.bookstore.domain.CategoryRepository;

@CrossOrigin
@Controller
public class BookController {
	@Autowired
	private BookRepository repository;

	@Autowired
	private CategoryRepository crepository;

	// http://localhost:8080/books
	// return all the books in bookstore
	@RequestMapping(value = "/books", method = RequestMethod.GET)
	public String getBooks(Model model) {
		List<Book> books = (List<Book>) repository.findAll();
		model.addAttribute("books", books);
		return "booklist";

	}

	// return all existing books in JSON
	@RequestMapping(value = "/booksjson", method = RequestMethod.GET)
	public @ResponseBody List<Book> bookListRest() {
		return (List<Book>) repository.findAll();
	}
	
	@RequestMapping (value ="/booksjson/{id}", method = RequestMethod.GET)
	public @ResponseBody Optional <Book> findBookRest(@PathVariable("id") Long id){
		return repository.findById(id);
		
	}

	// add new books to bookstore
	@RequestMapping(value = "/newbook", method = RequestMethod.GET)
	public String getNewBookForm(Model model) {
		model.addAttribute("book", new Book());
		model.addAttribute("categories", crepository.findAll());
		return "bookform";
	}

	// save books to bookstore
	@RequestMapping(value = "/savebook", method = RequestMethod.POST)
	public String saveCar(@ModelAttribute Book book) {
		// talletetaan yhden auton tiedot tietokantaan
		repository.save(book);
		return "redirect:/books";
	}

	// delete books
	@RequestMapping(value = "/deletebook/{id}", method = RequestMethod.GET)
	public String deleteBook(@PathVariable("id") Long bookId, Model model) {
		repository.deleteById(bookId);
		return "redirect:../books";
	}
	// edit existing books
	// todo make it work :)
	@RequestMapping(value = "/editbook/{id}", method = RequestMethod.POST)
	public String editBook(@PathVariable("id") Long bookId, Model model) {
		repository.findById(bookId);
		return "editbook";
	}

}
