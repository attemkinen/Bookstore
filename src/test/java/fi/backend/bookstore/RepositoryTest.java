package fi.backend.bookstore;

import static org.assertj.core.api.Assertions.assertThat;


import java.util.List;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import fi.backend.bookstore.domain.Book;
import fi.backend.bookstore.domain.BookRepository;
import fi.backend.bookstore.domain.Category;
import fi.backend.bookstore.domain.CategoryRepository;

@ExtendWith(SpringExtension.class)
@DataJpaTest
public class RepositoryTest {
	@Autowired
	private BookRepository brepository;
	@Autowired
	private CategoryRepository crepository;

	@Test // testing find method 
	public void FindByAuthorW() {
		List<Book> books = brepository.findByAuthor("Atte Mäkinen");
		assertThat(books).hasSize(1);

	}
	
	@Test // testing creating new categor
	public void createNewCategory () {
		Category category = new Category ("Gaming");
			crepository.save(category);
			assertThat(category.getCategoryId()).isNotNull();
	}
	
	@Test
	public void createNewBook() {
		 Category c3= new Category ("Education");
		 Book book = new Book ("testi", "Testin tekijä", "111-111-111-111", 20.00,2022, c3);
		 brepository.save(book);
		 assertThat(book.getId()).isNotNull();
		}
	
	
	
	
}
