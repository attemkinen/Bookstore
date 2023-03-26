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
@ExtendWith(SpringExtension.class)
@DataJpaTest
public class BookstoreRepositoryTest {
	@Autowired
	private BookRepository brepository;
	
	@Test
	public void FindByAuthorWorking () {
		List <Book> books = brepository.findByAuthor("Atte Mäkinen");
		assertThat(books).hasSize(1);
		
				
	}
}
