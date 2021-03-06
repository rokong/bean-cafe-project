package dev.rokong.order.product;

import java.util.List;

import dev.rokong.annotation.OrderStatus;
import dev.rokong.dto.OrderProductDTO;
import org.springframework.core.annotation.Order;

public interface OrderProductService {
    public List<OrderProductDTO> getOProducts(OrderProductDTO oProduct);
    public OrderProductDTO getOProduct(OrderProductDTO oProduct);
    public OrderProductDTO getOProductNotNull(OrderProductDTO oProduct);
    public void checkOProductExist(OrderProductDTO oProduct);
    public int countOProductsByDelivery(int orderId, int deliveryId);
    public int totalPrice(int orderId, int deliveryId);
    public OrderStatus getProperOrderStatus(int orderId, int deliveryId);

    /**
     * add order product
     * 
     * order id must be created before execute this method.
     * productCd is optional.
     * 
     * @param oProduct orderId and productId must be defined
     * @return newly created order product
     */
    public OrderProductDTO addOProduct(OrderProductDTO oProduct);
    public OrderProductDTO updateOProductCnt(OrderProductDTO oProduct);
    public void deleteOProduct(OrderProductDTO oProduct);

    /**
     * when product or product detail is changed, set order product invalid
     * associated with changed one
     *
     * @param productId
     * @param optionCd
     */
    public void updateOProductInvalid(int productId, String optionCd);

    public void updateStatus(OrderProductDTO oProduct);
    public void updateStatusByDelivery(int orderId, int deliveryId, OrderStatus orderStatus);

}