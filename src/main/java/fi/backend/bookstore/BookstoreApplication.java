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
import fi.backend.bookstore.domain.User;
import fi.backend.bookstore.domain.UserRepository;

@SpringBootApplication
public class BookstoreApplication {

	private static final Logger log = LoggerFactory.getLogger(BookstoreApplication.class);

	public static void main(String[] args) {
		SpringApplication.run(BookstoreApplication.class, args);

	}

	@Bean
	public CommandLineRunner demo(BookRepository bookrepository, CategoryRepository categoryrepository, UserRepository userrepository) {
		return (args) -> {
			
			Category c1 = new Category ("Drama");
			categoryrepository.save(c1);
			Category c2 = new Category ("Comedy");
			categoryrepository.save(c2);
			

			bookrepository.save( new Book("Matematiikan alkeet", "Atte Mäkinen", "111-222-333-4444", 19.9, 2009, c1));
			bookrepository.save( new Book("Biologian alkeet", "Matti Meikäläinen", "112-223-334-4455", 18.5, 1999,c2));
			
			// create users: admin & user profiles
			User user1 = new User("user","$2a$10$8EPyOOtvOPnunqN5I2E1vekajI6pgi5G4knfa9tGX4Iw1Winj5EGu", "USER");
			User user2 = new User("admin","$2a$10$C9oanpae9NOgFsrVIkwBYuaA33syb2UMNrPOF36OnmPhxDumc6S8S", "ADMIN");
			// saving newly created users
			userrepository.save(user1);
			userrepository.save(user2);

			log.info("saving");
			for (Book book : bookrepository.findAll()) {
				log.info(book.toString());
			}

		};
	}

}
