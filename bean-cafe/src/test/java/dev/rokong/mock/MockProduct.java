package dev.rokong.mock;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import dev.rokong.dto.ProductDTO;
import dev.rokong.dto.ProductDeliveryDTO;
import dev.rokong.product.main.ProductService;
import dev.rokong.util.RandomUtil;

@Component("MockProduct")
public class MockProduct extends AbstractMockObject<ProductDTO> {
    
    private @Autowired ProductService pService;

    private @Autowired MockUser mUser;
    private @Autowired MockCategory mCategory;
    private @Autowired MockProductDelivery mPDelivery;

    @Override
    public ProductDTO temp() {
        ProductDTO product = new ProductDTO();

        product.setName("product-"+RandomUtil.randomString(5));
        product.setPrice(RandomUtil.randomInt(5));
        product.setCategoryId(mCategory.any().getId());
        product.setEnabled(true);
        product.setSellerNm(mUser.any().getUserNm());
        product.setStockCnt(1);
        
        ProductDeliveryDTO pDelivery = mPDelivery.any();
        product.setDeliveryId(pDelivery.getId());
        product.setDeliveryPrice(pDelivery.getPrice());

        product.setDiscountPrice(0);

        return product;
    }

    @Override
    protected ProductDTO createObjService(ProductDTO obj) {
        return pService.createProduct(obj);
    }

    @Override
    protected ProductDTO getObjService(ProductDTO obj) {
        return pService.getProduct(obj.getId());
    }
}