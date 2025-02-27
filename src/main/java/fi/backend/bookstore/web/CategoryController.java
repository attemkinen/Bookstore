package fi.backend.bookstore.web;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;


import fi.backend.bookstore.domain.Category;
import fi.backend.bookstore.domain.CategoryRepository;
import jakarta.validation.Valid;


@Controller
public class CategoryController {
	@Autowired
	private CategoryRepository crepository;

	@GetMapping("/categorylist")
	public String categoryList(Model model) {
		model.addAttribute("category", crepository.findAll());
		return "categorylist";
	}

	 @GetMapping("/addcategory")
    public String addCategory(Model model) {
        model.addAttribute("category", new Category());
        return "categoryform";
    }

    @PostMapping("/savecategory")
public String saveCategory(@Valid @ModelAttribute("category") Category category, BindingResult bindingResult, Model model) {
    if (bindingResult.hasErrors()) {
        return "categoryform"; // Palautetaan lomake ja virheilmoitukset
    }

    // Haetaan tietokannasta kategoria nimellä
    Category existingCategory = crepository.findByName(category.getName());

    if (existingCategory != null) { // Jos samalla nimellä on jo olemassa oleva kategoria
        bindingResult.rejectValue("name", "error.category", "Kategoria tällä nimellä on jo olemassa");
        return "categoryform";
    }

    crepository.save(category);
    return "redirect:/categorylist";
}



	// RESTful to get all listed categories
	@RequestMapping(value = "/categories", method = RequestMethod.GET)
	public @ResponseBody List<Category> getCategoriesRest() {
		return (List<Category>) crepository.findAll();
	}

	// find categories by id with RESTful
	@RequestMapping(value = "catiegories/{id}", method = RequestMethod.GET)
	public @ResponseBody Optional<Category> findCategoryRest(@PathVariable("id") Long categoryId) {
		return crepository.findById(categoryId);

	}

	@RequestMapping(value = "/categories", method = RequestMethod.POST)
	public @ResponseBody Category saveCategoryRest(@RequestBody Category category) {
		return crepository.save(category);
	}

	@GetMapping("/deletecategory/{id}")
	@PreAuthorize("hasAuthority('ADMIN')")
	public String deleteCategory(@PathVariable("id") Long categoryId) {
		crepository.deleteById(categoryId);
		return "redirect:/categorylist";
	}

	@RequestMapping(value = "/editCategory/{id}", method = RequestMethod.GET)
	public String editCategory(@PathVariable("id") Long id, Model model) {
		model.addAttribute("category", crepository.findById(id).orElse(null));
		model.addAttribute("categoryId", id);
		return "editcategory";
	}

	@RequestMapping(value = "/updateCategory/{id}", method = RequestMethod.POST)
	public String updateCategory(@PathVariable("id") Long id, Category category) {
		Category existingCategory = crepository.findById(id).orElse(null);

		if (existingCategory != null) {
			existingCategory.setName(category.getName()); // Päivitetään vain nimi
			crepository.save(existingCategory); // Tallennetaan olemassa olevaan ID:hen
		}

		return "redirect:../categorylist";
	}

}
