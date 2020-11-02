package dev.rokong.product;

import java.util.List;

import dev.rokong.dto.ProductDTO;

public interface ProductDAO {
    public List<ProductDTO> selectProductList();
    public ProductDTO selectProduct(int id);
    public int insertProduct(ProductDTO product);
    public void deleteProduct(int id);
    public void updateProduct(ProductDTO product);
    public void updateProductColumn(int id, String column, Object value);
}
