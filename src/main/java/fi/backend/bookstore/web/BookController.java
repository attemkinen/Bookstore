package fi.backend.bookstore.web;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import fi.backend.bookstore.domain.Book;
import fi.backend.bookstore.domain.BookRepository;
import fi.backend.bookstore.domain.CategoryRepository;
import jakarta.validation.Valid;

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

	// return all existing books in JSON RESTful
	@RequestMapping(value = "/booksjson", method = RequestMethod.GET)
	public @ResponseBody List<Book> bookListRest() {
		return (List<Book>) repository.findAll();
	}

	// RESTful find by id
	@RequestMapping(value = "/booksjson/{id}", method = RequestMethod.GET)
	public @ResponseBody Optional<Book> findBookRest(@PathVariable("id") Long id) {
		return repository.findById(id);

	}

	// RESTful save new books
	@RequestMapping(value = "/booksjson", method = RequestMethod.POST)
	public @ResponseBody Book saveBookRest(@RequestBody Book book) {
		return repository.save(book);
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
	public String saveBook(@Valid @ModelAttribute Book book, BindingResult bindingResult, Model model) {
		if (bindingResult.hasErrors()) {
			model.addAttribute("categories", crepository.findAll());
			return "bookform";
		}
		repository.save(book);
		return "redirect:/books";
	}

	// delete books
	@RequestMapping(value = "/deletebook/{id}", method = RequestMethod.GET)
	@PreAuthorize("hasAuthority('ADMIN')")
	public String deleteBook(@PathVariable("id") Long bookId, Model model) {
		repository.deleteById(bookId);
		return "redirect:../books";
	}
	// edit existing books

	@RequestMapping(value = "/editBook/{id}", method = RequestMethod.GET)
	public String editBook(@PathVariable("id") Long id, Model model, Book book) {
		model.addAttribute("book", repository.findById(id));
		model.addAttribute("categories", crepository.findAll());
		model.addAttribute("bookId", id);
		return "editbook";
	}

	@RequestMapping(value = "/updateBook/{id}", method = RequestMethod.POST)
	public String updateBook(@PathVariable("id") Long id, Model model, Book book) {
		repository.save(book);
		return "redirect:../books";
	}

}
