package product.main;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.CoreMatchers.nullValue;
import static org.junit.Assert.assertThat;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import config.SpringConfig;
import dev.rokong.dto.ProductDTO;
import dev.rokong.product.main.ProductDAO;
import dev.rokong.product.main.ProductService;

public class DaoTest extends SpringConfig {
    
    @Autowired ProductService pService;
    @Autowired ProductDAO pDAO;

    @Test
    public void updateColumn(){
        pDAO.updateColumn(2, "price", 1111);
    }

    @Test
    public void updateProduct(){
        ProductDTO product = new ProductDTO();
        assertThat(product.getStockCnt(), is(nullValue()));
        assertThat(product.getEnabled(), is(nullValue()));

        pDAO.update(product);
    }
}
