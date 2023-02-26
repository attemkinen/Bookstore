package fi.backend.bookstore.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import fi.backend.bookstore.domain.Category;
import fi.backend.bookstore.domain.CategoryRepository;

@Controller
public class CategoryController {
	@Autowired
	private CategoryRepository crepository;
	
	@GetMapping("/categorylist")
	public String categoryList (Model model) {
		model.addAttribute("categorys", crepository.findAll());
		return "categorylist";
	} 
	
	@RequestMapping (value = "/addcategory", method =RequestMethod.GET)
	public String addGategory (Model model) {
		model.addAttribute("categorys", new Category());
		return "categoryform";
		
	}
	
	@RequestMapping (value = "/savecategory", method = RequestMethod.POST)
		public String saveCategory (@ModelAttribute Category category) {
		crepository.save(category);
		return "redirect:/categorylist";
	}
}
