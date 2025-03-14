package fi.backend.bookstore.domain;



import org.springframework.data.repository.CrudRepository;

public interface CategoryRepository extends CrudRepository<Category, Long> {
    Category findByName(String name);  // Hakee kategorian nimen perusteella
}
