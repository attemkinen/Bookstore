package fi.backend.bookstore;

import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import fi.backend.bookstore.domain.Book;
import fi.backend.bookstore.domain.BookRepository;
import fi.backend.bookstore.domain.Category;
import fi.backend.bookstore.domain.CategoryRepository;

@SpringBootApplication
public class BookstoreApplication {

	private static final Logger log = LoggerFactory.getLogger(BookstoreApplication.class);

	public static void main(String[] args) {
		SpringApplication.run(BookstoreApplication.class, args);

	}

	@Bean
	public CommandLineRunner demo(BookRepository bookrepository, CategoryRepository categoryrepository) {
		return (args) -> {
			
			Category c1 = new Category ("Drama");
			categoryrepository.save(c1);
			Category c2 = new Category ("Comedy");
			categoryrepository.save(c2);
			

			bookrepository.save( new Book("Matematiikan alkeet", "Atte Mäkinen", "111-222-333-4444", 19.9, 2009, c1));
			bookrepository.save( new Book("Biologian alkeet", "Matti Meikäläinen", "112-223-334-4455", 18.5, 1999,c2));

			

			log.info("saving");
			for (Book book : bookrepository.findAll()) {
				log.info(book.toString());
			}

		};
	}

}
