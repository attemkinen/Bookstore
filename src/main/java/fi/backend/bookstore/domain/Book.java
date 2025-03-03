package fi.backend.bookstore.domain;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.validation.constraints.*;

@Entity
public class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @NotBlank(message = "Title cannot be empty")
    private String title;

    @NotBlank(message = "Author cannot be empty")
    private String author;

    @Pattern(regexp = "\\d{3}-\\d{3}-\\d{3}-\\d{4}", message = "Invalid ISBN format (expected: 123-456-789-0123)")
    private String isbn;

    @Min(value = 0, message = "Price must be a positive number")
    private double price;

    @Min(value = 1000, message = "Year must be at least 1000")
    @Max(value = 2025, message = "Year cannot be in the future")
    private int published;

    @ManyToOne
    @JsonIgnoreProperties("booksjson")
    @JoinColumn(name = "categoryid")
    private Category category;

    public Book() {}
	
	
	public Book(String title, String author, String isbn, double price, int published, Category category) {
		super();
		this.title = title;
		this.author = author;
		this.isbn = isbn;
		this.price = price;
		this.published = published;
		this.category = category;
	}
	public Long getId() {
		return id;
	}
	
	public void setCategory ( Category category) {
		this.category = category;
	}
	
	public Category getCategory() {
		return category;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getAuthor() {
		return author;
	}
	public void setAuthor(String author) {
		this.author = author;
	}
	public String getIsbn() {
		return isbn;
	}
	public void setIsbn(String isbn) {
		this.isbn = isbn;
	}
	public double getPrice() {
		return price;
	}
	public void setPrice(double price) {
		this.price = price;
	}
	public int getPublished() {
		return published;
	}
	public void setPublished(int published) {
		this.published = published;
	}


	@Override
	public String toString() {
		if (this.category != null)
		return "Book [id=" + id + ", title=" + title + ", author=" + author + ", isbn=" + isbn + ", price=" + price
				+ ", published=" + published + ", category=" + this.getCategory ()+ "]";
		else 
			return "Book [id=" + id + ", title=" + title + ", author=" + author + ", isbn=" + isbn + ", price=" + price
					+ ", published=" + published + "]";
	}
	
	
	
	

}
